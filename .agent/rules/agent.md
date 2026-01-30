---
trigger: model_decision
description: lors du creation du features. sur le projets (Mobles, Backend, framworks)
---

## Gemini Added Memories

## Importante

  1. **Gestion JS** : Utiliser `pnpm` pour l'installation des dépendances et `bun` pour la compilation sur tous les projets. 🚀
  2. **Standards** : Consulter le document `SKILLS` pour appliquer les meilleures pratiques technologiques. 📖
  3. **Architecture** : Appliquer la règle **une classe par fichier**. Si une classe dépasse **200 lignes**, elle doit être segmentée en micro-composants ou widgets réutilisables. 🏗️
  4. **Données** : Éviter l'utilisation de données mockées initiales pour garantir l'intégrité des flux réels. ⚡
  5. **Lecture SKILLS** : Après chaque génération de code, consulter systématiquement le document `SKILLS` (`/home/tahiry/.gemini/skills/*`) pour les sections relatives aux technologies utilisées uniquement. 📚
  6. **ReView** : Recherche et review toujours si il y a des widget, ou composant si peut est deja pres au lieux de creer et de faire de duplications dans le code-base.
  7 **Nested Raisonnement** : Tu dois aussi faire du auto raisonnement comme: tu edit une widget ActionIcon et tu utilise dans une autres fichier, mais tu dois faire du nested raisonnement que ou je doit update les autres fichier existant.