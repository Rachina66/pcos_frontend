class ContentModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final List<String> tags;
  final bool isPublished;
  final DateTime createdAt;

  ContentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.tags,
    required this.isPublished,
    required this.createdAt,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      isPublished: json['isPublished'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get categoryLabel {
    switch (category) {
      case 'PCOS_BASICS':
        return 'PCOS Basics';
      case 'NUTRITION':
        return 'Nutrition';
      case 'EXERCISE':
        return 'Exercise';
      case 'MENTAL_HEALTH':
        return 'Mental Health';
      case 'TREATMENT':
        return 'Treatment';
      case 'LIFESTYLE':
        return 'Lifestyle';
      default:
        return category;
    }
  }
}
