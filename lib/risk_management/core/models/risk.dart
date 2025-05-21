// Représente la structure de données pour un risque
class Risk {
  // Attributs de la classe Risk
  final int? id; // L'ID peut être null pour un nouveau risque avant sauvegarde
  final String name;
  final String description;
  final String category;
  final int impact;
  final int probability;
  final String? owner; // Le propriétaire est optionnel (peut être null)
  final String? mitigationPlan; // Le plan est optionnel (peut être null)

  // Constructeur de la classe
  // Utilise les paramètres nommés requis ({required this.name, ...})
  // pour une meilleure lisibilité et sécurité.
  Risk({
    this.id, // id est optionnel
    required this.name,
    required this.description,
    required this.category,
    required this.impact,
    required this.probability,
    this.owner, // owner est optionnel
    this.mitigationPlan, // mitigationPlan est optionnel
  });

  // --- Méthodes Utilitaires (pour la conversion JSON) ---

  // Factory constructor : Crée une instance de Risk à partir d'une Map (JSON)
  // Utilisé pour désérialiser les données venant de l'API.
  factory Risk.fromJson(Map<String, dynamic> json) {
    // Vérifications basiques pour éviter les erreurs si le JSON est mal formé
    if (json['name'] == null || json['description'] == null || json['category'] == null || json['impact'] == null || json['probability'] == null) {
      throw FormatException("Champs requis manquants dans le JSON pour Risk: $json");
    }

    return Risk(
      // Utilise l'opérateur ?? pour fournir une valeur par défaut (null ici) si la clé n'existe pas
      id: json['id'] as int?, // Peut être null si l'ID n'est pas encore défini
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      impact: json['impact'] as int,
      probability: json['probability'] as int,
      owner: json['owner'] as String?, // Peut être null
      mitigationPlan: json['mitigationPlan'] as String?, // Peut être null
    );
  }

  // Méthode : Convertit l'instance de Risk en une Map (JSON)
  // Utilisé pour sérialiser les données avant de les envoyer à l'API (POST, PUT).
  Map<String, dynamic> toJson() {
    return {
      // N'inclut l'ID dans le JSON que s'il n'est pas null (typiquement pour les mises à jour)
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'impact': impact,
      'probability': probability,
      // Inclut les champs optionnels seulement s'ils ne sont pas null
      if (owner != null) 'owner': owner,
      if (mitigationPlan != null) 'mitigationPlan': mitigationPlan,
    };
  }

  // --- Méthode copyWith (Très utile pour l'immutabilité) ---
  // Crée une copie de l'objet Risk, en permettant de remplacer certaines valeurs.
  // Utile dans les systèmes de gestion d'état où l'on préfère des objets immuables.
  Risk copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    int? impact,
    int? probability,
    String? owner, // Utiliser ValueGetter<String?> pour distinguer null de "non fourni" si nécessaire
    String? mitigationPlan,
  }) {
    return Risk(
      id: id ?? this.id, // Si id n'est pas fourni, utilise l'id actuel
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      impact: impact ?? this.impact,
      probability: probability ?? this.probability,
      owner: owner ?? this.owner, // Si owner est null, cela le mettra à null
      mitigationPlan: mitigationPlan ?? this.mitigationPlan,
    );
  }

  // --- Méthodes pour l'égalité et le hashCode (Bonne pratique) ---
  // Permet de comparer correctement deux instances de Risk.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Risk &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              category == other.category &&
              impact == other.impact &&
              probability == other.probability &&
              owner == other.owner &&
              mitigationPlan == other.mitigationPlan;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      category.hashCode ^
      impact.hashCode ^
      probability.hashCode ^
      owner.hashCode ^
      mitigationPlan.hashCode;


  // --- Méthode toString (Pour le débogage) ---
  // Retourne une représentation textuelle de l'objet, utile pour les logs.
  @override
  String toString() {
    return 'Risk{id: $id, name: $name, category: $category, impact: $impact, probability: $probability, owner: $owner}';
  }

}