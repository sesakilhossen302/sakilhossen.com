class Profile {
  final String name;
  final String title;
  final String tagline;
  final String bio;
  final String cvUrl;
  final String experienceYears;
  final String completedProjects;
  final String happyClients;
  final String developmentPhilosophy;
  final String careerGoals;
  final String phone;
  final String profileImage;
  final String email;
  final String location;
  final String githubUrl;
  final String linkedinUrl;
  final String heroVideoUrl;

  const Profile({
    required this.name,
    required this.title,
    required this.tagline,
    required this.bio,
    required this.cvUrl,
    required this.experienceYears,
    required this.completedProjects,
    required this.happyClients,
    required this.developmentPhilosophy,
    required this.careerGoals,
    required this.phone,
    required this.profileImage,
    required this.email,
    required this.location,
    required this.githubUrl,
    required this.linkedinUrl,
    this.heroVideoUrl = '',
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      tagline: json['tagline'] ?? '',
      bio: json['bio'] ?? '',
      cvUrl: json['cvUrl'] ?? '',
      experienceYears: json['experienceYears'] ?? '',
      completedProjects: json['completedProjects'] ?? '',
      happyClients: json['happyClients'] ?? '',
      developmentPhilosophy: json['developmentPhilosophy'] ?? '',
      careerGoals: json['careerGoals'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      linkedinUrl: json['linkedinUrl'] ?? '',
      heroVideoUrl: json['heroVideoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'tagline': tagline,
      'bio': bio,
      'cvUrl': cvUrl,
      'experienceYears': experienceYears,
      'completedProjects': completedProjects,
      'happyClients': happyClients,
      'developmentPhilosophy': developmentPhilosophy,
      'careerGoals': careerGoals,
      'phone': phone,
      'profileImage': profileImage,
      'email': email,
      'location': location,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
      'heroVideoUrl': heroVideoUrl,
    };
  }
}


class AiWorkflowPoint {
  final String title;
  final String description;
  final String icon;

  const AiWorkflowPoint({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory AiWorkflowPoint.fromJson(Map<String, dynamic> json) {
    return AiWorkflowPoint(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}

class SkillCategory {
  final String category;
  final List<String> items;

  const SkillCategory({
    required this.category,
    required this.items,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      category: json['category'] ?? '',
      items: List<String>.from(json['items'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'items': items,
    };
  }
}

class Experience {
  final String id;
  final String role;
  final String company;
  final String duration;
  final List<String> achievements;

  const Experience({
    required this.id,
    required this.role,
    required this.company,
    required this.duration,
    required this.achievements,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      duration: json['duration'] ?? '',
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'company': company,
      'duration': duration,
      'achievements': achievements,
    };
  }
}

class Education {
  final String id;
  final String institution;
  final String degree;
  final String duration;
  final String details;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.duration,
    required this.details,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '',
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      duration: json['duration'] ?? '',
      details: json['details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'duration': duration,
      'details': details,
    };
  }
}

class ClientReference {
  final String id;
  final String clientName;
  final String clientCompany;
  final String clientComment;
  final double clientRating;
  final String clientImage;
  final String reviewImage;

  const ClientReference({
    required this.id,
    required this.clientName,
    required this.clientCompany,
    required this.clientComment,
    required this.clientRating,
    required this.clientImage,
    required this.reviewImage,
  });

  factory ClientReference.fromJson(Map<String, dynamic> json) {
    return ClientReference(
      id: json['id'] ?? '',
      clientName: json['clientName'] ?? '',
      clientCompany: json['clientCompany'] ?? '',
      clientComment: json['clientComment'] ?? '',
      clientRating: (json['clientRating'] as num?)?.toDouble() ?? 5.0,
      clientImage: json['clientImage'] ?? '',
      reviewImage: json['reviewImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientCompany': clientCompany,
      'clientComment': clientComment,
      'clientRating': clientRating,
      'clientImage': clientImage,
      'reviewImage': reviewImage,
    };
  }
}

class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String message;
  final String timestamp;

  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.timestamp,
  });

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
