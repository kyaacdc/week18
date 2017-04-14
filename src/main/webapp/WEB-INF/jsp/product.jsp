<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--@elvariable id="product" type="com.smarthouse.pojo.ProductCard"--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>


<html>
<head>
    <meta charset="UTF-8">
    <title>Product</title>
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
        <h1><i>Product ${product.name}</i></h1>
    </div>
</header>
<!-- /HEADER -->

<!-- MAIN SECTION -->
<main>
    <div class="container">
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
                        <input type="hidden" name="price" value=${product.price}>
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
    </div>

    <div>
        <c:if test="${isAttributesNotPresent}">
            <h3>This Product not have any attributes</h3>
        </c:if>
    </div>

    <div>
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
    </div>

    <hr>

    <div>
        <form method="POST" action="/oneClickBuy">
            <h3><em>One click Buy</em></h3>
            <strong>Email</strong> <input name="email" type="text" placeholder="email" value=${email}>
            * ${wrongEmail}<br>
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