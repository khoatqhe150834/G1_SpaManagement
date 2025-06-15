package dao;

import db.DBContext;
import model.CheckIn;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for CheckIn operations
 */
public class CheckInDAO {

  /**
   * Create a new check-in record
   */
  public boolean createCheckIn(CheckIn checkIn) {
    String sql = "INSERT INTO checkins (customer_id, customer_name, customer_email, " +
        "qr_code, checkin_type, appointment_id, status, notes, created_at, updated_at) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

      stmt.setInt(1, checkIn.getCustomerId());
      stmt.setString(2, checkIn.getCustomerName());
      stmt.setString(3, checkIn.getCustomerEmail());
      stmt.setString(4, checkIn.getQrCode());
      stmt.setString(5, checkIn.getCheckInType());

      if (checkIn.getAppointmentId() != null) {
        stmt.setInt(6, checkIn.getAppointmentId());
      } else {
        stmt.setNull(6, Types.INTEGER);
      }

      stmt.setString(7, checkIn.getStatus());
      stmt.setString(8, checkIn.getNotes());
      stmt.setTimestamp(9, Timestamp.valueOf(checkIn.getCreatedAt()));
      stmt.setTimestamp(10, Timestamp.valueOf(checkIn.getUpdatedAt()));

      int affectedRows = stmt.executeUpdate();

      if (affectedRows > 0) {
        try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
          if (generatedKeys.next()) {
            checkIn.setCheckInId(generatedKeys.getInt(1));
          }
        }
        return true;
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return false;
  }

  /**
   * Find check-in by QR code
   */
  public CheckIn findByQrCode(String qrCode) {
    String sql = "SELECT * FROM checkins WHERE qr_code = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setString(1, qrCode);

      try (ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
          return mapResultSetToCheckIn(rs);
        }
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return null;
  }

  /**
   * Update check-in status and time
   */
  public boolean updateCheckIn(CheckIn checkIn) {
    String sql = "UPDATE checkins SET checkin_time = ?, status = ?, notes = ?, updated_at = ? " +
        "WHERE checkin_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      if (checkIn.getCheckInTime() != null) {
        stmt.setTimestamp(1, Timestamp.valueOf(checkIn.getCheckInTime()));
      } else {
        stmt.setNull(1, Types.TIMESTAMP);
      }

      stmt.setString(2, checkIn.getStatus());
      stmt.setString(3, checkIn.getNotes());
      stmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
      stmt.setInt(5, checkIn.getCheckInId());

      return stmt.executeUpdate() > 0;

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return false;
  }

  /**
   * Get all check-ins for a customer
   */
  public List<CheckIn> getCheckInsByCustomerId(int customerId) {
    List<CheckIn> checkIns = new ArrayList<>();
    String sql = "SELECT * FROM checkins WHERE customer_id = ? ORDER BY created_at DESC";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, customerId);

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          checkIns.add(mapResultSetToCheckIn(rs));
        }
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return checkIns;
  }

  /**
   * Get all check-ins with pagination
   */
  public List<CheckIn> getAllCheckIns(int offset, int limit) {
    List<CheckIn> checkIns = new ArrayList<>();
    String sql = "SELECT * FROM checkins ORDER BY created_at DESC LIMIT ? OFFSET ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, limit);
      stmt.setInt(2, offset);

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          checkIns.add(mapResultSetToCheckIn(rs));
        }
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return checkIns;
  }

  /**
   * Get check-ins by status
   */
  public List<CheckIn> getCheckInsByStatus(String status) {
    List<CheckIn> checkIns = new ArrayList<>();
    String sql = "SELECT * FROM checkins WHERE status = ? ORDER BY created_at DESC";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setString(1, status);

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          checkIns.add(mapResultSetToCheckIn(rs));
        }
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return checkIns;
  }

  /**
   * Delete check-in by ID
   */
  public boolean deleteCheckIn(int checkInId) {
    String sql = "DELETE FROM checkins WHERE checkin_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, checkInId);
      return stmt.executeUpdate() > 0;

    } catch (SQLException e) {
      e.printStackTrace();
    }
    return false;
  }

  /**
   * Map ResultSet to CheckIn object
   */
  private CheckIn mapResultSetToCheckIn(ResultSet rs) throws SQLException {
    CheckIn checkIn = new CheckIn();
    checkIn.setCheckInId(rs.getInt("checkin_id"));
    checkIn.setCustomerId(rs.getInt("customer_id"));
    checkIn.setCustomerName(rs.getString("customer_name"));
    checkIn.setCustomerEmail(rs.getString("customer_email"));

    Timestamp checkInTime = rs.getTimestamp("checkin_time");
    if (checkInTime != null) {
      checkIn.setCheckInTime(checkInTime.toLocalDateTime());
    }

    checkIn.setQrCode(rs.getString("qr_code"));
    checkIn.setCheckInType(rs.getString("checkin_type"));

    Integer appointmentId = rs.getObject("appointment_id", Integer.class);
    checkIn.setAppointmentId(appointmentId);

    checkIn.setStatus(rs.getString("status"));
    checkIn.setNotes(rs.getString("notes"));
    checkIn.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
    checkIn.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

    return checkIn;
  }
}