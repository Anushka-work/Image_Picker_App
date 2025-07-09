import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnimatedFab extends StatefulWidget {
  final Function(XFile) onMediaSelected;

  const AnimatedFab({super.key, required this.onMediaSelected});

  @override
  State<AnimatedFab> createState() => AnimatedFabState();
}

class AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) widget.onMediaSelected(image);
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) widget.onMediaSelected(video);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.white : Colors.black;
    final Color iconColor = isDark ? Colors.black : Colors.white;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (isExpanded)
          Positioned(
            bottom: 135,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 180,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (isDark)
                      const BoxShadow(
                        color: Colors.white24,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _pickImage,
                          icon: Icon(Icons.photo, size: 30, color: iconColor),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _pickVideo,
                          icon:
                              Icon(Icons.videocam, size: 30, color: iconColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 50,
          child: AnimatedRotation(
            turns: isExpanded ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.white24 : Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _toggleFab,
                icon: Icon(Icons.add, color: iconColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
