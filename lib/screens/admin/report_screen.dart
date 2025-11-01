import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:biliran_alert/utils/theme.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  File? _imageFile;
  Uint8List? _webImage;
  bool _isLoading = false;
  bool _isLocating = false;

  final String cloudinaryUploadUrl =
      "https://api.cloudinary.com/v1_1/dcqlmbxbi/image/upload";
  final String uploadPreset = "biliran_unsigned";

  /// Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  /// Get current GPS location
  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      String readableAddress =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      setState(() {
        _locationController.text = readableAddress;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("📍 Location detected: $readableAddress")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error getting location: $e")),
      );
    }

    setState(() => _isLocating = false);
  }

  /// Upload image to Cloudinary
  Future<String?> _uploadToCloudinary() async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl))
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          _webImage!,
          filename: 'report.jpg',
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final url = RegExp(r'"secure_url":"([^"]+)"').firstMatch(resBody)?.group(1);
        return url;
      } else {
        print("Cloudinary upload failed: $resBody");
        return null;
      }
    } catch (e) {
      print("Cloudinary error: $e");
      return null;
    }
  }

  /// Submit report to Firestore under 'reports' collection
  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        (_imageFile == null && _webImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill out all fields.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadToCloudinary();

      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to upload image.")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Save report to 'reports' collection
      await FirebaseFirestore.instance.collection('incidents').add({
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'image_url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Report Submitted!")),
      );

      setState(() {
        _descriptionController.clear();
        _locationController.clear();
        _imageFile = null;
        _webImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error submitting report: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final imagePreview = kIsWeb
        ? (_webImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(_webImage!,
                    fit: BoxFit.cover, width: double.infinity, height: 200),
              )
            : const Center(
                child: Icon(Icons.camera_alt, size: 50, color: Colors.grey)))
        : (_imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!,
                    fit: BoxFit.cover, width: double.infinity, height: 200),
              )
            : const Center(
                child: Icon(Icons.camera_alt, size: 50, color: Colors.grey)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report an Incident"),
        backgroundColor: primaryDarkBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryDarkBlue, accentOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Upload or Take Photo",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryDarkBlue.withOpacity(0.3)),
                    color: Colors.white,
                  ),
                  child: imagePreview,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDarkBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Gallery"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text("Incident Location",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: "Enter or detect your location",
                          labelText: "Location",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _isLocating ? null : _getCurrentLocation,
                      icon: _isLocating
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.my_location, color: primaryDarkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text("Incident Description",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Describe the situation...",
                    labelText: "Description",
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submitReport,
                    icon: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send),
                    label:
                        Text(_isLoading ? "Submitting..." : "Submit Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
