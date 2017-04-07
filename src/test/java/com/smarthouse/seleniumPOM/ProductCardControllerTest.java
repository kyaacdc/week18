package com.smarthouse.seleniumPOM;

import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.ProductCardRepository;
import com.smarthouse.seleniumPOM.pom.ProductCardPage;
import com.smarthouse.seleniumPOM.pom.SeleniumTest;
import io.github.bonigarcia.wdm.ChromeDriverManager;
import org.junit.*;
import org.junit.runner.RunWith;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.PageFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import java.util.concurrent.TimeUnit;
import static org.hamcrest.Matchers.*;
import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest(properties = "server.port=8080", webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@SeleniumTest(driver = ChromeDriver.class, baseUrl = "http://localhost:8080/productCard/1-1")
public class ProductCardControllerTest {

    @Autowired
    private ProductCardRepository productCardRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private WebDriver driver;

    private ProductCardPage productCardPage;

    private static final long TIMEOUT = 30; // seconds

    @BeforeClass
    public static void setupClass() {
        ChromeDriverManager.getInstance().setup();
    }

    @Before
    public void setupTest() {

        Category category = categoryRepository.save(new Category("desc", "name", null));
        productCardRepository.save(new ProductCard("1-1", "name", 123, 321, 5, 6, "desc", category));

        //Always wait TIMEOUT seconds
        driver.manage().timeouts().implicitlyWait(TIMEOUT, TimeUnit.SECONDS);

        //Open system under test
       driver.get("http://localhost:8080/productCard/1-1");

        productCardPage = PageFactory.initElements(driver, ProductCardPage.class);
    }

    @After
    public void teardown() {
        productCardRepository.deleteAll();
        categoryRepository.deleteAll();
    }


    //Tests with use Page Object model pattern
    @Test
    public void containsCorrectTitle() {
        assertThat(productCardPage.getTitle(), is(equalTo("Product Card")));
    }

    @Test
    public void containWordsInBody(){
        assertTrue(productCardPage.getBodyWords().get(0).isDisplayed());
        assertTrue(productCardPage.getBodyWords().get(0).getText().length() > 0);
    }

    @Test
    public void containHrefWordsInBody(){
        assertTrue(productCardPage.getHrefWords().get(0).isDisplayed());
        assertTrue(productCardPage.getHrefWords().get(0).getText().length() > 0);
        assertThat(productCardPage.getHrefWords().get(0).getText(), is(equalTo("Back to Homepage")));
        System.out.println(productCardPage.getUrl());
    }

    @Test
    public void shouldCheckIsUrlCorrect(){
        assertThat(productCardPage.getUrl(), is(equalTo("http://localhost:8080/productCard/1-1")));
    }
}