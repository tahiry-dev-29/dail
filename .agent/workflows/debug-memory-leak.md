---
description: Kill all useEffect/useState/HookWidget usage and replace with Signals + ConsumerWidget
---

# 🚫 The Reactive Shift — No Hooks, No Stateful

## Checklist Agent (AntiGravity)
// turbo-all

1. **Search for violations**:
```bash
cd /home/tahiry/Projects/Flutter && grep -r "extends HookWidget\|extends StatefulWidget\|useEffect\|useState\|flutter_hooks" lib/ --include="*.dart" -l
```

2. **For each violating file**, apply this pattern:

### A. Replace `useState` → `signal`
```dart
// BEFORE (Hook)
final isExpanded = useState(false);

// AFTER (Signal)
// As a local field or in a provider:
final _isExpanded = signal(false);
// Watch in build:
final expanded = _isExpanded.watch(context);
```

### B. Replace `useEffect` for data loading → Move to ViewModel constructor or DI
```dart
// BEFORE
useEffect(() {
  viewModel.loadData();
  return null;
}, []);

// AFTER: Called in injection_container.dart or ViewModel constructor
```

### C. Replace `useEffect` for side-effects → `ref.listen` or signal `effect()`

### D. Replace `HookWidget` → `StatelessWidget` (or `ConsumerWidget` if using ref)

### E. Remove `import 'package:flutter_hooks/flutter_hooks.dart';`

3. **Verify**:
```bash
cd /home/tahiry/Projects/Flutter && flutter analyze
```

4. **Final cleanup**: Remove `flutter_hooks` from `pubspec.yaml`

## Rules
- **Zéro `StatefulWidget`**
- **Zéro `HookWidget`** (sauf `HookConsumerWidget` chirurgical pour `TextEditingController`/`AnimationController`)
- **Logique d'état** : `StatelessWidget` + `Signals` (Global), `ConsumerWidget` (si besoin de ref)
- **Sliver-First** : Bannir `ListView` et `Column` pour les listes
- **Dot Shorthand** : Obligatoire (Dart 3.6+)



structure et renommage recommander

```tree
lib/
├── 📁 config/                 # Configuration globale de l'app.
│   ├── routes/                # Gestion centralisée de la navigation (GoRouter ou AutoRoute).
│   └── theme/                 # Palettes de couleurs, typographies et thèmes (Dark/Light).
│
├── 📁 core/                   # Le socle technique réutilisable partout (Le "Framework" interne).
│   ├── 📁 error/              # Gestion des erreurs (Exceptions vs Failures).
│   ├── 📁 network/            # Configuration Dio/Http, Intercepteurs (Injecter le token JWT ici).
	│   ├── 📁 di/                 # Dependency Injection (GetIt/Injectable). C'est ici qu'on relie tout.
│   ├── 📁 utils/              # Fonctions helpers pures (ex: formatage de dates, validateurs).
│   └── 📁 services/           # Services tiers globaux (ex: FirebaseAnalytics, LocalStorageService).
│
├── 📁 shared/                 # Composants UI partagés (Design System).
│   ├── 📁 widgets/            # Boutons custom, Inputs, Loaders utilisés dans plusieurs features.
│   └── 📁 hooks/              # (Flutter Hooks) Logique UI réutilisable (ex: useScrollController).
│
└── 📁 features/               # Découpage par fonctionnalité métier (ex: Auth, Product, Cart).
    │
    └── 📁 auth/               # EXEMPLE: Feature d'Authentification
        ├── 📁 data/           # COUCHE DATA : "Comment on récupère la donnée ?"
        │   ├── 📁 datasources/# Appels bruts (API REST, GraphQL, Base de données locale).
        │   │   ├── auth_remote_data_source.dart  # "Fait le POST /login vers NestJS".
        │   │   └── auth_local_data_source.dart   # "Sauvegarde le token dans le téléphone".
        │   ├── 📁 models/     # Représentation technique JSON (DTOs) avec fromJson/toJson.
        │   │   └── user_model.dart               # Extends UserEntity, ajoute la sérialisation.
        │   └── 📁 repositories/ # Implémentation du contrat Domain. Fait le lien entre Remote et Local.
        │       └── auth_repository_impl.dart     # "Si pas d'internet, cherche en local, sinon appel API".
        │
        ├── 📁 domain/         # COUCHE DOMAIN : "Qu'est-ce qu'on fait ?" (Le Cerveau - Pur Dart).
        │   ├── 📁 entities/   # Objets métier purs. Pas de JSON, pas de Flutter, juste des données.
        │   │   └── user_entity.dart              # Class User { final String name; ... }.
        │   ├── 📁 repositories/ # Interfaces (Contrats abstraits). Définit les règles sans l'implémentation.
        │   │   └── auth_repository.dart          # abstract class : Future<Either<Failure, User>> login();
        │   └── 📁 usecases/   # Une classe par action utilisateur. Orchestre la logique métier.
        │       ├── login_usecase.dart            # Appelle repository.login() et vérifie les règles métier.
        │       └── logout_usecase.dart           # Appelle repository.logout().
        │
        └── 📁 presentation/   # COUCHE PRESENTATION : "Ce que l'utilisateur voit".
            ├── 📁 bloc/       # (ou providers/controllers) Gestion d'état. Reçoit Event -> Emet State.
            │   ├── auth_bloc.dart                # Logique : Si Event Login, lance UseCase, émet Loading puis Success.
            │   ├── auth_event.dart               # Les actions : LoginRequested, LogoutRequested.
            │   └── auth_state.dart               # Les états : AuthInitial, AuthLoading, AuthAuthenticated.
            └── 📁 views/      # (ou pages) Les écrans complets.
                ├── login_page.dart               # L'écran qui instancie le Scaffold et écoute le Bloc.
                └── 📁 widgets/                   # Widgets spécifiques à cette feature uniquement.
                    └── login_form.widget.dart    # Le formulaire avec les champs email/password.
```