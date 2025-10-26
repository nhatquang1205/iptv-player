import 'package:flutter/material.dart';
import 'package:iptv_player/data/models/quick_source.dart';

/// Curated list of legal, free IPTV sources for quick start
/// All sources are either public domain, official free streams, or demo content
final List<QuickSource> quickSources = [
  QuickSource(
    name: 'US News Channels',
    description: 'News channels from United States',
    url: 'https://iptv-org.github.io/iptv/countries/us.m3u8',
    category: 'News',
    icon: Icons.newspaper,
    color: Color(0xFF2196F3), // Blue
  ),
  QuickSource(
    name: 'UK Channels',
    description: 'Channels from United Kingdom',
    url: 'https://iptv-org.github.io/iptv/countries/uk.m3u8',
    category: 'General',
    icon: Icons.public,
    color: Color(0xFF4CAF50), // Green
  ),
  QuickSource(
    name: 'International Mix',
    description: 'Mix of international channels',
    url: 'https://iptv-org.github.io/iptv/countries/ca.m3u8',
    category: 'General',
    icon: Icons.tv,
    color: Color(0xFF9C27B0), // Purple
  ),
];

/// Alternative: If users want to explore more sources themselves
const String iptvOrgGitHubUrl = 'https://github.com/iptv-org/iptv';
const String iptvOrgReadmeUrl = 'https://github.com/iptv-org/iptv#readme';
