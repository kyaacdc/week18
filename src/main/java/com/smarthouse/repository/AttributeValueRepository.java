package com.smarthouse.repository;

import com.smarthouse.pojo.AttributeName;
import com.smarthouse.pojo.AttributeValue;
import com.smarthouse.pojo.ProductCard;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface AttributeValueRepository extends PagingAndSortingRepository<AttributeValue, Integer> {

    List<AttributeValue> findByAttributeName(AttributeName attributeName);

    List<AttributeValue> findByProductCard(ProductCard productCard);

}
