class MaterialCategory {
  final String id;
  final String name;
  final String? description;

  MaterialCategory({
    required this.id,
    required this.name,
    this.description,
  });

  factory MaterialCategory.fromJson(Map<String, dynamic> json) {
    return MaterialCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class StudyMaterialVersion {
  final String id;
  final String materialId;
  final int version;
  final String fileUrl;
  final int fileSize;
  final String fileType;
  final DateTime createdAt;

  StudyMaterialVersion({
    required this.id,
    required this.materialId,
    required this.version,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
    required this.createdAt,
  });

  factory StudyMaterialVersion.fromJson(Map<String, dynamic> json) {
    return StudyMaterialVersion(
      id: json['id'],
      materialId: json['materialId'],
      version: json['version'],
      fileUrl: json['fileUrl'],
      fileSize: json['fileSize'],
      fileType: json['fileType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class StudyMaterial {
  final String id;
  final String title;
  final String? description;
  final String categoryId;
  final String? subjectId;
  final String? topicId;
  final String fileUrl;
  final int fileSize;
  final String fileType;
  final String accessType;
  final String status;
  final int version;
  final bool isBookmarked;
  final DateTime createdAt;
  final MaterialCategory? category;
  final List<StudyMaterialVersion> versions;

  StudyMaterial({
    required this.id,
    required this.title,
    this.description,
    required this.categoryId,
    this.subjectId,
    this.topicId,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
    required this.accessType,
    required this.status,
    required this.version,
    required this.isBookmarked,
    required this.createdAt,
    this.category,
    required this.versions,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    var versionList = json['versions'] != null
        ? (json['versions'] as List)
            .map((v) => StudyMaterialVersion.fromJson(v))
            .toList()
        : <StudyMaterialVersion>[];

    return StudyMaterial(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['categoryId'],
      subjectId: json['subjectId'],
      topicId: json['topicId'],
      fileUrl: json['fileUrl'],
      fileSize: json['fileSize'] ?? 0,
      fileType: json['fileType'] ?? '',
      accessType: json['accessType'] ?? 'FREE',
      status: json['status'] ?? 'APPROVED',
      version: json['version'] ?? 1,
      isBookmarked: json['isBookmarked'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'] != null
          ? MaterialCategory.fromJson(json['category'])
          : null,
      versions: versionList,
    );
  }
}
