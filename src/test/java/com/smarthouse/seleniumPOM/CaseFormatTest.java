package com.smarthouse.seleniumPOM;

import com.smarthouse.seleniumPOM.pom.CaseFormat;
import org.junit.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class CaseFormatTest {
    @Test
    public void convertsCamelCaseToLowerUnderscore() {
        assertThat(CaseFormat.toLowerUnderscore("HomePageControllerTest"))
                .isEqualTo("home_page_controller_test");
    }
}