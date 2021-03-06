<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--@elvariable id="product" type="com.smarthouse.pojo.ProductCard"--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>


<html>
<head>
    <meta charset="UTF-8">
    <title>Product</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/shop.css">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>

<body>
<!-- NAVIGATION -->
<nav class="page-navigation">
    <div class="container">
        <div>
            <a href="/home" style="float:left">Back to Homepage</a>
            <div align="right">
                <form action="/logout" method="post">
                    <button type="submit" class="btn btn-danger">Log Out</button>
                    <input type="hidden" name="${_csrf.parameterName}"
                           value="${_csrf.token}"/>
                </form>
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
    <div class="table-responsive">
        <table class="table table-bordered">
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
                <td>${product.likes}</td>
                <td>${product.dislikes}</td>
                <td>${product.category.name}</td>
                <td>
                    <c:if test="${!isShowAttribute}">
                        <a href="<c:url value='/showAttributes/${product.sku}'/>">Show Attribute Table</a>
                    </c:if>
                    <c:if test="${isShowAttribute}">
                        <a href="<c:url value='/hideAttributes/${product.sku}'/>">Hide Attribute Table</a>
                    </c:if>
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

            <table class="table table-bordered">
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