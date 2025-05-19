import 'dart:io';
import 'package:angkor_shop/controllers/product_controller.dart';
import 'package:angkor_shop/controllers/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- riverpod import
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class UploadProductScreen extends ConsumerStatefulWidget {
  const UploadProductScreen({super.key});

  @override
  ConsumerState<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends ConsumerState<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();

  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  final ProductController _productController = ProductController();
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles;
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState?.validate() != true || _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields and select images')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      List<Map<String, dynamic>> imagesForUpload = [];

      for (final imageFile in _images) {
        final fileName = path.basename(imageFile.path);
        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
        final bytes = await File(imageFile.path).readAsBytes();

        imagesForUpload.add({
          'fileName': fileName,
          'fileType': mimeType,
          'bytes': bytes,
        });
      }

      bool success = await _productController.uploadProductWithImages(
        images: imagesForUpload,
        productName: _productNameController.text,
        productPrice: double.parse(_productPriceController.text),
        description: _descriptionController.text,
        quantity: int.parse(_quantityController.text),
        category: _categoryController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product uploaded successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productNameController,
                        decoration: const InputDecoration(labelText: 'Product Name'),
                        validator: (value) => value == null || value.isEmpty ? 'Enter product name' : null,
                      ),
                      TextFormField(
                        controller: _productPriceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Enter price' : null,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
                      ),
                      TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Enter quantity' : null,
                      ),

                      // --- Category Dropdown Here ---
                      DropdownButtonFormField<String>(
                        value: _categoryController.text.isNotEmpty ? _categoryController.text : null,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.categoryName, // adjust if your model uses different field
                            child: Text(category.categoryName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _categoryController.text = value ?? '';
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Select a category' : null,
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _pickImages,
                        child: const Text('Pick Images'),
                      ),
                      const SizedBox(height: 10),
                      _images.isEmpty
                          ? const Text('No images selected')
                          : Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _images.map((img) => Image.file(
                                File(img.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )).toList(),
                            ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _uploadProduct,
                        child: const Text('Upload Product'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
