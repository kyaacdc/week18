package com.smarthouse.seleniumPOM;

import com.smarthouse.pojo.Category;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.seleniumPOM.pom.HomePage;
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
@SeleniumTest(driver = ChromeDriver.class, baseUrl = "http://localhost:8080")
public class HomePageControllerTest {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private WebDriver driver;

    private HomePage homePage;

    private static final long TIMEOUT = 30; // seconds

    @BeforeClass
    public static void setupClass() {
        ChromeDriverManager.getInstance().setup();
    }

    @Before
    public void setupTest() {

        categoryRepository.save(new Category("desc", "name", null));

        //Always wait TIMEOUT seconds
        driver.manage().timeouts().implicitlyWait(TIMEOUT, TimeUnit.SECONDS);

        // Open system under test
        driver.get("http://localhost:8080/");

        homePage = PageFactory.initElements(driver, HomePage.class);
    }

    @After
    public void teardown() {
        categoryRepository.deleteAll();
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
    public void shouldCheckIsUrlCorrect(){
        assertThat(homePage.getUrl(), is(equalTo("http://localhost:8080/")));
    }

    @Test
    public void shouldAssertRightCurrentUrl() {
        assertEquals(homePage.getUrl(), "http://localhost:8080/");
    }
}