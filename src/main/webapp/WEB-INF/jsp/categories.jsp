<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>

<html>

<head>
    <meta charset="UTF-8">
    <title>Categories</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/style.css">
</head>

<body>

<!-- NAVIGATION -->
<nav class="page-navigation">
    <div class="container">
        <div>
            <c:if test="${!empty listSubCategories || !empty listProduct}">
                <a href="/home" style="float:left">Back to Homepage</a>
            </c:if>
            <div align="right">
                Total amount - (${cartSize}) Total price - (${totalPrice}) <a href="/showCart"><abbr
                    title="Cart with your products">Go to Cart</abbr></a>
            </div>
        </div>
    </div>
</nav>
<!-- /NAVIGATION -->

<!-- HEADER -->
<header class="header">
    <div>
        <form action="/findProducts" name="Search By:">
            <table class="tg" name="Search By:">
                <tr>
                    <td width="120">
                        <select name=findOption size=1>
                            <option value=FIND_ALL selected>Search all match (case ignored)</option>
                            <option value=FIND_IN_ALL_PLACES>Search in all places (exactly)</option>
                            <option value=FIND_IN_NAME>Search in products names</option>
                            <option value=FIND_IN_PROD_DESC>Search in products descriptions</option>
                            <option value=FIND_IN_CATEGORY_NAME>Search in categories names</option>
                            <option value=FIND_IN_CATEGORY_DESC>Search in categories descriptions</option>
                        </select>
                    </td>
                    <td width="120">
                        <input type="text" title="searchValue" name="searchValue"
                               placeholder="Please input SEARCH value"/>
                    </td>
                    <td width="120">
                        <input type="submit" value="Search">
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div class="container">
        <c:if test="${isCartEmpty}">
            <h1>Your Cart is Empty</h1>
            <h2>But you can continue shopping</h2>
        </c:if>

        <c:if test="${isProductNotFound || isNotFound}">
            <h1>Sorry, but products not found</h1>
            <h2>But you can continue shopping</h2>
        </c:if>

        <c:if test="${success}">
            <h1>
                Thanks for your choice. Your orderId is ***** ${orderId} *****
            </h1>
            <h2>Our operator will contact you as soon as possible</h2>
            <h3>You can continue shopping</h3>
        </c:if>

        <c:if test="${isAddedToCart}">
            <h1>Selected product is added to Cart</h1>
            <h2>You can continue shopping</h2>
        </c:if>

        <c:if test="${!empty listSubCategories}">
            <h1>SubCategories of ${listSubCategories.get(0).category.name}</h1>
        </c:if>

        <c:if test="${!empty listProduct && isFoundListEmpty}">
            <h1>Products from ${listProduct.get(0).category.name} category</h1>
        </c:if>

        <c:if test="${!empty listProduct && !isFoundListEmpty}">
            <h1>Search results</h1>
        </c:if>

        <c:if test="${!empty noProductExist}">
            <h1>${noProductExist}</h1>
        </c:if>

        <c:if test="${!empty undefinedError}">
            <h1>${undefinedError}</h1>
        </c:if>

        <c:if test="${!isNotFound && !success && !isAddedToCart && !isCartEmpty && (empty listProduct) && (empty listSubCategories) && (empty noProductExist) && (empty undefinedError)}">
            <h1>
                Welcome to Internet Shop "Smart House"
            </h1>
        </c:if>
    </div>
</header>
<!-- /HEADER -->

<!-- MAIN SECTION -->
<main>
    <div class="container">
        <c:if test="${!empty listRootCategories}">
            <table class="tg">
                <tr>
                    <th width="20">ID</th>
                    <th width="200">Name</th>
                    <th width="500">Description</th>
                </tr>

                <c:forEach items="${listRootCategories}" var="category">
                    <tr>
                        <td>${category.id}</td>
                        <td>
                            <a href="<c:url value='/subcategories/${category.id}@${category.name}'/>">${category.name}</a>
                        </td>
                        <td>${category.description}</td>
                    </tr>
                </c:forEach>
            </table>

        </c:if>

        <c:if test="${!empty listSubCategories}">
            <table class="tg">
                <tr>
                    <th width="20">ID</th>
                    <th width="200">Name</th>
                    <th width="1000">Description</th>
                </tr>

                <c:forEach items="${listSubCategories}" var="category">
                    <tr>
                        <td>${category.id}</td>
                        <td>
                            <a href="<c:url value='/subcategories/${category.id}@${category.name}'/>">${category.name}</a>
                        </td>
                        <td>${category.description}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <c:if test="${!empty listProduct}">
            <table class="tg">
                <tr>
                    <th width="20">SKU</th>
                    <th width="80">
                        <form action="/sortProductCardBy">
                            <input type="hidden" name="categoryId" value=${categoryId}>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_NAME>
                            </c:if>
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_NAME_REVERSED>
                            </c:if>
                            <input type="submit" value="Name"/>
                        </form>
                    </th>
                    <th width="200">Description</th>
                    <th width="20">
                        <form action="/sortProductCardBy">
                            <input type="hidden" name="categoryId" value=${categoryId}>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_LOW_PRICE>
                            </c:if>
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_HIGH_PRICE>
                            </c:if>
                            <input type="submit" value="Price"/>
                        </form>
                    </th>
                    <th width="20">Amount</th>
                    <th width="20">
                        <form action="/sortProductCardBy">
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_POPULARITY>
                                <input type="submit" value="Like"/>
                            </c:if>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_POPULARITY_REVERSED>
                                <input type="submit" value="Like"/>
                            </c:if>
                        </form>
                    </th>
                    <th width="20">
                        <form action="/sortProductCardBy">
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_UNPOPULARITY>
                                <input type="submit" value="Dislike"/>
                            </c:if>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_UNPOPULARITY_REVERSED>
                                <input type="submit" value="Dislike"/>
                            </c:if>
                        </form>
                    </th>
                </tr>

                <c:forEach items="${listProduct}" var="product">
                    <tr>
                        <td>${product.sku}</td>
                        <td><a href="<c:url value='/product/${product.sku}@${product.name}'/>">${product.name}</a></td>
                        <td>${product.productDescription}</td>
                        <td>${product.price}</td>
                        <td>${product.amount}</td>
                        <td>${product.likes}</td>
                        <td>${product.dislikes}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    </div>
</main>
<!-- /MAIN SECTION -->

<!-- FOOTER -->
<footer class="footer">
    <div class="container">
        <br><br><br><br><br><br>
        <hr>
        <h6>@ Designed by Yuriy Kozheurov, 2017</h6>
    </div>
</footer>
<!-- /FOOTER -->

</body>
</html>