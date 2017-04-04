package com.smarthouse.repository;

import com.smarthouse.pojo.Category;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface CategoryRepository extends PagingAndSortingRepository<Category, Integer> {

    List<Category> findByNameIgnoreCase(@Param("name") String name);
    List<Category> findByDescriptionIgnoreCase(@Param("description") String description);

    //List<Category> findByCategory(@Param("categoryId") int category);
    List<Category> findByCategory(Category category);
}
