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
        <p><i>${product.name}</i></p>
    </div>
    <div class="col-sm-2">
        <c:if test="${cartSize == 0}">
            <a class="btn btn-warning  btn-block btn-xl" href="/showCart" role="button" data-toggle="tooltip"
               title="Shop CART empty">
                <i class="glyphicon glyphicon-shopping-cart"></i>
            </a>
        </c:if>
        <c:if test="${cartSize > 0}">
            <a class="btn btn-danger  btn-block btn-xl" href="/showCart" role="button" data-toggle="tooltip"
               title="Shop CART with products">
                <div class="row">
                    <div class="col-sm-4">
                        <span class="badge">${cartSize}pcs</span><br><br>
                        <span class="badge">${totalPrice}$</span>
                    </div>
                    <div class="col-sm-8">
                        <i class="glyphicon glyphicon-shopping-cart"></i>
                    </div>
                </div>
            </a>
        </c:if>
    </div>
</div>

<div class="bigProductCard">
    <div class="row">
        <div class="col-sm-8">
            <div id="carousel-example-generic2" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators">
                    <li data-target="#carousel-example-generic2" data-slide-to="0" class="active"></li>

                    <c:set var="count" value="0" scope="page"/>
                    <c:forEach items="${listVisualisations}" var="visual">
                        <c:if test="${count != 0}">
                            <li data-target="#carousel-example-generic2" data-slide-to="${count}"></li>
                        </c:if>
                        <c:set var="count" value="${count + 1}" scope="page"/>
                    </c:forEach>
                </ol>

                <!-- Wrapper for slides -->
                <div class="carousel-inner">
                    <div class="item active">
                        <img src="${listVisualisations.get(0).url}" class="img-responsive center-block"
                             alt="Smart House"/>
                        <div class="carousel-caption">
                            <h3>${product.name}</h3>
                        </div>
                    </div>

                    <c:set var="count" value="0" scope="page"/>
                    <c:forEach items="${listVisualisations}" var="visual">
                        <c:if test="${count != 0}">
                            <div class="item">
                                <img src="${listVisualisations.get(count).url}" class="img-responsive center-block"
                                     alt="Smart House"/>
                                <div class="carousel-caption">
                                    <h3>${product.name}</h3>
                                </div>
                            </div>
                        </c:if>
                        <c:set var="count" value="${count + 1}" scope="page"/>
                    </c:forEach>
                </div>

                <!-- Controls -->
                <a class="left carousel-control" href="#carousel-example-generic2" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                </a>
                <a class="right carousel-control" href="#carousel-example-generic2" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                </a>
            </div> <!-- Carousel -->
            <br>
            <div>
                <!-- Navigation -->
                <ul class="nav nav-tabs" role="tablist">
                    <c:if test="${wrongEmail == null && wrongName == null && wrongPhone == null}">
                    <li class="active">
                        </c:if>
                        <c:if test="${wrongEmail != null || wrongName != null || wrongPhone != null}">
                    <li>
                        </c:if>
                        <a href="#prodDescription" class="btn btn-danger btn-block btn-xxl"
                           aria-controls="prodDescription" role="tab" data-toggle="tab"
                           title="Show description of ${product.name}">
                            <i class="glyphicon glyphicon-info-sign"></i>
                        </a>
                    </li>
                    <li>
                        <a href="#prodAttrib" class="btn btn-danger btn-block btn-xxl" aria-controls="prodAttrib"
                           role="tab" data-toggle="tab"
                           title="Show attribute table of ${product.name}">
                            <i class="glyphicon glyphicon-cog"></i>
                        </a>
                    </li>
                    <c:if test="${wrongEmail == null && wrongName == null && wrongPhone == null}">
                    <li>
                        </c:if>
                        <c:if test="${wrongEmail != null || wrongName != null || wrongPhone != null}">
                    <li class="active">
                        </c:if>
                        <a href="#oneClickBuy" class="btn btn-danger btn-block btn-xxl" aria-controls="oneClickBuy"
                           role="tab" data-toggle="tab"
                           title="Buy ${product.name} on one click">
                            <i class="glyphicon glyphicon-briefcase"></i>
                        </a>
                    </li>
                </ul>
                <!-- Content -->
                <div class="tab-content text-center">
                    <c:if test="${wrongEmail == null && wrongName == null && wrongPhone == null}">
                    <div role="tabpanel" class="tab-pane active" id="prodDescription">
                        </c:if>
                        <c:if test="${wrongEmail != null || wrongName != null || wrongPhone != null}">
                        <div role="tabpanel" class="tab-pane" id="prodDescription">
                            </c:if>

                            <p>
                                <mark><b><i>Description ${product.name}</i></b></mark>
                            </p>
                            <p>
                                ${product.productDescription}
                            </p>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="prodAttrib">
                            <c:if test="${isAttributesNotPresent}">
                                <h3><p>This Product not have any attributes</p></h3>
                            </c:if>

                            <c:if test="${!empty attributeList}">
                                <p>
                                    <mark><i>Attribute Table</i></mark>
                                </p>

                                <table class="table table-bordered">
                                    <c:forEach items="${attributeList}" var="attribute">
                                        <tr>
                                            <td><p>${attribute.attributeName.name}</p></td>
                                            <td><p>${attribute.value}</p></td>
                                        </tr>
                                    </c:forEach>
                                </table>
                            </c:if>
                        </div>
                        <c:if test="${wrongEmail != null || wrongName != null || wrongPhone != null}">
                        <div role="tabpanel" class="tab-pane active" id="oneClickBuy"></c:if>
                            <c:if test="${wrongEmail == null && wrongName == null && wrongPhone == null}">
                            <div role="tabpanel" class="tab-pane" id="oneClickBuy"></c:if>
                                <p>
                                    <mark><i>One click to Buy</i></mark>
                                </p>
                                <div>
                                    <form role="form" method="POST" action="/oneClickBuy">
                                        <div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label" title="Enter your Email"><i
                                                        class="glyphicon glyphicon-envelope"></i></label>
                                                <div class="col-sm-9 input-group submitForm">
                                                    <input name="email" type="text" class="form-control"
                                                           placeholder="${wrongEmail}"
                                                           title="Please input your Email here"
                                                           value=${email}>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label" title="Enter your Name"><i
                                                        class="glyphicon glyphicon-user"></i></label>
                                                <div class="col-sm-9 input-group submitForm">
                                                    <input name="name" type="text" class="form-control"
                                                           title="Please input your Name here"
                                                           placeholder="${wrongName}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label" title="Enter your Phone"><i
                                                        class="glyphicon glyphicon-phone-alt"></i></label>
                                                <div class="col-sm-9 input-group submitForm">
                                                    <input name="phone" type="text" class="form-control"
                                                           title="Please input your Phone number here"
                                                           placeholder="${wrongPhone}">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label" title="Enter your Address"><i
                                                        class="glyphicon glyphicon-object-align-bottom"></i></label>
                                                <div class="col-sm-9 input-group submitForm">
                                                    <input name="address" type="text" class="form-control"
                                                           title="Please input your Address here">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label" title="Enter Amount"><i
                                                        class="glyphicon glyphicon-duplicate"></i></label>
                                                <div class="col-sm-3 submitForm">
                                                    <label title="Please enter Amount">
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
                                                </div>
                                                <div class="col-sm-6">
                                                </div>
                                            </div>
                                            <input name="sku" type="hidden" value=${product.sku}>
                                        </div>
                                        <button class="btn btn-success btn-block btn-xl" type="submit"
                                                title="Click for Buy Now..."><p>Buy Now...</p></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>

                <div class="col-sm-4">
                    <div class="row">
                        <div class="col-sm-12">
                            <p>
                                <mark><i>PRICE</i></mark>
                            </p>
                        </div>
                        <div class="col-sm-12">
                            <p>${product.price}<i class="glyphicon glyphicon-usd"></i></p>
                        </div>
                        <div class="col-sm-6">
                            <form action="/changeRate" method="POST">
                                <input type="hidden" name="sku" value=${product.sku}>
                                <input type="hidden" name="isLike" value=true>
                                <button type="submit" class="btn btn-success btn-block btn-md"
                                        title="Add Like for ${product.name}">
                                    <i class="glyphicon glyphicon-hand-right glyphicon-small"></i><br>
                                    <span class="badge">${product.likes}</span>
                                </button>
                            </form>
                        </div>
                        <div class="col-sm-6">
                            <form action="/changeRate" method="POST">
                                <input type="hidden" name="sku" value=${product.sku}>
                                <input type="hidden" name="isLike" value=false>
                                <button type="submit" class="btn btn-danger btn-block btn-md"
                                        title="Add Dislike for ${product.name}">
                                    <i class="glyphicon glyphicon-thumbs-down glyphicon-small"></i><br>
                                    <span class="badge">${product.dislikes}</span>
                                </button>
                            </form>
                        </div>

                        <div class="col-sm-12">
                            <form role="form" class="form-inline" action="/addToCart" method="POST" name="Amount:">
                                <div>
                                    <div class="row">
                                        <div class="col-sm-6 searchForm">
                                            <label>
                                                <select class="form-control form-control" name="amount"
                                                        data-toggle="tooltip"
                                                        title="Click for choose amount of Product">
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
                                        </div>
                                        <div class="col-sm-6">
                                            <i class="glyphicon glyphicon-duplicate"></i>
                                        </div>
                                        <div class="col-sm-12">
                                            <input type="hidden" name="sku" value=${product.sku}>
                                            <input type="hidden" name="name" value=${product.name}>
                                            <input type="hidden" name="price" value=${product.price}>
                                            <button type="submit" class="btn btn-info btn-block"
                                                    title="Add ${product.name} to Cart">
                                                <i class="glyphicon glyphicon-save"></i><br><br>
                                                <i class="glyphicon glyphicon-shopping-cart"></i><br><br>
                                                <span class="badge">${product.name}</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

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
                            <form role="form" class="form-inline" action="/addToCart" method="POST" name="Amount:">
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
                                    <form role="form" class="form-inline" action="/addToCart" method="POST" name="Amount:">
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
                                    <form role="form" class="form-inline" action="/addToCart" method="POST"
                                          name="Amount:">
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
