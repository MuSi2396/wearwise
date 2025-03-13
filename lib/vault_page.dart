import 'dart:io';
import 'package:flutter/material.dart';

class VaultPage extends StatelessWidget {
  final List<Map<String, dynamic>> uploadedImages;

  const VaultPage({super.key, required this.uploadedImages, required void Function(int index) onDelete});

  // Method to handle deletion of an outfit
  void _deleteOutfit(BuildContext context, List<Map<String, dynamic>> uploadedImages, Map<String, dynamic> image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Outfit'),
        content: Text('Are you sure you want to delete this outfit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              uploadedImages.remove(image); // Remove the image from the list
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Method to handle editing of outfit metadata
  void _editOutfit(BuildContext context, Map<String, dynamic> image) {
    final _sizeController = TextEditingController(text: image['size']);
    final _colorController = TextEditingController(text: image['color']);
    final _dateController = TextEditingController(text: image['purchaseDate']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Outfit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _sizeController,
              decoration: InputDecoration(labelText: 'Size'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Purchase Date'),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              image['size'] = _sizeController.text;
              image['color'] = _colorController.text;
              image['purchaseDate'] = _dateController.text;
              Navigator.pop(context); // Close the dialog after updating
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group images by category for better organization
    Map<String, List<Map<String, dynamic>>> categorizedImages = {};
    for (var image in uploadedImages) {
      String category = image['category'];
      if (categorizedImages.containsKey(category)) {
        categorizedImages[category]!.add(image);
      } else {
        categorizedImages[category] = [image];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Wardrobe'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: categorizedImages.keys.map((category) {
            return ExpansionTile(
              title: Text(
                category,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: categorizedImages[category]!.map((image) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Outfit image
                      Image.file(
                        File(image['imagePath']),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      // Outfit details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              image['category'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('Size: ${image['size']}'),
                            Text('Color: ${image['color']}'),
                            Text('Purchased on: ${image['purchaseDate']}'),
                          ],
                        ),
                      ),
                      // Edit button
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editOutfit(context, image);
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteOutfit(context, uploadedImages, image);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
