<%-- 
    Document   : blog_list
    Created on : Jun 18, 2025, 2:22:37 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- meta tags and other links -->
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:31 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Wowdash - Bootstrap 5 Admin Dashboard HTML Template</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />


        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Blog</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Blog</li>
                </ul>
            </div>

            <!-- Search bar, status filter, and category filter -->
            <form action="${pageContext.request.contextPath}/blog" method="GET" class="d-flex align-items-center gap-3 mb-24" style="flex-wrap: wrap;">
                <input type="hidden" name="action" value="list" />
                <div class="navbar-search">
                    <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Search by title" value="${param.search != null ? param.search : ''}"/>
                    <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                </div>
                <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                    <option value="">All Status</option>
                    <option value="DRAFT" ${param.status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                    <option value="PUBLISHED" ${param.status == 'PUBLISHED' ? 'selected' : ''}>Published</option>
                    <option value="ARCHIVED" ${param.status == 'ARCHIVED' ? 'selected' : ''}>Archived</option>
                </select>
                <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="category">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}" ${param.category == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                    <a href="${pageContext.request.contextPath}/blog?action=add" class="btn btn-success h-40-px radius-12 ms-auto d-flex align-items-center gap-1">
                        <iconify-icon icon="ic:round-add" class="text-lg"></iconify-icon> Add New Blog
                    </a>
                </c:if>
            </form>

            <div class="row gy-4">
                <!-- Style Three -->
                <c:forEach var="blog" items="${blogs}">
                <div class="col-xxl-3 col-lg-4 col-sm-6">
                    <div class="card h-100 p-0 radius-12 overflow-hidden">
                        <div class="card-body p-24">
                            <h6 class="mb-16">
                                <a href="${pageContext.request.contextPath}/blog?id=${blog.blogId}" class="text-line-2 text-hover-primary-600 text-xl transition-2">${blog.title}</a>
                            </h6>
                            <div class="d-flex align-items-center gap-6 justify-content-between flex-wrap mb-16">
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-chat-3-line"></i>
                                    ${blog.viewCount} views
                                </div>
                                <div class="d-flex align-items-center gap-8 text-neutral-500 fw-medium">
                                    <i class="ri-calendar-2-line"></i>
                                    <fmt:formatDate value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}" pattern="MMM dd, yyyy"/>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/blog?id=${blog.blogId}" class="w-100 max-h-194-px radius-8 overflow-hidden">
                                <img src="${pageContext.request.contextPath}/${empty blog.featureImageUrl ? 'assets/admin/images/blog/blog1.png' : blog.featureImageUrl}" alt="" class="w-100 h-100 object-fit-cover">                        
                            </a>
                            <div class="mt-20">
                                <p class="text-line-3 text-neutral-500">${blog.summary}</p>
                                <span class="d-block border-bottom border-neutral-300 border-dashed my-20"></span>
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-6">
                                    <div class="d-flex align-items-center gap-8 flex-grow-1">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-40-px h-40-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-sm mb-0">${blog.authorName}</h6>
                                            <c:choose>
                                                <c:when test="${blog.status == 'PUBLISHED'}">
                                                    <span class="badge px-2 py-1 mt-1" style="font-size:12px; font-weight:600; background-color:#28a745; color:#fff;">PUBLISHED</span>
                                                </c:when>
                                                <c:when test="${blog.status == 'DRAFT'}">
                                                    <span class="badge px-2 py-1 mt-1" style="font-size:12px; font-weight:600; background-color:#6c757d; color:#fff;">DRAFT</span>
                                                </c:when>
                                                <c:when test="${blog.status == 'ARCHIVED'}">
                                                    <span class="badge px-2 py-1 mt-1" style="font-size:12px; font-weight:600; background-color:#ffc107; color:#212529;">ARCHIVED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge px-2 py-1 mt-1" style="font-size:12px; font-weight:600; background-color:#dee2e6; color:#212529;">${blog.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="d-flex flex-column align-items-end gap-2">
                                        <a href="${pageContext.request.contextPath}/blog?id=${blog.blogId}" class="btn btn-sm btn-primary-600 d-flex align-items-center gap-1 text-xs px-8 py-6">
                                            Read More
                                        </a>
                                        <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 2}">
                                            <c:choose>
                                                <c:when test="${blog.status == 'DRAFT'}">
                                                    <form action="${pageContext.request.contextPath}/blog" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="updateBlogStatus">
                                                        <input type="hidden" name="blogId" value="${blog.blogId}">
                                                        <input type="hidden" name="status" value="PUBLISHED">
                                                        <input type="hidden" name="page" value="${currentPage}" />
                                                        <button type="submit" class="btn btn-sm btn-success d-flex align-items-center gap-1 text-xs px-8 py-6 w-100">
                                                            <iconify-icon icon="mdi:check" class="text-lg"></iconify-icon>
                                                            Approve
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${blog.status == 'PUBLISHED'}">
                                                    <form action="${pageContext.request.contextPath}/blog" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="updateBlogStatus">
                                                        <input type="hidden" name="blogId" value="${blog.blogId}">
                                                        <input type="hidden" name="status" value="ARCHIVED">
                                                        <input type="hidden" name="page" value="${currentPage}" />
                                                        <button type="submit" class="btn btn-sm btn-warning d-flex align-items-center gap-1 text-xs px-8 py-6 w-100">
                                                            <iconify-icon icon="mdi:archive" class="text-lg"></iconify-icon>
                                                            Archive
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${blog.status == 'ARCHIVED'}">
                                                    <form action="${pageContext.request.contextPath}/blog" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="updateBlogStatus">
                                                        <input type="hidden" name="blogId" value="${blog.blogId}">
                                                        <input type="hidden" name="status" value="PUBLISHED">
                                                        <input type="hidden" name="page" value="${currentPage}" />
                                                        <button type="submit" class="btn btn-sm btn-info d-flex align-items-center gap-1 text-xs px-8 py-6 w-100">
                                                            <iconify-icon icon="mdi:restore" class="text-lg"></iconify-icon>
                                                            Restore
                                                        </button>
                                                    </form>
                                                </c:when>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </c:forEach>

                                </div>

            <!-- Pagination block -->
            <c:url value="/blog" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
                <c:if test="${not empty param.status}">
                    <c:param name="status" value="${param.status}" />
                </c:if>
            </c:url>
            <div class="col-md-12 mt-32">
                <div class="card p-0 overflow-hidden position-relative radius-12">
                        <div class="card-body p-24">
                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <!-- First -->
                            <li class="page-item">
                                <a class="page-link bg-primary-50 text-secondary-light fw-medium radius-8 border-0 px-20 py-10 d-flex align-items-center justify-content-center h-48-px ${currentPage == 1 ? 'disabled' : ''}"
                                   href="${currentPage == 1 ? 'javascript:void(0)' : paginationUrl}">First</a>
                            </li>
                            <!-- Arrow left -->
                            <li class="page-item">
                                <a class="page-link bg-primary-50 text-secondary-light fw-medium radius-8 border-0 px-20 py-10 d-flex align-items-center justify-content-center h-48-px w-48-px ${currentPage == 1 ? 'disabled' : ''}"
                                   href="${currentPage == 1 ? 'javascript:void(0)' : paginationUrl}&page=${currentPage - 1}">
                                    <iconify-icon icon="ep:d-arrow-left" class="text-xl"></iconify-icon>
                                </a>
                            </li>
                            <!-- Page numbers -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item">
                                    <a class="page-link bg-primary-50 text-secondary-light fw-medium radius-8 border-0 px-20 py-10 d-flex align-items-center justify-content-center h-48-px w-48-px ${currentPage == i ? 'bg-primary-600 text-white' : ''}"
                                       href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <!-- Arrow right -->
                            <li class="page-item">
                                <a class="page-link bg-primary-50 text-secondary-light fw-medium radius-8 border-0 px-20 py-10 d-flex align-items-center justify-content-center h-48-px w-48-px ${currentPage == totalPages ? 'disabled' : ''}"
                                   href="${currentPage == totalPages ? 'javascript:void(0)' : paginationUrl}&page=${currentPage + 1}">
                                    <iconify-icon icon="ep:d-arrow-right" class="text-xl"></iconify-icon>
                                </a>
                            </li>
                            <!-- Last -->
                            <li class="page-item">
                                <a class="page-link bg-primary-50 text-secondary-light fw-medium radius-8 border-0 px-20 py-10 d-flex align-items-center justify-content-center h-48-px ${currentPage == totalPages ? 'disabled' : ''}"
                                   href="${currentPage == totalPages ? 'javascript:void(0)' : paginationUrl}&page=${totalPages}">Last</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:34 GMT -->
</html>
