import 'package:flutter/material.dart';
import 'package:iptv_player/data/models/quick_source.dart';

/// Curated list of legal, free IPTV sources for quick start
/// All sources are either public domain, official free streams, or demo content
final List<QuickSource> quickSources = [
  QuickSource(
    name: 'Sports',
    description: 'News channels related to sports',
    url: 'https://iptv-org.github.io/iptv/categories/sports.m3u',
    category: 'Sports',
    icon: Icons.sports_soccer,
    color: Color(0xFF2196F3), // Blue
  ),
  QuickSource(
    name: 'Animation Mix',
    description: 'Mix of animation channels',
    url: 'https://iptv-org.github.io/iptv/categories/animation.m3u',
    category: 'General',
    icon: Icons.tv,
    color: Color(0xFF9C27B0), // Purple
  ),
];

/// Alternative: If users want to explore more sources themselves
const String iptvOrgGitHubUrl = 'https://github.com/iptv-org/iptv';
const String iptvOrgReadmeUrl = 'https://github.com/iptv-org/iptv#readme';
