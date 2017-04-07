<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>

<html>

<head>
    <title>Categories</title>

    <style type="text/css">
        .tg {
            border-collapse: collapse;
            border-spacing: 0;
            border-color: #ccc;
        }

        .tg td {
            font-family: Arial, sans-serif;
            font-size: 14px;
            padding: 10px 5px;
            border-style: solid;
            border-width: 1px;
            overflow: hidden;
            word-break: normal;
            border-color: #ccc;
            color: #333;
            background-color: #fff;
        }

        .tg th {
            font-family: Arial, sans-serif;
            font-size: 14px;
            font-weight: normal;
            padding: 10px 5px;
            border-style: solid;
            border-width: 1px;
            overflow: hidden;
            word-break: normal;
            border-color: #ccc;
            color: #333;
            background-color: #f0f0f0;
        }

        .tg .tg-4eph {
            background-color: #f9f9f9
        }
    </style>

</head>
<body>

<div align="right"><a href="/showBasket">Go to Basket</a></div>

<c:if test="${!empty listRootCategories}">

    <c:if test="${success}">
        <h1>Thanks for your choice. Our operator will contact you as soon as possible</h1>
        <h1>You can continue shopping</h1>
    </c:if>

    <c:if test="${isAddedToBasket}">
        <h1>Choiced product is added to basket</h1>
        <h1>You can continue shopping</h1>
    </c:if>

    <c:if test="${!success && !isAddedToBasket}">
        <h1>Welcome into Internet Shop "Smart House"</h1>
    </c:if>

    <table class="tg">
        <tr>
            <th width="20">ID</th>
            <th width="200">Name</th>
            <th width="500">Description</th>
            <th width="500">Subcategories</th>
        </tr>

        <c:forEach items="${listRootCategories}" var="category">
            <tr>
                <td>${category.id}</td>
                <td>
                    <a href="<c:url value='/subcategories/${category.id}'/>">${category.name}</a>
                </td>
                <td>${category.description}</td>
                <td>
                    <c:forEach items="${listAllCategories}" var="subcategory">
                        <c:if test="${category.id == subcategory.category.id}">
                            <a href="<c:url value='/subcategories/${subcategory.id}'/>">${subcategory.name}</a>
                        </c:if>
                    </c:forEach>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<c:if test="${!empty listSubCategories}">

    <a href="/home">Back to Homepage</a>

    <h1>SubCategories of ${listSubCategories.get(0).category.name}</h1>

    <table class="tg">
        <tr>
            <th width="20">ID</th>
            <th width="200">Name</th>
            <th width="1000">Description</th>
            <th width="1000">Subcategories</th>
            <th width="500">ProductCards</th>
        </tr>

        <c:forEach items="${listSubCategories}" var="category">
            <tr>
                <td>${category.id}</td>
                <td>
                    <a href="<c:url value='/subcategories/${category.id}'/>">${category.name}</a>
                </td>
                <td>${category.description}</td>
                <td>
                    <c:forEach items="${listAllCategories}" var="subcategory">
                        <c:if test="${category.id == subcategory.category.id}">
                            <a href="<c:url value='/subcategories/${subcategory.id}'/>">${subcategory.name}</a>
                        </c:if>
                    </c:forEach>
                </td>
                <td>
                    <c:if test="${!empty listAllProductCards}">
                        <c:forEach items="${listAllProductCards}" var="product">
                            <c:if test="${category.id == product.category.id}">
                                <a href="<c:url value='/productCard/${product.sku}'/>">${product.name}</a>
                            </c:if>
                        </c:forEach>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<c:if test="${!empty listProductCards}">

    <a href="/home">Back to Homepage</a>

    <h1>Product cards from ${listProductCards.get(0).category.name} category</h1>

    <table class="tg">
        <tr>
            <th width="20">SKU</th>
            <th width="80">Name</th>
            <th width="200">Description</th>
            <th width="20">Price</th>
            <th width="20">Amount</th>
            <th width="20">Likes</th>
            <th width="20">Dislikes</th>
            <th width="20">Category</th>
        </tr>

        <c:forEach items="${listProductCards}" var="product">
            <tr>
                <td>${product.sku}</td>
                <td><a href="<c:url value='/productCard/${product.sku}'/>">${product.name}</a></td>
                <td>${product.productDescription}</td>
                <td>${product.price}</td>
                <td>${product.amount}</td>
                <td>${product.likes}</td>
                <td>${product.dislikes}</td>
                <td>${product.category.name}</td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<br><br><br><br><br><br>
<h6>@ Designed by Yuriy Kozheurov</h6>

</body>
</html>