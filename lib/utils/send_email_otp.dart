import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';

Future<bool> sendOtpEmail(String email) async {
  const String username = 'shakeelhuzaifa520@gmail.com';
  const String password = r'Huzaifa11!~22';

  final smtpServer = SmtpServer(
    'smtp.gmail.com',
    port: 587,
    username: username,
    password: password,
    ssl: false,
    ignoreBadCertificate: false,
  );

  // Generate a 6-digit OTP for password reset
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
            background-color: #B89F5C; /* accentGold color */
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
            color: #B89F5C;
            text-decoration: none;
          }
          .highlight {
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Your OTP Verification Code</h1>
          
          <p>Thank you for choosing <span class="highlight">NAYBRZ DBX</span>! To complete your password reset process, please use the OTP code below:</p>
          
          <div class="otp-container">
            $otp
          </div>
          
          <p>This OTP is valid for <span class="highlight">2 minutes</span>. Please do not share this code with anyone.</p>
          
          <p>If you did not request this OTP, please ignore this email or contact our support team at <a href="mailto:connect@naybrz-dxb.com">connect@naybrz-dxb.com</a>.</p>
          
          <p class="footer">
            Thank you for trusting <span class="highlight">NAYBRZ DBX</span>. We are excited to have you on board!<br><br>
            Best regards,<br>
            The NAYBRZ DBX Team
          </p>
        </div>
      </body>
    </html>
  ''';

  final message = Message()
    ..from = const Address(username, 'Student Ride App Support')
    ..recipients.add(email)
    ..subject = 'Password Reset Code'
    ..html = htmlContent;

  try {
    final sendResult = await send(message, smtpServer);

    print(sendResult.toString());

    // Get a reference to the user document with the matching email
    final querySnapshot =
        await userCollection.where("email", isEqualTo: email).get();

    // Check if user exists
    if (querySnapshot.docs.isEmpty) {
      print('No user found with email: $email');
      return false;
    }

    // Update the OTP in the user document
    final docId = querySnapshot.docs.first.id;
    await userCollection.doc(docId).update({'otp': otp});

    // await otpCollection
    //     .doc(email)
    //     .set({'otp': otp, 'timestamp': DateTime.now()});

    return true;
  } catch (e) {
    print('Error sending OTP email: $e');
    return false;
  }
}
