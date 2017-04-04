<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
            <th width="80">Description</th>
            <th width="20">Price</th>
            <th width="20">Amount</th>
            <th width="20">Likes</th>
            <th width="20">Dislikes</th>
            <th width="20">Category</th>
            <th width="20">Attributes</th>
            <th width="20">Visualisation</th>

        </tr>


            <tr>
                <td>${productCard.sku}</td>
                <td>${productCard.name}</td>
                <td>${productCard.productDescription}</td>
                <td>${productCard.price}</td>
                <td>${productCard.amount}</td>
                <td>${productCard.likes}</td>
                <td>${productCard.dislikes}</td>
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
            </tr>
    </table>

<br><br><br><br><br><br>
<h6>@ Designed by Yuriy Kozheurov</h6>

</body>
</html>