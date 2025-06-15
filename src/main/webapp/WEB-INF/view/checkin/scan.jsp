<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quét QR Code Check-in - Spa Management</title>
    
    <!-- Import stylesheets -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <style>
        .scan-card {
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #E5E7EB;
        }
        
        .upload-area {
            border: 2px dashed #D1D5DB;
            border-radius: 12px;
            padding: 3rem 2rem;
            text-align: center;
            transition: all 0.3s ease;
            background: #F9FAFB;
        }
        
        .upload-area.dragover {
            border-color: #3B82F6;
            background: #EFF6FF;
        }
        
        .upload-area:hover {
            border-color: #6B7280;
            background: #F3F4F6;
        }
        
        .file-input {
            display: none;
        }
        
        .upload-btn {
            background: linear-gradient(135deg, #3B82F6 0%, #1E40AF 100%);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 2rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .upload-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(59, 130, 246, 0.3);
            color: white;
        }
        
        .customer-info-card {
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            color: white;
            border-radius: 12px;
            padding: 1.5rem;
        }
        
        .confirm-btn {
            background: linear-gradient(135deg, #EF4444 0%, #DC2626 100%);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 2rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .confirm-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(239, 68, 68, 0.3);
            color: white;
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
        
        .preview-image {
            max-width: 300px;
            max-height: 300px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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
                                    <iconify-icon icon="solar:camera-outline" class="me-2"></iconify-icon>
                                    Quét QR Code Check-in
                                </h4>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Dashboard</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/checkin">Check-in</a></li>
                                        <li class="breadcrumb-item active">Quét QR Code</li>
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
                    <!-- QR Code Scanner -->
                    <div class="col-lg-6">
                        <div class="card scan-card">
                            <div class="card-header bg-white border-bottom">
                                <h5 class="card-title mb-0 d-flex align-items-center gap-2">
                                    <iconify-icon icon="solar:upload-outline"></iconify-icon>
                                    Tải lên ảnh QR Code
                                </h5>
                            </div>
                            <div class="card-body">
                                <!-- Upload Form -->
                                <form method="post" action="${pageContext.request.contextPath}/checkin/scan" 
                                      enctype="multipart/form-data" id="scanForm">
                                    <div class="upload-area" id="uploadArea">
                                        <iconify-icon icon="solar:cloud-upload-outline" class="text-6xl text-gray-400 mb-3"></iconify-icon>
                                        <h6 class="text-gray-600 mb-2">Kéo thả ảnh QR code vào đây</h6>
                                        <p class="text-gray-500 mb-3">hoặc</p>
                                        <button type="button" class="upload-btn" onclick="document.getElementById('qrImage').click()">
                                            <iconify-icon icon="solar:gallery-outline" class="me-1"></iconify-icon>
                                            Chọn ảnh từ máy tính
                                        </button>
                                        <input type="file" 
                                               class="file-input" 
                                               id="qrImage" 
                                               name="qrImage" 
                                               accept="image/*" 
                                               required>
                                        <p class="text-xs text-gray-400 mt-3">
                                            Hỗ trợ: JPG, PNG, GIF (tối đa 10MB)
                                        </p>
                                    </div>
                                    
                                    <!-- Image Preview -->
                                    <div id="imagePreview" class="text-center mt-3" style="display: none;">
                                        <h6 class="mb-2">Ảnh đã chọn:</h6>
                                        <img id="previewImg" class="preview-image" alt="Preview">
                                        <div class="mt-3">
                                            <button type="submit" class="btn btn-success me-2">
                                                <iconify-icon icon="solar:eye-outline" class="me-1"></iconify-icon>
                                                Quét QR Code
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary" onclick="resetUpload()">
                                                <iconify-icon icon="solar:refresh-outline" class="me-1"></iconify-icon>
                                                Chọn lại
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Instructions -->
                        <div class="card mt-4">
                            <div class="card-header bg-white border-bottom">
                                <h5 class="card-title mb-0 d-flex align-items-center gap-2">
                                    <iconify-icon icon="solar:info-circle-outline"></iconify-icon>
                                    Hướng dẫn sử dụng
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex align-items-start gap-3 mb-3">
                                    <div class="flex-shrink-0">
                                        <div class="w-8 h-8 bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <span class="text-primary-600 fw-bold text-sm">1</span>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Nhận QR code từ khách hàng</h6>
                                        <p class="text-gray-600 mb-0 text-sm">Khách hàng có thể hiển thị QR code trên điện thoại hoặc giấy in</p>
                                    </div>
                                </div>
                                <div class="d-flex align-items-start gap-3 mb-3">
                                    <div class="flex-shrink-0">
                                        <div class="w-8 h-8 bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <span class="text-primary-600 fw-bold text-sm">2</span>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Chụp ảnh hoặc tải lên</h6>
                                        <p class="text-gray-600 mb-0 text-sm">Chụp ảnh QR code hoặc tải lên file ảnh có sẵn</p>
                                    </div>
                                </div>
                                <div class="d-flex align-items-start gap-3 mb-3">
                                    <div class="flex-shrink-0">
                                        <div class="w-8 h-8 bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <span class="text-primary-600 fw-bold text-sm">3</span>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Xác minh thông tin</h6>
                                        <p class="text-gray-600 mb-0 text-sm">Kiểm tra thông tin khách hàng hiển thị</p>
                                    </div>
                                </div>
                                <div class="d-flex align-items-start gap-3">
                                    <div class="flex-shrink-0">
                                        <div class="w-8 h-8 bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                            <span class="text-primary-600 fw-bold text-sm">4</span>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Xác nhận check-in</h6>
                                        <p class="text-gray-600 mb-0 text-sm">Nhấn "Xác nhận check-in" để hoàn tất</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Scan Results -->
                    <div class="col-lg-6">
                        <c:choose>
                            <c:when test="${not empty checkIn}">
                                <!-- Customer Information Display -->
                                <div class="customer-info-card">
                                    <div class="d-flex align-items-center gap-3 mb-3">
                                        <iconify-icon icon="solar:user-check-outline" class="text-4xl"></iconify-icon>
                                        <div>
                                            <h5 class="mb-1">Thông tin khách hàng</h5>
                                            <p class="mb-0 opacity-75">Quét QR code thành công</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p class="mb-2"><strong>Họ tên:</strong><br>${checkIn.customerName}</p>
                                            <p class="mb-2"><strong>Email:</strong><br>${checkIn.customerEmail}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="mb-2"><strong>Loại check-in:</strong><br>
                                                <c:choose>
                                                    <c:when test="${checkIn.checkInType == 'appointment'}">Có lịch hẹn</c:when>
                                                    <c:otherwise>Không có lịch hẹn</c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p class="mb-2"><strong>Trạng thái:</strong><br>
                                                <c:choose>
                                                    <c:when test="${checkIn.status == 'pending'}">
                                                        <span class="status-badge status-pending">Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${checkIn.status == 'confirmed'}">
                                                        <span class="status-badge status-confirmed">Đã xác nhận</span>
                                                    </c:when>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty checkIn.appointmentId}">
                                        <p class="mb-2"><strong>Mã lịch hẹn:</strong> #${checkIn.appointmentId}</p>
                                    </c:if>
                                    
                                    <p class="mb-0"><strong>Ngày tạo QR:</strong> 
                                        <fmt:formatDate value="${checkIn.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </div>

                                <!-- Check-in Confirmation -->
                                <c:if test="${checkIn.status == 'pending'}">
                                    <div class="card mt-4">
                                        <div class="card-header bg-white border-bottom">
                                            <h5 class="card-title mb-0 d-flex align-items-center gap-2">
                                                <iconify-icon icon="solar:check-circle-outline"></iconify-icon>
                                                Xác nhận check-in
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <form method="post" action="${pageContext.request.contextPath}/checkin/confirm">
                                                <input type="hidden" name="qrData" value="${qrData}">
                                                
                                                <div class="mb-3">
                                                    <label for="notes" class="form-label">Ghi chú (tùy chọn)</label>
                                                    <textarea class="form-control" 
                                                              id="notes" 
                                                              name="notes" 
                                                              rows="3" 
                                                              placeholder="Nhập ghi chú về check-in này..."></textarea>
                                                </div>
                                                
                                                <button type="submit" class="confirm-btn w-100">
                                                    <iconify-icon icon="solar:check-circle-outline" class="me-2"></iconify-icon>
                                                    Xác nhận check-in
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${checkIn.status == 'confirmed'}">
                                    <div class="alert alert-info mt-4">
                                        <iconify-icon icon="solar:info-circle-outline" class="me-2"></iconify-icon>
                                        Khách hàng này đã check-in trước đó vào lúc: 
                                        <strong>
                                            <fmt:formatDate value="${checkIn.checkInTime}" pattern="dd/MM/yyyy HH:mm" />
                                        </strong>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <!-- Empty State -->
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
                                        <iconify-icon icon="solar:camera-outline" class="text-6xl text-gray-300 mb-3"></iconify-icon>
                                        <h5 class="text-gray-500 mb-2">Chưa có QR code nào được quét</h5>
                                        <p class="text-gray-400">Tải lên ảnh QR code để xem thông tin khách hàng</p>
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

    <!-- Success/Error/Warning Messages -->
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

    <c:if test="${not empty warning}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                Swal.fire({
                    title: 'Cảnh báo!',
                    text: '${warning}',
                    icon: 'warning',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#f39c12'
                });
            });
        </script>
    </c:if>

    <script>
        // File upload handling
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('qrImage');
        const imagePreview = document.getElementById('imagePreview');
        const previewImg = document.getElementById('previewImg');

        // Drag and drop events
        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                handleFileSelect(files[0]);
            }
        });

        // File input change event
        fileInput.addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                handleFileSelect(e.target.files[0]);
            }
        });

        // Handle file selection
        function handleFileSelect(file) {
            if (file && file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    imagePreview.style.display = 'block';
                    uploadArea.style.display = 'none';
                };
                reader.readAsDataURL(file);
            } else {
                alert('Vui lòng chọn file ảnh hợp lệ!');
            }
        }

        // Reset upload
        function resetUpload() {
            fileInput.value = '';
            imagePreview.style.display = 'none';
            uploadArea.style.display = 'block';
        }
    </script>
</body>
</html> 