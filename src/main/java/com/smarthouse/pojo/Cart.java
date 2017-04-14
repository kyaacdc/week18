package com.smarthouse.pojo;

public class Cart {

    private String sku;
    private String name;
    private int amount;
    private int price;


    public Cart() {
    }

    public Cart(String sku, String name, int amount, int price) {
        this.sku = sku;
        this.name = name;
        this.amount = amount;
        this.price = price;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }
}
