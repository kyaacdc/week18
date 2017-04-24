package com.smarthouse.seleniumSimple;

import java.util.concurrent.TimeUnit;

import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.ProductCardRepository;
import org.junit.After;
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
import io.github.bonigarcia.wdm.ChromeDriverManager;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

@RunWith(SpringRunner.class)
@SpringBootTest(properties = "server.port=8080", webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
public class HomePageSimpleSeleniumTest {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private ProductCardRepository productCardRepository;

    private static final long TIMEOUT = 30; // seconds
    private WebDriver driver;

    @BeforeClass
    public static void setupClass() {
        ChromeDriverManager.getInstance().setup();
    }

    @Before
    public void setupTest() {

        Category category = categoryRepository.save(new Category("desc", "name", null));
        productCardRepository.save(new ProductCard("1-1", "name", 123, 321, 5, 6, "desc", category));

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
        productCardRepository.deleteAll();
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

        // Click on link
        driver.findElement(By.linkText("name")).click();

        // Verify second page text content
        assertTrue(ExpectedConditions
                .textToBePresentInElementLocated(By.tagName("body"), "Product")
                .apply(driver));

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