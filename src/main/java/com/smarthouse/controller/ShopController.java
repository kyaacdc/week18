package com.smarthouse.controller;

import com.smarthouse.pojo.AttributeValue;
import com.smarthouse.pojo.Cart;
import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.AttributeValueRepository;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.ProductCardRepository;
import com.smarthouse.service.ShopManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.validation.ValidationException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@Scope(proxyMode = ScopedProxyMode.TARGET_CLASS, value = "session")
public class ShopController {

    private ShopManager shopManager;
    private CategoryRepository categoryRepository;
    private ProductCardRepository productCardRepository;

    private List<Cart> cartList = new ArrayList<>();

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

    @RequestMapping(value = "/oneClickBuy", method = RequestMethod.POST)
    public String oneClickBuy(@RequestParam(value = "email") String email,
                              @RequestParam(value = "sku") String sku,
                              @RequestParam(value = "name") String name,
                              @RequestParam(value = "phone") String phone,
                              @RequestParam(value = "address") String address,
                              @RequestParam(value = "amount", defaultValue = "1") int amount,
                              Model model) {

        try {
            shopManager.createOrder(email, name, phone, address, amount, sku);
        } catch (ValidationException e) {
            model.addAttribute("wrongEmail", "Email not valid.");
            return showProductCard(sku, model);
        } catch (Exception e) {
            model.addAttribute("email", email);
            model.addAttribute("wrongName", "Name should consist only of letters.");
            model.addAttribute("wrongPhone", "Phone number should consist only of digits.");
            return showProductCard(sku, model);
        }
        shopManager.submitOrder(email);

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("cartSize", cartList.size());
        model.addAttribute("success", true);

        return "categories";
    }

    @RequestMapping(value = "/addToCart", method = RequestMethod.POST)
    public String addToCart(@RequestParam(value = "sku") String sku,
                            @RequestParam(value = "name") String name,
                            @RequestParam(value = "amount", defaultValue = "1") int amount,
                            Model model) {

        cartList.add(new Cart(sku, name, amount));
        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("cartSize", cartList.size());
        model.addAttribute("isAddedToCart", true);

        return "categories";
    }

    @RequestMapping(value = "/showCart", method = RequestMethod.GET)
    public String showCart(Model model) {

        if (cartList.size() != 0) {
            model.addAttribute("listCart", cartList);
            model.addAttribute("isCartEmpty", false);
            return "cart";
        } else {
            model.addAttribute("isCartEmpty", true);
            return showRootCategories(model);
        }
    }

    @RequestMapping(value = "/buy", method = RequestMethod.POST)
    public String buy(@RequestParam(value = "email") String email,
                      @RequestParam(value = "name") String name,
                      @RequestParam(value = "phone") String phone,
                      @RequestParam(value = "address") String address,
                      Model model) {

        for (Cart b : cartList) {
            try {
                shopManager.createOrder(email, name, phone, address, b.getAmount(), b.getSku());
            } catch (ValidationException e) {
                model.addAttribute("wrongEmail", "Email not valid.");
                return showCart(model);
            } catch (Exception e) {
                model.addAttribute("email", email);
                model.addAttribute("wrongName", "Name should consist only of letters.");
                model.addAttribute("wrongPhone", "Phone number should consist only of digits.");
                return showCart(model);
            }
        }

        cartList.clear();

        shopManager.submitOrder(email);

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("cartSize", cartList.size());
        model.addAttribute("success", true);

        return "categories";
    }

    @RequestMapping(value = "/changeRate", method = RequestMethod.POST)
    public String changeRate(@RequestParam(value = "rate") int rate,
                             @RequestParam(value = "sku") String sku,
                             @RequestParam(value = "isLike") boolean isLike,
                             Model model) {

        ProductCard productCard = productCardRepository.findOne(sku);

        if (isLike)
            productCard.setLikes(productCard.getLikes() + rate);
        else
            productCard.setDislikes(productCard.getDislikes() + rate);

        productCardRepository.save(productCard);

        return showProductCard(sku, model);
    }

    @RequestMapping(value = {"/", "/index", "/home", "/categories"}, method = RequestMethod.GET)
    public String showRootCategories(Model model) {

        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("cartSize", cartList.size());

        return "categories";
    }

    @RequestMapping(value = {"/subcategories/{id}", "/subcategories"}, method = RequestMethod.GET)
    public String showSubcategories(@PathVariable(value = "id", required = false) String idStr, Model model) {

        if (idStr == null)
            return "redirect:/categories";

        String[] split = idStr.split("@");

        Integer id = Integer.parseInt(split[0]);

        Category category = categoryRepository.findOne(id);

        if (id <= 0 || category == null)
            return showRootCategories(model);

        int cartSize = cartList.size();

        List<Category> subCategories = shopManager.getSubCategories(id);

        if (subCategories.size() > 0) {
            model.addAttribute("listSubCategories", subCategories);
            model.addAttribute("cartSize", cartSize);

            return "categories";
        } else {
            model.addAttribute("listProduct", shopManager.getProductCardsByCategory(id));
            model.addAttribute("cartSize", cartSize);
            return "categories";
        }
    }

    @RequestMapping("/product/{sku}")
    public String showProductCard(
            @PathVariable(value = "sku")
                    String skuStr,
            Model model) {

        String[] split = skuStr.split("@");
        String sku = split[0];

        ProductCard productCard = productCardRepository.findOne(sku);

        if (productCard != null) {
            model.addAttribute("product", productCard);
            model.addAttribute("cartSize", cartList.size());
            model.addAttribute("listVisualisations", shopManager.getVisualListByProduct(sku));

            return "product";
        } else
            return "redirect:/categories";
    }

    @RequestMapping("/showAttributes/{sku}")
    public String showAttributes(
            @PathVariable(value = "sku")
                    String sku,
            Model model) {

        List<AttributeValue> attrValuesByProduct = shopManager.getAttrValuesByProduct(sku);
        if(attrValuesByProduct.size() > 0) {
            model.addAttribute("attributeList", attrValuesByProduct);
            model.addAttribute("isAttributesNotPresent", false);
        } else model.addAttribute("isAttributesNotPresent", true);

        return showProductCard(sku, model);
    }



/*
    @RequestMapping("/showProductCardsByCategory")
    public String showProductCardsByCategory(
            @RequestParam(value = "categoryId", required = false, defaultValue = "0")
                    int categoryId,
            Model model) {
        if (categoryId == 0)
            model.addAttribute("listProductCards", productCardRepository.findAll());
        else
            model.addAttribute("listProductCards", shopManager.getProductCardsByCategory(categoryId));

        return "productCards";
    }


    @RequestMapping(value = {"/pdf", "/index/pdf", "/home/pdf", "/categories/pdf"}, method = RequestMethod.GET)
    public String showRootCategoriesInPdf(Model model, HttpServletResponse response) throws JDOMException, DocumentException {

        File test = new File("/home/kya/new/week18/src/main/resources/pdf.pdf");
        response.setHeader("Content-Type", "application/pdf");
        response.setHeader("Content-Length", String.valueOf(test.length()));
        response.setHeader("Content-Disposition", "inline; filename=\"pdf.pdf\"");
        try {
            Files.copy(test.toPath(), response.getOutputStream());
        } catch (IOException e) {

            e.printStackTrace();
        }
        return "redirect:/categoriespdf";
    }
    */
}