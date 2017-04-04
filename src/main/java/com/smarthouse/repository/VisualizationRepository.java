package com.smarthouse.repository;

import com.smarthouse.pojo.ProductCard;
import com.smarthouse.pojo.Visualization;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface VisualizationRepository extends PagingAndSortingRepository<Visualization, Integer> {

    List<Visualization> findByProductCard(ProductCard productCard);
}
