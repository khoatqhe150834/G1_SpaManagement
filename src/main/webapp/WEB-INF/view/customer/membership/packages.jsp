<%-- 
    Document   : packages.jsp
    Created on : Membership Packages Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Gói Hội Viên - BeautyZone Spa</title>
    
    <!-- Include Home Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
</head>
<body id="bg">
    <div class="page-wraper">
        <div id="loading-area"></div>
        <!-- header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
        <!-- header END -->
        
        <!-- Content -->
        <div class="page-content bg-white">
            <!-- inner page banner -->
            <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Gói Hội Viên</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer-dashboard">Bảng Điều Khiển</a></li>
                                <li><a href="${pageContext.request.contextPath}/appointments/booking-selection">Đặt Dịch Vụ</a></li>
                                <li>Gói Hội Viên</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- inner page banner END -->
            
            <!-- membership area -->
            <div class="section-full content-inner shop-account">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-12 text-center">
                            <h3 class="font-weight-700 m-t0 m-b20">Gói Hội Viên</h3>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="p-a30 border-1 seth">
                                <div class="text-center">
                                    <iconify-icon icon="solar:crown-outline" style="font-size: 64px; color: #f59e0b; margin-bottom: 20px;"></iconify-icon>
                                    <h4 class="font-weight-700">GÓI HỘI VIÊN</h4>
                                    <p class="font-weight-600">
                                        Tính năng gói hội viên đang được phát triển.
                                    </p>
                                    <p class="text-muted">
                                        Trở thành hội viên để nhận được những ưu đãi đặc biệt và dịch vụ cao cấp.
                                    </p>
                                    
                                    <div class="m-t30">
                                        <a href="${pageContext.request.contextPath}/appointments/booking-selection" 
                                           class="site-button m-r5 button-lg radius-no">
                                            <i class="fa fa-arrow-left m-r10"></i>Quay Lại
                                        </a>
                                        <%-- Show "Đặt lịch ngay" button only for customers and guests --%>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.customer or (empty sessionScope.user and empty sessionScope.customer)}">
                                        <a href="${pageContext.request.contextPath}/appointments/booking-individual" 
                                           class="site-button outline button-lg radius-no">
                                            Đặt Lịch Ngay
                                        </a>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- membership area END -->
        </div>
        <!-- Content END-->
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- Footer END -->
        <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- Include Home Framework JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
</body>
</html> 