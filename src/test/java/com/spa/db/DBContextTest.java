package com.spa.db;

import java.sql.Connection;
import java.sql.SQLException;
import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class DBContextTest {

    @BeforeEach
    void setUp() {
        // Any setup before each test
    }

    @AfterEach
    void tearDown() {
        // Close connection after each test
        DBContext.closeConnection();
    }

    @Test
    void testGetConnection() throws SQLException {
        // Test getting a new connection
        Connection conn = DBContext.getConnection();
        assertNotNull(conn, "Connection should not be null");
        assertFalse(conn.isClosed(), "Connection should be open");
    }

  

   
}