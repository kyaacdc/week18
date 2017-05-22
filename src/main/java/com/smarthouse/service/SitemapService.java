package com.smarthouse.service;

import com.redfin.sitemapgenerator.ChangeFreq;
import com.redfin.sitemapgenerator.WebSitemapGenerator;
import com.redfin.sitemapgenerator.WebSitemapUrl;
import com.smarthouse.pojo.Category;
import com.smarthouse.pojo.ProductCard;
import com.smarthouse.repository.CategoryRepository;
import com.smarthouse.repository.ProductCardRepository;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.net.MalformedURLException;
import java.util.Date;
import java.util.Objects;

@Service
public final class SitemapService {

    private static final String BASE_URL = "http://localhost:8888";

    private final ProductCardRepository productCardRepository;
    private final CategoryRepository categoryRepository;

    @Inject
    public SitemapService(ProductCardRepository productCardRepository, CategoryRepository categoryRepository) {
        this.productCardRepository = Objects.requireNonNull(productCardRepository);
        this.categoryRepository = categoryRepository;
    }

    public String createFullSitemap() throws MalformedURLException {

        WebSitemapGenerator webSitemapGenerator = new WebSitemapGenerator(BASE_URL);

        for (Category category : categoryRepository.findAll()) {
            String url = BASE_URL + "/subcategories/" + category.getId() + "@" + category.getName();
            WebSitemapUrl webSitemapUrl = new WebSitemapUrl
                    .Options(url)
                    .lastMod(new Date())
                    .priority(0.8)
                    .changeFreq(ChangeFreq.MONTHLY).build();
            webSitemapGenerator.addUrl(webSitemapUrl);
        }

        for (ProductCard productCard : productCardRepository.findAll()) {
            String url = BASE_URL + "/product/" + productCard.getSku() + "@" + productCard.getName();
            WebSitemapUrl webSitemapUrl = new WebSitemapUrl
                    .Options(url)
                    .lastMod(new Date())
                    .priority(1.0)
                    .changeFreq(ChangeFreq.DAILY).build();
            webSitemapGenerator.addUrl(webSitemapUrl);
        }

        return String.join("", webSitemapGenerator.writeAsStrings());
    }
}
