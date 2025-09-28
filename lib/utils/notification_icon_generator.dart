import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

/// A utility class to generate properly formatted notification icons
/// Android notification icons must be white foreground with transparent background
class NotificationIconGenerator {
  /// Generate notification icons for Android
  /// This should be called during development, not at runtime
  static Future<void> generateNotificationIcons() async {
    try {
      // Source image path
      final String sourceImagePath = 'assets/logo/1000088366.png';

      // Load the image
      final ByteData data = await rootBundle.load(sourceImagePath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      // Define target sizes for different densities
      final Map<String, int> densitySizes = {
        'mdpi': 24,
        'hdpi': 36,
        'xhdpi': 48,
        'xxhdpi': 72,
        'xxxhdpi': 96,
      };

      // Get temp directory to save the resized images
      final Directory tempDir = await getTemporaryDirectory();

      // Create resized icons for each density
      for (final MapEntry<String, int> entry in densitySizes.entries) {
        final String density = entry.key;
        final int size = entry.value;

        // Create a recorder to draw the image
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);

        // Draw the image with white color and transparent background
        final Paint paint = Paint()
          ..colorFilter = const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          );

        // Calculate scale to fit the image within the target size
        final double scale = size / image.width;

        // Scale the image
        canvas.scale(scale, scale);
        canvas.drawImage(image, Offset.zero, paint);

        // End recording
        final ui.Picture picture = recorder.endRecording();
        final ui.Image resizedImage = await picture.toImage(size, size);

        // Convert image to byte data
        final ByteData? byteData = await resizedImage.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();

          // Save the resized image
          final String iconPath = path.join(
            tempDir.path,
            'notification_icon_$density.png',
          );
          final File iconFile = File(iconPath);
          await iconFile.writeAsBytes(pngBytes);

          print('Generated notification icon for $density: $iconPath');
        }
      }

      print('Notification icons generated successfully!');
      print(
          'Copy these files to the appropriate drawable directories in your Android project.');
    } catch (e) {
      print('Error generating notification icons: $e');
    }
  }
}
