import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_frame/core/utils/image_picker.dart';

class ImagePickerTestPage extends StatefulWidget {
  const ImagePickerTestPage({super.key});

  @override
  State<ImagePickerTestPage> createState() => _ImagePickerTestPageState();
}

class _ImagePickerTestPageState extends State<ImagePickerTestPage> {
  File? _selectedImage;
  String? _base64String;

  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();

  Future<void> _pickImage(bool isGallery) async {
    final file = await _imagePickerUtil.selectImage(isGallery: isGallery);
    if (file != null) {
      setState(() {
        _selectedImage = file;
        _base64String = null; // Reset
      });
    }
  }

  // ignore: unused_element
  Future<void> _pickAndConvertToBase64(bool isGallery) async {
    final base64 = await _imagePickerUtil.selectImageAndConvertToBase64(
      isGallery: isGallery,
    );
    if (base64 != null) {
      setState(() {
        _base64String = base64;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Image Picker Test",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Image preview
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Text(
                          "No Image Selected",
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 30),

              // Camera button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _pickImage(false),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  "Pick from Camera",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),

              // Gallery button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _pickImage(true),
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text(
                  "Pick from Gallery",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),

              // Convert to Base64 button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _selectedImage != null
                    ? () async {
                        final base64 =
                            await _imagePickerUtil.convertFileToBase64(
                          _selectedImage!,
                        );
                        setState(() {
                          _base64String = base64;
                        });
                      }
                    : null,
                child: const Text(
                  "Convert to Base64",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              // Show Base64 String
              if (_base64String != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _base64String!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
