package com.smarthouse.seleniumPOM.pom;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class CartPage {
    private final WebDriver driver;

    @FindBy(xpath = "/html/body/nav/div/div/div")
    private WebElement totalAmountAndPrice;

    @FindBy(xpath = "//table[@class='tg']/tr")
    private List<WebElement> trCollection;

    @FindBy(xpath = "//table/tbody/tr[2]/td/form/button")
    private List<WebElement> btnsRemove;

    @FindBy(name = "email")

    private WebElement email;

    @FindBy(xpath = "/html/body/main/div[2]/form/input[2]")
    private WebElement name;

    @FindBy(xpath = "/html/body/main/div[2]/form/input[3]")
    private WebElement phone;

    @FindBy(xpath = "/html/body/main/div[2]/form/input[4]")
    private WebElement address;

    @FindBy(xpath = "/html/body/main/div[2]/form/button")
    private WebElement btnSubmit;

    public CartPage(WebDriver driver) {
        this.driver = driver;
    }

    public void removeFromCartByName(String productName) {
        WebElement btnRemove = driver.findElement(
                By.xpath("//td[a[contains(text(),'" + productName + "')]]/following-sibling::td[3]//button")
        );
        btnRemove.click();
    }

    public WebElement getTotalAmountAndPrice() {
        return totalAmountAndPrice;
    }

    public List<WebElement> getTrCollection() {
        return trCollection;
    }

    public List<WebElement> getBtnsRemove() {
        return btnsRemove;
    }

    public WebElement getEmail() {
        return email;
    }

    public WebElement getName() {
        return name;
    }

    public WebElement getPhone() {
        return phone;
    }

    public WebElement getAddress() {
        return address;
    }

    public WebElement getBtnSubmit() {
        return btnSubmit;
    }
}
