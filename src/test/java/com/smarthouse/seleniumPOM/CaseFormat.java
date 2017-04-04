package com.smarthouse.seleniumPOM;

import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class CaseFormat {

    public static String toLowerUnderscore(String upperCamel) {
        return Stream
                .of(upperCamel.split("(?=[A-Z])"))
                .map(String::toLowerCase)
                .collect(Collectors.joining("_"));
    }
}