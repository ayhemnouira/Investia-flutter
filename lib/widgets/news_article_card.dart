import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nécessaire pour formater la date
import '../models/news_article.dart';

// Assure-toi d'ajouter la dépendance intl dans ton pubspec.yaml:
// dependencies:
//   intl: ^0.19.0 # ou la dernière version

class NewsArticleCard extends StatelessWidget {
  final NewsArticle newsArticle;
  // Ajoute un callback pour gérer le tap si tu veux ouvrir l'article
  final VoidCallback? onTap;

  const NewsArticleCard({
    Key? key,
    required this.newsArticle,
    this.onTap, // Rend le onTap optionnel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Utilise un Card pour une meilleure présentation visuelle,
    // et un ListTile à l'intérieur.
    return Card(
       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Marges cohérentes
       elevation: 2.0,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(8.0),
       ),
      child: InkWell( // Rend la carte cliquable avec un effet visuel (ripple effect)
        onTap: onTap, // Gère le tap via le callback passé
        child: Padding( // Ajoute un peu de padding à l'intérieur de la carte
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newsArticle.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // Petit espace entre titre et date/summary
              Text(
                // Formate la date pour un meilleur affichage
                "Date: ${DateFormat('yyyy-MM-dd').format(newsArticle.date)}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8), // Espace entre date et summary
              Text(
                // **CORRECTION : Utilise newsArticle.summary**
                newsArticle.summary,
                maxLines: 3, // Limite le nombre de lignes pour le résumé
                overflow: TextOverflow.ellipsis, // Ajoute "..." si le texte est trop long
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              // Tu peux ajouter une icône ou une image ici si ton modèle l'inclut
              // if (newsArticle.imageUrl != null) ...[
              //   const SizedBox(height: 8),
              //   Image.network(newsArticle.imageUrl!), // Utilise CachedNetworkImage pour le cache
              // ]
            ],
          ),
        ),
      ),
    );
  }
}