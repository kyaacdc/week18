package com.smarthouse.controller;

import java.util.concurrent.TimeUnit;

import com.smarthouse.pojo.Category;
import com.smarthouse.repository.CategoryRepository;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import io.github.bonigarcia.wdm.ChromeDriverManager;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

@RunWith(SpringRunner.class)
@SpringBootTest(properties = "server.port=8080", webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
public class SimpleSeleniumTest {

    @Autowired
    private CategoryRepository categoryRepository;

    private static final long TIMEOUT = 30; // seconds
    private WebDriver driver;

    @BeforeClass
    public static void setupClass() {
        ChromeDriverManager.getInstance().setup();
    }

    @Before
    public void setupTest() {
        categoryRepository.save(new Category("desc", "name", null));
        driver = new ChromeDriver();

        //Always wait TIMEOUT seconds
        driver.manage().timeouts().implicitlyWait(TIMEOUT, TimeUnit.SECONDS);

        // Open system under test
        driver.get("http://localhost:8080/");
    }

    @After
    public void teardown() {
        if (driver != null) {
            driver.quit();
        }
        categoryRepository.deleteAll();
    }

    @Test
    public void shouldCorrectFindElementInBody() {

        assertTrue(ExpectedConditions
                .textToBePresentInElementLocated(By.tagName("body"), "Welcome")
                .apply(driver));

        driver.findElement(By.linkText("name")).click();

        // Verify second page text content
        assertTrue(ExpectedConditions
                .textToBePresentInElementLocated(By.tagName("body"), "Product")
                .apply(driver));
    }

    @Test
    public void shouldRedirectToProductCardPage() {

        assertThat(driver.getCurrentUrl(), is(equalTo("http://localhost:8080/")));

        WebElement element = driver.findElement(By.linkText("name"));

        element.getTagName();

        // Click on link
        driver.findElement(By.linkText("name")).click();

        // Verify second page text content
        assertTrue(ExpectedConditions
                .textToBePresentInElementLocated(By.tagName("body"), "Product")
                .apply(driver));
        assertTrue(ExpectedConditions.titleContains("Product").apply(driver));


        // Click on link
        driver.findElement(By.linkText("Back to Homepage")).click();

        assertTrue(ExpectedConditions.titleContains("Categories").apply(driver));

    }

    @Test
    public void containsWordsInBodyTags() {

        // Verify first page title
        assertTrue(ExpectedConditions.titleContains("Categories").apply(driver));
        assertTrue(ExpectedConditions.titleIs("Categories").apply(driver));

        assertTrue(ExpectedConditions
                .textToBePresentInElementLocated(By.tagName("body"), "Welcome")
                .apply(driver));

        //ExpectedConditions.elementToBeSelected()

        driver.findElement(By.linkText("name")).click();

        // Verify second page text content
        assertTrue(ExpectedConditions
                .textToBePresentInElementLocated(By.tagName("body"), "Product")
                .apply(driver));
    }


}