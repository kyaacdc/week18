package com.smarthouse.service;

import com.smarthouse.pojo.User;

public interface UserService {
    void save(User user);

    User findByUsername(String username);
}
