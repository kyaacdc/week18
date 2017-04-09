package com.smarthouse.perfomance;

import com.smarthouse.WebApplication;
import com.smarthouse.controller.ShopController;
import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.ProductCardRepository;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.ui.Model;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = WebApplication.class)
public class ProductCartPermomanceChecker {

    @Autowired
    CategoryRepository categoryRepository;

    @Autowired
    ProductCardRepository productCardRepository;

    @Test
    public void shouldCompareMeasureOfPerfomanceShowProductCards(){

        Category category = categoryRepository.save(new Category("desc", "name", null));

        for(int i = 0; i < 5000; i++)
            productCardRepository.save(new ProductCard(("" + i), "name", 123, 321, 5, 6, "desc", category));

        String sku = "5500";

        String response = "";

        for(int i = 0; i < 5000; i++) {
            List<String> listSku = ((List<ProductCard>) productCardRepository.findAll()).stream()
                    .map(ProductCard::getSku).collect(Collectors.toList());
            if (listSku.contains(sku)) {
                productCardRepository.findOne(sku);
                response = "product";
            }
        }

        long start = System.nanoTime();
        for(int i = 0; i < 5000; i++) {
            List<String> listSku = ((List<ProductCard>) productCardRepository.findAll()).stream()
                    .map(ProductCard::getSku).collect(Collectors.toList());
            if (listSku.contains(sku)) {
                productCardRepository.findOne(sku);
                response = "product";
            }
        }
        long stop = System.nanoTime() - start;

        for(int i = 0; i < 5000; i++) {
            if (productCardRepository.findOne(sku) != null)
                response = "product";
        }

        start = System.nanoTime();
        for(int i = 0; i < 5000; i++) {
            if (productCardRepository.findOne(sku) != null)
                response = "product";
        }
        System.out.println("Method with use list sku slower than with no list - " + stop / (System.nanoTime() - start));

        productCardRepository.deleteAll();
        categoryRepository.deleteAll();
    }
}
