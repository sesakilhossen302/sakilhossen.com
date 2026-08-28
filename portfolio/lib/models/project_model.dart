class Project {
  final String id;
  final String title;
  final String description;
  final String image;
  final String? videoUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? githubUrl;
  final List<String> tags;
  final List<String> features;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.videoUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.githubUrl,
    required this.tags,
    required this.features,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      videoUrl: (json['videoUrl'] == null || json['videoUrl'] == '')
          ? (json['video'] == null || json['video'] == '' ? null : json['video'])
          : json['videoUrl'],
      playStoreUrl: json['playStoreUrl'] == '' ? null : json['playStoreUrl'],
      appStoreUrl: json['appStoreUrl'] == '' ? null : json['appStoreUrl'],
      githubUrl: json['githubUrl'] == '' ? null : json['githubUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      features: List<String>.from(json['features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'videoUrl': videoUrl ?? '',
      'playStoreUrl': playStoreUrl ?? '',
      'appStoreUrl': appStoreUrl ?? '',
      'githubUrl': githubUrl ?? '',
      'tags': tags,
      'features': features,
    };
  }
}
