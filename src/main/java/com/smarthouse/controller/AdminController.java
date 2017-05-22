package com.smarthouse.controller;

import com.smarthouse.pojo.*;
import com.smarthouse.service.AdminManager;
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

import java.util.*;
import java.util.stream.Collectors;

import static com.smarthouse.service.util.enums.EnumSearcher.FIND_ALL;
import static com.smarthouse.service.util.enums.EnumSearcher.FIND_IN_ALL_PLACES;

@Controller
@Scope(proxyMode = ScopedProxyMode.TARGET_CLASS, value = "session")
public class AdminController {

    private boolean isSorted = true;
    private List<ProductCard> foundProducts = new ArrayList<>();
    private List<Visualization> listVizualisations = new ArrayList<>();
    private final ShopManager shopManager;
    private final AdminManager adminManager;

    @Autowired
    public AdminController(ShopManager shopManager, AdminManager adminManager) {
        this.shopManager = shopManager;
        this.adminManager = adminManager;
    }

    @GetMapping(value = {"/admin/categoriesAdmin", "/admin"})
    public String showRootCategories(Model model) {

        model.addAttribute("category", new Category());
        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        model.addAttribute("pathPhotoHomepage", shopManager.getVisualListByType(555).get(0).getUrl());

        return "/admin/categoriesAdmin";
    }

    @GetMapping(value = {"/admin/subcategoriesAdmin/{id}", "/admin/subcategoriesAdmin"})
    public String showSubcategories(@PathVariable(value = "id", required = false) String idStr, Model model) {

        if (idStr == null)
            return "redirect:/admin/categoriesAdmin";

        String[] split = idStr.split("@");
        Integer id = Integer.parseInt(split[0]);
        Category category = shopManager.getCategoryById(id);

        if (id <= 0 || category == null)
            return showRootCategories(model);

        List<Category> subCategories = shopManager.getSubCategories(id);
        List<ProductCard> productCardsByCategory = shopManager.getProductCardsByCategory(id);
        List<Visualization> listVizualisations = productCardsByCategory.stream()
                .flatMap(a -> shopManager.getVisualListByProduct(a.getSku()).stream())
                .collect(Collectors.toList());

        foundProducts.clear();
        model.addAttribute("category", new Category());
        model.addAttribute("listProduct", productCardsByCategory);
        model.addAttribute("listVizualisations", listVizualisations);
        model.addAttribute("categoryId", id);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
        model.addAttribute("listSubCategories", subCategories);

        return "/admin/categoriesAdmin";
    }

    @GetMapping("/admin/categoriesAdmin/edit/{id}")
    public String editRootCategory(@PathVariable("id") int id, Model model) {
        model.addAttribute("category", shopManager.getCategoryById(id));
        model.addAttribute("listRootCategories", shopManager.getRootCategories());
        return "/admin/categoriesAdmin";
    }

    @GetMapping("/admin/subcategoriesAdmin/edit/{id}")
    public String editSubCategory(@PathVariable("id") int id, Model model) {
        int idParentCategory = shopManager.getCategoryById(id).getCategory().getId();
        model.addAttribute("category", shopManager.getCategoryById(id));
        model.addAttribute("listSubCategories", shopManager.getSubCategories(idParentCategory));
        return "/admin/categoriesAdmin";
    }

    @PostMapping("/admin/subcategoriesAdmin/add")
    public String addCategory(@ModelAttribute("category") Category category) {
        adminManager.addCategory(category);
        return "redirect:/admin/categoriesAdmin";
    }

    @GetMapping(value = {"/admin/productAdmin/{sku}", "/admin/productAdmin"})
    public String showProductCard(@PathVariable(value = "sku", required = false) String skuStr, Model model) {

        if (skuStr == null)
            return "redirect:/admin/categoriesAdmin";

        String[] split = skuStr.split("@");
        String sku = split[0];

        ProductCard productCard = shopManager.getProductCardBySku(sku);

        if (productCard != null) {
            model.addAttribute("product", productCard);
            model.addAttribute("listVisualisations", shopManager.getVisualListByProduct(sku));

            List<AttributeValue> attrValuesByProduct = shopManager.getAttrValuesByProduct(sku);
            if (attrValuesByProduct.size() > 0) {
                model.addAttribute("attributeList", attrValuesByProduct);
                model.addAttribute("isAttributesNotPresent", false);
            } else model.addAttribute("isAttributesNotPresent", true);

            return "/admin/productAdmin";
        } else
            return "redirect:/admin/categoriesAdmin";
    }

    @GetMapping(value = "/admin/sortProductCardByAdmin")
    public String sortProductCardBy(@RequestParam(value = "categoryId", required = false) Integer categoryId,
                                    @RequestParam(value = "sortCriteria") EnumProductSorter sortCriteria,
                                    Model model) {

        if (foundProducts.size() == 0 && categoryId != null) {
            model.addAttribute("listProduct", shopManager.sortProductCardBy(categoryId, sortCriteria));
            model.addAttribute("categoryId", categoryId);
        } else
            model.addAttribute("listProduct", shopManager.sortSearchResultsBy(foundProducts, sortCriteria));

        model.addAttribute("isSorted", isSorted);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
        model.addAttribute("listVizualisations", listVizualisations);

        isSorted = !isSorted;

        return "/admin/categoriesAdmin";
    }

    @GetMapping(value = "/admin/findProductsAdmin")
    public String findProducts(@RequestParam(value = "findOption", required = false) EnumSearcher findBy,
                               @RequestParam(value = "searchValue") String searchValue,
                               Model model) {
        if (findBy == FIND_ALL) {
            Set<ProductCard> allProductsByCriteria = shopManager.findAllIncludeText(searchValue);
            foundProducts = new ArrayList<>(allProductsByCriteria);
        } else if (findBy == FIND_IN_ALL_PLACES) {
            Set<ProductCard> allProductsByCriteria = shopManager.findAllProductsByCriteria(searchValue);
            foundProducts = new ArrayList<>(allProductsByCriteria);
        } else {
            Set<ProductCard> allProductsByCriteria = shopManager.findProductsIn(searchValue, findBy);
            foundProducts = new ArrayList<>(allProductsByCriteria);
        }

        listVizualisations = foundProducts.stream()
                .flatMap(a -> shopManager.getVisualListByProduct(a.getSku()).stream())
                .collect(Collectors.toList());

        model.addAttribute("listProduct", foundProducts);
        model.addAttribute("isFoundListEmpty", foundProducts.isEmpty());
        model.addAttribute("listVizualisations", listVizualisations);

        if (foundProducts.isEmpty()) {
            model.addAttribute("listRootCategories", shopManager.getRootCategories());
            model.addAttribute("isNotFound", true);
        }

        return "/admin/categoriesAdmin";
    }

}