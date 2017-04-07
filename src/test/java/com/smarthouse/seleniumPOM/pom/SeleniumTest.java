package com.smarthouse.seleniumPOM.pom;

import com.smarthouse.seleniumPOM.pom.SeleniumTestExecutionListener;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.springframework.test.context.TestExecutionListeners;

import java.lang.annotation.*;

import static org.springframework.test.context.TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS;

@Documented
@Inherited
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@TestExecutionListeners(
        listeners = SeleniumTestExecutionListener.class,
        mergeMode = MERGE_WITH_DEFAULTS)
public @interface SeleniumTest {

    Class<? extends WebDriver> driver() default ChromeDriver.class;

    String baseUrl() default "http://localhost:8080";
}