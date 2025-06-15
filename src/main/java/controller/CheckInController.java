package controller;

import dao.CheckInDAO;
import dao.CustomerDAO;
import dao.AppointmentDAO;
import model.CheckIn;
import model.Customer;
import model.Appointment;
import service.QRCodeService;
import service.QRCodeReaderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * Controller for handling QR code check-in functionality
 */
@WebServlet(urlPatterns = { "/checkin/*" })
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB max file size
public class CheckInController extends HttpServlet {

  private CheckInDAO checkInDAO;
  private CustomerDAO customerDAO;
  private AppointmentDAO appointmentDAO;
  private QRCodeService qrCodeService;
  private QRCodeReaderService qrCodeReaderService;

  @Override
  public void init() throws ServletException {
    checkInDAO = new CheckInDAO();
    customerDAO = new CustomerDAO();
    appointmentDAO = new AppointmentDAO();
    qrCodeService = new QRCodeService();
    qrCodeReaderService = new QRCodeReaderService();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();
    HttpSession session = request.getSession();

    // Check authentication
    if (session.getAttribute("user") == null && session.getAttribute("customer") == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    if (pathInfo == null || pathInfo.equals("/")) {
      // Show check-in dashboard
      showCheckInDashboard(request, response);
    } else if (pathInfo.equals("/generate")) {
      // Show QR code generation page
      showQRCodeGeneration(request, response);
    } else if (pathInfo.equals("/scan")) {
      // Show QR code scanning page
      showQRCodeScanning(request, response);
    } else if (pathInfo.equals("/history")) {
      // Show check-in history
      showCheckInHistory(request, response);
    } else {
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();
    HttpSession session = request.getSession();

    // Check authentication
    if (session.getAttribute("user") == null && session.getAttribute("customer") == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    if (pathInfo.equals("/generate")) {
      // Generate QR code for check-in
      handleQRCodeGeneration(request, response);
    } else if (pathInfo.equals("/scan")) {
      // Process QR code scan
      handleQRCodeScan(request, response);
    } else if (pathInfo.equals("/confirm")) {
      // Confirm check-in
      handleCheckInConfirmation(request, response);
    } else {
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
  }

  /**
   * Show check-in dashboard
   */
  private void showCheckInDashboard(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    String userType = (String) session.getAttribute("userType");

    if ("customer".equals(userType)) {
      // Customer dashboard - show personal check-ins
      Customer customer = (Customer) session.getAttribute("customer");
      List<CheckIn> checkIns = checkInDAO.getCheckInsByCustomerId(customer.getCustomerId());
      request.setAttribute("checkIns", checkIns);
      request.setAttribute("customer", customer);
    } else {
      // Staff dashboard - show all pending check-ins
      List<CheckIn> pendingCheckIns = checkInDAO.getCheckInsByStatus("pending");
      request.setAttribute("pendingCheckIns", pendingCheckIns);
    }

    request.getRequestDispatcher("/WEB-INF/view/checkin/dashboard.jsp").forward(request, response);
  }

  /**
   * Show QR code generation page
   */
  private void showQRCodeGeneration(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    String userType = (String) session.getAttribute("userType");

    if ("customer".equals(userType)) {
      Customer customer = (Customer) session.getAttribute("customer");
      request.setAttribute("customer", customer);

      // Get customer's upcoming appointments
//      List<Appointment> appointments = appointmentDAO.getUpcomingAppointmentsByCustomerId(customer.getCustomerId());
//      request.setAttribute("appointments", appointments);
    }

    request.getRequestDispatcher("/WEB-INF/view/checkin/generate.jsp").forward(request, response);
  }

  /**
   * Show QR code scanning page
   */
  private void showQRCodeScanning(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    request.getRequestDispatcher("/WEB-INF/view/checkin/scan.jsp").forward(request, response);
  }

  /**
   * Show check-in history
   */
  private void showCheckInHistory(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    String userType = (String) session.getAttribute("userType");

    List<CheckIn> checkIns;
    if ("customer".equals(userType)) {
      Customer customer = (Customer) session.getAttribute("customer");
      checkIns = checkInDAO.getCheckInsByCustomerId(customer.getCustomerId());
    } else {
      // Staff can see all check-ins
      checkIns = checkInDAO.getAllCheckIns(0, 50); // Get recent 50 check-ins
    }

    request.setAttribute("checkIns", checkIns);
    request.getRequestDispatcher("/WEB-INF/view/checkin/history.jsp").forward(request, response);
  }

  /**
   * Handle QR code generation
   */
  private void handleQRCodeGeneration(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    Customer customer = (Customer) session.getAttribute("customer");

    if (customer == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    try {
      String checkInType = request.getParameter("checkInType");
      String appointmentIdStr = request.getParameter("appointmentId");

      Integer appointmentId = null;
      if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty() && !"walk-in".equals(checkInType)) {
        appointmentId = Integer.parseInt(appointmentIdStr);
      }

      // Generate QR code
      String qrCodeImage = qrCodeService.generateCheckInQRCode(
          customer.getCustomerId(),
          customer.getFullName(),
          customer.getEmail(),
          checkInType,
          appointmentId);

      if (qrCodeImage != null) {
        // Create check-in record
        String qrData = qrCodeService.generateQRDataString(
            customer.getCustomerId(),
            customer.getFullName(),
            customer.getEmail(),
            checkInType,
            appointmentId);

        CheckIn checkIn = new CheckIn(
            customer.getCustomerId(),
            customer.getFullName(),
            customer.getEmail(),
            qrData,
            checkInType,
            appointmentId);

        if (checkInDAO.createCheckIn(checkIn)) {
          request.setAttribute("qrCodeImage", qrCodeImage);
          request.setAttribute("checkIn", checkIn);
          request.setAttribute("success", "QR code đã được tạo thành công!");
        } else {
          request.setAttribute("error", "Không thể tạo bản ghi check-in!");
        }
      } else {
        request.setAttribute("error", "Không thể tạo mã QR code!");
      }

    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("error", "Có lỗi xảy ra khi tạo QR code!");
    }

    showQRCodeGeneration(request, response);
  }

  /**
   * Handle QR code scan
   */
  private void handleQRCodeScan(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    try {
      Part filePart = request.getPart("qrImage");
      if (filePart == null || filePart.getSize() == 0) {
        request.setAttribute("error", "Vui lòng chọn file ảnh QR code!");
        showQRCodeScanning(request, response);
        return;
      }

      // Read uploaded image
      byte[] imageBytes = new byte[(int) filePart.getSize()];
      try (InputStream inputStream = filePart.getInputStream()) {
        inputStream.read(imageBytes);
      }

      // Decode QR code
      String qrData = qrCodeReaderService.readQRCodeFromImage(imageBytes);
      if (qrData == null) {
        request.setAttribute("error", "Không thể đọc QR code từ ảnh này!");
        showQRCodeScanning(request, response);
        return;
      }

      // Validate QR code
      if (!qrCodeReaderService.isValidSpaQRCode(qrData)) {
        request.setAttribute("error", "QR code không hợp lệ cho hệ thống spa!");
        showQRCodeScanning(request, response);
        return;
      }

      // Extract customer information
      Map<String, Object> customerInfo = qrCodeReaderService.extractCustomerInfo(qrData);
      if (customerInfo == null) {
        request.setAttribute("error", "Không thể trích xuất thông tin khách hàng từ QR code!");
        showQRCodeScanning(request, response);
        return;
      }

      // Find existing check-in record
      CheckIn checkIn = checkInDAO.findByQrCode(qrData);
      if (checkIn == null) {
        request.setAttribute("error", "Không tìm thấy bản ghi check-in cho QR code này!");
        showQRCodeScanning(request, response);
        return;
      }

      // Check if already checked in
      if ("confirmed".equals(checkIn.getStatus())) {
        request.setAttribute("warning", "Khách hàng đã check-in trước đó!");
      }

      request.setAttribute("checkIn", checkIn);
      request.setAttribute("customerInfo", customerInfo);
      request.setAttribute("qrData", qrData);

    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("error", "Có lỗi xảy ra khi xử lý QR code!");
    }

    showQRCodeScanning(request, response);
  }

  /**
   * Handle check-in confirmation
   */
  private void handleCheckInConfirmation(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    try {
      String qrData = request.getParameter("qrData");
      String notes = request.getParameter("notes");

      if (qrData == null || qrData.trim().isEmpty()) {
        request.setAttribute("error", "Dữ liệu QR code không hợp lệ!");
        showQRCodeScanning(request, response);
        return;
      }

      // Find check-in record
      CheckIn checkIn = checkInDAO.findByQrCode(qrData);
      if (checkIn == null) {
        request.setAttribute("error", "Không tìm thấy bản ghi check-in!");
        showQRCodeScanning(request, response);
        return;
      }

      // Update check-in
      checkIn.setCheckInTime(LocalDateTime.now());
      checkIn.setStatus("confirmed");
      checkIn.setNotes(notes);

      if (checkInDAO.updateCheckIn(checkIn)) {
        request.setAttribute("success", "Check-in thành công cho " + checkIn.getCustomerName() + "!");
      } else {
        request.setAttribute("error", "Không thể cập nhật trạng thái check-in!");
      }

    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("error", "Có lỗi xảy ra khi xác nhận check-in!");
    }

    showCheckInDashboard(request, response);
  }
}