/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.email.qr;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;

public class QRCodeService {
    
    private static final int QR_CODE_SIZE = 300;
    
    /**
     * Generate QR code for customer check-in
     */
    public static byte[] generateCustomerCheckInQR(Long customerId, Long appointmentId) 
            throws WriterException, IOException {
        
        String checkInData = String.format(
            "{\"type\":\"checkin\",\"customerId\":%d,\"appointmentId\":%s,\"timestamp\":%d}",
            customerId, 
            appointmentId != null ? appointmentId.toString() : "null",
            System.currentTimeMillis()
        );
        
        return generateQRCodeImage(checkInData);
    }
    
    /**
     * Generate QR code for appointment confirmation
     */
    public static byte[] generateAppointmentQR(Long appointmentId, String customerEmail) 
            throws WriterException, IOException {
        
        String appointmentData = String.format(
            "{\"type\":\"appointment\",\"appointmentId\":%d,\"email\":\"%s\",\"timestamp\":%d}",
            appointmentId, customerEmail, System.currentTimeMillis()
        );
        
        return generateQRCodeImage(appointmentData);
    }
    
    private static byte[] generateQRCodeImage(String text) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, QR_CODE_SIZE, QR_CODE_SIZE);
        
        BufferedImage bufferedImage = new BufferedImage(QR_CODE_SIZE, QR_CODE_SIZE, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = bufferedImage.createGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, QR_CODE_SIZE, QR_CODE_SIZE);
        graphics.setColor(Color.BLACK);
        
        for (int x = 0; x < QR_CODE_SIZE; x++) {
            for (int y = 0; y < QR_CODE_SIZE; y++) {
                if (bitMatrix.get(x, y)) {
                    graphics.fillRect(x, y, 1, 1);
                }
            }
        }
        graphics.dispose();
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(bufferedImage, "PNG", baos);
        return baos.toByteArray();
    }
}