<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo QR Code Check-in - Spa Management</title>
    
    <!-- Import stylesheets -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <style>
        .qr-form-card {
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #E5E7EB;
        }
        
        .qr-display-card {
            border-radius: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            padding: 2rem;
        }
        
        .qr-code-container {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            margin: 1.5rem 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #D1D5DB;
            padding: 0.75rem 1rem;
            transition: all 0.2s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #3B82F6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .btn-generate {
            background: linear-gradient(135deg, #3B82F6 0%, #1E40AF 100%);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(59, 130, 246, 0.3);
        }
        
        .download-btn {
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            border: none;
            border-radius: 8px;
            padding: 0.5rem 1.5rem;
            color: white;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .download-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(16, 185, 129, 0.3);
            color: white;
            text-decoration: none;
        }
        
        .info-card {
            background: linear-gradient(135deg, #F3F4F6 0%, #E5E7EB 100%);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid #D1D5DB;
        }
        
        .step-indicator {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .step-number {
            width: 32px;
            height: 32px;
            background: #3B82F6;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .step-text {
            flex: 1;
            color: #374151;
            font-weight: 500;
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
                                    Tạo QR Code Check-in
                                </h4>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Dashboard</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/checkin">Check-in</a></li>
                                        <li class="breadcrumb-item active">Tạo QR Code</li>
                                    </ol>
                                </nav>
                            </div>
                            <a href="${pageContext.request.contextPath}/checkin" 
                               class="btn btn-outline-primary">
                                <iconify-icon icon="solar:arrow-left-outline" class="me-1"></iconify-icon>
                                Quay lại
                            </a>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- QR Code Generation Form -->
                    <div class="col-lg-6">
                        <div class="card qr-form-card">
                            <div class="card-header bg-white border-bottom">
                                <h5 class="card-title mb-0 d-flex align-items-center gap-2">
                                    <iconify-icon icon="solar:settings-outline"></iconify-icon>
                                    Thông tin check-in
                                </h5>
                            </div>
                            <div class="card-body">
                                <!-- Customer Info Display -->
                                <div class="info-card mb-4">
                                    <h6 class="fw-semibold mb-3 d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:user-outline"></iconify-icon>
                                        Thông tin khách hàng
                                    </h6>
                                    <div class="row">
                                        <div class="col-12">
                                            <p class="mb-2"><strong>Họ tên:</strong> ${customer.fullName}</p>
                                            <p class="mb-0"><strong>Email:</strong> ${customer.email}</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- QR Generation Form -->
                                <form method="post" action="${pageContext.request.contextPath}/checkin/generate">
                                    <div class="mb-4">
                                        <label for="checkInType" class="form-label fw-semibold">
                                            <iconify-icon icon="solar:tag-outline" class="me-1"></iconify-icon>
                                            Loại check-in
                                        </label>
                                        <select class="form-select" id="checkInType" name="checkInType" required>
                                            <option value="">Chọn loại check-in</option>
                                            <option value="appointment">Có lịch hẹn</option>
                                            <option value="walk-in">Không có lịch hẹn</option>
                                        </select>
                                    </div>

                                    <div class="mb-4" id="appointmentSection" style="display: none;">
                                        <label for="appointmentId" class="form-label fw-semibold">
                                            <iconify-icon icon="solar:calendar-outline" class="me-1"></iconify-icon>
                                            Chọn lịch hẹn
                                        </label>
                                        <select class="form-select" id="appointmentId" name="appointmentId">
                                            <option value="">Chọn lịch hẹn</option>
                                            <c:forEach var="appointment" items="${appointments}">
                                                <option value="${appointment.appointmentId}">
                                                    ${appointment.serviceTitle} - 
                                                    <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-generate w-100">
                                        <iconify-icon icon="solar:qr-code-outline" class="me-2"></iconify-icon>
                                        Tạo QR Code
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- How to Use -->
                        <div class="card mt-4">
                            <div class="card-header bg-white border-bottom">
                                <h5 class="card-title mb-0 d-flex align-items-center gap-2">
                                    <iconify-icon icon="solar:info-circle-outline"></iconify-icon>
                                    Hướng dẫn sử dụng
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="step-indicator">
                                    <div class="step-number">1</div>
                                    <div class="step-text">Chọn loại check-in (có hẹn hoặc không hẹn)</div>
                                </div>
                                <div class="step-indicator">
                                    <div class="step-number">2</div>
                                    <div class="step-text">Nếu có hẹn, chọn lịch hẹn tương ứng</div>
                                </div>
                                <div class="step-indicator">
                                    <div class="step-number">3</div>
                                    <div class="step-text">Nhấn "Tạo QR Code" để tạo mã</div>
                                </div>
                                <div class="step-indicator">
                                    <div class="step-number">4</div>
                                    <div class="step-text">Lưu hoặc chụp ảnh QR code</div>
                                </div>
                                <div class="step-indicator">
                                    <div class="step-number">5</div>
                                    <div class="step-text">Đưa QR code cho nhân viên khi đến spa</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- QR Code Display -->
                    <div class="col-lg-6">
                        <c:choose>
                            <c:when test="${not empty qrCodeImage}">
                                <div class="qr-display-card">
                                    <iconify-icon icon="solar:qr-code-outline" class="text-6xl mb-3"></iconify-icon>
                                    <h5 class="mb-3">QR Code của bạn đã sẵn sàng!</h5>
                                    
                                    <div class="qr-code-container">
                                        <img src="data:image/png;base64,${qrCodeImage}" 
                                             alt="QR Code Check-in" 
                                             class="img-fluid" 
                                             style="max-width: 250px;">
                                    </div>
                                    
                                    <div class="d-flex gap-3 justify-content-center">
                                        <a href="data:image/png;base64,${qrCodeImage}" 
                                           download="checkin-qr-code.png" 
                                           class="download-btn">
                                            <iconify-icon icon="solar:download-outline"></iconify-icon>
                                            Tải xuống
                                        </a>
                                        <button type="button" 
                                                class="btn btn-outline-light" 
                                                onclick="printQRCode()">
                                            <iconify-icon icon="solar:printer-outline" class="me-1"></iconify-icon>
                                            In
                                        </button>
                                    </div>
                                    
                                    <div class="mt-4 p-3 bg-white bg-opacity-10 rounded">
                                        <h6 class="mb-2">
                                            <iconify-icon icon="solar:info-circle-outline" class="me-1"></iconify-icon>
                                            Thông tin check-in
                                        </h6>
                                        <p class="mb-1"><strong>Loại:</strong> 
                                            <c:choose>
                                                <c:when test="${checkIn.checkInType == 'appointment'}">Có lịch hẹn</c:when>
                                                <c:otherwise>Không có lịch hẹn</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="mb-1"><strong>Trạng thái:</strong> Chờ check-in</p>
                                        <p class="mb-0"><strong>Mã ID:</strong> #${checkIn.checkInId}</p>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
                                        <iconify-icon icon="solar:qr-code-outline" class="text-6xl text-gray-300 mb-3"></iconify-icon>
                                        <h5 class="text-gray-500 mb-2">QR Code sẽ hiển thị ở đây</h5>
                                        <p class="text-gray-400">Điền thông tin bên trái và nhấn "Tạo QR Code" để bắt đầu</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
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

    <script>
        // Show/hide appointment selection based on check-in type
        document.getElementById('checkInType').addEventListener('change', function() {
            const appointmentSection = document.getElementById('appointmentSection');
            const appointmentSelect = document.getElementById('appointmentId');
            
            if (this.value === 'appointment') {
                appointmentSection.style.display = 'block';
                appointmentSelect.required = true;
            } else {
                appointmentSection.style.display = 'none';
                appointmentSelect.required = false;
                appointmentSelect.value = '';
            }
        });

        // Print QR Code function
        function printQRCode() {
            const qrImage = document.querySelector('.qr-code-container img');
            if (qrImage) {
                const printWindow = window.open('', '_blank');
                printWindow.document.write(`
                    <html>
                        <head>
                            <title>QR Code Check-in</title>
                            <style>
                                body { 
                                    margin: 0; 
                                    padding: 20px; 
                                    text-align: center; 
                                    font-family: Arial, sans-serif;
                                }
                                .qr-container {
                                    border: 2px solid #ccc;
                                    padding: 20px;
                                    display: inline-block;
                                    border-radius: 10px;
                                }
                                img { max-width: 300px; }
                                h3 { margin-top: 15px; color: #333; }
                                p { color: #666; margin: 5px 0; }
                                @media print {
                                    .no-print { display: none; }
                                }
                            </style>
                        </head>
                        <body>
                            <div class="qr-container">
                                <img src="${qrImage.src}" alt="QR Code Check-in">
                                <h3>QR Code Check-in</h3>
                                <p>Khách hàng: ${customer.fullName}</p>
                                <p>Email: ${customer.email}</p>
                                <p>Loại: <c:choose><c:when test="${checkIn.checkInType == 'appointment'}">Có lịch hẹn</c:when><c:otherwise>Không có lịch hẹn</c:otherwise></c:choose></p>
                            </div>
                            <script>
                                window.onload = function() {
                                    window.print();
                                    window.onafterprint = function() {
                                        window.close();
                                    }
                                }
                            </script>
                        </body>
                    </html>
                `);
                printWindow.document.close();
            }
        }
    </script>
</body>
</html> 