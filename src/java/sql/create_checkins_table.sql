-- Create checkins table for QR code check-in functionality
CREATE TABLE checkins (
    checkin_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    customer_name NVARCHAR(255) NOT NULL,
    customer_email NVARCHAR(255) NOT NULL,
    checkin_time DATETIME2 NULL,
    qr_code NVARCHAR(MAX) NOT NULL,
    checkin_type NVARCHAR(50) NOT NULL CHECK (checkin_type IN ('appointment', 'walk-in')),
    appointment_id INT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    notes NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Create indexes for better performance
CREATE INDEX IX_checkins_customer_id ON checkins(customer_id);
CREATE INDEX IX_checkins_status ON checkins(status);
CREATE INDEX IX_checkins_created_at ON checkins(created_at);
CREATE INDEX IX_checkins_qr_code ON checkins(qr_code);

-- Add foreign key constraint if customers table exists
-- ALTER TABLE checkins ADD CONSTRAINT FK_checkins_customer_id 
-- FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Add foreign key constraint if appointments table exists  
-- ALTER TABLE checkins ADD CONSTRAINT FK_checkins_appointment_id 
-- FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id); 