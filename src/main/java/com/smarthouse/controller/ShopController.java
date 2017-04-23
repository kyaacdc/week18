package com.smarthouse.controller;

import com.smarthouse.pojo.*;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.ProductCardRepository;
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

import static com.smarthouse.service.util.enums.EnumSearcher.FIND_ALL;

@Controller
@Scope(proxyMode = ScopedProxyMode.TARGET_CLASS, value = "session")
public class ShopController {

    private int cartSize;
    private int totalPrice;
    private boolean isSorted = true;
    private Set<Rate> likedSkuSet = new HashSet<>();
    private List<Cart> cartList = new ArrayList<>();
    private List<ProductCard> foundProducts = new ArrayList<>();

    private ShopManager shopManager;
    private CategoryRepository categoryRepository;
    private ProductCardRepository productCardRepository;

    @Autowired
    public void setShopManager(ShopManager shopManager) {
        this.shopManager = shopManager;
    }

    @Autowired
    public void setCategoryRepository(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Autowired
    public void setProductCardRepository(ProductCardRepository productCardRepository) {
        this.productCardRepository = productCardRepository;
    }

    @PostMapping(value = "/oneClickBuy")
    public String oneClickBuy(@RequestParam(value = "email") String email,
                              @RequestParam(value = "sku") String sku,
                              @RequestParam(value = "name") String name,
                              @RequestParam(value = "phone")  String phone,
                              @RequestParam(value = "address") String address,
                              @RequestParam(value = "amount", defaultValue = "1") int amount, Model model) {

            if (cartSize == 0) {

                try {
                    shopManager.createOrder(email, name, phone, address, amount, sku);
                } catch (ValidationException e) {
                    model.addAttribute("wrongEmail", "Email not valid.");
                    return showProductCard(sku, model);
                } catch (TransactionSystemException e){
                    model.addAttribute("email", email);
                    if(!name.equals(""))
                        model.addAttribute("wrongName", "Name should consist only of letters.");
                    if(!phone.equals(""))
                        model.addAttribute("wrongPhone", "Phone number should consist only of digits.");
                    return showProductCard(sku, model);
                } catch (NoResultException e) {
                    model.addAttribute("noProductExist",
                            "Sorry, this product not exist on warehouse. Please continue shopping.");
                    model.addAttribute("listRootCategories", shopManager.getRootCategories());
                    model.addAttribute("cartSize", cartSize);
                    model.addAttribute("totalPrice", totalPrice);
                    return "categories";
                }  catch (Exception e) {
                    model.addAttribute("undefinedError", "Sorry! Undefined error. Please continue shopping.");
                    model.addAttribute("listRootCategories", shopManager.getRootCategories());
                    model.addAttribute("cartSize", cartSize);
                    model.addAttribute("totalPrice", totalPrice);
                    return "categories";
                }

                shopManager.submitOrder(email);

                LinkedList<OrderMain> orderMainLinkedList =
                        new LinkedList<>(shopManager.getOrdersByCustomer(email));
                int orderId = orderMainLinkedList.getLast().getOrderId();

                model.addAttribute("listRootCategories", shopManager.getRootCategories());
                model.addAttribute("success", true);
                model.addAttribute("orderId", orderId);
                model.addAttribute("cartSize", cartSize);
                model.addAttribute("totalPrice", totalPrice);

                return "categories";

            } else {
                ProductCard productCard = productCardRepository.findOne(sku);

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

        if (productCardRepository.findOne(sku).getAmount() >= amount) {
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

        return "categories";
    }

    @PostMapping(value = "/removeFromCart")
    public String removeFromCart(@RequestParam(value = "index") int index, Model model) {

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

        if (cartList.size() != 0) {
            model.addAttribute("listCart", cartList);
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
            model.addAttribute("isCartEmpty", false);
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
            }  catch (ValidationException e) {
                model.addAttribute("wrongEmail", "Email not valid.");
                return showCart(model);
            }  catch (TransactionSystemException e) {
                model.addAttribute("email", email);
                if(!name.equals(""))
                    model.addAttribute("wrongName", "Name should consist only of letters.");
                if(!phone.equals(""))
                    model.addAttribute("wrongPhone", "Phone number should consist only of digits.");
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

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("orderId", orderMainLinkedList.getLast().getOrderId());
        model.addAttribute("success", true);

        return "categories";
    }

    @PostMapping(value = "/changeRate")
    public String changeRate(@RequestParam(value = "sku") String sku,
                             @RequestParam(value = "isLike") boolean isLike, Model model) {

        ProductCard productCard = productCardRepository.findOne(sku);

        Rate rate = new Rate();
        boolean isRateFound = false;

        for (Rate r: likedSkuSet){
            if(r.getSku().equals(sku)){
                rate = r;
                isRateFound = true;
                break;
            }
        }

        if(isRateFound) {

            if (rate.isLiked() && isLike) {
                return showProductCard(sku, model);
            }
            else if (rate.isDisliked() && !isLike) {
                return showProductCard(sku, model);
            }
            else if (rate.isLiked() && !isLike && !rate.isDisliked()) {
                rate.setDisliked(true);
                productCard.setLikes(productCard.getLikes() - 1);
                productCardRepository.save(productCard);
            }
            else if (rate.isDisliked() && isLike && !rate.isLiked()) {
                rate.setLiked(true);
                productCard.setDislikes(productCard.getDislikes() - 1);
                productCardRepository.save(productCard);
            }
        }
        else {
            rate.setSku(sku);
            if(isLike) {
                rate.setLiked(true);
                productCard.setLikes(productCard.getLikes() + 1);
                productCardRepository.save(productCard);
            }
            else {
                rate.setDisliked(true);
                productCard.setDislikes(productCard.getDislikes() + 1);
                productCardRepository.save(productCard);
            }
        }

        if(rate.isLiked() && rate.isDisliked()){
            model.addAttribute("isDislikePushed", true);
            model.addAttribute("isLikePushed", true);
        } else if (rate.isLiked() && !rate.isDisliked()){
            model.addAttribute("isDislikePushed", false);
            model.addAttribute("isLikePushed", true);
        } else if (!rate.isLiked() && rate.isDisliked()){
            model.addAttribute("isDislikePushed", true);
            model.addAttribute("isLikePushed", false);
        } else {
            model.addAttribute("isDislikePushed", false);
            model.addAttribute("isLikePushed", false);
        }

        likedSkuSet.add(rate);

        return showProductCard(sku, model);
    }

    @GetMapping(value = {"/", "/index", "/home", "/categories"})
    public String showRootCategories(Model model) {

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
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

        Category category = categoryRepository.findOne(id);

        if (id <= 0 || category == null)
            return showRootCategories(model);

        List<Category> subCategories = shopManager.getSubCategories(id);

        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);

        if (subCategories.size() > 0)
            model.addAttribute("listSubCategories", subCategories);
        else {
            foundProducts.clear();
            model.addAttribute("listProduct", shopManager.getProductCardsByCategory(id));
            model.addAttribute("categoryId", id);
            model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
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

        for (Rate r: likedSkuSet){
            if(r.getSku().equals(sku)){
                rate = r;
                break;
            }
        }

        if(rate != null) {
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

        ProductCard productCard = productCardRepository.findOne(sku);

        if (productCard != null) {
            model.addAttribute("product", productCard);
            model.addAttribute("cartSize", cartSize);
            model.addAttribute("totalPrice", totalPrice);
            model.addAttribute("listVisualisations", shopManager.getVisualListByProduct(sku));

            return "product";
        } else
            return "redirect:/categories";
    }

    @GetMapping(value = "/showAttributes/{sku}")
    public String showAttributes(@PathVariable(value = "sku") String sku, Model model) {

        List<AttributeValue> attrValuesByProduct = shopManager.getAttrValuesByProduct(sku);
        if (attrValuesByProduct.size() > 0) {
            model.addAttribute("attributeList", attrValuesByProduct);
            model.addAttribute("isAttributesNotPresent", false);
            model.addAttribute("isShowAttribute", true);
        } else model.addAttribute("isAttributesNotPresent", true);

        return showProductCard(sku, model);
    }

    @GetMapping(value = "/hideAttributes/{sku}")
    public String hideAttributes(@PathVariable(value = "sku") String sku, Model model) {
        model.addAttribute("isShowAttribute", false);
        return showProductCard(sku, model);
    }

    @GetMapping(value = "/sortProductCardBy")
    public String sortProductCardBy(@RequestParam(value = "categoryId", required = false) Integer categoryId,
                                    @RequestParam(value = "sortCriteria") EnumProductSorter sortCriteria,
                                    Model model) {

        if(foundProducts.size() == 0 && categoryId != null) {
            model.addAttribute("listProduct", shopManager.sortProductCardBy(categoryId, sortCriteria));
            model.addAttribute("categoryId", categoryId);
        }
        else
            model.addAttribute("listProduct", shopManager.sortSearchResultsBy(foundProducts, sortCriteria));

        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("isSorted", isSorted);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());

        isSorted = !isSorted;

        return "categories";
    }

    @GetMapping(value = "/findProducts")
    public String findProducts(@RequestParam(value = "findOption", required = false) EnumSearcher findBy,
                               @RequestParam(value = "searchValue") String searchValue,
                                    Model model) {
        if(findBy == FIND_ALL) {
            Set<ProductCard> allProductsByCriteria = shopManager.findAllProductsByCriteria(searchValue);
            foundProducts = new ArrayList<>(allProductsByCriteria);
            model.addAttribute("listProduct", foundProducts);
        }
        else {
            Set<ProductCard> allProductsByCriteria = shopManager.findProductsIn(searchValue, findBy);
            foundProducts = new ArrayList<>(allProductsByCriteria);
            model.addAttribute("listProduct", foundProducts);
        }

        model.addAttribute("cartSize", cartSize);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());

        if(foundProducts.isEmpty()) {
            model.addAttribute("listRootCategories", shopManager.getRootCategories());
            model.addAttribute("isNotFound", true);
        }

        return "categories";
    }
}