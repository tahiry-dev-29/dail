---
name: Flutter 2026 Standards
description: Evolution "Clean Code" de 2026 pour Flutter (Dart 3.6+, Slivers, Dot Shorthand)
---

# 🚀 Flutter 2026 Standards

Ce guide définit les standards de développement pour les projets Flutter en 2026, optimisant la productivité et les performances.

## 📝 Modifications Majeures

* **Dot Shorthand (Dart 3.6+)** : Suppression de la redondance des types pour les Enums et Static Constants.
  - *Avant :* `MainAxisAlignment.center`, `FontWeight.bold`
  - *Après :* `.center`, `.bold`
* **Sliver-First Architecture** : Utilisation systématique de `CustomScrollView` au lieu du combo `Column` + `ListView`.
* **SliverMainAxisGroup** : Grouper logiquement des Slivers (Header + List) tout en conservant le lazy loading.
* **Optimisation mémoire** : Éviter les listes imbriquées avec hauteurs fixes.

## 📂 Structure du Projet (Micro-composants)

```text
lib/
├── ui/
│   ├── shared/
│   │   └── widgets/
│   │       └── custom-dash-text.dart  (Naming: dash-separated)
│   └── features/
│       └── dashboard/
│           ├── widgets/
│           │   ├── dashboard-header.dart
│           │   └── dashboard-list-item.dart
│           └── dashboard-screen.dart
└── core/
    └── providers/
        └── dashboard-provider.dart
```

## 💻 Exemple d'Implémentation (Dashboard 2026)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverMainAxisGroup(
            slivers: [
              const SliverToBoxAdapter(
                child: DashboardHeader(),
              ),
              const DashboardList(), // Implicitly a Sliver
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Flutter 2026 Update",
        textAlign: .center, // Dot Shorthand
        style: const TextStyle(
          fontWeight: .w700, // Dot Shorthand
          fontSize: 24,
        ),
      ),
    );
  }
}
```

## 🛠️ Rappels Techniques

1. **SDK Version** : `pubspec.yaml` doit avoir `sdk: '>=3.6.0'`.
2. **Performance** : Les Slivers sont gérés de manière atomique par le moteur.
3. **Maintien** : Tester chaque partie du scroll indépendamment via les micro-composants.
4. **Conformité** : Toujours consulter les **Règles de l'IDE** et le **SKILLS Global** après avoir pris connaissance de ce document spécifique.
