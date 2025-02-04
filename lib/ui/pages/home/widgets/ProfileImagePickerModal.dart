import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileImagePickerModal extends StatelessWidget {
  final Function(String) onImageSelected;
  final VoidCallback? onRemoveImage;
  final bool hasExistingImage;
  final String? authToken;

  const ProfileImagePickerModal({
    Key? key,
    required this.onImageSelected,
    this.onRemoveImage,
    this.hasExistingImage = false,
    this.authToken,
  }) : super(key: key);

  Future<String?> _uploadImage(String imagePath) async {
    try {
      final uploadUrl = dotenv.env['FILE_UPLOAD_ENDPOINT']!;
      final file = File(imagePath);

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add auth header if token is provided
      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      // Add file to request
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: path.basename(file.path),
      );

      request.files.add(multipartFile);

      // Send request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // Parse JSON response
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        return jsonResponse['url'] as String?; // Extract URL from JSON
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _pickAndUploadImage(
      ImageSource source, BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null && context.mounted) {
        // Upload the image
        final uploadedUrl = await _uploadImage(image.path);

        if (context.mounted) {
          Navigator.pop(context); // Close loading indicator
          Navigator.pop(context); // Close modal

          if (uploadedUrl != null) {
            onImageSelected(uploadedUrl);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile picture updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } else if (context.mounted) {
        Navigator.pop(context); // Close loading indicator
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile picture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 24.0,
        bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Update Profile Picture',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take a Photo'),
            onTap: () => _pickAndUploadImage(ImageSource.camera, context),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => _pickAndUploadImage(ImageSource.gallery, context),
          ),
          if (hasExistingImage && onRemoveImage != null) ...[
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Remove Current Photo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () {
                onRemoveImage?.call();
                Navigator.pop(context);
              },
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
