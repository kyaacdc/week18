<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>

<html>

<head>
    <meta charset="UTF-8">
    <title>Categories</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>

<body>

<!-- NAVIGATION -->
<nav class="page-navigation">
    <div>
        <div><a href="/home" class="btn btn-warning btn-lg" style="float:left">Back to Homepage</a></div>
        <div><h2 style="float:left">Welcome ${pageContext.request.userPrincipal.name}</h2></div>
        <div align="right">
            <form action="/logout" method="post">
                <button type="submit" class="btn btn-danger btn-lg">Log Out</button>
                <input type="hidden" name="${_csrf.parameterName}"
                       value="${_csrf.token}"/>
            </form>
        </div>
    </div>
</nav>
<!-- /NAVIGATION -->

<!-- HEADER -->
<header class="header">
    <div>
        <form action="/admin/findProductsAdmin" name="Search By:">
            <table class="table table-striped" name="Search By:">
                <tr>
                    <td width="120">
                        <select name=findOption size=1>
                            <option value=FIND_ALL selected>Search all match (case ignored)</option>
                            <option value=FIND_IN_ALL_PLACES>Search in all places (exactly)</option>
                            <option value=FIND_IN_NAME>Search in products names</option>
                            <option value=FIND_IN_PROD_DESC>Search in products descriptions</option>
                            <option value=FIND_IN_CATEGORY_NAME>Search in categories names</option>
                            <option value=FIND_IN_CATEGORY_DESC>Search in categories descriptions</option>
                        </select>
                    </td>
                    <td width="120">
                        <input type="text" title="searchValue" name="searchValue"
                               placeholder="Please input SEARCH value"/>
                    </td>
                    <td width="120">
                        <input type="submit" value="Search">
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div class="container">

        <c:if test="${isProductNotFound || isNotFound}">
            <h1>Sorry, but products not found</h1>
            <h2>But you can continue search</h2>
        </c:if>

        <c:if test="${!empty listSubCategories}">
            <h1>SubCategories of ${listSubCategories.get(0).category.name}</h1>
        </c:if>

        <c:if test="${!empty listProduct && isFoundListEmpty}">
            <h1>Products from ${listProduct.get(0).category.name} category</h1>
        </c:if>

        <c:if test="${!empty listProduct && !isFoundListEmpty}">
            <h1>Search results</h1>
        </c:if>

        <c:if test="${!empty noProductExist}">
            <h1>${noProductExist}</h1>
        </c:if>

        <c:if test="${!empty undefinedError}">
            <h1>${undefinedError}</h1>
        </c:if>

        <c:if test="${!isNotFound && !success && !isAddedToCart && !isCartEmpty && (empty listProduct) && (empty listSubCategories) && (empty noProductExist) && (empty undefinedError)}">
            <h1>
                Welcome to Admin Panel of Internet Shop "Smart House"
            </h1>
        </c:if>
    </div>
</header>
<!-- /HEADER -->

<!-- MAIN SECTION -->
<main>

    <div>


        <c:if test="${!empty listRootCategories}">
            <h1>Add/Edit Category</h1>
            <c:url var="addAction" value="/admin/categoriesAdmin/add"/>
            <form:form action="${addAction}" commandName="category">
                <table>
                    <c:if test="${!empty category.name}">
                        <tr>
                            <td>
                                <form:label path="id">
                                    <spring:message text="ID"/>
                                </form:label>
                            </td>
                            <td>
                                <form:input path="id" readonly="true" size="8" disabled="true"/>
                                <form:hidden path="id"/>
                            </td>
                        </tr>
                    </c:if>
                    <tr>
                        <td>
                            <form:label path="name">
                                <spring:message text="name"/>
                            </form:label>
                        </td>
                        <td>
                            <form:input path="name"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:label path="description">
                                <spring:message text="description"/>
                            </form:label>
                        </td>
                        <td>
                            <form:input path="description"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:label path="category">
                                <spring:message text="category"/>
                            </form:label>
                        </td>
                        <td>
                            <form:input path="category"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <c:if test="${!empty category.name}">
                                <input type="submit"
                                       value="<spring:message text="Edit Category"/>"/>
                            </c:if>
                            <c:if test="${empty category.name}">
                                <input type="submit"
                                       value="<spring:message text="Add Category"/>"/>
                            </c:if>
                        </td>
                    </tr>
                </table>
            </form:form>
        </c:if>

        <c:if test="${!empty listSubCategories}">
            <h1>Add/Edit Category</h1>
            <c:url var="addAction" value="/admin/subcategoriesAdmin/add"/>
            <form:form action="${addAction}" commandName="category">
                <table>
                    <c:if test="${!empty category.name}">
                        <tr>
                            <td>
                                <form:label path="id">
                                    <spring:message text="ID"/>
                                </form:label>
                            </td>
                            <td>
                                <form:input path="id" readonly="true" size="8" disabled="true"/>
                                <form:hidden path="id"/>
                            </td>
                        </tr>
                    </c:if>
                    <tr>
                        <td>
                            <form:label path="name">
                                <spring:message text="name"/>
                            </form:label>
                        </td>
                        <td>
                            <form:input path="name"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:label path="description">
                                <spring:message text="description"/>
                            </form:label>
                        </td>
                        <td>
                            <form:input path="description"/>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <form:label path="category">
                                <spring:message text="category"/>
                            </form:label>
                        </td>
                        <td>
                            <form:input path="category"/>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <c:if test="${!empty category.name}">
                                <input type="submit"
                                       value="<spring:message text="Edit Category"/>"/>
                            </c:if>
                            <c:if test="${empty category.name}">
                                <input type="submit"
                                       value="<spring:message text="Add Category"/>"/>
                            </c:if>
                        </td>
                    </tr>
                </table>
            </form:form>
        </c:if>
    </div>

    <div class="table-responsive">
        <c:if test="${!empty listRootCategories}">
            <table class="table table-striped table-condensed">
                <tr class="active">
                    <th width="20">ID</th>
                    <th width="200">Name</th>
                    <th width="500">Description</th>
                    <th width="100">Edit</th>
                </tr>

                <c:forEach items="${listRootCategories}" var="category">
                    <tr>
                        <td>${category.id}</td>
                        <td>
                            <a href="<c:url value='/admin/subcategoriesAdmin/${category.id}@${category.name}'/>">${category.name}</a>
                        </td>
                        <td>${category.description}</td>
                        <td><a href="<c:url value='/admin/categoriesAdmin/edit/${category.id}'/>">Edit</a></td>
                    </tr>
                </c:forEach>
            </table>

        </c:if>

        <c:if test="${!empty listSubCategories}">
            <table class="table table-striped">
                <tr>
                    <th width="20">ID</th>
                    <th width="200">Name</th>
                    <th width="800">Description</th>
                    <th width="100">Edit</th>
                </tr>

                <c:forEach items="${listSubCategories}" var="category">
                    <tr>
                        <td>${category.id}</td>
                        <td>
                            <a href="<c:url value='/admin/subcategoriesAdmin/${category.id}@${category.name}'/>">${category.name}</a>
                        </td>
                        <td>${category.description}</td>
                        <td><a href="<c:url value='/admin/subcategoriesAdmin/edit/${category.id}'/>">Edit</a></td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <c:if test="${!empty listProduct}">
            <table class="table table-striped">
                <tr>
                    <th width="20">SKU</th>
                    <th width="80">
                        <form action="/admin/sortProductCardByAdmin">
                            <input type="hidden" name="categoryId" value=${categoryId}>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_NAME>
                            </c:if>
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_NAME_REVERSED>
                            </c:if>
                            <input type="submit" value="Name"/>
                        </form>
                    </th>
                    <th width="200">Description</th>
                    <th width="20">
                        <form action="/admin/sortProductCardByAdmin">
                            <input type="hidden" name="categoryId" value=${categoryId}>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_LOW_PRICE>
                            </c:if>
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_HIGH_PRICE>
                            </c:if>
                            <input type="submit" value="Price"/>
                        </form>
                    </th>
                    <th width="20">
                        <form action="/admin/sortProductCardByAdmin">
                            <input type="hidden" name="categoryId" value=${categoryId}>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_AMOUNT_REVERSED>
                            </c:if>
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="sortCriteria" value=SORT_BY_AMOUNT>
                            </c:if>
                            <input type="submit" value="Amount"/>
                        </form>
                    </th>
                    <th width="20">
                        <form action="/admin/sortProductCardByAdmin">
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_POPULARITY>
                                <input type="submit" value="Like"/>
                            </c:if>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_POPULARITY_REVERSED>
                                <input type="submit" value="Like"/>
                            </c:if>
                        </form>
                    </th>
                    <th width="20">
                        <form action="/admin/sortProductCardByAdmin">
                            <c:if test="${!isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_UNPOPULARITY>
                                <input type="submit" value="Dislike"/>
                            </c:if>
                            <c:if test="${isSorted}">
                                <input type="hidden" name="categoryId" value=${categoryId}>
                                <input type="hidden" name="sortCriteria" value=SORT_BY_UNPOPULARITY_REVERSED>
                                <input type="submit" value="Dislike"/>
                            </c:if>
                        </form>
                    </th>
                </tr>

                <c:forEach items="${listProduct}" var="product">
                    <tr>
                        <td>${product.sku}</td>
                        <td>
                            <a href="<c:url value='/admin/productAdmin/${product.sku}@${product.name}'/>">${product.name}</a>
                        </td>
                        <td>${product.productDescription}</td>
                        <td>${product.price}</td>
                        <td>${product.amount}</td>
                        <td>${product.likes}</td>
                        <td>${product.dislikes}</td>
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