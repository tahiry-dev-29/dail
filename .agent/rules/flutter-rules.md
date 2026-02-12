---
trigger: always_on
glob: lib/**/*.dart
description: Application stricte de la Clean Architecture Flutter avec hybridation Riverpod (Data) + Signals (UI), interdiction des StatefulWidget et Hooks, et respect de la règle des 120 lignes.
---
Salut Tahiry ! C'est un excellent point de départ. En tant que futur senior, il est crucial que tes règles soient parfaitement alignées avec tes contraintes (notamment l'interdiction des Hooks que tu as mentionnée dans tes préférences).

J'ai optimisé tes règles pour qu'elles soient plus strictes, plus "Senior-level" et surtout cohérentes avec l'usage exclusif de Signals pour la réactivité locale, en éliminant complètement les Hooks. 🚀

🏗 1. Architecture Flutter : Riverpod + Signals Hybrid
⚡ Principes Fondamentaux
Zéro StatefulWidget & Zéro Flutter Hooks : Utiliser exclusivement ConsumerWidget (Riverpod) pour l'accès aux données et Signals pour la réactivité locale/UI.

Règle des 120 Lignes : Toute classe/widget dépassant 120 lignes doit être segmenté en micro-composants dans le dossier widgets/.

Une classe par fichier : Strict respect de la structure atomique.

🌊 Gestion des Données (Riverpod)
Riverpod est utilisé comme la Source de Vérité et le moteur de mise en cache.

Fetching API : Utiliser exclusivement AsyncValue avec des FutureProvider ou NotifierProvider.

Immuabilité : Pas de mutation directe des états Riverpod depuis la vue.

Smart Caching :

Utiliser .autoDispose par défaut.

ref.keepAlive() pour les données persistantes (ex: Profil utilisateur).

Invalidation manuelle via ref.invalidate(provider) pour le Pull-to-refresh.

Pattern de Rendu : Utiliser .when() pour forcer la gestion des états loading et error.

🚦 Réactivité UI (Signals)
Les Signals gèrent les états éphémères et les interactions UI ultra-fluides.

Local UI State : Utiliser des signal<T>() au sein des contrôleurs ou directement dans le bloc/ pour les inputs, les switchs, ou les animations.

Computed Signals : Utiliser computed() pour dériver des états (ex: validation de formulaire) sans recalcul inutile.

Performance : Les Signals permettent de ne reconstruire que le micro-widget concerné plutôt que toute la page.

📂 Structure Tree Optimisée (Feature-First)
Plaintext
lib/
├── 📁 config/          # Routes (GoRouter), Theme (Design System Tokens)
├── 📁 core/            # DI (GetIt), Error (Failures), Network (Dio), Utils
├── 📁 shared/          # Partagé entre toutes les features
│   ├── 📁 widgets/     # UI Atoms/Molecules (Boutons, Inputs réutilisables)
│   ├── 📁 services/    # Services globaux (Storage, Location, AppService)
│   └── 📁 models/      # DTOs globaux ou ValueObjects
└── 📁 features/        # Feature-First Approach
    └── 📁 [feature_name]/ 
        ├── 📁 data/            # Models, DataSources, RepositoriesImpl
        ├── 📁 domain/          # Entities, Repositories (Interfaces), UseCases
        └── 📁 presentation/
            ├── 📁 bloc/        # Logique d'état hybride
            │   ├── [feature]_provider.dart  # Riverpod (Data fetching)
            │   └── [feature]_signals.dart   # Signals (UI State & Logic)
            ├── 📁 views/       # Scaffolds & Pages (ConsumerWidget uniquement)
            └── 📁 widgets/     # Micro-composants privés (< 120 lignes)
🛠 Standard de Code (Doxygen & Testing)
Documentation : Chaque méthode complexe doit être documentée au format Doxygen.

Tests : Utiliser Vitest pour la partie TS/Angular et les tests unitaires Flutter pour la logique domain/.

Zéro Mock Initial : Toujours privilégier les flux de données réels ou des Fakes structurés pour garantir l'intégrité.

💡 Pourquoi cette amélioration ?
Cohérence totale : On supprime les hooks qui entraient en conflit avec ta règle n°1.

Séparation des responsabilités : Riverpod s'occupe du "Quoi" (les données) et Signals du "Comment" (l'interaction utilisateur).

Scalabilité : La structure bloc/ divisée en provider et signals évite d'avoir des fichiers de logique géants.
