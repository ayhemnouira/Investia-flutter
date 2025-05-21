import 'package:hive/hive.dart'; // Importe Hive

// Exécute: flutter packages pub run build_runner build
// Chaque fois que tu modifies cette classe pour générer/mettre à jour le fichier news_article.g.dart
part 'news_article.g.dart';

@HiveType(typeId: 0) // ID unique pour NewsArticle (choisis un nombre différent pour chaque modèle)
class NewsArticle {
  @HiveField(0) // Index unique pour chaque champ dans cette classe
  final String title;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String summary;
  // Tu pourrais ajouter d'autres champs comme source, imageUrl, articleUrl
  // @HiveField(3) // Assigne un index différent si tu ajoutes des champs
  // final String? source;
  // @HiveField(4)
  // final String? imageUrl;
  // @HiveField(5)
  // final String? articleUrl;


  NewsArticle({
    required this.title,
    required this.date,
    required this.summary,
    // this.source,
    // this.imageUrl,
    // this.articleUrl,
  });

  // Methode factory pour créer un article depuis un JSON (à adapter selon l'API utilisée)
  // Assure-toi que les clés JSON ('title', 'date', 'summary') correspondent à ton API
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // Exemple basique, à adapter à la structure exacte de ton JSON API
    // Utilise des casts sûrs si les données de l'API peuvent être null ou d'un autre type
    return NewsArticle(
      title: json['title'] as String? ?? '', // Utilise ?? '' pour gérer le null si title peut être nullable dans le JSON
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(), // Gère les dates nulles ou invalides
      summary: json['summary'] as String? ?? 'No summary available.', // Gère le null
      // source: json['source'] as String?,
      // imageUrl: json['imageUrl'] as String?,
      // articleUrl: json['articleUrl'] as String?,
    );
  }
}