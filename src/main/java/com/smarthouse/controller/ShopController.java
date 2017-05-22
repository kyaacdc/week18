package com.smarthouse.controller;

import com.smarthouse.pojo.*;
import com.smarthouse.service.ShopManager;
import com.smarthouse.service.util.enums.EnumProductSorter;
import com.smarthouse.service.util.enums.EnumSearcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionSystemException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.persistence.NoResultException;
import javax.validation.ValidationException;
import java.util.*;
import java.util.stream.Collectors;

import static com.smarthouse.service.util.enums.EnumProductSorter.SORT_BY_POPULARITY;
import static com.smarthouse.service.util.enums.EnumSearcher.FIND_ALL;
import static com.smarthouse.service.util.enums.EnumSearcher.FIND_IN_ALL_PLACES;

@Controller
@Scope(proxyMode = ScopedProxyMode.TARGET_CLASS, value = "session")
public class ShopController {

    private int cartSize;
    private int totalPrice;
    private boolean isSorted = true;
    private Set<Rate> likedSkuSet = new HashSet<>();
    private List<Cart> cartList = new ArrayList<>();
    private List<ProductCard> foundProducts = new ArrayList<>();
    private List<ProductCard> listPopularProducts = new ArrayList<>();
    private List<Visualization> listPopularVizualisations = new ArrayList<>();
    private List<Visualization> listVizualisations = new ArrayList<>();

    private static volatile long visitsCounter = 0;

    private final ShopManager shopManager;

    @Autowired
    public ShopController(ShopManager shopManager) {
        this.shopManager = shopManager;
    }

    private synchronized void increaseAmountOfVisits() {
        visitsCounter++;
    }

    @PostMapping(value = "/oneClickBuy")
    public String oneClickBuy(@RequestParam(value = "email") String email,
                              @RequestParam(value = "sku") String sku,
                              @RequestParam(value = "name") String name,
                              @RequestParam(value = "phone") String phone,
                              @RequestParam(value = "address") String address,
                              @RequestParam(value = "amount", defaultValue = "1") int amount, Model model) {

        if (cartSize == 0) {

            try {
                shopManager.createOrder(email, name, phone, address, amount, sku);
                model.addAttribute("email", email);
            } catch (ValidationException e) {
                model.addAttribute("wrongEmail", "Email not valid.");
                return showProductCard(sku, model);
            } catch (TransactionSystemException e) {
                model.addAttribute("email", email);
                if (!name.equals(""))
                    model.addAttribute("wrongName", "Name should consist only of letters.");
                if (!phone.equals(""))
                    model.addAttribute("wrongPhone", "Phone number should consist only of digits.");
                return showProductCard(sku, model);
            } catch (NoResultException e) {
                model.addAttribute("noProductExist",
                        "Sorry, this product not exist on warehouse. Please continue shopping.");
                return "categories";
            } catch (Exception e) {
                model.addAttribute("undefinedError", "Sorry! Undefined error. Please continue shopping.");
                return "categories";
            } finally {
                model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());
                model.addAttribute("listRootCategories", shopManager.getRootCategories());
                model.addAttribute("cartSize", cartSize);
                model.addAttribute("totalPrice", totalPrice);
                model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());
            }

            shopManager.submitOrder(email);

            LinkedList<OrderMain> orderMainLinkedList =
                    new LinkedList<>(shopManager.getOrdersByCustomer(email));
            int orderId = orderMainLinkedList.getLast().getOrderId();

            model.addAttribute("success", true);
            model.addAttribute("orderId", orderId);
            model.addAttribute("listPopularProducts", listPopularProducts);
            model.addAttribute("listPopularVizualisations", listPopularVizualisations);

            shopManager.sendMail(email, "Thanks for your order. Your order ID is - " + orderId);

            return "categories";

        } else {
            ProductCard productCard = shopManager.getProductCardBySku(sku);

            cartList.add(new Cart(sku, productCard.getName(), amount, productCard.getPrice()));
            cartSize = cartList.stream().map(Cart::getAmount).reduce((x, y) -> x + y).orElse(0);
            totalPrice = cartList.stream().map(Cart::getPrice).reduce((x, y) -> x + y).orElse(0);
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
            model.addAttribute("email", email);
            return showCart(model);
        }
    }

    @PostMapping(value = "/addToCart")
    public String addToCart(@RequestParam(value = "sku") String sku,
                            @RequestParam(value = "name") String name,
                            @RequestParam(value = "amount", defaultValue = "1") int amount,
                            @RequestParam(value = "price") int price, Model model) {

        if (shopManager.getProductCardBySku(sku).getAmount() >= amount) {
            cartList.add(new Cart(sku, name, amount, price * amount));
            cartSize = cartList.stream().map(Cart::getAmount).reduce((x, y) -> x + y).orElse(0);
            totalPrice = cartList.stream().map(Cart::getPrice).reduce((x, y) -> x + y).orElse(0);
            model.addAttribute("listRootCategories", shopManager.getRootCategories());
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
            model.addAttribute("isAddedToCart", true);
        } else {
            model.addAttribute("noProductExist",
                    "Sorry, this product not exist on warehouse. Please continue shopping.");
            model.addAttribute("listRootCategories", shopManager.getRootCategories());
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
        }

        model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());
        model.addAttribute("listPopularProducts", listPopularProducts);
        model.addAttribute("listPopularVizualisations", listPopularVizualisations);

        return "categories";
    }

    @PostMapping(value = "/removeFromCart")
    public String removeFromCart(@RequestParam(value = "index") int index, Model model) {

        model.addAttribute("listPopularProducts", listPopularProducts);
        cartList.remove(index);
        cartSize = cartList.stream().map(Cart::getAmount).reduce((x, y) -> x + y).orElse(0);
        totalPrice = cartList.stream().map(Cart::getPrice).reduce((x, y) -> x + y).orElse(0);
        return showCart(model);
    }

    @GetMapping(value = "/clearCart")
    public String clearCart(Model model) {
        cartList.clear();
        cartSize = 0;
        totalPrice = 0;
        model.addAttribute("isCartEmpty", true);
        return showRootCategories(model);
    }

    @GetMapping(value = "/showCart")
    public String showCart(Model model) {

        model.addAttribute("listPopularProducts", listPopularProducts);

        if (cartList.size() != 0) {
            model.addAttribute("listCart", cartList);
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
            model.addAttribute("isCartEmpty", false);
            model.addAttribute("listPopularProducts", listPopularProducts);
            model.addAttribute("listPopularVizualisations", listPopularVizualisations);

            return "cart";
        } else {
            model.addAttribute("isCartEmpty", true);
            return showRootCategories(model);
        }
    }

    @PostMapping(value = "/buy")
    public String buy(@RequestParam(value = "email") String email,
                      @RequestParam(value = "name") String name,
                      @RequestParam(value = "phone") String phone,
                      @RequestParam(value = "address") String address, Model model) {

        for (Cart b : cartList) {
            try {
                shopManager.createOrder(email, name, phone, address, b.getAmount(), b.getSku());
                model.addAttribute("email", email);
            } catch (ValidationException e) {
                model.addAttribute("wrongEmail", "Email not valid.");
                return showCart(model);
            } catch (TransactionSystemException e) {
                model.addAttribute("email", email);
                if (!name.equals(""))
                    model.addAttribute("wrongName", "Name must have only letters.");
                if (!phone.equals(""))
                    model.addAttribute("wrongPhone", "Phone must have only digits.");
                return showCart(model);
            } catch (Exception e) {
                model.addAttribute("undefinedError", "Sorry. Undefined shop error. Please continue shopping.");
                model.addAttribute("listRootCategories", shopManager.getRootCategories());
                model.addAttribute("cartSize", cartSize);
                model.addAttribute("totalPrice", totalPrice);
                return "categories";
            }
        }

        cartList.clear();

        cartSize = 0;
        totalPrice = 0;

        shopManager.submitOrder(email);

        LinkedList<OrderMain> orderMainLinkedList =
                new LinkedList<>(shopManager.getOrdersByCustomer(email));

        int orderId = orderMainLinkedList.getLast().getOrderId();

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("orderId", orderId);
        model.addAttribute("success", true);

        shopManager.sendMail(email, "Thanks for your order. Your order ID is - " + orderId);

        model.addAttribute("listPopularProducts", listPopularProducts);
        model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());
        model.addAttribute("listPopularVizualisations", listPopularVizualisations);

        return "categories";
    }

    @PostMapping(value = "/changeRate")
    public String changeRate(@RequestParam(value = "sku") String sku,
                             @RequestParam(value = "isLike") boolean isLike, Model model) {

        ProductCard productCard = shopManager.getProductCardBySku(sku);

        Rate rate = new Rate();
        boolean isRateFound = false;

        for (Rate r : likedSkuSet) {
            if (r.getSku().equals(sku)) {
                rate = r;
                isRateFound = true;
                break;
            }
        }

        if (isRateFound) {

            if (rate.isLiked() && isLike) {
                return showProductCard(sku, model);
            } else if (rate.isDisliked() && !isLike) {
                return showProductCard(sku, model);
            } else if (rate.isLiked() && !isLike && !rate.isDisliked()) {
                rate.setDisliked(true);
                productCard.setLikes(productCard.getLikes() - 1);
                shopManager.saveProductCard(productCard);
            } else if (rate.isDisliked() && isLike && !rate.isLiked()) {
                rate.setLiked(true);
                productCard.setDislikes(productCard.getDislikes() - 1);
                shopManager.saveProductCard(productCard);
            }
        } else {
            rate.setSku(sku);
            if (isLike) {
                rate.setLiked(true);
                productCard.setLikes(productCard.getLikes() + 1);
                shopManager.saveProductCard(productCard);
            } else {
                rate.setDisliked(true);
                productCard.setDislikes(productCard.getDislikes() + 1);
                shopManager.saveProductCard(productCard);
            }
        }

        if (rate.isLiked() && rate.isDisliked()) {
            model.addAttribute("isDislikePushed", true);
            model.addAttribute("isLikePushed", true);
        } else if (rate.isLiked() && !rate.isDisliked()) {
            model.addAttribute("isDislikePushed", false);
            model.addAttribute("isLikePushed", true);
        } else if (!rate.isLiked() && rate.isDisliked()) {
            model.addAttribute("isDislikePushed", true);
            model.addAttribute("isLikePushed", false);
        } else {
            model.addAttribute("isDislikePushed", false);
            model.addAttribute("isLikePushed", false);
        }

        likedSkuSet.add(rate);

        model.addAttribute("listPopularProducts", listPopularProducts);

        return showProductCard(sku, model);
    }

    @GetMapping(value = {"/", "/index", "/home", "/categories"})
    public String showRootCategories(Model model) {

        increaseAmountOfVisits();

        listPopularProducts = shopManager.getAllProductCards()
                .stream()
                .sorted(Comparator.comparing(ProductCard::getLikes).reversed())
                .limit(6)
                .collect(Collectors.toList());

        listPopularVizualisations = listPopularProducts.stream()
                .flatMap(a -> shopManager.getVisualListByProduct(a.getSku()).stream())
                .collect(Collectors.toList());

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("listPopularProducts", listPopularProducts);
        model.addAttribute("listPopularVizualisations", listPopularVizualisations);
        model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());
        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);

        return "categories";
    }

    @GetMapping(value = {"/subcategories/{id}", "/subcategories"})
    public String showSubcategories(@PathVariable(value = "id", required = false) String idStr, Model model) {

        if (idStr == null)
            return "redirect:/categories";

        String[] split = idStr.split("@");

        Integer id = Integer.parseInt(split[0]);

        Category category = shopManager.getCategoryById(id);

        if (id <= 0 || category == null)
            return showRootCategories(model);

        List<Category> subCategories = shopManager.getSubCategories(id);

        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);

        if (subCategories.size() > 0) {
            model.addAttribute("listSubCategories", subCategories);
            model.addAttribute("listPopularProducts", listPopularProducts);
            model.addAttribute("listPopularVizualisations", listPopularVizualisations);
        } else {
            List<ProductCard> listPopularCategoryProducts = shopManager.sortProductCardBy(id, SORT_BY_POPULARITY);
            List<ProductCard> result = new ArrayList<>(listPopularCategoryProducts);
            int size = result.size();

            if(size < 6){
                boolean isDublicate;
                for(ProductCard pAll: listPopularProducts){
                    isDublicate = false;
                    for(ProductCard p: listPopularCategoryProducts) {
                        if(pAll.getSku().equals(p.getSku())) {
                            isDublicate = true;
                            break;
                        }
                    }
                    if(isDublicate)
                        continue;
                    result.add(pAll);
                    if(result.size() == 6)
                        break;
                }
            }

            listPopularVizualisations = result.stream()
                    .flatMap(a -> shopManager.getVisualListByProduct(a.getSku()).stream())
                    .collect(Collectors.toList());

            List<ProductCard> productCardsByCategory = shopManager.getProductCardsByCategory(id);

            List<Visualization> listVizualisations = productCardsByCategory.stream()
                    .flatMap(a -> shopManager.getVisualListByProduct(a.getSku()).stream())
                    .collect(Collectors.toList());


            foundProducts.clear();
            model.addAttribute("listProduct", productCardsByCategory);
            model.addAttribute("listVizualisations", listVizualisations);
            model.addAttribute("categoryId", id);
            model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
            model.addAttribute("listPopularProducts", result);
            model.addAttribute("listPopularVizualisations", listPopularVizualisations);
        }

        return "categories";
    }

    @GetMapping(value = {"/product/{sku}", "/product"})
    public String showProductCard(@PathVariable(value = "sku", required = false) String skuStr, Model model) {

        if (skuStr == null)
            return "redirect:/categories";

        String[] split = skuStr.split("@");
        String sku = split[0];

        Rate rate = null;

        for (Rate r : likedSkuSet) {
            if (r.getSku().equals(sku)) {
                rate = r;
                break;
            }
        }

        if (rate != null) {
            if (rate.isLiked() && rate.isDisliked()) {
                model.addAttribute("isDislikePushed", true);
                model.addAttribute("isLikePushed", true);
            } else if (rate.isLiked() && !rate.isDisliked()) {
                model.addAttribute("isDislikePushed", false);
                model.addAttribute("isLikePushed", true);
            } else if (!rate.isLiked() && rate.isDisliked()) {
                model.addAttribute("isDislikePushed", true);
                model.addAttribute("isLikePushed", false);
            }
        } else {
            model.addAttribute("isDislikePushed", false);
            model.addAttribute("isLikePushed", false);
        }

        model.addAttribute("listPopularProducts", listPopularProducts);
        model.addAttribute("listPopularVizualisations", listPopularVizualisations);

        ProductCard productCard = shopManager.getProductCardBySku(sku);

        if (productCard != null) {
            model.addAttribute("product", productCard);
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
            model.addAttribute("listVisualisations", shopManager.getVisualListByProduct(sku));

            List<AttributeValue> attrValuesByProduct = shopManager.getAttrValuesByProduct(sku);
            if (attrValuesByProduct.size() > 0) {
                model.addAttribute("attributeList", attrValuesByProduct);
                model.addAttribute("isAttributesNotPresent", false);
            } else model.addAttribute("isAttributesNotPresent", true);

            return "product";
        } else
            return "redirect:/categories";
    }

    @GetMapping(value = "/sortProductCardBy")
    public String sortProductCardBy(@RequestParam(value = "categoryId", required = false) Integer categoryId,
                                    @RequestParam(value = "sortCriteria") EnumProductSorter sortCriteria,
                                    Model model) {

        if (foundProducts.size() == 0 && categoryId != null) {
            model.addAttribute("listProduct", shopManager.sortProductCardBy(categoryId, sortCriteria));
            model.addAttribute("categoryId", categoryId);
        } else
            model.addAttribute("listProduct", shopManager.sortSearchResultsBy(foundProducts, sortCriteria));

        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("isSorted", isSorted);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
        model.addAttribute("listPopularProducts", listPopularProducts);
        model.addAttribute("listVizualisations", listVizualisations);
        model.addAttribute("listPopularVizualisations", listPopularVizualisations);

        isSorted = !isSorted;

        return "categories";
    }

    @GetMapping(value = "/findProducts")
    public String findProducts(@RequestParam(value = "findOption", required = false) EnumSearcher findBy,
                               @RequestParam(value = "searchValue") String searchValue,
                               Model model) {
        if (findBy == FIND_ALL) {
            Set<ProductCard> allProductsByCriteria = shopManager.findAllIncludeText(searchValue);
            foundProducts = new ArrayList<>(allProductsByCriteria);
            model.addAttribute("listProduct", foundProducts);
        } else if (findBy == FIND_IN_ALL_PLACES) {
            Set<ProductCard> allProductsByCriteria = shopManager.findAllProductsByCriteria(searchValue);
            foundProducts = new ArrayList<>(allProductsByCriteria);
            model.addAttribute("listProduct", foundProducts);
        } else {
            Set<ProductCard> allProductsByCriteria = shopManager.findProductsIn(searchValue, findBy);
            foundProducts = new ArrayList<>(allProductsByCriteria);
            model.addAttribute("listProduct", foundProducts);
        }

        listVizualisations = foundProducts.stream()
                .flatMap(a -> shopManager.getVisualListByProduct(a.getSku()).stream())
                .collect(Collectors.toList());

        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
        model.addAttribute("listPopularProducts", listPopularProducts);
        model.addAttribute("listVizualisations", listVizualisations);
        model.addAttribute("listPopularVizualisations", listPopularVizualisations);

        if (foundProducts.isEmpty()) {
            model.addAttribute("listRootCategories", shopManager.getRootCategories());
            model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());
            model.addAttribute("isNotFound", true);
        }

        return "categories";
    }
}