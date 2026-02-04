---
trigger: model_decision
description: lors du creation du features. sur le projets (Mobles, Backend, framworks)
---

---

## 📜 Manifeste du Développeur Senior (Tahiry Edition)

### 1. La Règle d'Or : "The Dependency Flow"

**Règle :** Les dépendances pointent toujours vers l'intérieur (vers le Domain).

* **Domain** ne connaît personne (Pur Dart).
* **Data** connaît **Domain** (pour implémenter les interfaces).
* **Presentation** connaît **Domain** (pour appeler les UseCases).
* **Strictement Interdit :** Importer un `Model` ou une `DataSource` dans une `View`.

### 2. Services & Injection (DI)

**Règle :** Pas de Singletons statiques (`static Instance`).

* Toutes les classes doivent recevoir leurs dépendances via le **constructeur**.
* Utilise `GetIt` ou un système de `Providers` pour injecter les instances.
* **Pourquoi ?** Pour pouvoir remplacer n'importe quel service par un `Mock` lors des tests.

### 3. Modélisation : Entity vs DTO

**Règle :** Une `@Collection` Isar ou une `@Entity` NestJS n'est **JAMAIS** affichée directement dans l'UI.

* **DTO/Model :** Contient les annotations techniques (`@Id`, `@Index`, `fromJson`).
* **Entity :** Contient uniquement les champs métier (`String`, `int`, `DateTime`).
* **Mapper :** Chaque Model doit avoir une méthode `.toEntity()` pour passer de la couche Data à la couche Domain.

### 4. Logique Métier : Le UseCase Unique

**Règle :** Une action utilisateur = Un UseCase.

* Le `Bloc` ou le `Controller` ne calcule rien. Il appelle `execute()`.
* Un UseCase ne fait qu'**une seule chose** (Single Responsibility).
* *Exemple :* `DeleteFolderUseCase` gère la suppression du dossier, mais aussi la vérification si le dossier est vide.

---

## 🚀 Nouvelles règles pour aller encore plus loin

### 5. La Gestion des Erreurs : "Functional Error Handling"

**Règle :** Ne jamais utiliser de `try/catch` dans l'UI.

* Utilise le package **`dartz`** ou un pattern `Result<T>` pour retourner soit une `Failure`, soit la `Data`.
* **Signature Senior :** `Future<Either<Failure, List<Block>>> getBlocks();`
* Cela force le développeur UI à traiter le cas d'erreur explicitement.

### 6. Le Design System : "No Random Widgets"

**Règle :** Si un `Padding`, une `Color` ou un `SizedBox` est répété 2 fois, il doit être dans le `Design System`.

* Utilise ton dossier `atoms/` et `molecules/`.
* Un développeur Senior ne tape jamais `Colors.blue`. Il utilise `AppColors.primary`.

### 7. Performance : "Signals & Const"

**Règle :** Minimiser les reconstructions (Rebuilds).

* Utilise le mot-clé `const` partout où c'est possible.
* Avec les **Signals**, assure-toi de n'écouter (`.watch`) que la partie spécifique de l'état nécessaire. Pas besoin de reconstruire toute la page pour un petit loader.

### 8. Clean Code NestJS (Côté Backend)

Puisque tu es Full-Stack :

* **Validation :** Utilise toujours `class-validator` avec des DTOs pour tes entrées.
* **Interceptors :** Pour transformer tes réponses API de manière globale.
* **Business Logic :** Sort la logique des `Controllers` pour la mettre dans des `Services` dédiés.

---

### 📂 Résumé de la structure cible (Tree Final)

```text
lib/
├── core/
│   ├── di/               # "Chain d'assemblage" (GetIt)
│   ├── error/            # "Failures" classes
│   └── theme/            # Design System (Atoms)
├── features/
│   └── feature_name/
│       ├── data/         # Models, RepositoriesImpl, DataSources
│       ├── domain/       # Entities, Repositories (Interfaces), UseCases
│       └── presentation/ # BLoC/Signals, Pages, Widgets (Molecules)

```

## Gemini Added Memories

## Importante

  1. **Gestion JS** : Utiliser `pnpm` pour l'installation des dépendances et `bun` pour la compilation sur tous les projets. 🚀
  2. **Standards** : Consulter le document `SKILLS` pour appliquer les meilleures pratiques technologiques. 📖
  3. **Architecture** : Appliquer la règle **une classe par fichier**. Si une classe dépasse **200 lignes**, elle doit être segmentée en micro-composants ou widgets réutilisables. 🏗️
  4. **Données** : Éviter l'utilisation de données mockées initiales pour garantir l'intégrité des flux réels. ⚡
  5. **Lecture SKILLS** : Après chaque génération de code, consulter systématiquement le document `SKILLS` (`/home/tahiry/.gemini/skills/*`) pour les sections relatives aux technologies utilisées uniquement. 📚
  6. **ReView** : Recherche et review toujours si il y a des widget, ou composant si peut est deja pres au lieux de creer et de faire de duplications dans le code-base.
  7 **Nested Raisonnement** : Tu dois aussi faire du auto raisonnement comme: tu edit une widget ActionIcon et tu utilise dans une autres fichier, mais tu dois faire du nested raisonnement que ou je doit update les autres fichier existant.
  8 **stateFulWidget vs hooks** :Global State / Async Data : Utilise ConsumerWidget + Riverpod (AsyncValue). C'est ton équivalent RxResource.

Local State (Formulaires, Animations) : Utilise HookConsumerWidget (Flutter Hooks) car tu veux éviter StatefulWidget à tout prix.