package model;

import java.time.LocalDateTime;

/**
 * Model class representing a customer check-in
 */
public class CheckIn {
  private int checkInId;
  private int customerId;
  private String customerName;
  private String customerEmail;
  private LocalDateTime checkInTime;
  private String qrCode;
  private String checkInType; // "appointment" or "walk-in"
  private Integer appointmentId; // null for walk-in
  private String status; // "pending", "confirmed", "cancelled"
  private String notes;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  // Default constructor
  public CheckIn() {
  }

  // Constructor for new check-in
  public CheckIn(int customerId, String customerName, String customerEmail,
      String qrCode, String checkInType, Integer appointmentId) {
    this.customerId = customerId;
    this.customerName = customerName;
    this.customerEmail = customerEmail;
    this.qrCode = qrCode;
    this.checkInType = checkInType;
    this.appointmentId = appointmentId;
    this.status = "pending";
    this.createdAt = LocalDateTime.now();
    this.updatedAt = LocalDateTime.now();
  }

  // Getters and Setters
  public int getCheckInId() {
    return checkInId;
  }

  public void setCheckInId(int checkInId) {
    this.checkInId = checkInId;
  }

  public int getCustomerId() {
    return customerId;
  }

  public void setCustomerId(int customerId) {
    this.customerId = customerId;
  }

  public String getCustomerName() {
    return customerName;
  }

  public void setCustomerName(String customerName) {
    this.customerName = customerName;
  }

  public String getCustomerEmail() {
    return customerEmail;
  }

  public void setCustomerEmail(String customerEmail) {
    this.customerEmail = customerEmail;
  }

  public LocalDateTime getCheckInTime() {
    return checkInTime;
  }

  public void setCheckInTime(LocalDateTime checkInTime) {
    this.checkInTime = checkInTime;
  }

  public String getQrCode() {
    return qrCode;
  }

  public void setQrCode(String qrCode) {
    this.qrCode = qrCode;
  }

  public String getCheckInType() {
    return checkInType;
  }

  public void setCheckInType(String checkInType) {
    this.checkInType = checkInType;
  }

  public Integer getAppointmentId() {
    return appointmentId;
  }

  public void setAppointmentId(Integer appointmentId) {
    this.appointmentId = appointmentId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  @Override
  public String toString() {
    return "CheckIn{" +
        "checkInId=" + checkInId +
        ", customerId=" + customerId +
        ", customerName='" + customerName + '\'' +
        ", customerEmail='" + customerEmail + '\'' +
        ", checkInTime=" + checkInTime +
        ", qrCode='" + qrCode + '\'' +
        ", checkInType='" + checkInType + '\'' +
        ", appointmentId=" + appointmentId +
        ", status='" + status + '\'' +
        ", notes='" + notes + '\'' +
        ", createdAt=" + createdAt +
        ", updatedAt=" + updatedAt +
        '}';
  }
}