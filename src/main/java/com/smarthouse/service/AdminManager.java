package com.smarthouse.service;

import com.smarthouse.pojo.Category;
import com.smarthouse.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminManager {

    private final ProductCardRepository productCardRepository;
    private final CategoryRepository categoryRepository;
    private final CustomerRepository customerRepository;
    private final OrderMainRepository orderMainRepository;
    private final OrderItemRepository orderItemRepository;
    private final VisualizationRepository visualizationRepository;
    private final AttributeValueRepository attributeValueRepository;
    private final AttributeNameRepository attributeNameRepository;

    @Autowired
    public AdminManager(ProductCardRepository productCardRepository, CategoryRepository categoryRepository, CustomerRepository customerRepository, OrderMainRepository orderMainRepository, OrderItemRepository orderItemRepository, VisualizationRepository visualizationRepository, AttributeValueRepository attributeValueRepository, AttributeNameRepository attributeNameRepository) {
        this.productCardRepository = productCardRepository;
        this.categoryRepository = categoryRepository;
        this.customerRepository = customerRepository;
        this.orderMainRepository = orderMainRepository;
        this.orderItemRepository = orderItemRepository;
        this.visualizationRepository = visualizationRepository;
        this.attributeValueRepository = attributeValueRepository;
        this.attributeNameRepository = attributeNameRepository;
    }

    public Category addCategory(Category category) {
        return categoryRepository.save(category);
    }
}
