package com.smarthouse.pojo;

public class Cart {

    private String sku;
    private String name;
    private int amount;

    public Cart() {
    }

    public Cart(String sku, String name, int amount) {
        this.sku = sku;
        this.name = name;
        this.amount = amount;
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
}
