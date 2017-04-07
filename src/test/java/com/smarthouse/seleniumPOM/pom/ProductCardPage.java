package com.smarthouse.seleniumPOM.pom;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

import java.util.List;

public class ProductCardPage {

    @FindBy(how = How.TAG_NAME, using = "body")
    private List<WebElement> bodyWords;

    @FindBy(xpath = "//a")
    private List<WebElement> hrefWords;

    private final WebDriver driver;

    public ProductCardPage(WebDriver driver) {
        this.driver = driver;
    }

    public String getTitle() {
        return driver.getTitle();
    }

    public String getUrl() {
        return driver.getCurrentUrl();
    }



    public List<WebElement> getBodyWords() {
        return bodyWords;
    }

    public List<WebElement> getHrefWords() {
        return hrefWords;
    }
}
