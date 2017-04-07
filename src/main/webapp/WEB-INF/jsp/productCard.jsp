<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--@elvariable id="productCard" type="com.smarthouse.pojo.ProductCard"--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>




<html>
<head>
    <title>Product Card</title>

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

<a href="/home">Back to Homepage</a>

<h1>Product card ${productCard.name}</h1>

<table class="tg">
    <tr>
        <th width="20">SKU</th>
        <th width="80">Name</th>
        <th width="200">Description</th>
        <th width="20">Price</th>
        <th width="20">Amount</th>
        <th width="20">Likes</th>
        <th width="20">Dislikes</th>
        <th width="80">Category</th>
        <th width="20">Attributes</th>
        <th width="200">Visualisation</th>
        <th width="20">SessionId</th>

    </tr>


    <tr>
        <td>${productCard.sku}</td>
        <td>${productCard.name}</td>
        <td>${productCard.productDescription}</td>
        <td>${productCard.price}</td>
        <td>${productCard.amount}</td>
        <td>${productCard.likes}
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
                <input type="hidden" name="sku" value=${productCard.sku}>
                <input type="hidden" name="isLike" value=true>
                <p><input type="submit" value="Like"></p>
            </form>
        </td>
        <td>${productCard.dislikes}
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
                <input type="hidden" name="sku" value=${productCard.sku}>
                <input type="hidden" name="isLike" value=false>
                <p><input type="submit" value="Dislike"></p>
            </form>
        </td>
        <td>${productCard.category.name}</td>
        <td>
            <c:if test="${!empty listAttributeValues}">
                <c:forEach items="${listAttributeValues}" var="attribute">
                    <c:if test="${attribute.productCard.sku == productCard.sku}">
                        ${attribute.attributeName.name} - ${attribute.value}<br>
                    </c:if>
                </c:forEach>
            </c:if>
        </td>
        <td>
            <c:if test="${!empty listVisualisations}">
                <c:forEach items="${listVisualisations}" var="visualisation">
                    <c:if test="${visualisation.productCard.sku == productCard.sku}">
                        <img src="${visualisation.url}"/>
                    </c:if>
                </c:forEach>
            </c:if>
        </td>
        <td>${httpSessionId}</td>
    </tr>
</table>

<form method="POST" action="/oneClickBuy">
    <h2>One click Buy</h2>
    <input name="email" type="text" placeholder="email" value=${email}>*${wrongEmail}<br>
    <input name="name" type="text" placeholder="name">${wrongName}<br>
    <input name="phone" type="text" placeholder="phone">${wrongPhone}<br>
    <input name="address" type="text" placeholder="address"><br>
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
    <input name="sku" type="hidden" value=${productCard.sku}>
    <button type="submit">Buy</button>
</form>

<br><br><br><br><br><br>

<h6>@ Designed by Yuriy Kozheurov</h6>

</body>
</html>