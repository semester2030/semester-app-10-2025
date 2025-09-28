import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';

/// Send OTP email for signup email verification (before registration)
/// This stores OTP temporarily in a separate collection for verification
Future<bool> sendSignupOtpEmail(String email) async {
  const String username = 'shakeelhuzaifa520@gmail.com';
  const String password = 'aquf nfxh yboq sasr';

  final smtpServer = SmtpServer(
    'smtp.gmail.com',
    port: 587,
    username: username,
    password: password,
    ssl: false,
    ignoreBadCertificate: false,
  );

  // Generate a 6-digit OTP for email verification
  final otp = Random().nextInt(900000) + 100000; // Ensures a 6-digit OTP

  // HTML content for the email with clean simple design
  final htmlContent = '''
    <html>
      <head>
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
          body {
            font-family: 'Inter', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f6fa;
            color: #333333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
          }
          .container {
            background-color: white;
            border-radius: 10px;
            padding: 40px 20px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
          }
          h1 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333333;
          }
          p {
            font-size: 16px;
            line-height: 1.5;
            color: #555555;
            margin-bottom: 20px;
          }
          .otp-container {
            background-color: #8A2BE2; /* accentPurple color */
            color: white;
            font-size: 28px;
            font-weight: bold;
            padding: 15px 30px;
            border-radius: 8px;
            display: inline-block;
            margin: 20px 0;
            letter-spacing: 2px;
          }
          .footer {
            margin-top: 30px;
            font-size: 14px;
            color: #666666;
          }
          a {
            color: #8A2BE2;
            text-decoration: none;
          }
          .highlight {
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Email Verification Code</h1>
          
          <p>Welcome to <span class="highlight">Student Ride App</span>! To complete your registration, please verify your email using the OTP code below:</p>
          
          <div class="otp-container">
            $otp
          </div>
          
          <p>This OTP is valid for <span class="highlight">5 minutes</span>. Please do not share this code with anyone.</p>
          
          <p>If you did not request this verification, please ignore this email or contact our support team.</p>
          
          <p class="footer">
            Thank you for choosing <span class="highlight">Student Ride App</span>. We are excited to have you on board!<br><br>
            Best regards,<br>
            The Student Ride App Team
          </p>
        </div>
      </body>
    </html>
  ''';

  final message = Message()
    ..from = const Address(username, 'Student Ride App Registration')
    ..recipients.add(email)
    ..subject = 'Email Verification Code - Student Ride App'
    ..html = htmlContent;

  try {
    final sendResult = await send(message, smtpServer);
    print('Email sent: ${sendResult.toString()}');

    // Store OTP temporarily in Firestore for verification
    // Using a separate collection for pending signups
    await FirebaseFirestore.instance
        .collection('pending_signups')
        .doc(email)
        .set({
      'otp': otp.toString(),
      'email': email,
      'timestamp': DateTime.now(),
      'expiresAt': DateTime.now().add(const Duration(minutes: 5)),
    });

    print('OTP stored for email: $email');
    return true;
  } catch (e) {
    print('Error sending signup OTP email: $e');
    return false;
  }
}

/// Verify OTP for signup email verification
Future<bool> verifySignupOtp(String email, String enteredOtp) async {
  try {
    // Get the OTP document from pending_signups collection
    final doc = await FirebaseFirestore.instance
        .collection('pending_signups')
        .doc(email)
        .get();

    if (!doc.exists) {
      print('No OTP found for email: $email');
      return false;
    }

    final data = doc.data()!;
    final storedOtp = data['otp'] as String;
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();

    // Check if OTP has expired
    if (DateTime.now().isAfter(expiresAt)) {
      print('OTP expired for email: $email');
      // Clean up expired OTP
      await FirebaseFirestore.instance
          .collection('pending_signups')
          .doc(email)
          .delete();
      return false;
    }

    // Check if OTP matches
    if (storedOtp == enteredOtp) {
      print('OTP verified successfully for email: $email');
      // Clean up used OTP
      await FirebaseFirestore.instance
          .collection('pending_signups')
          .doc(email)
          .delete();
      return true;
    } else {
      print('OTP mismatch for email: $email');
      return false;
    }
  } catch (e) {
    print('Error verifying signup OTP: $e');
    return false;
  }
}
