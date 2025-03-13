import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wearwise/services/weather_service.dart';
 // Import the WeatherService
import 'vault_page.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:intl/intl.dart'; // For date formatting

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  String _selectedCategory = 'Top'; // Default category
  String _size = ''; // To store the size
  String _color = ''; // To store the color
  String _purchaseDate = ''; // To store the purchase date
  List<Map<String, dynamic>> uploadedImages = []; // Store uploaded images
  String _weatherInfo = 'Fetching weather...'; // Weather information
  bool _isLoadingWeather = true; // To show loading spinner while weather is being fetched

  // Initialize WeatherService
  final WeatherService _weatherService = WeatherService();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getTemporaryDirectory();
      final localPath = '${directory.path}/${pickedFile.name}';

      final imageFile = File(pickedFile.path);
      await imageFile.copy(localPath);

      setState(() {
        _imageFile = File(localPath);
      });
    }
  }

  // Method to upload metadata
  void _uploadMetadata() {
    if (_imageFile != null && _selectedCategory.isNotEmpty) {
      setState(() {
        uploadedImages.add({
          'imagePath': _imageFile!.path,
          'category': _selectedCategory,
          'size': _size,
          'color': _color,
          'purchaseDate': _purchaseDate,
        });
      });
      print('Image path: ${_imageFile!.path}');
      print('Category: $_selectedCategory');
      print('Size: $_size');
      print('Color: $_color');
      print('Purchase Date: $_purchaseDate');
    } else {
      print('No image selected');
    }
  }

  // Navigate to VaultPage with the current uploaded images and delete function
  void _goToVault() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VaultPage(
          uploadedImages: uploadedImages,
          onDelete: _deleteImage,  // Pass the delete callback
        ),
      ),
    );
  }

  // Fetch weather data
  void _fetchWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Fetch weather information for the user's location
      Map<String, dynamic> weatherData = await _weatherService.getWeather(position);

      setState(() {
        _weatherInfo = 'Temperature: ${weatherData['current']['temperature']}°C, '
            '${weatherData['current']['weather_descriptions'][0]}';
        _isLoadingWeather = false; // Stop loading when weather data is fetched
      });
    } catch (e) {
      setState(() {
        _weatherInfo = 'Failed to fetch weather data: $e';
        _isLoadingWeather = false;
      });
    }
  }

  // Show date picker for purchase date
  Future<void> _selectPurchaseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _purchaseDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Delete the selected image from the list
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index); // Remove the image at the given index
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Your Outfit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather info display
              if (_isLoadingWeather)
                Center(child: CircularProgressIndicator()) // Show loading spinner until weather data is fetched
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_weatherInfo, style: TextStyle(fontSize: 16)),
                  ),
                ),

              // Category selection
              SizedBox(height: 20),
              Text('Select Category:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Top'),
                    value: 'Top',
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Bottom'),
                    value: 'Bottom',
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Full Length'),
                    value: 'Full Length',
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),

              // Size input field
              SizedBox(height: 20),
              Text('Enter Size:', style: TextStyle(fontSize: 18)),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _size = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter size (e.g., S, M, L)',
                ),
              ),

              // Color input field
              SizedBox(height: 20),
              Text('Enter Color:', style: TextStyle(fontSize: 18)),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _color = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter color (e.g., Red, Blue)',
                ),
              ),

              // Purchase date picker
              SizedBox(height: 20),
              Text('Select Purchase Date:', style: TextStyle(fontSize: 18)),
              ElevatedButton(
                onPressed: _selectPurchaseDate,
                child: Text(_purchaseDate.isEmpty ? 'Select Date' : _purchaseDate),
              ),

              // Pick image button
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: Text('Pick Image', style: TextStyle(fontSize: 16)),
                ),
              ),

              // Display selected image and delete button
              if (_imageFile != null) ...[
                SizedBox(height: 20),
                Center(
                  child: Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover),
                ),
                SizedBox(height: 10),
                Center(child: Text('Image saved at: ${_imageFile!.path}')),

                // Delete Image button
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // If you need to delete the image
                        _imageFile = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: Text('Delete Image', style: TextStyle(fontSize: 16, color: Colors.red)),
                  ),
                ),
              ],

              // Upload metadata button
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _uploadMetadata,
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: Text('Upload Metadata', style: TextStyle(fontSize: 16)),
                ),
              ),

              // Vault button
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _goToVault,
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: Text('Open Vault', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
