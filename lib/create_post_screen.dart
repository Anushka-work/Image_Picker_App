import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _imageFile;
  String? _imageUrl;
  final TextEditingController _captionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as XFile?;
    if (args != null) {
      setState(() {
        if (kIsWeb) {
          _imageUrl = args.path;
        } else {
          _imageFile = File(args.path);
        }
      });
    }
  }

  void _submitPost() {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a caption")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post uploaded successfully!")),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child: const Text('Post', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_imageUrl != null || _imageFile != null)
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: kIsWeb
                        ? NetworkImage(_imageUrl!)
                        : FileImage(_imageFile!) as ImageProvider,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write a caption...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            if (_isSubmitting) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
