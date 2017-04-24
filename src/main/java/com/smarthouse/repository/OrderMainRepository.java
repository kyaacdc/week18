package com.smarthouse.repository;

import com.smarthouse.pojo.Customer;
import com.smarthouse.pojo.OrderMain;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderMainRepository extends PagingAndSortingRepository<OrderMain, Integer> {

    List<OrderMain> findByAddressIgnoreCase(@Param("address") String address);

    List<OrderMain> findByCustomer(Customer customer);
}
