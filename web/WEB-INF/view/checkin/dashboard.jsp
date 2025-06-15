<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-in Dashboard - Spa Management</title>
    
    <!-- Import stylesheets -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <style>
        .qr-stats-card {
            border-radius: 16px;
            transition: all 0.3s ease;
            border: 1px solid #E5E7EB;
        }
        
        .qr-stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .status-badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
        }
        
        .status-pending {
            background-color: #FEF3C7;
            color: #92400E;
        }
        
        .status-confirmed {
            background-color: #D1FAE5;
            color: #065F46;
        }
        
        .status-cancelled {
            background-color: #FEE2E2;
            color: #991B1B;
        }
        
        .checkin-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .table thead th {
            background-color: #F8FAFC;
            border-bottom: 1px solid #E2E8F0;
            font-weight: 600;
            color: #475569;
            padding: 1rem;
        }
        
        .table tbody td {
            padding: 1rem;
            border-bottom: 1px solid #F1F5F9;
        }
        
        .quick-action-btn {
            transition: all 0.2s ease;
        }
        
        .quick-action-btn:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <!-- Include header -->
    <jsp:include page="/WEB-INF/view/common/home/header.jsp" />

    <div class="dashboard-main-wrapper">
        <!-- Include sidebar -->
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <div class="dashboard-body">
            <div class="container-fluid">
                <!-- Page Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="text-lg fw-semibold text-primary-light mb-2">
                                    <iconify-icon icon="solar:qr-code-outline" class="me-2"></iconify-icon>
                                    Check-in Dashboard
                                </h4>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Dashboard</a></li>
                                        <li class="breadcrumb-item active">Check-in</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="d-flex gap-2">
                                <c:if test="${sessionScope.userType == 'customer'}">
                                    <a href="${pageContext.request.contextPath}/checkin/generate" 
                                       class="btn btn-primary d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:qr-code-outline"></iconify-icon>
                                        Tạo QR Code
                                    </a>
                                </c:if>
                                <c:if test="${sessionScope.userType != 'customer'}">
                                    <a href="${pageContext.request.contextPath}/checkin/scan" 
                                       class="btn btn-success d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:camera-outline"></iconify-icon>
                                        Quét QR Code
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/checkin/history" 
                                   class="btn btn-outline-primary d-flex align-items-center gap-2">
                                    <iconify-icon icon="solar:history-outline"></iconify-icon>
                                    Lịch sử
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats Cards -->
                <div class="row mb-4">
                    <c:if test="${sessionScope.userType == 'customer'}">
                        <div class="col-md-4">
                            <div class="card qr-stats-card h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="w-12 h-12 bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:qr-code-outline" class="text-2xl text-primary-600"></iconify-icon>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="fw-semibold text-primary-light mb-1">Tổng Check-in</h6>
                                        <h4 class="fw-bold text-primary-600 mb-0">${checkIns.size()}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card qr-stats-card h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="w-12 h-12 bg-success-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:check-circle-outline" class="text-2xl text-success-600"></iconify-icon>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="fw-semibold text-primary-light mb-1">Đã xác nhận</h6>
                                        <h4 class="fw-bold text-success-600 mb-0">
                                            <c:set var="confirmedCount" value="0" />
                                            <c:forEach var="checkIn" items="${checkIns}">
                                                <c:if test="${checkIn.status == 'confirmed'}">
                                                    <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${confirmedCount}
                                        </h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card qr-stats-card h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="w-12 h-12 bg-warning-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:clock-circle-outline" class="text-2xl text-warning-600"></iconify-icon>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="fw-semibold text-primary-light mb-1">Chờ xác nhận</h6>
                                        <h4 class="fw-bold text-warning-600 mb-0">
                                            <c:set var="pendingCount" value="0" />
                                            <c:forEach var="checkIn" items="${checkIns}">
                                                <c:if test="${checkIn.status == 'pending'}">
                                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${pendingCount}
                                        </h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${sessionScope.userType != 'customer'}">
                        <div class="col-md-6">
                            <div class="card qr-stats-card h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="w-12 h-12 bg-warning-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:clock-circle-outline" class="text-2xl text-warning-600"></iconify-icon>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="fw-semibold text-primary-light mb-1">Check-in chờ xác nhận</h6>
                                        <h4 class="fw-bold text-warning-600 mb-0">${pendingCheckIns.size()}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card qr-stats-card h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="w-12 h-12 bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:camera-outline" class="text-2xl text-primary-600"></iconify-icon>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="fw-semibold text-primary-light mb-1">Quét QR Code ngay</h6>
                                        <a href="${pageContext.request.contextPath}/checkin/scan" 
                                           class="btn btn-primary btn-sm quick-action-btn">
                                            <iconify-icon icon="solar:camera-outline" class="me-1"></iconify-icon>
                                            Bắt đầu quét
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Check-in List -->
                <div class="row">
                    <div class="col-12">
                        <div class="card checkin-table">
                            <div class="card-header bg-white border-bottom">
                                <h5 class="card-title mb-0 d-flex align-items-center gap-2">
                                    <iconify-icon icon="solar:list-outline"></iconify-icon>
                                    <c:choose>
                                        <c:when test="${sessionScope.userType == 'customer'}">
                                            Check-in của tôi
                                        </c:when>
                                        <c:otherwise>
                                            Check-in chờ xác nhận
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${sessionScope.userType == 'customer' && not empty checkIns}">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Ngày tạo</th>
                                                        <th>Loại</th>
                                                        <th>Trạng thái</th>
                                                        <th>Thời gian check-in</th>
                                                        <th>Ghi chú</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="checkIn" items="${checkIns}">
                                                        <tr>
                                                            <td>
                                                                <fmt:formatDate value="${checkIn.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${checkIn.checkInType == 'appointment'}">
                                                                        <span class="badge bg-primary">Có hẹn</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">Không hẹn</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${checkIn.status == 'pending'}">
                                                                        <span class="status-badge status-pending">Chờ xác nhận</span>
                                                                    </c:when>
                                                                    <c:when test="${checkIn.status == 'confirmed'}">
                                                                        <span class="status-badge status-confirmed">Đã xác nhận</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-badge status-cancelled">Đã hủy</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty checkIn.checkInTime}">
                                                                        <fmt:formatDate value="${checkIn.checkInTime}" pattern="dd/MM/yyyy HH:mm" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Chưa check-in</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty checkIn.notes}">
                                                                        ${checkIn.notes}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Không có</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:when test="${sessionScope.userType != 'customer' && not empty pendingCheckIns}">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Khách hàng</th>
                                                        <th>Email</th>
                                                        <th>Loại</th>
                                                        <th>Ngày tạo</th>
                                                        <th>Trạng thái</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="checkIn" items="${pendingCheckIns}">
                                                        <tr>
                                                            <td class="fw-medium">${checkIn.customerName}</td>
                                                            <td>${checkIn.customerEmail}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${checkIn.checkInType == 'appointment'}">
                                                                        <span class="badge bg-primary">Có hẹn</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">Không hẹn</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${checkIn.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </td>
                                                            <td>
                                                                <span class="status-badge status-pending">Chờ xác nhận</span>
                                                            </td>
                                                            <td>
                                                                <form method="post" action="${pageContext.request.contextPath}/checkin/confirm" class="d-inline">
                                                                    <input type="hidden" name="qrData" value="${checkIn.qrCode}">
                                                                    <input type="hidden" name="notes" value="Check-in được xác nhận bởi nhân viên">
                                                                    <button type="submit" class="btn btn-success btn-sm d-flex align-items-center gap-1">
                                                                        <iconify-icon icon="solar:check-circle-outline"></iconify-icon>
                                                                        Xác nhận
                                                                    </button>
                                                                </form>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <div class="d-flex flex-column align-items-center">
                                                <iconify-icon icon="solar:inbox-outline" class="text-6xl text-gray-300 mb-3"></iconify-icon>
                                                <h6 class="text-gray-500 mb-2">Chưa có check-in nào</h6>
                                                <p class="text-gray-400 mb-3">
                                                    <c:choose>
                                                        <c:when test="${sessionScope.userType == 'customer'}">
                                                            Bạn chưa có lần check-in nào. Tạo QR code để bắt đầu!
                                                        </c:when>
                                                        <c:otherwise>
                                                            Hiện tại không có check-in nào chờ xác nhận.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <c:if test="${sessionScope.userType == 'customer'}">
                                                    <a href="${pageContext.request.contextPath}/checkin/generate" 
                                                       class="btn btn-primary">
                                                        <iconify-icon icon="solar:qr-code-outline" class="me-1"></iconify-icon>
                                                        Tạo QR Code đầu tiên
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include footer -->
    <jsp:include page="/WEB-INF/view/common/home/footer.jsp" />

    <!-- Success/Error Messages -->
    <c:if test="${not empty success}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                Swal.fire({
                    title: 'Thành công!',
                    text: '${success}',
                    icon: 'success',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#3085d6'
                });
            });
        </script>
    </c:if>

    <c:if test="${not empty error}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                Swal.fire({
                    title: 'Lỗi!',
                    text: '${error}',
                    icon: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#d33'
                });
            });
        </script>
    </c:if>
</body>
</html> 