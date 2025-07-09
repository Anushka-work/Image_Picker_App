import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_app1/animated_fab.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'dart:html' as html;

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen>
    with SingleTickerProviderStateMixin {
  io.File? _image;
  String? _webImagePath;
  List<XFile> recentMedia = [];

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleMediaSelection(XFile file) {
    final path = file.path;
    setState(() {
      if (kIsWeb) {
        _webImagePath = path;
      } else {
        _image = io.File(path);
      }

      recentMedia.insert(0, file);
      if (recentMedia.length > 10) {
        recentMedia.removeLast();
      }

      _animationController.reset();
      _animationController.forward();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Media selected. Redirecting...")),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushNamed(context, '/create', arguments: file);
    });
  }

  Widget _buildMediaPreview(XFile file) {
    final isVideo =
        file.path.endsWith(".mp4") || file.mimeType?.contains("video") == true;

    if (kIsWeb) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(file.path),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (!isVideo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          io.File(file.path),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.videocam, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const double fixedImageWidth = 300;
    const double fixedImageHeight = 300;

    final List<String> sampleImages = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGA9K_Fo2N1P-m2ekBz-LusUESP1gOxFad-w&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSD40Cf8DvID8LrcHkSbqNvrq3N--k-H6Tj5C0O78ug9y0B8M8Yu_qxRgoi_nyCq1IuKlY&usqp=CAU',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: fixedImageWidth,
                            height: fixedImageHeight,
                            color: Theme.of(context).cardColor,
                            child: kIsWeb
                                ? (_webImagePath != null
                                    ? Image.network(_webImagePath!,
                                        fit: BoxFit.cover)
                                    : Image.network(sampleImages[0],
                                        fit: BoxFit.cover))
                                : (_image != null
                                    ? Image.file(_image!, fit: BoxFit.cover)
                                    : Image.network(sampleImages[0],
                                        fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Pick from below or use the + button",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      icon: const Icon(Icons.person),
                      label: const Text("Open Profile"),
                    ),
                    const SizedBox(height: 30),
                    if (recentMedia.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Recent Picks",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: recentMedia.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) =>
                              _buildMediaPreview(recentMedia[index]),
                        ),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: AnimatedFab(
                    onMediaSelected: _handleMediaSelection,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
