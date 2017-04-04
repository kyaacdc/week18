package com.smarthouse.controller;

import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.AttributeValueRepository;
import com.smarthouse.repository.ProductCardRepository;
import com.smarthouse.service.ShopManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class ShopController {

    private ShopManager shopManager;
    private ProductCardRepository productCardRepository;
    private AttributeValueRepository attributeValueRepository;

    @Autowired
    public void setShopManager(ShopManager shopManager) {
        this.shopManager = shopManager;
    }

    @Autowired
    public void setProductCardRepository(ProductCardRepository productCardRepository) {
        this.productCardRepository = productCardRepository;
    }

    @Autowired
    public void setAttributeValueRepository(AttributeValueRepository attributeValueRepository) {
        this.attributeValueRepository = attributeValueRepository;
    }

    @RequestMapping(value = "/oneClickBuy", method = RequestMethod.POST)
    public String oneClickBuy(@RequestParam(value = "email") String email,
                              @RequestParam(value = "sku") String sku,
                              @RequestParam(value = "name") String name,
                              @RequestParam(value = "phone") String phone,
                              @RequestParam(value = "address") String address,
                              @RequestParam(value = "amount", defaultValue = "1") int amount,
                              Model model) {
        shopManager.createOrder(email, name, phone, address, amount, sku);
        shopManager.submitOrder(email);
        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("listAllCategories", shopManager.getAllCategories());
        model.addAttribute("success", true);

        return "categories";
    }

    @RequestMapping(value = "/changeRate", method = RequestMethod.POST)
    public String changeRate(@RequestParam(value = "rate") int rate,
                             @RequestParam(value = "sku") String sku,
                             @RequestParam(value = "isLike") boolean isLike,
                              Model model) {

        ProductCard productCard = productCardRepository.findOne(sku);
        if(isLike)
            productCard.setLikes(productCard.getLikes() + rate);
        else
            productCard.setDislikes(productCard.getDislikes() + rate);

        productCardRepository.save(productCard);

        return showProductCard(sku, model);
    }

    @RequestMapping(value = {"/", "/index", "/home", "/categories"}, method = RequestMethod.GET)
    public String showRootCategories(Model model) {
        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("listAllCategories", shopManager.getAllCategories());

        return "categories";
    }

    @RequestMapping(value = {"/subcategories/{id}", "/subcategories"}, method = RequestMethod.GET)
    public String showSubcategories(@PathVariable(value = "id", required = false) Integer id, Model model) {

        if (id == null)
            return showRootCategories(model);

        List<Category> subCategories = shopManager.getSubCategories(id);

        List<ProductCard> productCardsByCategory = shopManager.getProductCardsByCategory(id);

        if (subCategories.size() > 0) {
            model.addAttribute("listSubCategories", subCategories);
            model.addAttribute("listAllCategories", shopManager.getAllCategories());
            model.addAttribute("listAllProductCards", productCardRepository.findAll());
            return "categories";
        } else {
            model.addAttribute("listProductCards", productCardsByCategory);
            return "categories";
        }
    }

    @RequestMapping("/productCard/{sku}")
    public String showProductCard(
            @PathVariable(value = "sku")
                    String sku,
            Model model) {

        ProductCard productCard = productCardRepository.findOne(sku);

        model.addAttribute("productCard", productCard);
        model.addAttribute("listAttributeValues", attributeValueRepository.findByProductCard(productCard));
        model.addAttribute("listVisualisations", shopManager.getVisualListByProduct(productCard.getSku()));

        return "productCard";
    }

    // TODO: 04.04.17
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