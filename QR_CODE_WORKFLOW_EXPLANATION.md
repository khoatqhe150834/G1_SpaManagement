# QR Code Check-in Workflow Explanation

## Overview

The QR code check-in system works through a **manual scanning and confirmation process**, not automatic detection. Here's how it works:

## Step-by-Step Process

### 1. QR Code Generation (Customer Side)

```
Customer → Fills form → Generates QR Code → Database record created
```

**What happens:**

- Customer inputs their information and check-in type
- System generates QR code containing JSON data:
  ```json
  {
    "customerId": 123,
    "customerName": "John Doe",
    "customerEmail": "john@example.com",
    "checkInType": "appointment",
    "appointmentId": 456,
    "timestamp": 1698765432000,
    "spa": "SpaManagement"
  }
  ```
- A record is created in `checkins` table with status "pending"
- QR code image is displayed to customer

### 2. QR Code Scanning (Staff Side)

```
Staff → Uploads QR image → System decodes → Displays customer info
```

**What happens:**

- Staff member goes to `/checkin/scan` page
- Uploads an image file containing the QR code
- `QRCodeReaderService.readQRCodeFromImage()` decodes the image
- System extracts customer information from QR data
- System finds matching record in database using the QR data

### 3. Check-in Confirmation (Manual Process)

```
Staff → Reviews info → Clicks "Confirm" → Status updated to "confirmed"
```

**What happens:**

- Staff reviews the customer information displayed
- Staff clicks "Confirm Check-in" button
- `CheckInController.handleCheckInConfirmation()` is called
- Database record is updated:
  - `status` changed from "pending" to "confirmed"
  - `checkin_time` set to current timestamp
  - `notes` added if provided

## Key Points About Detection

### The System Does NOT Automatically Know When QR is Scanned

- **No real-time detection**: The backend doesn't automatically know when someone scans a QR code
- **Manual upload required**: Staff must manually upload the QR code image
- **Manual confirmation required**: Staff must manually click "Confirm" to update status

### Why This Design?

1. **Security**: Prevents unauthorized check-ins
2. **Verification**: Staff can verify customer identity
3. **Control**: Business can control check-in process
4. **Notes**: Staff can add notes about the check-in

## Database State Changes

### Initial State (After QR Generation)

```sql
INSERT INTO checkins (
    customer_id, customer_name, customer_email,
    qr_code, checkin_type, status, created_at
) VALUES (
    123, 'John Doe', 'john@example.com',
    '{"customerId":123,...}', 'appointment', 'pending', GETDATE()
);
```

### After Staff Confirmation

```sql
UPDATE checkins SET
    checkin_time = GETDATE(),
    status = 'confirmed',
    notes = 'Check-in confirmed by staff',
    updated_at = GETDATE()
WHERE qr_code = '{"customerId":123,...}';
```

## Testing the Workflow

### 1. Generate QR Code

- Access: `http://localhost:8080/yourapp/test-qr-generation.jsp`
- Fill form and click "Generate QR Code"
- Download or screenshot the QR code

### 2. Scan QR Code

- Access: `http://localhost:8080/yourapp/checkin/scan`
- Upload the QR code image
- System will display customer information

### 3. Confirm Check-in

- Review customer details
- Add notes if needed
- Click "Confirm Check-in"
- Status changes to "confirmed"

## Code Flow

### QR Generation Flow

```
TestQRController.doPost()
→ QRCodeService.generateCheckInQRCode()
→ CheckInDAO.createCheckIn()
→ Database: status = "pending"
```

### QR Scanning Flow

```
CheckInController.doPost("/scan")
→ QRCodeReaderService.readQRCodeFromImage()
→ CheckInDAO.findByQrCode()
→ Display customer info
```

### Confirmation Flow

```
CheckInController.doPost("/confirm")
→ CheckInDAO.updateCheckIn()
→ Database: status = "confirmed", checkin_time = NOW()
```

## Important Notes

1. **One-way process**: QR code scanning is initiated by staff, not customers
2. **Manual verification**: Staff must manually confirm each check-in
3. **Audit trail**: All check-ins are logged with timestamps
4. **Security**: QR codes contain spa identifier to prevent misuse
5. **Status tracking**: Easy to see which check-ins are pending vs confirmed

## Alternatives for Automatic Detection

If you wanted automatic detection, you would need:

1. **Mobile app**: Customer scans QR at physical location
2. **NFC tags**: Customers tap phone to NFC reader
3. **Beacon technology**: Automatic detection when customer enters area
4. **Camera system**: Automatic QR detection via security cameras

But the current manual system provides better control and verification.
