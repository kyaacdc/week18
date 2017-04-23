package com.smarthouse.pojo;

public class Rate {
    private String sku;
    private boolean isLiked;
    private boolean isDisliked;

    public Rate() {
    }

    public Rate(String sku, boolean isLiked, boolean isDisliked) {
        this.sku = sku;
        this.isLiked = isLiked;
        this.isDisliked = isDisliked;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public boolean isLiked() {
        return isLiked;
    }

    public void setLiked(boolean liked) {
        isLiked = liked;
    }

    public boolean isDisliked() {
        return isDisliked;
    }

    public void setDisliked(boolean disliked) {
        isDisliked = disliked;
    }
}
