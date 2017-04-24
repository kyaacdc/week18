<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>

<html>

<head>
    <title>Cart</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="/resources/css/style.css">
</head>

<body>

<!-- NAVIGATION -->
<nav class="page-navigation">
    <div class="container">
        <div>
            <a href="/home" style="float:left">Back to Homepage</a>
            <div align="right">
                Total amount - (${cartSize}) Total price - (${totalPrice})
            </div>
        </div>
    </div>
</nav>
<!-- /NAVIGATION -->

<!-- HEADER -->
<header class="header">
    <div class="container">
        <h1>Cart</h1>
    </div>
</header>
<!-- /HEADER -->

<!-- MAIN SECTION -->
<main>
    <div class="container">
        <table class="tg">
            <tr>
                <th width="60">SKU</th>
                <th width="60">Name</th>
                <th width="60">Amount</th>
                <th width="60">Total Price</th>
                <th width="60">
                    <a href="/clearCart">Clear Cart</a>
                </th>
            </tr>

            <c:forEach items="${listCart}" var="cart">
                <tr>
                    <td>${cart.sku}</td>
                    <td><a href="<c:url value='/product/${cart.sku}@${cart.name}'/>">${cart.name}</a></td>
                    <td>${cart.amount}</td>
                    <td>${cart.price}</td>
                    <td>
                        <form method="POST" action="/removeFromCart">
                            <input name="index" type="hidden" value="${listCart.indexOf(cart)}"><br>
                            <button type="submit">Remove</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <div>
        <hr>
        <form method="POST" action="/buy">
            <h2>Submit order</h2>
            <b>Email</b> <input name="email" type="text" placeholder="email" value=${email}> * ${wrongEmail}<br>
            Name <input name="name" type="text" placeholder="name"> ${wrongName}<br>
            Phone <input name="phone" type="text" placeholder="phone"> ${wrongPhone}<br>
            Address <input name="address" type="text" placeholder="address"><br>
            <button type="submit">Submit</button>
        </form>
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