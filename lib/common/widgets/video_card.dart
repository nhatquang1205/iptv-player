import 'dart:io';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String imagePath;
  final String videoName;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final String avatarIcon;
  final String avatarColor;

  VideoCard({
    required this.imagePath,
    required this.videoName,
    this.isFavorite = false,
    required this.onFavoriteToggle,
    required this.avatarIcon,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ Thumbnail Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imagePath.isEmpty
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(int.parse(avatarColor)),
                  child: Icon(IconData(int.parse(avatarIcon),
                      fontFamily: 'MaterialIcons')))
              : Image(
                  image: imagePath.contains('http')
                      ? NetworkImage(imagePath)
                      : FileImage(File(imagePath)),
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
        ),

        // ✅ Heart Icon (Favorite)
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
