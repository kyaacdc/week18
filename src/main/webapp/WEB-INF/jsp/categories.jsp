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

<div>
    <div class="row">
        <div class="col-sm-3">
            <a class="btn btn-success btn-block btn-xl" href="/home" role="button" data-toggle="tooltip"
               title="Go to homepage">
                <i class="glyphicon glyphicon-home"></i>
            </a>
        </div>
        <div class="col-sm-6">
            <div>
                <c:if test="${isCartEmpty}">

                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#cartEmpty").modal('show');
                        });
                    </script>

                    <div id="cartEmpty" class="modal fade">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button class="close" type="button" data-dismiss="modal" title="Close">×</button>
                                    <p class="modal-title">Cart Empty</p>
                                </div>
                                <div class="modal-body text-center text-primary h2">
                                    <p>
                                        <i>Your Cart is Empty. Please continue shopping</i>
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-success btn-lg" type="button" data-dismiss="modal"
                                            title="Click for continue"><i class="glyphicon glyphicon-ok"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <p>
                        <mark><b><i>Please continue shopping</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${isProductNotFound || isNotFound}">

                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#notFound").modal('show');
                        });
                    </script>

                    <div id="notFound" class="modal fade">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button class="close" type="button" data-dismiss="modal" title="Close">×</button>
                                    <p class="modal-title">Products not found</p>
                                </div>
                                <div class="modal-body text-center text-primary h2">
                                    <p>
                                        <i>Sorry, but products not found. Please, continue shopping</i>
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-success btn-lg" type="button" data-dismiss="modal"
                                            title="Click for continue"><i class="glyphicon glyphicon-ok"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <p>
                        <mark><b><i>Please, continue shopping</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${success}">

                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#successBuy").modal('show');
                        });
                    </script>

                    <div id="successBuy" class="modal fade">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button class="close" type="button" data-dismiss="modal" title="Close">×</button>
                                    <p class="modal-title">Thank you for visiting our shop</p>
                                </div>
                                <div class="modal-body text-center text-primary h2">
                                    <p>
                                        <i>Thanks for purchase. Your orderId is ${orderId} <br>
                                            Our operator will contact you as soon as possible. Please check your
                                            email ${email}<br>
                                        </i>
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-success btn-lg" type="button" data-dismiss="modal"
                                            title="Click for continue"><i class="glyphicon glyphicon-ok"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <p>
                        <mark><b><i>We will glad to see you soon. Your orderId is ${orderId}</i></b></mark>
                    </p>
                    <p>
                        <mark><b><i>You can continue shopping.</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${isAddedToCart}">

                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#addedToCart").modal('show');
                        });
                    </script>

                    <div id="addedToCart" class="modal fade">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button class="close" type="button" data-dismiss="modal" title="Close">×</button>
                                    <p class="modal-title">Product is added to Cart</p>
                                </div>
                                <div class="modal-body text-center text-primary h2">
                                    <p>
                                        <i>Thanks for your choice. Selected product is added to Cart.</i>
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <a class="btn btn-warning  btn-lg" href="/showCart" role="button"
                                       data-toggle="tooltip"
                                       title="Shop CART">
                                        <span class="badge">${cartSize}pcs</span><span
                                            class="badge">${totalPrice}$</span><br>
                                        <i class="glyphicon glyphicon-shopping-cart"></i><br>
                                    </a>
                                    <button class="btn btn-success btn-lg" type="button" data-dismiss="modal"
                                            title="Click for continue"><i class="glyphicon glyphicon-ok"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <p>
                        <mark><b><i>Please continue shopping</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${!empty listSubCategories}">
                    <p>
                        <mark><b><i>SubCategories of ${listSubCategories.get(0).category.name}</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${!empty listProduct && isFoundListEmpty}">
                    <p>
                        <mark><b><i>Products from ${listProduct.get(0).category.name} category</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${!empty listProduct && !isFoundListEmpty}">
                    <p>
                        <mark><b><i>Search results</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${!empty noProductExist}">

                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#productNotExist").modal('show');
                        });
                    </script>

                    <div id="productNotExist" class="modal fade">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button class="close" type="button" data-dismiss="modal" title="Close">×</button>
                                    <p class="modal-title">Products not exist</p>
                                </div>
                                <div class="modal-body text-center text-primary h2">
                                    <p>
                                        <i>${noProductExist}</i>
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-success btn-lg" type="button" data-dismiss="modal"
                                            title="Click for continue"><i class="glyphicon glyphicon-ok"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>


                    <p>
                        <mark><b><i>${noProductExist}</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${!empty undefinedError}">
                    <p>
                        <mark><b><i>${undefinedError}</i></b></mark>
                    </p>
                </c:if>

                <c:if test="${!isNotFound && !success && !isAddedToCart && !isCartEmpty && (empty listProduct) && (empty listSubCategories) && (empty noProductExist) && (empty undefinedError)}">
                    <p>
                        <mark><b><i>Welcome to Internet Shop "Smart House"</i></b></mark>
                    </p>
                </c:if>
            </div>
        </div>
        <div class="col-sm-3">
            <c:if test="${cartSize == 0}">
                <a class="btn btn-warning  btn-block btn-xl" href="/showCart" role="button" data-toggle="tooltip"
                   title="Shop CART empty">
                    <i class="glyphicon glyphicon-shopping-cart"></i>
                </a>
            </c:if>
            <c:if test="${cartSize > 0}">
                <a class="btn btn-danger  btn-block btn-xl" href="/showCart" role="button" data-toggle="tooltip"
                   title="Shop CART with products">
                    <i class="glyphicon glyphicon-shopping-cart"></i><br><br>
                    <span class="badge">${cartSize}pcs</span>
                    <span class="badge">${totalPrice}$</span>
                </a>
            </c:if>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-sm-3">
        <div class="form-group dropdown">
            <button type="button" class="btn btn-primary  btn-block btn-xxl" data-toggle="dropdown"
                    title="Show Category content">
                <i class="glyphicon glyphicon-menu-hamburger"></i>
            </button>

            <ul class="dropdown-menu dropdown-menu-left">
                <c:if test="${!empty listRootCategories}">
                    <li class="dropdown-header">
                        <p>
                            <mark><b>Categories</b></mark>
                        </p>
                    </li>
                    <c:forEach items="${listRootCategories}" var="category">
                        <li data-toggle="tooltip" title=${category.description}>
                            <a href="<c:url value='/subcategories/${category.id}@${category.name}'/>">
                                <p>${category.name}</p></a>
                        </li>
                    </c:forEach>
                </c:if>

                <c:if test="${!empty listSubCategories}">
                    <li class="dropdown-header">
                        <p>
                            <mark><b>SubCategories</b></mark>
                        </p>
                    </li>
                    <li data-toggle="tooltip">
                        <a href="/home" role="button" data-toggle="tooltip" title="Go to homepage">
                            <p>
                                <mark><i>Back to
                                    homepage</i></mark>
                            </p>
                        </a>
                    </li>
                    <c:forEach items="${listSubCategories}" var="category">
                        <li data-toggle="tooltip" title=${category.description}>
                            <a href="<c:url value='/subcategories/${category.id}@${category.name}'/>">
                                <p>${category.name}</p></a>
                        </li>
                    </c:forEach>
                </c:if>

                <c:if test="${!empty listProduct}">
                    <li class="dropdown-header">
                        <p>
                            <mark><b>Products</b></mark>
                        </p>
                    </li>
                    <li data-toggle="tooltip">
                        <a href="/home" role="button" data-toggle="tooltip" title="Go to homepage">
                            <p>
                                <mark><i>Back to
                                    homepage</i></mark>
                            </p>
                        </a>
                    </li>
                    <c:forEach items="${listProduct}" var="product">
                        <li data-toggle="tooltip" title=${product.productDescription}>
                            <a href="<c:url value='/product/${product.sku}@${product.name}'/>">
                                <p>${product.name}</p></a>
                        </li>
                    </c:forEach>
                </c:if>
                <li>
                    <a href="/admin/categoriesAdmin" role="button" data-toggle="tooltip"
                       title="Go to Admin Panel">
                        <p>
                            <mark><i>Admin Panel</i></mark>
                        </p>
                    </a>
                </li>
            </ul>
        </div>
        <c:if test="${!empty listProduct}">
            <div class="col-sm-12">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group dropdown">
                            <button type="button" class="btn btn-danger btn-block"
                                    data-toggle="dropdown"
                                    title="Sort product cards By ...">
                                <i class="glyphicon glyphicon-sort"></i>
                            </button>

                            <ul class="dropdown-menu dropdown-menu-left">
                                <li class="dropdown-header">
                                    <p>
                                        <mark><b>SORT By:</b></mark>
                                    </p>
                                </li>
                                <li data-toggle="tooltip" title="Sort Products By Name">
                                    <form action="/sortProductCardBy">
                                        <input type="hidden" name="categoryId" value=${categoryId}>
                                        <c:if test="${isSorted}">
                                            <input type="hidden" name="sortCriteria" value=SORT_BY_NAME>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Name Down">
                                                <i class="glyphicon glyphicon-sort-by-alphabet"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${!isSorted}">
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_NAME_REVERSED>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Name Up">
                                                <i class="glyphicon glyphicon-sort-by-alphabet-alt"></i>
                                            </button>
                                        </c:if>

                                    </form>
                                </li>

                                <li data-toggle="tooltip" title="Sort Products By Price">
                                    <form action="/sortProductCardBy">
                                        <input type="hidden" name="categoryId" value=${categoryId}>
                                        <c:if test="${isSorted}">
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_LOW_PRICE>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Low Price">
                                                <i class="glyphicon glyphicon-usd"></i>
                                                <i class="glyphicon glyphicon-arrow-up"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${!isSorted}">
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_HIGH_PRICE>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By High Price">
                                                <i class="glyphicon glyphicon-usd"></i>
                                                <i class="glyphicon glyphicon-arrow-down"></i>
                                            </button>
                                        </c:if>
                                    </form>
                                </li>

                                <li data-toggle="tooltip" title="Sort Products By Popularity">
                                    <form action="/sortProductCardBy">
                                        <c:if test="${!isSorted}">
                                            <input type="hidden" name="categoryId" value=${categoryId}>
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_POPULARITY>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Popularity Down">
                                                <i class="glyphicon glyphicon-thumbs-up"></i>
                                                <i class="glyphicon glyphicon-arrow-down"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${isSorted}">
                                            <input type="hidden" name="categoryId" value=${categoryId}>
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_POPULARITY_REVERSED>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Popularity Up">
                                                <i class="glyphicon glyphicon-thumbs-up"></i>
                                                <i class="glyphicon glyphicon-arrow-up"></i>
                                            </button>
                                        </c:if>
                                    </form>
                                </li>

                                <li data-toggle="tooltip" title="Sort Products By Unpopularity">
                                    <form action="/sortProductCardBy">
                                        <c:if test="${!isSorted}">
                                            <input type="hidden" name="categoryId" value=${categoryId}>
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_UNPOPULARITY>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Unpopularity Down">
                                                <i class="glyphicon glyphicon-thumbs-down"></i>
                                                <i class="glyphicon glyphicon-arrow-down"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${isSorted}">
                                            <input type="hidden" name="categoryId" value=${categoryId}>
                                            <input type="hidden" name="sortCriteria"
                                                   value=SORT_BY_UNPOPULARITY_REVERSED>
                                            <button type="submit" class="btn btn-block btn-info btn-xl"
                                                    data-toggle="tooltip"
                                                    title="Sort Products By Unpopularity Up">
                                                <i class="glyphicon glyphicon-thumbs-down"></i>
                                                <i class="glyphicon glyphicon-arrow-up"></i>
                                            </button>
                                        </c:if>
                                    </form>
                                <li>
                                    <a href="/admin/categoriesAdmin" role="button" data-toggle="tooltip"
                                       title="Go to Admin Panel">
                                        <p>
                                            <mark><i>Admin Panel</i></mark>
                                        </p>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty listProduct}">
            <a href="/admin/categoriesAdmin" class="btn btn-danger btn-lg" role="button" data-toggle="tooltip"
               title="Go to Admin Panel">
                <p>
                    <i class="glyphicon glyphicon-wrench"></i>
                </p>
            </a>
        </c:if>
    </div>

    <div class="col-sm-9" align="left">
        <form role="form" class="form-inline" action="/findProducts" name="Search By:">
            <div class="row">
                <div class="col-sm-2">
                    <div class="col-sm-12">
                        <button type="submit" class="btn btn-info  btn-blockbtn-success"
                                data-toggle="tooltip"
                                title="Start search">
                            <i class="glyphicon glyphicon-search"></i>
                        </button>
                    </div>
                </div>
                <div class="col-sm-10 searchForm">
                    <div class="row">
                        <div class="col-sm-12 searchForm">
                            <label>
                                <select class="form-control form-control" name="findOption" data-toggle="tooltip"
                                        title="Click for select">
                                    <option value=FIND_ALL>Search all(case ignore)</option>
                                    <option value=FIND_IN_ALL_PLACES>Search all(exactly)</option>
                                    <option value=FIND_IN_NAME>In products names</option>
                                    <option value=FIND_IN_PROD_DESC>In products description</option>
                                    <option value=FIND_IN_CATEGORY_NAME>In category names</option>
                                    <option value=FIND_IN_CATEGORY_DESC>In category description</option>
                                </select>
                            </label>
                        </div>
                        <div class="col-sm-12 searchForm">
                            <input type="text" class="form-control" title="Input search value" name="searchValue"
                                   placeholder="Input for search..."/>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<div>
    <c:if test="${!empty listRootCategories}">
        <div class="row">
            <div class="col-sm-4">
                <ul>
                    <li class="dropdown-header"><p>Categories</p></li>
                    <c:forEach items="${listRootCategories}" var="category">
                        <li data-toggle="tooltip" title=${category.description}>
                            <a href="<c:url value='/subcategories/${category.id}@${category.name}'/>">
                                <p>
                                    <mark><b>${category.name}</b></mark>
                                </p>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <div class="container col-sm-8">
                <img src="${pathPhotoHomepage}"
                     class="img-responsive img-circle center-block"
                     alt="Smart House"/>
            </div>
        </div>
    </c:if>
</div>

<div>
    <c:if test="${!empty listSubCategories}">
        <!-- Navigation -->
        <ul class="nav nav-tabs" role="tablist">
            <li class="active">
                <a href="#subcategories" aria-controls="subcategories" role="tab" data-toggle="tab">
                    <p>
                        <mark><b>SubCategories ${listSubCategories.get(0).category.name}</b></mark>
                    </p>
                </a>
            </li>
            <li>
                <a href="#description" aria-controls="description" role="tab" data-toggle="tab">
                    <p>
                        <mark><b>Description ${listSubCategories.get(0).category.name}</b></mark>
                    </p>
                </a>
            </li>
        </ul>
        <!-- Content -->
        <div class="tab-content text-center">
            <div role="tabpanel" class="tab-pane active" id="subcategories">
                <c:forEach items="${listSubCategories}" var="category">
                    <li data-toggle="tooltip" title=${category.description}>
                        <a href="<c:url value='/subcategories/${category.id}@${category.name}'/>">
                            <p>${category.name}</p></a>
                    </li>
                </c:forEach>
            </div>
            <div role="tabpanel" class="tab-pane" id="description">
                <div class="row">
                    <div class="col-sm-12">
                        <p>${listSubCategories.get(0).category.description}</p>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${!empty listProduct && !isFoundListEmpty}">

        <div class="row">
            <div class="col-sm-12">
                <p>
                    <mark><b>Found products</b></mark>
                </p>
            </div>
            <c:forEach items="${listProduct}" var="product">
                <div class="col-sm-4 smallProductCard">
                    <div class="col-sm-9">
                        <a href="/product/${product.sku}@${product.name}">
                            <c:set var="isFound" value="${false}"/>
                            <c:forEach items="${listVizualisations}" var="visual">
                                <c:if test="${product.getSku() == visual.getProductCard().getSku() && !isFound}">
                                    <img src="${visual.getUrl()}"
                                         class="img-responsive img-circle center-block"
                                         alt="Smart House"/>
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
                                    title="Add Like  for ${product.name}">
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
    </c:if>

    <c:if test="${!empty listProduct && isFoundListEmpty}">

        <!-- Navigation -->
        <ul class="nav nav-tabs" role="tablist">
            <li class="active">
                <a href="#products" aria-controls="products" role="tab" data-toggle="tab">
                    <p>
                        <mark><b>Products in ${listProduct.get(0).category.name} category</b></mark>
                    </p>
                </a>
            </li>
            <li>
                <a href="#prodDescription" aria-controls="prodDescription" role="tab" data-toggle="tab">
                    <p>
                        <mark><b>Description ${listProduct.get(0).category.name}</b></mark>
                    </p>
                </a>
            </li>
        </ul>
        <!-- Content -->
        <div class="tab-content text-center">
            <div role="tabpanel" class="tab-pane active" id="products">
                <div class="row">
                    <c:forEach items="${listProduct}" var="product">
                        <div class="col-sm-4 smallProductCard" data-toggle="tooltip"
                             title=${product.productDescription}>
                            <div class="col-sm-9">
                                <a href="/product/${product.sku}@${product.name}">
                                    <c:set var="isFound" value="${false}"/>
                                    <c:forEach items="${listPopularVizualisations}" var="visual">
                                        <c:if test="${product.getSku() == visual.getProductCard().getSku() && !isFound}">
                                            <img src="${visual.getUrl()}"
                                                 class="img-responsive img-circle center-block"
                                                 alt="Smart House"/>
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
            <div role="tabpanel" class="tab-pane" id="prodDescription">
                <div class="row">
                    <div class="col-sm-12">
                        <p>${listProduct.get(0).category.description}</p>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
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
                            <form role="form" class="form-inline" action="/addToCart" method="POST" name="Amount:">
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
