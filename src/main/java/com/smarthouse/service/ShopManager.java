package com.smarthouse.service;

import com.smarthouse.repository.*;
import com.smarthouse.pojo.*;
import com.smarthouse.service.util.validators.EmailValidator;
import com.smarthouse.service.util.enums.EnumProductSorter;
import com.smarthouse.service.util.enums.EnumSearcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.persistence.NoResultException;
import javax.validation.ValidationException;
import java.util.*;
import java.util.stream.Collectors;

import static org.springframework.data.domain.Sort.Direction.ASC;
import static org.springframework.data.domain.Sort.Direction.DESC;

@Service
public class ShopManager {

    private ProductCardRepository productCardRepository;
    private CategoryRepository categoryRepository;
    private CustomerRepository customerRepository;
    private OrderMainRepository orderMainRepository;
    private OrderItemRepository orderItemRepository;
    private VisualizationRepository visualizationRepository;
    private AttributeValueRepository attributeValueRepository;
    private AttributeNameRepository attributeNameRepository;

    @Autowired
    public void setProductCardRepository(ProductCardRepository productCardRepository) {
        this.productCardRepository = productCardRepository;
    }
    @Autowired
    public void setCategoryRepository(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }
    @Autowired
    public void setCustomerRepository(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }
    @Autowired
    public void setOrderMainRepository(OrderMainRepository orderMainRepository) {
        this.orderMainRepository = orderMainRepository;
    }
    @Autowired
    public void setOrderItemRepository(OrderItemRepository orderItemRepository) {
        this.orderItemRepository = orderItemRepository;
    }
    @Autowired
    public void setVisualizationRepository(VisualizationRepository visualizationRepository) {
        this.visualizationRepository = visualizationRepository;
    }
    @Autowired
    public void setAttributeValueRepository(AttributeValueRepository attributeValueRepository) {
        this.attributeValueRepository = attributeValueRepository;
    }

    @Autowired
    public void setAttributeNameRepository(AttributeNameRepository attributeNameRepository) {
        this.attributeNameRepository = attributeNameRepository;
    }

    public ShopManager() {
    }

    public ShopManager(ProductCardRepository productCardRepository, CategoryRepository categoryRepository,
                       CustomerRepository customerRepository, OrderMainRepository orderMainRepository,
                       OrderItemRepository orderItemRepository, VisualizationRepository visualizationRepository,
                       AttributeValueRepository attributeValueRepository) {
        this.productCardRepository = productCardRepository;
        this.categoryRepository = categoryRepository;
        this.customerRepository = customerRepository;
        this.orderMainRepository = orderMainRepository;
        this.orderItemRepository = orderItemRepository;
        this.visualizationRepository = visualizationRepository;
        this.attributeValueRepository = attributeValueRepository;
    }

    /**
     * Method createOrder is add or update new Customer into database
     * and also add order info in DB with compute total price
     *
     * @param email   user email address for identy each user by primary key
     * @param name    name of user (optional)
     * @param phone   phone number of user (optional)
     * @param address address for receive order
     * @param amount  amount of products in order
     * @param sku     unique id of each product
     * @throws NoResultException   if amount of products in our order
     *                             less than on warehouse
     * @throws ValidationException if email is not valid
     */
    @Transactional
    public OrderMain createOrder(String email, String name, String phone,
                                 String address, int amount, String sku) {

        EmailValidator emailValidator = new EmailValidator();

        if (!emailValidator.validate(email))
            throw new ValidationException("Email not valid");
        if (!isRequiredAmountOfProductCardAvailable(sku, amount))
            throw new NoResultException("This amount of products not exist on our warehouse");

        OrderMain orderMain;

        if(customerRepository.findOne(email) == null) {
            Customer customer = new Customer(email, name, true, phone);
            customer = customerRepository.save(customer);
            orderMain = new OrderMain(address, 1, customer);
            orderMain = orderMainRepository.save(orderMain);
            ProductCard productCard = productCardRepository.findOne(sku);
            int totalPrice = productCard.getPrice() * amount;
            orderItemRepository.save(new OrderItem(amount, totalPrice, productCard, orderMain));
        }
        else if (orderMainRepository
                .findByCustomer(customerRepository
                        .findOne(email)).get((orderMainRepository
                        .findByCustomer(customerRepository.findOne(email)).size() - 1)).getStatus() == 2)
        {
            Customer customer = customerRepository.findOne(email);
            customer.setName(name);
            customer.setPhone(phone);
            customer = customerRepository.save(customer);
            orderMain = new OrderMain(address, 1, customer);
            orderMain = orderMainRepository.save(orderMain);
            ProductCard productCard = productCardRepository.findOne(sku);
            int totalPrice = productCard.getPrice() * amount;
            orderItemRepository.save(new OrderItem(amount, totalPrice, productCard, orderMain));
        }

        else {
            ProductCard productCard = productCardRepository.findOne(sku);
            int totalPrice = productCard.getPrice() * amount;

            LinkedList<OrderMain> orderMainLinkedList =
                    new LinkedList<>(orderMainRepository.findByCustomer(customerRepository.findOne(email)));

            orderMain = orderMainLinkedList.getLast();

            orderItemRepository.save(new OrderItem(amount, totalPrice, productCard, orderMain));
        }

        return orderMain;
    }

    /**
     * Method submitOrder need for update amount of ProductCard
     * on warehouse and update status of order in OrderMain in tables
     *
     * @param email is  a user email for making changes
     * @return void type
     * @throws NoResultException if amount of products in our order
     *                           less than on warehouse
     */
    @Transactional
    public List<OrderMain> submitOrder(String email) {

        if (validateOrder(email) && customerRepository.exists(email)) {
            Customer customer = customerRepository.findOne(email);
            List<OrderMain> ordersByCustomer = getOrdersByCustomer(customer.getEmail());
            List<OrderMain> resultList = new ArrayList<>();

            for (OrderMain om : ordersByCustomer) {

                if (om.getStatus() != 1)
                    continue;

                List<OrderItem> orderItemsByOrderMain = getItemOrdersByOrderMain(om.getOrderId());
                for (OrderItem oi : orderItemsByOrderMain) {
                    ProductCard productCard = productCardRepository.findOne(oi.getProductCard().getSku());
                    int newAmount = productCard.getAmount() - oi.getAmount();
                    productCard.setAmount(newAmount);
                    productCardRepository.save(productCard);
                }

                om.setStatus(2);
                resultList.add(orderMainRepository.save(om));
            }

            return resultList;
        }
        throw new NoResultException("Error of submit order");
    }

    /**
     * Method findProductsByCriteriaInAllPlaces need for find any ProductCard
     * on warehouse by String criteria in all Db     *
     *
     * @param criteria String is  a string for the find
     * @return Set<ProductCard> type with found set of products
     */
    //public Set<ProductCard> findAllProductsByCriteria(@RequestParam(value="criteria") String criteria) {
    public Set<ProductCard> findAllProductsByCriteria(String criteria) {

        Set<ProductCard> result = new LinkedHashSet<>();

        ProductCard productCard = productCardRepository.findOne(criteria);
        if (productCard != null)
            result.add(productCard);

        List<ProductCard> list = productCardRepository.findByNameIgnoreCase(criteria);
        if (list.size() > 0)
            result.addAll(list);

        list = productCardRepository.findByProductDescriptionIgnoreCase(criteria);
        if (list.size() > 0)
            result.addAll(list);

        result.addAll(getProductsByCategoryDescription(criteria));
        result.addAll(getProductsByCategoryName(criteria));

        return result;
    }

    public Set<ProductCard> findAllIncludeText(String criteria) {

        String finalCriteria = criteria.toLowerCase();

        return ((List<ProductCard>) productCardRepository.findAll()).stream()
                .filter(a -> a.getName().toLowerCase().contains(finalCriteria) ||
                        a.getProductDescription().toLowerCase().contains(finalCriteria) ||
                        a.getCategory().getName().toLowerCase().contains(finalCriteria) ||
                        a.getCategory().getDescription().toLowerCase().contains(finalCriteria))
                .sorted(Comparator.comparing(ProductCard::getName).reversed())
                .collect(Collectors.toSet());
    }

    /**
     * Method findProductsInColumn need for find any ProductCard
     * on warehouse by String criteria, in custom place.
     *
     * @param criteria     String is  a string for the find
     * @param place enumeration for choose sort criteria:
     *                     FIND_ALL,
     *                     FIND_BY_NAME,
     *                     FIND_IN_PROD_DESC,
     *                     FIND_IN_CATEGORY_NAME,
     *                     FIND_IN_CATEGORY_DESC;
     * @return Set<ProductCard> found results of products
     */
    public Set<ProductCard> findProductsIn(String criteria, EnumSearcher place) {

        Set<ProductCard> result = new LinkedHashSet<>();

        switch (place) {
            case FIND_IN_NAME:
                result.addAll(productCardRepository.findByNameIgnoreCase(criteria));
                return result;
            case FIND_IN_PROD_DESC:
                result.addAll(productCardRepository.findByProductDescriptionIgnoreCase(criteria));
                return result;
            case FIND_IN_CATEGORY_NAME:
                return getProductsByCategoryName(criteria);
            case FIND_IN_CATEGORY_DESC:
                return getProductsByCategoryDescription(criteria);
            default:
                throw new NoResultException();
        }
    }

    public List<ProductCard> sortProductCardBy(int categoryId, EnumProductSorter sortCriteria) {

        Category category = null;

        if(categoryId != 0)
            category = categoryRepository.findOne(categoryId);

        Sort sort;

        switch (sortCriteria) {
            case SORT_BY_NAME:
                sort = new Sort(new Sort.Order(ASC, "name")); break;
            case SORT_BY_NAME_REVERSED:
                sort = new Sort(new Sort.Order(DESC, "name")); break;
            case SORT_BY_LOW_PRICE:
                sort = new Sort(new Sort.Order(ASC, "price")); break;
            case SORT_BY_HIGH_PRICE:
                sort = new Sort(new Sort.Order(DESC, "price")); break;
            case SORT_BY_POPULARITY_REVERSED:
                sort = new Sort(new Sort.Order(ASC, "likes")); break;
            case SORT_BY_POPULARITY:
                sort = new Sort(new Sort.Order(DESC, "likes")); break;
            case SORT_BY_UNPOPULARITY_REVERSED:
                sort = new Sort(new Sort.Order(ASC, "dislikes")); break;
            case SORT_BY_UNPOPULARITY:
                sort = new Sort(new Sort.Order(DESC, "dislikes")); break;
            default:
                throw new NoResultException();
        }

        return categoryId == 0 ? productCardRepository.findAllBy(sort) : productCardRepository.findByCategory(category, sort);
    }

    public List<ProductCard> sortSearchResultsBy(List<ProductCard> list, EnumProductSorter sortCriteria) {

        switch (sortCriteria) {
            case SORT_BY_NAME:
                return list.stream().sorted(Comparator.comparing(ProductCard::getName)).collect(Collectors.toList());
            case SORT_BY_NAME_REVERSED:
                return list.stream().sorted(Comparator.comparing(ProductCard::getName).reversed()).collect(Collectors.toList());
            case SORT_BY_LOW_PRICE:
                return list.stream().sorted(Comparator.comparing(ProductCard::getPrice)).collect(Collectors.toList());
            case SORT_BY_HIGH_PRICE:
                return list.stream().sorted(Comparator.comparing(ProductCard::getPrice).reversed()).collect(Collectors.toList());
            case SORT_BY_POPULARITY_REVERSED:
                return list.stream().sorted(Comparator.comparing(ProductCard::getLikes).reversed()).collect(Collectors.toList());
            case SORT_BY_POPULARITY:
                return list.stream().sorted(Comparator.comparing(ProductCard::getLikes)).collect(Collectors.toList());
            case SORT_BY_UNPOPULARITY_REVERSED:
                return list.stream().sorted(Comparator.comparing(ProductCard::getDislikes).reversed()).collect(Collectors.toList());
            case SORT_BY_UNPOPULARITY:
                return list.stream().sorted(Comparator.comparing(ProductCard::getDislikes)).collect(Collectors.toList());
            default:
                throw new NoResultException();
        }
    }

// Methods for getting lists of various items

    public List<Category> getAllCategories() {
        return (List<Category>) categoryRepository.findAll();
    }

    public List<Category> getRootCategories() {
        return categoryRepository.findByCategory(null);
    }

    public List<Category> getSubCategories(int categoryId) {
        return categoryRepository.findByCategory(categoryRepository.findOne(categoryId));
    }

    public List<ProductCard> getProductCardsByCategory(int categoryId) {
        Sort sort = new Sort(new Sort.Order(ASC, "name"));
        return productCardRepository.findByCategory(categoryRepository.findOne(categoryId), sort);
    }

    public List<Visualization> getVisualListByProduct(String productCardId) {
            return visualizationRepository.findByProductCard(productCardRepository.findOne(productCardId));
    }

    public List<AttributeValue> getAttrValuesByProduct(String productCardId) {
        return attributeValueRepository.findByProductCard(productCardRepository.findOne(productCardId));
    }

    public List<AttributeValue> getAttributeValuesByName(String name) {

        return attributeValueRepository.findByAttributeName(attributeNameRepository.findOne(name));
    }

    public List<OrderMain> getOrdersByCustomer(String email) {
        return orderMainRepository.findByCustomer(customerRepository.findOne(email));
    }

    public List<OrderItem> getItemOrdersByOrderMain(int orderId) {
        return orderItemRepository.findByOrderMain(orderMainRepository.findOne(orderId));
    }

    public List<OrderItem> getItemOrdersByProdCard(String productCardId) {
        return orderItemRepository.findByProductCard(productCardRepository.findOne(productCardId));
    }

    //Return product availabitity in storehouse by amount
    public boolean isRequiredAmountOfProductCardAvailable(String sku, int amount) {

        ProductCard productCard = productCardRepository.findOne(sku);
        int productCardAmount = productCard.getAmount();

        return amount <= productCardAmount;
    }

    //Return product availabitity in storehouse
    public boolean isProductAvailable(String sku) {
        return productCardRepository.exists(sku);
    }

    /**
     * Method validateOrder need for check amount of ProductCard
     * on warehouse.
     *
     * @param email is  a user email for making changes
     * @return boolean type. True if amount in order >= amount on
     * warehouse
     */
    public boolean validateOrder(String email) {
        boolean isExist = true;
        Customer customer = customerRepository.findOne(email);
        List<OrderMain> ordersByCustomer = getOrdersByCustomer(customer.getEmail());
        l1:
        for (OrderMain om : ordersByCustomer) {
            List<OrderItem> itemOrdersByOrderMain = getItemOrdersByOrderMain(om.getOrderId());
            for (OrderItem oi : itemOrdersByOrderMain) {
                if (!isProductAvailable(oi.getProductCard().getSku())) {
                    isExist = false;
                    break l1;
                }
            }
        }
        return isExist;
    }

    public void sendMail (String to, String mess){

            // Sender's email ID needs to be mentioned
            String from = "kozheurovyuriy@gmail.com";
            final String username = "kozheurovyuriy";//change accordingly
            final String password = "43046721a";//change accordingly

            // Assuming you are sending email through relay.jangosmtp.net
            String host = "smtp.gmail.com";

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", "587");

            // Get the Session object.
            Session session = Session.getInstance(props,
                    new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(username, password);
                        }
                    });

            try {
                // Create a default MimeMessage object.
                Message message = new MimeMessage(session);

                // Set From: header field of the header.
                message.setFrom(new InternetAddress(from));

                // Set To: header field of the header.
                message.setRecipients(Message.RecipientType.TO,
                        InternetAddress.parse(to));

                // Set Subject: header field
                message.setSubject("Testing Subject");

                // Now set the actual message
                message.setText(mess);

                // Send message
                Transport.send(message);

                System.out.println("Sent message successfully....");

            } catch (MessagingException e) {
                throw new RuntimeException(e);
            }

    }

    //Private helpful methods

    private Set<ProductCard> getProductsByCategoryDescription(String criteria) {

        Set<ProductCard> result = new LinkedHashSet<>();

        List<Category> categoryList = categoryRepository.findByDescriptionIgnoreCase(criteria);
        if (categoryList.size() > 0) {
            for (Category c : categoryList) {
                Sort sort = new Sort(new Sort.Order(ASC, "name"));
                List<ProductCard> list = productCardRepository.findByCategory(c, sort);
                result.addAll(list);
            }
        }

        return result;
    }

    private Set<ProductCard> getProductsByCategoryName(String criteria) {

        Set<ProductCard> result = new LinkedHashSet<>();

        List<Category> categoryList = categoryRepository.findByNameIgnoreCase(criteria);
        if (categoryList.size() > 0) {
            for (Category c : categoryList) {
                Sort sort = new Sort(new Sort.Order(ASC, "name"));
                List<ProductCard> list = productCardRepository.findByCategory(c, sort);
                result.addAll(list);
            }
        }

        return result;
    }
}
