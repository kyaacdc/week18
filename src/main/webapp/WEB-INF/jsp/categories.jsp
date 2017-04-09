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

<div align="right">(${cartSize}) <a href="/showCart">Go to Cart</a></div>

<c:if test="${!empty listRootCategories}">

    <c:if test="${isCartEmpty}">
        <h1>Your Cart is Empty</h1>
        <h1>But you can continue shopping</h1>
    </c:if>

    <c:if test="${success}">
        <h1>Thanks for your choice. Our operator will contact you as soon as possible</h1>
        <h1>You can continue shopping</h1>
    </c:if>

    <c:if test="${isAddedToCart}">
        <h1>Choiced product is added to Cart</h1>
        <h1>You can continue shopping</h1>
    </c:if>

    <c:if test="${!success && !isAddedToCart && !isCartEmpty}">
        <h1>Welcome into Internet Shop "Smart House"</h1>
    </c:if>

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

    <a href="/home">Back to Homepage</a>

    <h1>SubCategories of ${listSubCategories.get(0).category.name}</h1>

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

    <a href="/home">Back to Homepage</a>

    <h1>Products from ${listProduct.get(0).category.name} category</h1>

    <table class="tg">
        <tr>
            <th width="20">SKU</th>
            <th width="80">Name</th>
            <th width="200">Description</th>
            <th width="20">Price</th>
            <th width="20">Amount</th>
            <th width="20">Likes</th>
            <th width="20">Dislikes</th>
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

<br><br><br><br><br><br>
<h6>@ Designed by Yuriy Kozheurov, 2017</h6>

</body>
</html>