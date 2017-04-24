package com.smarthouse.seleniumPOM;

import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.OrderItemRepository;
import com.smarthouse.repository.OrderMainRepository;
import com.smarthouse.repository.ProductCardRepository;
import com.smarthouse.seleniumPOM.pom.CartPage;
import com.smarthouse.seleniumPOM.pom.ProductCardPage;
import com.smarthouse.seleniumPOM.pom.SeleniumTest;
import io.github.bonigarcia.wdm.ChromeDriverManager;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.PageFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.DependencyInjectionTestExecutionListener;
import org.springframework.test.context.support.DirtiesContextTestExecutionListener;
import org.springframework.test.context.transaction.TransactionalTestExecutionListener;

import java.util.concurrent.TimeUnit;

import static org.hamcrest.Matchers.containsString;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest(properties = "server.port=8080", webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@SeleniumTest(driver = ChromeDriver.class, baseUrl = "http://localhost:8080/showCart")
public class CartPageTest {

    @Autowired
    private WebDriver driver;

    @Autowired
    private ProductCardRepository productCardRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private OrderMainRepository orderMainRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    private CartPage cartPage;
    private ProductCardPage productCardPage;

    private static final long TIMEOUT = 10; // seconds

    @BeforeClass
    public static void setupClass() {
        ChromeDriverManager.getInstance().setup();
    }

    @Before
    public void setUp() throws Exception {
        Category category = categoryRepository.save(new Category("desc", "name", null));
        productCardRepository.save(
                new ProductCard(
                        "1-1", "name", 123, 321, 5, 6, "desc", category
                )
        );
        driver.manage().timeouts().implicitlyWait(TIMEOUT, TimeUnit.SECONDS);

        driver.get("http://localhost:8080/product/1-1");
        productCardPage = PageFactory.initElements(driver, ProductCardPage.class);
    }

    @After
    public void tearDown() throws Exception {
        orderItemRepository.deleteAll();
        productCardRepository.deleteAll();
        orderMainRepository.deleteAll();
        categoryRepository.deleteAll();
    }

    @Test
    public void whenNotAddProductShouldShowMessageAboutEmptyCart() throws Exception {
        driver.get("http://localhost:8080/showCart");
        cartPage = PageFactory.initElements(driver, CartPage.class);
        assertEquals("Your Cart is Empty",
                driver.findElement(By.xpath("html/body/header/div/h1")).getText());
    }

    @Test
    public void whenAddOneProductShouldRecalculatePrice() throws Exception {
        productCardPage.addToCart("name");
        driver.findElement(By.xpath("html/body/nav/div/div/div/a/abbr")).click();
        cartPage = PageFactory.initElements(driver, CartPage.class);

        assertEquals("Total amount - (1) Total price - (123)",
                cartPage.getTotalAmountAndPrice().getText());

        cartPage.removeFromCartByName("name");
    }

    @Test
    public void whenRemoveOneProductShouldRecalculatePrice() throws Exception {
        productCardPage.addToCart("name");
        driver.findElement(By.xpath("html/body/nav/div/div/div/a/abbr")).click();
        cartPage = PageFactory.initElements(driver, CartPage.class);

        cartPage.removeFromCartByName("name");
        assertEquals("Total amount - (0) Total price - (0) Go to Cart",
                cartPage.getTotalAmountAndPrice().getText());
    }

    @Test
    public void whenAddOneProductAndCustomerFormIsCorrectShouldBuyOneProduct() throws Exception {
        productCardPage.addToCart("name");
        driver.findElement(By.xpath("html/body/nav/div/div/div/a/abbr")).click();
        cartPage = PageFactory.initElements(driver, CartPage.class);

        cartPage.getEmail().sendKeys("a@a.ru");
        cartPage.getBtnSubmit().click();
        assertThat(driver.findElement(By.xpath("html/body/header/div/h1")).getText(),
                containsString("Thanks for your choice. Your orderId is"));
    }

    @Test
    public void whenAddOneProductAndCustomerEmailIsNotCorrectShouldShowErrorMessages() throws Exception {
        productCardPage.addToCart("name");
        driver.findElement(By.xpath("html/body/nav/div/div/div/a/abbr")).click();
        cartPage = PageFactory.initElements(driver, CartPage.class);

        cartPage.getEmail().sendKeys("mail");
        cartPage.getBtnSubmit().click();
        assertThat(driver.findElement(By.xpath("html/body/main/div[2]/form")).getText(),
                containsString("* Email not valid."));

        cartPage.removeFromCartByName("name");
    }

    @Test
    public void whenAddOneProductAndCustomerAnotherFielsIsNotCorrectShouldShowErrorMessages() throws Exception {
        productCardPage.addToCart("name");
        driver.findElement(By.xpath("html/body/nav/div/div/div/a/abbr")).click();
        cartPage = PageFactory.initElements(driver, CartPage.class);

        cartPage.getEmail().sendKeys("a@a.com");
        cartPage.getName().sendKeys("Andrii123");
        cartPage.getPhone().sendKeys("023a");
        cartPage.getAddress().sendKeys("Super address");
        cartPage.getBtnSubmit().click();

        WebElement form = driver.findElement(By.xpath("html/body/main/div[2]/form"));
        assertThat(form.getText(),
                containsString("Name should consist only of letters."));
        assertThat(form.getText(),
                containsString("Phone number should consist only of digits."));

        cartPage.removeFromCartByName("name");
    }
}
