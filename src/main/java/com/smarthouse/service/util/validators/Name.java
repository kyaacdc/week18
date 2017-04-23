package com.smarthouse.service.util.validators;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = NameConstraintValidator.class)
@Target( { ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface Name {
    String message() default "{Name}";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
