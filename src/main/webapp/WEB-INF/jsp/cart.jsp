<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>

<html>

<head>
    <title>Cart</title>

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

<h1>Cart</h1>

    <table class="tg">
        <tr>
            <th width="60">SKU</th>
            <th width="60">Name</th>
            <th width="60">Amount</th>
        </tr>

        <c:forEach items="${listCart}" var="cart">
            <tr>
                <td>${cart.sku}</td>
                <td><a href="<c:url value='/product/${cart.sku}@${cart.name}'/>">${cart.name}</a></td>
                <td>${cart.amount}</td>
            </tr>
        </c:forEach>
    </table>

<form method="POST" action="/buy">
    <h2>Submit order</h2>
    Email <input name="email" type="text" placeholder="email" value=${email}> * ${wrongEmail}<br>
    Name <input name="name" type="text" placeholder="name"> ${wrongName}<br>
    Phone <input name="phone" type="text" placeholder="phone"> ${wrongPhone}<br>
    Address <input name="address" type="text" placeholder="address"><br>
    <button type="submit">Submit</button>
</form>

<br><br><br><br><br><br>
<h6>@ Designed by Yuriy Kozheurov, 2017</h6>

</body>
</html>