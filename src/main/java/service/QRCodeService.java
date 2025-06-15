package service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * Service for generating QR codes for customer check-ins
 */
public class QRCodeService {

  private static final int QR_CODE_SIZE = 300;
  private static final String QR_CODE_FORMAT = "PNG";

  /**
   * Generate QR code for customer check-in
   * 
   * @param customerId    Customer ID
   * @param customerName  Customer name
   * @param customerEmail Customer email
   * @param checkInType   Type of check-in (appointment/walk-in)
   * @param appointmentId Appointment ID (null for walk-in)
   * @return Base64 encoded QR code image
   */
  public String generateCheckInQRCode(int customerId, String customerName, String customerEmail,
      String checkInType, Integer appointmentId) {
    try {
      // Create JSON data for QR code
      String qrData = createQRData(customerId, customerName, customerEmail, checkInType, appointmentId);

      // Generate QR code
      return generateQRCodeImage(qrData);

    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  /**
   * Create JSON data string for QR code
   */
  private String createQRData(int customerId, String customerName, String customerEmail,
      String checkInType, Integer appointmentId) {
    StringBuilder jsonBuilder = new StringBuilder();
    jsonBuilder.append("{");
    jsonBuilder.append("\"customerId\":").append(customerId).append(",");
    jsonBuilder.append("\"customerName\":\"").append(escapeJson(customerName)).append("\",");
    jsonBuilder.append("\"customerEmail\":\"").append(escapeJson(customerEmail)).append("\",");
    jsonBuilder.append("\"checkInType\":\"").append(checkInType).append("\",");
    jsonBuilder.append("\"timestamp\":").append(System.currentTimeMillis()).append(",");

    if (appointmentId != null) {
      jsonBuilder.append("\"appointmentId\":").append(appointmentId).append(",");
    }

    jsonBuilder.append("\"spa\":\"SpaManagement\"");
    jsonBuilder.append("}");

    return jsonBuilder.toString();
  }

  /**
   * Escape special characters for JSON
   */
  private String escapeJson(String input) {
    if (input == null)
      return "";
    return input.replace("\\", "\\\\")
        .replace("\"", "\\\"")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t");
  }

  /**
   * Generate QR code image from data string
   */
  private String generateQRCodeImage(String data) throws WriterException, IOException {
    // Set QR code parameters
    Map<EncodeHintType, Object> hints = new HashMap<>();
    hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
    hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
    hints.put(EncodeHintType.MARGIN, 1);

    // Generate QR code matrix
    QRCodeWriter qrCodeWriter = new QRCodeWriter();
    BitMatrix bitMatrix = qrCodeWriter.encode(data, BarcodeFormat.QR_CODE, QR_CODE_SIZE, QR_CODE_SIZE, hints);

    // Create BufferedImage
    BufferedImage qrImage = new BufferedImage(QR_CODE_SIZE, QR_CODE_SIZE, BufferedImage.TYPE_INT_RGB);
    Graphics2D graphics = qrImage.createGraphics();

    // Set white background
    graphics.setColor(Color.WHITE);
    graphics.fillRect(0, 0, QR_CODE_SIZE, QR_CODE_SIZE);

    // Draw QR code
    graphics.setColor(Color.BLACK);
    for (int x = 0; x < QR_CODE_SIZE; x++) {
      for (int y = 0; y < QR_CODE_SIZE; y++) {
        if (bitMatrix.get(x, y)) {
          graphics.fillRect(x, y, 1, 1);
        }
      }
    }
    graphics.dispose();

    // Convert to Base64
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    ImageIO.write(qrImage, QR_CODE_FORMAT, outputStream);
    byte[] imageBytes = outputStream.toByteArray();

    return Base64.getEncoder().encodeToString(imageBytes);
  }

  /**
   * Generate QR data string for validation (without generating image)
   * This is used to store in database for later validation
   */
  public String generateQRDataString(int customerId, String customerName, String customerEmail,
      String checkInType, Integer appointmentId) {
    return createQRData(customerId, customerName, customerEmail, checkInType, appointmentId);
  }

  /**
   * Extract customer ID from QR data string
   */
  public Integer extractCustomerIdFromQRData(String qrData) {
    try {
      // Simple JSON parsing for customerId
      String customerIdPattern = "\"customerId\":";
      int startIndex = qrData.indexOf(customerIdPattern);
      if (startIndex == -1)
        return null;

      startIndex += customerIdPattern.length();
      int endIndex = qrData.indexOf(",", startIndex);
      if (endIndex == -1) {
        endIndex = qrData.indexOf("}", startIndex);
      }

      if (endIndex != -1) {
        String customerIdStr = qrData.substring(startIndex, endIndex).trim();
        return Integer.parseInt(customerIdStr);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  /**
   * Validate QR data format
   */
  public boolean isValidQRData(String qrData) {
    if (qrData == null || qrData.trim().isEmpty()) {
      return false;
    }

    // Check if it contains required fields
    return qrData.contains("\"customerId\":") &&
        qrData.contains("\"customerName\":") &&
        qrData.contains("\"customerEmail\":") &&
        qrData.contains("\"checkInType\":") &&
        qrData.contains("\"spa\":\"SpaManagement\"");
  }
}