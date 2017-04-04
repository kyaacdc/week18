package com.smarthouse.seleniumPOM;

import com.smarthouse.pojo.Category;
import com.smarthouse.repository.CategoryRepository;
import io.github.bonigarcia.wdm.ChromeDriverManager;
import org.junit.*;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.concurrent.TimeUnit;

import static org.openqa.selenium.remote.ErrorCodes.TIMEOUT;
import static org.hamcrest.Matchers.*;
import static org.junit.Assert.*;

//@SpringBootTest(properties = "server.port=9000", webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
//@SeleniumTest(driver = ChromeDriver.class, baseUrl = "http://localhost:9000")

@RunWith(SpringRunner.class)
@SpringBootTest(properties = "server.port=8080", webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@SeleniumTest(driver = ChromeDriver.class, baseUrl = "http://localhost:8080")
public class HomeControllerTest {

    @Autowired
    private CategoryRepository categoryRepository;

    private WebDriver driver;

    private HomePage homePage;

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

    @Before
    public void setUp() throws Exception {
        homePage = PageFactory.initElements(driver, HomePage.class);
    }

    //Test with Page Object model

    @Test
    public void containsCorrectTitle() {

        assertThat(homePage.getTitle(), is(equalTo("Categories")));
    }

    @Test
    public void containsActuatorLinks() {

        homePage.assertThat()
                .hasActuatorLink("name")
                .hasNoActuatorLink("noname");
    }

    @Test
    public void failingTest() {
        homePage.assertThat()
                .hasNoActuatorLink("failname");
    }

    @Test
    public void shouldAssertRightCurrentUrl() {
        assertEquals(homePage.getUrl(), "http://localhost:8080/");
    }
}