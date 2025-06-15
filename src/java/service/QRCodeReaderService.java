package service;

import com.google.zxing.*;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.HybridBinarizer;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Service for reading and decoding QR codes from images
 */
public class QRCodeReaderService {

  /**
   * Read QR code from image bytes
   * 
   * @param imageBytes Image data as byte array
   * @return QR code data string, or null if not readable
   */
  public String readQRCodeFromImage(byte[] imageBytes) {
    try {
      // Convert byte array to BufferedImage
      BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(imageBytes));
      if (bufferedImage == null) {
        return null;
      }

      // Create luminance source from image
      LuminanceSource source = new BufferedImageLuminanceSource(bufferedImage);
      BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));

      // Set decode hints
      Map<DecodeHintType, Object> hints = new HashMap<>();
      hints.put(DecodeHintType.CHARACTER_SET, "UTF-8");
      hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
      hints.put(DecodeHintType.POSSIBLE_FORMATS, BarcodeFormat.QR_CODE);

      // Decode QR code
      MultiFormatReader reader = new MultiFormatReader();
      Result result = reader.decode(bitmap, hints);

      return result.getText();

    } catch (NotFoundException e) {
      // QR code not found in image
      System.out.println("QR code not found in image");
      return null;
    } catch (IOException e) {
      // Error reading image
      System.out.println("Error reading image: " + e.getMessage());
      return null;
    } catch (Exception e) {
      // Other decoding errors
      System.out.println("Error decoding QR code: " + e.getMessage());
      return null;
    }
  }

  /**
   * Read QR code from BufferedImage
   * 
   * @param bufferedImage Image as BufferedImage
   * @return QR code data string, or null if not readable
   */
  public String readQRCodeFromBufferedImage(BufferedImage bufferedImage) {
    try {
      if (bufferedImage == null) {
        return null;
      }

      // Create luminance source from image
      LuminanceSource source = new BufferedImageLuminanceSource(bufferedImage);
      BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));

      // Set decode hints
      Map<DecodeHintType, Object> hints = new HashMap<>();
      hints.put(DecodeHintType.CHARACTER_SET, "UTF-8");
      hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
      hints.put(DecodeHintType.POSSIBLE_FORMATS, BarcodeFormat.QR_CODE);

      // Decode QR code
      MultiFormatReader reader = new MultiFormatReader();
      Result result = reader.decode(bitmap, hints);

      return result.getText();

    } catch (NotFoundException e) {
      // QR code not found in image
      System.out.println("QR code not found in image");
      return null;
    } catch (Exception e) {
      // Other decoding errors
      System.out.println("Error decoding QR code: " + e.getMessage());
      return null;
    }
  }

  /**
   * Validate and extract customer information from QR data
   * 
   * @param qrData QR code data string
   * @return Map containing customer information, or null if invalid
   */
  public Map<String, Object> extractCustomerInfo(String qrData) {
    if (qrData == null || qrData.trim().isEmpty()) {
      return null;
    }

    try {
      Map<String, Object> customerInfo = new HashMap<>();

      // Extract customerId
      Integer customerId = extractIntValue(qrData, "customerId");
      if (customerId == null)
        return null;
      customerInfo.put("customerId", customerId);

      // Extract customerName
      String customerName = extractStringValue(qrData, "customerName");
      if (customerName == null)
        return null;
      customerInfo.put("customerName", customerName);

      // Extract customerEmail
      String customerEmail = extractStringValue(qrData, "customerEmail");
      if (customerEmail == null)
        return null;
      customerInfo.put("customerEmail", customerEmail);

      // Extract checkInType
      String checkInType = extractStringValue(qrData, "checkInType");
      if (checkInType == null)
        return null;
      customerInfo.put("checkInType", checkInType);

      // Extract appointmentId (optional)
      Integer appointmentId = extractIntValue(qrData, "appointmentId");
      customerInfo.put("appointmentId", appointmentId);

      // Extract timestamp
      Long timestamp = extractLongValue(qrData, "timestamp");
      customerInfo.put("timestamp", timestamp);

      // Validate spa identifier
      String spa = extractStringValue(qrData, "spa");
      if (!"SpaManagement".equals(spa)) {
        return null;
      }

      return customerInfo;

    } catch (Exception e) {
      System.out.println("Error extracting customer info: " + e.getMessage());
      return null;
    }
  }

  /**
   * Extract integer value from JSON-like string
   */
  private Integer extractIntValue(String jsonData, String key) {
    try {
      String pattern = "\"" + key + "\":";
      int startIndex = jsonData.indexOf(pattern);
      if (startIndex == -1)
        return null;

      startIndex += pattern.length();
      int endIndex = jsonData.indexOf(",", startIndex);
      if (endIndex == -1) {
        endIndex = jsonData.indexOf("}", startIndex);
      }

      if (endIndex != -1) {
        String valueStr = jsonData.substring(startIndex, endIndex).trim();
        return Integer.parseInt(valueStr);
      }
    } catch (Exception e) {
      // Ignore parsing errors
    }
    return null;
  }

  /**
   * Extract long value from JSON-like string
   */
  private Long extractLongValue(String jsonData, String key) {
    try {
      String pattern = "\"" + key + "\":";
      int startIndex = jsonData.indexOf(pattern);
      if (startIndex == -1)
        return null;

      startIndex += pattern.length();
      int endIndex = jsonData.indexOf(",", startIndex);
      if (endIndex == -1) {
        endIndex = jsonData.indexOf("}", startIndex);
      }

      if (endIndex != -1) {
        String valueStr = jsonData.substring(startIndex, endIndex).trim();
        return Long.parseLong(valueStr);
      }
    } catch (Exception e) {
      // Ignore parsing errors
    }
    return null;
  }

  /**
   * Extract string value from JSON-like string
   */
  private String extractStringValue(String jsonData, String key) {
    try {
      String pattern = "\"" + key + "\":\"";
      int startIndex = jsonData.indexOf(pattern);
      if (startIndex == -1)
        return null;

      startIndex += pattern.length();
      int endIndex = jsonData.indexOf("\"", startIndex);

      if (endIndex != -1) {
        return unescapeJson(jsonData.substring(startIndex, endIndex));
      }
    } catch (Exception e) {
      // Ignore parsing errors
    }
    return null;
  }

  /**
   * Unescape JSON string
   */
  private String unescapeJson(String input) {
    if (input == null)
      return null;
    return input.replace("\\\"", "\"")
        .replace("\\\\", "\\")
        .replace("\\n", "\n")
        .replace("\\r", "\r")
        .replace("\\t", "\t");
  }

  /**
   * Check if QR data is from the spa management system
   */
  public boolean isValidSpaQRCode(String qrData) {
    if (qrData == null || qrData.trim().isEmpty()) {
      return false;
    }

    return qrData.contains("\"spa\":\"SpaManagement\"") &&
        qrData.contains("\"customerId\":") &&
        qrData.contains("\"customerName\":") &&
        qrData.contains("\"customerEmail\":");
  }
}