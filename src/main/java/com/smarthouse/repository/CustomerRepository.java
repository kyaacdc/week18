package com.smarthouse.repository;

import com.smarthouse.pojo.Customer;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface CustomerRepository extends PagingAndSortingRepository<Customer, String> {

    List<Customer> findByName(@Param("name") String name);


}
