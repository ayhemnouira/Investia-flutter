import 'package:flutter/material.dart';
import 'package:investia/models/news_article.dart';
import 'package:investia/providers/news_provider.dart';
import 'package:investia/widgets/news_article_card.dart';
import 'package:provider/provider.dart';



class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Contrôleur pour le champ de recherche
  final TextEditingController _searchController = TextEditingController();

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });
    // Ajoute un listener au contrôleur pour mettre à jour la recherche dans le provider
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Nettoie le contrôleur et retire le listener quand l'écran est supprimé
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Fonction appelée quand le texte de recherche change
  void _onSearchChanged() {
    // Met à jour le texte de recherche dans le provider
    Provider.of<NewsProvider>(context, listen: false).setSearchText(_searchController.text);
  }


  // Fonction pour gérer le tap sur une actualité (exemple)
  void _handleArticleTap(NewsArticle article) {
     print("Tapped on: ${article.title}");
     // TODO: Implement navigation to article detail screen or open URL
     // Exemple pour ouvrir une URL (nécessite le package url_launcher)
     // if (article.articleUrl != null) {
     //   launchUrl(Uri.parse(article.articleUrl!));
     // } else {
     //   ScaffoldMessenger.of(context).showSnackBar(
     //     const SnackBar(content: Text("No URL available for this article")),
     //   );
     // }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Actualités Financières"),
         leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Column( // Utilise une colonne pour la barre de recherche et la liste
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher des actualités',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded( // Permet à la liste de prendre l'espace restant
            child: Center(
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : provider.errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               const Icon(Icons.error_outline, color: Colors.red, size: 50),
                               const SizedBox(height: 10),
                                Text(
                                   provider.errorMessage!,
                                   textAlign: TextAlign.center,
                                   style: const TextStyle(color: Colors.red, fontSize: 16),
                                 ),
                                 const SizedBox(height: 20),
                                 ElevatedButton(
                                    onPressed: () => provider.fetchNews(),
                                    child: const Text("Réessayer"),
                                 ),
                             ],
                           ),
                        )
                      // Utilise provider.articles (la liste filtrée)
                      : provider.articles.isEmpty && provider.searchText.isEmpty // Si liste vide et pas de recherche active
                          ? const Text("Aucune actualité disponible pour l'instant.")
                          : provider.articles.isEmpty && provider.searchText.isNotEmpty // Si liste vide mais recherche active
                             ? Text("Aucun résultat pour \"${provider.searchText}\".")
                             : RefreshIndicator(
                                  onRefresh: () => provider.fetchNews(),
                                  // Utilise provider.articles (la liste filtrée)
                                  child: ListView.builder(
                                    itemCount: provider.articles.length,
                                    itemBuilder: (context, index) {
                                      final article = provider.articles[index];
                                      return NewsArticleCard(
                                        newsArticle: article,
                                        onTap: () => _handleArticleTap(article),
                                      );
                                    },
                                  ),
                                ),
            ),
          ),
        ],
      ),
    );
  }
}