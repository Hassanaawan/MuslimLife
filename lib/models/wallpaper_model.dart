class WallpaperModel {
  final String id;
  final String wallpaperName;
  final String originalUrl;
  final String thumbnailUrl;
  final String timestamp;

  WallpaperModel({
    required this.id,
    required this.wallpaperName,
    required this.originalUrl,
    required this.thumbnailUrl,
    required this.timestamp,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['_id'],
      wallpaperName: json['wallpaperName'],
      originalUrl: json['originalUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'wallpaperName': wallpaperName,
      'originalUrl': originalUrl,
      'thumbnailUrl': thumbnailUrl,
      'timestamp': timestamp,
    };
  }
}