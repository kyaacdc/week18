package com.smarthouse.repository;

import com.smarthouse.pojo.OrderItem;
import com.smarthouse.pojo.OrderMain;
import com.smarthouse.pojo.ProductCard;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface OrderItemRepository extends PagingAndSortingRepository<OrderItem, Integer> {

    List<OrderItem> findByOrderMain(OrderMain orderMain);

    List<OrderItem> findByProductCard(ProductCard productCard);

}
