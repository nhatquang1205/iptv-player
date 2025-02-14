class Channel {
  int? id;
  int? playListId;
  String title;
  String url;
  String thumbnail;
  int duration;
  DateTime createdAt;
  bool isFavorite;

  Channel({
    this.id,
    this.playListId,
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.duration,
    required this.createdAt,
    required this.isFavorite,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      playListId: json['playListId'],
      title: json['title'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playlist_id': playListId,
      'title': title,
      'url': url,
      'thumbnail': thumbnail,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }
}
