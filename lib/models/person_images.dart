class PersonImages {
  final List<ImageData> profiles;

  PersonImages({required this.profiles});

  factory PersonImages.fromJson(Map<String, dynamic> json) {
    var profilesList = json['profiles'] as List;
    List<ImageData> profiles =
        profilesList.map((i) => ImageData.fromJson(i)).toList();

    return PersonImages(profiles: profiles);
  }
}

class ImageData {
  final String filePath;
  final double aspectRatio;
  final int width;
  final int height;

  ImageData({
    required this.filePath,
    required this.aspectRatio,
    required this.width,
    required this.height,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      filePath: json['file_path'],
      aspectRatio: json['aspect_ratio']?.toDouble() ?? 1.0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}
