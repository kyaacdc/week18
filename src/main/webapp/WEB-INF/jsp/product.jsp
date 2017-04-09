<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--@elvariable id="product" type="com.smarthouse.pojo.ProductCard"--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>


<html>
<head>
    <title>Product</title>

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

<a href="/home">Back to Homepage</a>

<h1>Product${productCard.name}</h1>

<table class="tg">
    <tr>
        <th width="20">SKU</th>
        <th width="80">Name</th>
        <th width="200">Description</th>
        <th width="20">Price</th>
        <th width="20">Amount</th>
        <th width="20">Likes</th>
        <th width="20">Dislikes</th>
        <th width="30">Category</th>
        <th width="80">Attributes</th>
        <th width="200">Visualisation</th>
        <th width="20">Cart</th>

    </tr>


    <tr>
        <td>${product.sku}</td>
        <td>${product.name}</td>
        <td>${product.productDescription}</td>
        <td>${product.price}</td>
        <td>${product.amount}</td>
        <td>${product.likes}
            <form action="/changeRate" method="POST">
                <p>
                    <label>
                        <select name=rate size=1>
                            <option value=1 selected>1</option>
                            <option value=2>2</option>
                            <option value=3>3</option>
                            <option value=4>4</option>
                            <option value=5>5</option>
                        </select>
                    </label>
                </p>
                <input type="hidden" name="sku" value=${product.sku}>
                <input type="hidden" name="isLike" value=true>
                <p><input type="submit" value="Like"></p>
            </form>
        </td>
        <td>${product.dislikes}
            <form action="/changeRate" method="POST">
                <p>
                    <label>
                        <select name=rate size=1>
                            <option value=1 selected>1</option>
                            <option value=2>2</option>
                            <option value=3>3</option>
                            <option value=4>4</option>
                            <option value=5>5</option>
                        </select>
                    </label>
                </p>
                <input type="hidden" name="sku" value=${product.sku}>
                <input type="hidden" name="isLike" value=false>
                <p><input type="submit" value="Dislike"></p>
            </form>
        </td>
        <td>${product.category.name}</td>
        <td>
            <a href="<c:url value='/showAttributes/${product.sku}'/>">Show Attribute Table</a>
        </td>
        <td>
            <c:if test="${!empty listVisualisations}">
                <c:forEach items="${listVisualisations}" var="visualisation">
                    <c:if test="${visualisation.productCard.sku == product.sku}">
                        <img src="${visualisation.url}"/>
                    </c:if>
                </c:forEach>
            </c:if>
        </td>
        <td>
            <form action="/addToCart" method="POST">
                <input type="hidden" name="sku" value=${product.sku}>
                <input type="hidden" name="name" value=${product.name}>
                <label>
                    <select name=amount size=1>
                        <option value=1 selected>1</option>
                        <option value=2>2</option>
                        <option value=3>3</option>
                        <option value=4>4</option>
                        <option value=5>5</option>
                        <option value=6>6</option>
                        <option value=7>7</option>
                        <option value=8>8</option>
                        <option value=9>9</option>
                        <option value=10>10</option>
                    </select>
                </label>
                <p><input type="submit" value="Add To Cart"></p>
            </form>
        </td>
    </tr>
</table>

<c:if test="${isAttributesNotPresent}">
    <h3>This Product not have any attributes</h3>
</c:if>

<c:if test="${!empty attributeList}">
    <h3>Attribute Table</h3>

    <table class="tg">
        <tr>
            <th width="200">Name</th>
            <th width="800">Value</th>
        </tr>
        <c:forEach items="${attributeList}" var="attribute">
            <tr>
                <td>${attribute.attributeName.name}</td>
                <td>${attribute.value}</td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<form method="POST" action="/oneClickBuy">
    <h2>One click Buy</h2>
    Email <input name="email" type="text" placeholder="email" value=${email}> * ${wrongEmail}<br>
    Name <input name="name" type="text" placeholder="name"> ${wrongName}<br>
    Phone <input name="phone" type="text" placeholder="phone"> ${wrongPhone}<br>
    Address <input name="address" type="text" placeholder="address"><br>
    <label>Amount
        <select name=amount size=1>
            <option value=1 selected>1</option>
            <option value=2>2</option>
            <option value=3>3</option>
            <option value=4>4</option>
            <option value=5>5</option>
            <option value=6>6</option>
            <option value=7>7</option>
            <option value=8>8</option>
            <option value=9>9</option>
            <option value=10>10</option>
        </select>
    </label><br>
    <input name="sku" type="hidden" value=${product.sku}>
    <button type="submit">Buy</button>
</form>

<br><br><br><br><br><br>

<h6>@ Designed by Yuriy Kozheurov, 2017</h6>

</body>
</html>