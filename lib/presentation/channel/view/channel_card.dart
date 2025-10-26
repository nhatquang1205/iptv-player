import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';

class ChannelSelector extends StatelessWidget {
  final Channel channel;
  final VoidCallback onChannelSelected;
  final bool isSelected;

  const ChannelSelector({
    super.key,
    required this.channel,
    required this.onChannelSelected,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          onChannelSelected();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                child: channel.thumbnail.isEmpty
                    ? Image.asset(
                        'assets/images/placeholder.jpg',
                        width: 30,
                        fit: BoxFit.contain,
                      )
                    : Image(
                        image: channel.thumbnail.contains('http')
                            ? CachedNetworkImageProvider(channel.thumbnail)
                            : FileImage(File(channel.thumbnail)),
                        width: 30,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/placeholder.jpg',
                          width: 30,
                          fit: BoxFit.contain,
                        ),
                        fit: BoxFit.contain,
                      ),
              ),
              const SizedBox(width: 8),
              Text(channel.title),
              const Spacer(),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    context.read<ChannelBloc>().add(ChannelToggleFavorite(
                        channel.id!, !channel.isFavorite));
                  },
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      channel.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: channel.isFavorite
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[500],
                    ),
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
