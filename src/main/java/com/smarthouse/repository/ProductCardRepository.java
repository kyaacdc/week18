package com.smarthouse.repository;

import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProductCardRepository extends PagingAndSortingRepository<ProductCard, String> {

    List<ProductCard> findByNameIgnoreCase(@Param("name") String name);

    List<ProductCard> findByProductDescriptionIgnoreCase(String productDescription);
    List<ProductCard> findByCategory(Category category, Sort sort);
    List<ProductCard> findAllBy(Sort sort);
}
