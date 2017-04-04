package com.smarthouse.seleniumPOM;


import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.List;

public class HomePage {

    //@FindBy(how = How.TAG_NAME, using = "body")
    @FindBy(xpath = "//table//td/a")
    //@FindBy(xpath = "//a")
    private List<WebElement> actuatorLinks;



    private final WebDriver driver;

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    public HomePageAssert assertThat() {
        return new HomePageAssert(this);
    }

    public String getTitle() {
        return driver.getTitle();
    }

    public String getUrl() {
        return driver.getCurrentUrl();
    }


    public List<WebElement> getActuatorLinks() {
        return actuatorLinks;
    }
}
