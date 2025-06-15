package controller;

import dao.CheckInDAO;
import model.CheckIn;
import service.QRCodeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Test controller for QR code generation
 */
@WebServlet(urlPatterns = { "/test-qr-generate" })
public class TestQRController extends HttpServlet {

  private QRCodeService qrCodeService;
  private CheckInDAO checkInDAO;

  @Override
  public void init() throws ServletException {
    qrCodeService = new QRCodeService();
    checkInDAO = new CheckInDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Forward to test page
    request.getRequestDispatcher("/test-qr-generation.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    try {
      // Get form parameters
      String customerIdStr = request.getParameter("customerId");
      String customerName = request.getParameter("customerName");
      String customerEmail = request.getParameter("customerEmail");
      String checkInType = request.getParameter("checkInType");
      String appointmentIdStr = request.getParameter("appointmentId");

      // Validate required fields
      if (customerIdStr == null || customerIdStr.trim().isEmpty() ||
          customerName == null || customerName.trim().isEmpty() ||
          customerEmail == null || customerEmail.trim().isEmpty() ||
          checkInType == null || checkInType.trim().isEmpty()) {

        request.setAttribute("error", "Please fill in all required fields!");
        request.getRequestDispatcher("/test-qr-generation.jsp").forward(request, response);
        return;
      }

      int customerId = Integer.parseInt(customerIdStr);
      Integer appointmentId = null;

      // Parse appointment ID if provided
      if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
        try {
          appointmentId = Integer.parseInt(appointmentIdStr);
        } catch (NumberFormatException e) {
          request.setAttribute("error", "Invalid appointment ID format!");
          request.getRequestDispatcher("/test-qr-generation.jsp").forward(request, response);
          return;
        }
      }

      // Generate QR code
      String qrCodeImage = qrCodeService.generateCheckInQRCode(
          customerId, customerName, customerEmail, checkInType, appointmentId);

      if (qrCodeImage != null) {
        // Generate QR data string for database storage
        String qrData = qrCodeService.generateQRDataString(
            customerId, customerName, customerEmail, checkInType, appointmentId);

        // Create check-in record in database
        CheckIn checkIn = new CheckIn(
            customerId, customerName, customerEmail, qrData, checkInType, appointmentId);

        boolean created = checkInDAO.createCheckIn(checkIn);

        if (created) {
          // Set attributes for JSP display
          request.setAttribute("qrCodeImage", qrCodeImage);
          request.setAttribute("qrData", qrData);
          request.setAttribute("checkIn", checkIn);
          request.setAttribute("success", "QR Code generated successfully! Check-in ID: " + checkIn.getCheckInId());

          // Log the creation for debugging
          System.out.println("Created check-in record:");
          System.out.println("- ID: " + checkIn.getCheckInId());
          System.out.println("- Customer: " + customerName + " (" + customerEmail + ")");
          System.out.println("- Type: " + checkInType);
          System.out.println("- Appointment ID: " + appointmentId);
          System.out.println("- Status: " + checkIn.getStatus());
          System.out.println("- QR Data Length: " + qrData.length() + " characters");
        } else {
          request.setAttribute("error", "Failed to create check-in record in database!");
        }
      } else {
        request.setAttribute("error", "Failed to generate QR code!");
      }

    } catch (NumberFormatException e) {
      request.setAttribute("error", "Invalid customer ID format!");
    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("error", "An error occurred: " + e.getMessage());
    }

    // Forward back to the test page
    request.getRequestDispatcher("/test-qr-generation.jsp").forward(request, response);
  }
}