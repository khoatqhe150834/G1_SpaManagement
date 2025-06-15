<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test QR Code Generation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.iconify.design/3/3.1.1/iconify.min.js"></script>
    <style>
        .qr-container {
            text-align: center;
            padding: 2rem;
            background: #f8f9fa;
            border-radius: 8px;
            margin: 1rem 0;
        }
        .qr-image {
            max-width: 300px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            background: white;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <iconify-icon icon="solar:qr-code-outline" class="me-2"></iconify-icon>
                            Test QR Code Generation
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- QR Generation Form -->
                        <form method="post" action="<%= request.getContextPath() %>/test-qr-generate">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="customerId" class="form-label">Customer ID</label>
                                        <input type="number" class="form-control" id="customerId" name="customerId" 
                                               value="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="customerName" class="form-label">Customer Name</label>
                                        <input type="text" class="form-control" id="customerName" name="customerName" 
                                               value="Nguyen Van Test" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="customerEmail" class="form-label">Customer Email</label>
                                        <input type="email" class="form-control" id="customerEmail" name="customerEmail" 
                                               value="test@example.com" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="checkInType" class="form-label">Check-in Type</label>
                                        <select class="form-select" id="checkInType" name="checkInType" required>
                                            <option value="appointment">With Appointment</option>
                                            <option value="walk-in">Walk-in</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="appointmentId" class="form-label">Appointment ID (optional)</label>
                                <input type="number" class="form-control" id="appointmentId" name="appointmentId" 
                                       placeholder="Leave empty for walk-in">
                            </div>
                            
                            <button type="submit" class="btn btn-primary">
                                <iconify-icon icon="solar:qr-code-outline" class="me-1"></iconify-icon>
                                Generate QR Code
                            </button>
                        </form>
                        
                        <!-- QR Code Display -->
                        <c:if test="${not empty qrCodeImage}">
                            <div class="qr-container mt-4">
                                <h5>Generated QR Code:</h5>
                                <div class="mt-3">
                                    <img src="data:image/png;base64,${qrCodeImage}" 
                                         alt="QR Code" class="qr-image">
                                </div>
                                <div class="mt-3">
                                    <p class="text-muted">QR Data: ${qrData}</p>
                                    <a href="data:image/png;base64,${qrCodeImage}" 
                                       download="test-qr-code.png" 
                                       class="btn btn-success me-2">
                                        <iconify-icon icon="solar:download-outline" class="me-1"></iconify-icon>
                                        Download QR Code
                                    </a>
                                    <button type="button" class="btn btn-info" onclick="copyQRData()">
                                        <iconify-icon icon="solar:copy-outline" class="me-1"></iconify-icon>
                                        Copy QR Data
                                    </button>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Error Display -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-3">
                                <iconify-icon icon="solar:danger-outline" class="me-1"></iconify-icon>
                                ${error}
                            </div>
                        </c:if>
                        
                        <!-- Success Display -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success mt-3">
                                <iconify-icon icon="solar:check-circle-outline" class="me-1"></iconify-icon>
                                ${success}
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Instructions -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <iconify-icon icon="solar:info-circle-outline" class="me-2"></iconify-icon>
                            How QR Code Scanning Works
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>1. QR Code Generation</h6>
                                <ul>
                                    <li>Customer creates QR code with their info</li>
                                    <li>QR contains JSON data with customer details</li>
                                    <li>Check-in record is created in database with status "pending"</li>
                                </ul>
                                
                                <h6>2. QR Code Scanning</h6>
                                <ul>
                                    <li>Staff uploads QR code image to scan page</li>
                                    <li>Backend decodes QR and extracts customer info</li>
                                    <li>System finds matching check-in record</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6>3. Status Update Process</h6>
                                <ul>
                                    <li>Staff reviews customer information</li>
                                    <li>Staff clicks "Confirm Check-in" button</li>
                                    <li>Backend updates check-in status to "confirmed"</li>
                                    <li>Check-in time is recorded</li>
                                </ul>
                                
                                <h6>4. Testing Links</h6>
                                <div class="d-grid gap-2">
                                    <a href="<%= request.getContextPath() %>/checkin/scan" class="btn btn-outline-primary btn-sm">
                                        Test QR Scanning Page
                                    </a>
                                    <a href="<%= request.getContextPath() %>/checkin/dashboard" class="btn btn-outline-secondary btn-sm">
                                        Check-in Dashboard
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function copyQRData() {
            const qrData = '<c:out value="${qrData}" escapeXml="false"/>';
            if (qrData) {
                navigator.clipboard.writeText(qrData).then(function() {
                    alert('QR data copied to clipboard!');
                });
            }
        }
        
        // Show/hide appointment ID based on check-in type
        document.getElementById('checkInType').addEventListener('change', function() {
            const appointmentField = document.getElementById('appointmentId');
            if (this.value === 'walk-in') {
                appointmentField.value = '';
                appointmentField.disabled = true;
            } else {
                appointmentField.disabled = false;
            }
        });
    </script>
</body>
</html> 