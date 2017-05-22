<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Smart House</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/shop.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<div class="row">
    <div class="col-sm-2">
        <a class="btn btn-success btn-block btn-xl" href="/home" role="button" data-toggle="tooltip"
           title="Go to homepage">
            <i class="glyphicon glyphicon-home"></i>
        </a>
    </div>
    <div class="col-sm-8">
        <p><i>CART</i></p>
        <p><i class="glyphicon glyphicon-trash"></i></p>
    </div>
    <div class="col-sm-2">
        <a class="btn btn-warning  btn-block btn-xl" href="/clearCart" role="button" data-toggle="tooltip"
           title="Clear All CART">
            <i class="glyphicon glyphicon-remove"></i><br>
            <i class="glyphicon glyphicon-trash"></i>
        </a>
    </div>
</div>

<p><br></p>
<table class="table table-hover">
    <tr>
        <th class="col-md-1">
            <p>
                <mark><b>№</b></mark>
            </p>
        </th>
        <th class="col-md-8">
            <p>
                <mark><i>Name</i></mark>
            </p>
        </th>
        <th class="col-md-1"><i class="glyphicon glyphicon-euro"></i></th>
        <th class="col-md-1"><i class="glyphicon glyphicon-usd"></i></th>
        <th class="col-md-1">
            <a class="btn btn-danger btn-block btn-xl" href="/clearCart" role="button" data-toggle="tooltip"
               title="Clear All CART">
                <i class="glyphicon glyphicon-remove-circle"></i>
            </a>
        </th>
    </tr>

    <c:forEach items="${listCart}" var="cart">
        <tr>
            <td><b>${cart.sku}</b></td>
            <td><a href="<c:url value='/product/${cart.sku}@${cart.name}'/>"><p>${cart.name}</p></a></td>
            <td><p>${cart.amount}</p></td>
            <td><p>${cart.price}$</p></td>
            <td>
                <form method="POST" action="/removeFromCart">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input name="index" type="hidden" value="${listCart.indexOf(cart)}"><br>
                    <button type="submit" class="btn btn-info btn-block btn-xl"><i
                            class="glyphicon glyphicon-remove-sign" title="Remove ${cart.name} from CART"></i></button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<p>
    <mark><i>Submit Form</i></mark>
</p>
<form role="form" method="POST" action="/buy">
    <div class="form-group">
        <label class="col-sm-3 control-label"><p>* Email</p></label>
        <div class="col-sm-9 input-group submitForm">
            <input name="email" type="text" class="form-control" placeholder="${wrongEmail}" value=${email}>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label"><p>Name<br></p></label>
        <div class="col-sm-9 input-group submitForm">
            <input name="name" type="text" class="form-control" placeholder="${wrongName}">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label"><p>Phone</p></label>
        <div class="col-sm-9 input-group submitForm">
            <input name="phone" type="text" class="form-control" placeholder="${wrongPhone}">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label"><p>Address</p></label>
        <div class="col-sm-9 input-group submitForm">
            <label>
                <input name="address" type="text" class="form-control">
            </label>
        </div>
    </div>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <button class="btn btn-success btn-block btn-xl" type="submit"><p>Submit</p></button>
</form>

<c:if test="${!empty listPopularProducts}">
    <div class="container">
        <p>
            <mark><b><i>Promotion</i></b></mark>
        </p>
    </div>
    <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>

            <c:set var="count" value="0" scope="page"/>
            <c:forEach items="${listPopularProducts}" var="visual">
                <c:if test="${count != 0}">
                    <li data-target="#carousel-example-generic" data-slide-to="${count}"></li>
                </c:if>
                <c:set var="count" value="${count + 1}" scope="page"/>
            </c:forEach>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner">

            <c:set var="product" value="${listPopularProducts.get(0)}" scope="page"/>
            <div class="item active">
                <div class="row smallProductCard">
                    <div class="col-sm-9">
                        <a href="/product/${product.sku}@${product.name}">
                            <c:set var="isFound" value="${false}"/>
                            <c:forEach items="${listPopularVizualisations}" var="visual">
                                <c:if test="${product.getSku() == visual.getProductCard().getSku() && !isFound}">
                                    <img src="${visual.getUrl()}" alt="Smart House"/>
                                    <c:set var="isFound" value="${true}"/>
                                </c:if>
                            </c:forEach>
                        </a>
                    </div>

                    <div class="col-sm-3">
                        <form role="form" class="form-inline" action="/addToCart" method="POST" name="Cart:">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="sku" value=${product.sku}>
                            <input type="hidden" name="name" value=${product.name}>
                            <input type="hidden" name="price" value=${product.price}>
                            <button type="submit" class="btn btn-info btn-block btn-lg"
                                    title="Add ${product.name} to Cart">
                                <i class="glyphicon glyphicon-save glyphicon-small"></i><br>
                                <i class="glyphicon glyphicon-shopping-cart"></i>
                            </button>
                        </form>
                    </div>

                    <div class="col-sm-8">
                        <a href="<c:url value='/product/${product.sku}@${product.name}'/>">${product.name}</a>
                    </div>
                    <div class="col-sm-4">
                            ${product.price}<i class="glyphicon glyphicon-usd glyphicon-small"></i>
                    </div>
                    <div class="col-sm-6">
                            ${product.productDescription}
                    </div>
                    <div class="col-sm-3">
                        <form action="/changeRate" method="POST">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="sku" value=${product.sku}>
                            <input type="hidden" name="isLike" value=true>
                            <button type="submit" class="btn btn-success btn-block btn-lg"
                                    title="Add Like for ${product.name}">
                                <i class="glyphicon glyphicon-hand-right"></i><br>
                                <span class="badge">${product.likes}</span>
                            </button>
                        </form>
                    </div>
                    <div class="col-sm-3">
                        <form action="/changeRate" method="POST">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="sku" value=${product.sku}>
                            <input type="hidden" name="isLike" value=false>
                            <button type="submit" class="btn btn-danger btn-block btn-lg"
                                    title="Add Dislike for ${product.name}">
                                <i class="glyphicon glyphicon-thumbs-down"></i><br>
                                <span class="badge">${product.dislikes}</span>
                            </button>
                        </form>
                    </div>
                </div>
            </div>


            <c:set var="count" value="0" scope="page"/>
            <c:forEach items="${listPopularProducts}" var="product">
                <c:if test="${count != 0}">
                    <div class="item">
                        <div class="row smallProductCard">
                            <div class="col-sm-9">
                                <a href="/product/${product.sku}@${product.name}">
                                    <c:set var="isFound" value="${false}"/>
                                    <c:forEach items="${listPopularVizualisations}" var="visual">
                                        <c:if test="${product.getSku() == visual.getProductCard().getSku() && !isFound}">
                                            <img src="${visual.getUrl()}" alt="Smart House"/>
                                            <c:set var="isFound" value="${true}"/>
                                        </c:if>
                                    </c:forEach>
                                </a>
                            </div>

                            <div class="col-sm-3">
                                <form role="form" class="form-inline" action="/addToCart" method="POST" name="Cart:">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <input type="hidden" name="sku" value=${product.sku}>
                                    <input type="hidden" name="name" value=${product.name}>
                                    <input type="hidden" name="price" value=${product.price}>
                                    <button type="submit" class="btn btn-info btn-block btn-lg"
                                            title="Add ${product.name} to Cart">
                                        <i class="glyphicon glyphicon-save glyphicon-small"></i><br>
                                        <i class="glyphicon glyphicon-shopping-cart"></i>
                                    </button>
                                </form>
                            </div>

                            <div class="col-sm-8">
                                <a href="<c:url value='/product/${product.sku}@${product.name}'/>">${product.name}</a>
                            </div>
                            <div class="col-sm-4">
                                    ${product.price}<i class="glyphicon glyphicon-usd glyphicon-small"></i>
                            </div>
                            <div class="col-sm-6">
                                    ${product.productDescription}
                            </div>
                            <div class="col-sm-3">
                                <form action="/changeRate" method="POST">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <input type="hidden" name="sku" value=${product.sku}>
                                    <input type="hidden" name="isLike" value=true>
                                    <button type="submit" class="btn btn-success btn-block btn-lg"
                                            title="Add Like for ${product.name}">
                                        <i class="glyphicon glyphicon-hand-right"></i><br>
                                        <span class="badge">${product.likes}</span>
                                    </button>
                                </form>
                            </div>
                            <div class="col-sm-3">
                                <form action="/changeRate" method="POST">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <input type="hidden" name="sku" value=${product.sku}>
                                    <input type="hidden" name="isLike" value=false>
                                    <button type="submit" class="btn btn-danger btn-block btn-lg"
                                            title="Add Dislike for ${product.name}">
                                        <i class="glyphicon glyphicon-thumbs-down"></i><br>
                                        <span class="badge">${product.dislikes}</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:set var="count" value="${count + 1}" scope="page"/>
            </c:forEach>
        </div>

        <!-- Controls -->
        <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
        </a>
        <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
        </a>
    </div>
    <!-- Carousel -->
</c:if>

<br>

<div>
    <c:if test="${!empty listPopularProducts}">
        <div class="row">
            <div class="col-sm-12">
                <p>
                    <mark><b><i>Popular products</i></b></mark>
                </p>
            </div>
            <div class="row smallProductCard">
                <c:forEach items="${listPopularProducts}" var="product">
                    <div class="col-sm-4 smallProductCard">
                        <div class="col-sm-9">
                            <a href="/product/${product.sku}@${product.name}">
                                <c:set var="isFound" value="${false}"/>
                                <c:forEach items="${listPopularVizualisations}" var="visual">
                                    <c:if test="${product.getSku() == visual.getProductCard().getSku() && !isFound}">
                                        <img src="${visual.getUrl()}" alt="Smart House"/>
                                        <c:set var="isFound" value="${true}"/>
                                    </c:if>
                                </c:forEach>
                            </a>
                        </div>

                        <div class="col-sm-3">
                            <form role="form" class="form-inline" action="/addToCart" method="POST" name="Cart:">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="sku" value=${product.sku}>
                                <input type="hidden" name="name" value=${product.name}>
                                <input type="hidden" name="price" value=${product.price}>
                                <button type="submit" class="btn btn-info btn-block"
                                        title="Add ${product.name} to Cart">
                                    <i class="glyphicon glyphicon-save glyphicon-small"></i><br>
                                    <i class="glyphicon glyphicon-shopping-cart glyphicon-small"></i>
                                </button>
                            </form>
                        </div>

                        <div class="col-sm-8">
                            <a href="<c:url value='/product/${product.sku}@${product.name}'/>">${product.name}</a>
                        </div>
                        <div class="col-sm-4">
                                ${product.price}<i class="glyphicon glyphicon-usd glyphicon-small"></i>
                        </div>
                        <div class="col-sm-6">
                                ${product.productDescription}
                        </div>
                        <div class="col-sm-3">
                            <form action="/changeRate" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="sku" value=${product.sku}>
                                <input type="hidden" name="isLike" value=true>
                                <button type="submit" class="btn btn-success btn-block"
                                        title="Add Like for ${product.name}">
                                    <i class="glyphicon glyphicon-hand-right glyphicon-small"></i><br>
                                    <span class="badge">${product.likes}</span>
                                </button>
                            </form>
                        </div>
                        <div class="col-sm-3">
                            <form action="/changeRate" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="sku" value=${product.sku}>
                                <input type="hidden" name="isLike" value=false>
                                <button type="submit" class="btn btn-danger btn-block"
                                        title="Add Dislike for ${product.name}">
                                    <i class="glyphicon glyphicon-thumbs-down glyphicon-small"></i><br>
                                    <span class="badge">${product.dislikes}</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>
<h2>@ Designed by Yuriy Kozheurov, 2017</h2>

</body>
</html>
