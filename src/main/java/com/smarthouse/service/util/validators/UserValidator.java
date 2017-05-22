package com.smarthouse.service.util.validators;

import com.smarthouse.pojo.User;
import com.smarthouse.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

@Component
public class UserValidator implements Validator {

    private final UserService userService;

    @Autowired
    public UserValidator(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return User.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        User user = (User) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "username", "Required");
        if(user.getUsername().length() < 4 || user.getUsername().length() > 32)
            errors.rejectValue("username", "Size.userForm.username");
        if(userService.findByUsername(user.getUsername()) != null)
            errors.rejectValue("username", "Duplicate.userForm.username");

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "password", "Required");
        if(user.getPassword().length() < 4 || user.getPassword().length() > 16)
            errors.rejectValue("password", "Size.userForm.password");
        if(!user.getConfirmPassword().equals(user.getPassword()))
            errors.rejectValue("password", "Different.userForm.password");

    }
}

