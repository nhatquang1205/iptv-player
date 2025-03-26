import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String imagePath;
  final String videoName;
  final bool isFavorite;
  final String avatarIcon;
  final String avatarColor;

  VideoCard({
    required this.imagePath,
    required this.videoName,
    this.isFavorite = false,
    required this.avatarIcon,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child:
          // ✅ Thumbnail Image
          ClipRRect(
        child: imagePath.isEmpty
            ? Image.asset(
                'assets/images/placeholder.jpg',
                height: 45,
                width: double.infinity,
                fit: BoxFit.contain,
              )
            : Image(
                image: imagePath.contains('http')
                    ? CachedNetworkImageProvider(imagePath)
                    : FileImage(File(imagePath)),
                width: double.infinity,
                height: 45,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder.jpg',
                  height: 45,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
