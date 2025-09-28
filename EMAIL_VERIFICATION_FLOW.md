# Email Verification Flow for User Registration

## Overview
The signup flow has been modified to implement email verification before user registration. This ensures that only users with valid email addresses can complete the registration process.

## Flow Description

### 1. User Fills Registration Form
- User enters their information (name, email, phone, password, gender, role)
- All validation happens locally before proceeding

### 2. Email Verification Process
When the user clicks "Continue Registration":

1. **Validation**: The system validates all form fields
2. **Availability Check**: Checks if email and phone number are already registered
3. **OTP Generation**: Generates a 6-digit OTP and sends it to the user's email
4. **Navigation**: User is redirected to OTP verification screen

### 3. OTP Verification
- User enters the 6-digit OTP received in their email
- System verifies the OTP against the stored value
- OTP expires after 5 minutes for security

### 4. Registration Completion
- After successful OTP verification, the actual user registration happens
- User account is created in Firebase Authentication
- User data is stored in Firestore
- Success screen is shown

## Technical Implementation

### Files Modified

1. **`/lib/utils/send_signup_email_otp.dart`** (New)
   - Handles sending OTP emails for signup verification
   - Stores OTP temporarily in `pending_signups` collection
   - Verifies entered OTP against stored value

2. **`/lib/screens/auth/signup/provider/signup_provider.dart`**
   - Added `sendEmailVerificationOtp()` method
   - Modified `signupStudent()` to complete registration after verification
   - Separated validation from registration

3. **`/lib/screens/auth/signup/signup_user.dart`**
   - Updated `onSignUpPressed()` to call email verification instead of direct registration

4. **`/lib/screens/auth/forget_password/otp_view.dart`**
   - Enhanced to handle both signup and password reset flows
   - Added signup-specific OTP verification logic
   - Calls final registration after successful verification

### Key Functions

#### `sendSignupOtpEmail(String email)`
- Generates 6-digit OTP
- Sends formatted HTML email with OTP
- Stores OTP in `pending_signups` collection with 5-minute expiry

#### `verifySignupOtp(String email, String enteredOtp)`
- Retrieves stored OTP from `pending_signups` collection
- Checks if OTP matches and hasn't expired
- Cleans up OTP data after verification

#### `sendEmailVerificationOtp(BuildContext context)`
- Validates form data
- Checks email/phone availability
- Sends OTP and navigates to verification screen

#### `signupStudent(BuildContext context)`
- Completes the actual user registration
- Creates Firebase user account
- Stores user data in Firestore

## Security Features

1. **OTP Expiry**: All OTPs expire after 5 minutes
2. **Single Use**: OTPs are deleted after successful verification
3. **Temporary Storage**: OTPs are stored in a separate collection, not with user data
4. **Email Validation**: Only users with access to the email can complete registration

## Database Collections

### `pending_signups` (Temporary)
```javascript
{
  email: "user@example.com",
  otp: "123456",
  timestamp: "2025-01-01T00:00:00Z",
  expiresAt: "2025-01-01T00:05:00Z"
}
```

### `users` (Permanent)
User data is only created after successful email verification.

## User Experience

1. **Clear Process**: User knows email verification is required
2. **Immediate Feedback**: OTP is sent immediately with confirmation
3. **Error Handling**: Clear error messages for invalid/expired OTPs
4. **Success Confirmation**: Success screen confirms account creation

## Benefits

1. **Email Verification**: Ensures users provide valid email addresses
2. **Reduced Spam**: Prevents fake account creation
3. **Better Security**: Two-step verification process
4. **Clean Data**: Only verified emails in the database
5. **Compliance**: Follows email verification best practices

## Testing Flow

1. Fill out the registration form with valid data
2. Click "Continue Registration"
3. Check email for OTP (also check spam folder)
4. Enter 6-digit OTP in verification screen
5. Verify successful account creation and navigation to login

## Email Template

The OTP email includes:
- Professional branding
- Clear OTP display
- Security reminder (don't share OTP)
- 5-minute expiry notice
- Support contact information
