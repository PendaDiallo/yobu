# YOBU — Brief design & coordination Claude Design ↔ Claude Code

## 0. Le problème que ce doc résout

Tu vas utiliser Claude pour le design **et** Claude Code pour le dev. Le piège classique, celui qui va te coûter ta semaine 3 si tu ne le désamorces pas maintenant :

> Claude Design produit de jolies maquettes en HTML/Tailwind. Claude Code doit les traduire en Flutter. La traduction est approximative. Tu passes ton temps à faire le pont entre les deux, à la main, écran par écran.

**La parade : ce n'est pas la maquette qui fait autorité, c'est le fichier de tokens en Dart.**

```
docs/03-design-brief.md   ──►  Claude Design : produit les maquettes
        │                              │
        └──► lib/shared/theme/ ◄───────┘  les tokens Dart sont la source de vérité
                    │
                    └──► Claude Code : implémente en consommant les tokens
```

**Le protocole, en 3 règles :**
1. **Le design system s'écrit en Dart AVANT toute maquette** (jour 2). C'est `lib/shared/theme/tokens.dart` + les 9 widgets du socle dans `lib/shared/widgets/` (§3). Les 4 autres arrivent avec leur feature.
2. **Claude Design ne dessine jamais un composant qui n'existe pas dans le design system.** Si une maquette a besoin d'un nouveau composant, il s'ajoute d'abord au système, puis on dessine.
3. **Claude Code n'écrit jamais une couleur ou un padding en dur.** Uniquement `AppColors.x`, `AppSpacing.y`. Si un token manque, il le demande — il ne l'invente pas.

Résultat : la maquette devient une *référence de composition*, pas une spec pixel. Claude Code n'a plus à « traduire », il assemble des composants qui existent déjà.

## 1. Direction artistique — « Affirmé » (direction B, choisie le 17/07)

**Ce que YOBU doit dire en 2 secondes :** *fiable, matinal, local, moderne — et pas un truc de startup pour bobos.*

**Le principe qui fait la modernité de cette direction, et ce n'est pas la couleur : c'est la hiérarchie.**

> Sur un écran mal designé, tout a la même importance. Sur celui-ci, **le prix écrase le reste**, l'itinéraire vient ensuite, le conducteur en dernier. L'utilisateur lit dans l'ordre où il décide. Les coins à 22px et la typo à 800 ne font que suivre.

- **Pas** l'esthétique BlaBlaCar/Uber (bleu-violet, illustrations 3D génériques, anglicismes). Tes utilisateurs prennent le car rapide, pas des VTC.
- **Pas** non plus le dépouillement utilitaire à la Wave. Wave est un outil ; YOBU est un choix qu'on fait chaque matin.
- **Oui** : contraste fort, gros chiffres, coins généreux, beaucoup d'air. Photos de vraies personnes. Français simple.
- **Les neutres sont teintés vert**, jamais gris pur. C'est ce qui fait qu'un écran tient ensemble sans qu'on sache pourquoi.

**Le test du design :** ton utilisateur ouvre l'app à 6h20, une main sur le portail, puis la rouvre à 18h en plein soleil. Est-ce qu'il trouve son bouton **les deux fois** ?

> ⚠️ **Ce qui a changé entre la maquette et les tokens.** Dans la maquette B, le CTA était blanc sur le vert vif `#00B368`. J'ai calculé : **2,7:1 de contraste** — ça échoue le minimum d'accessibilité (4,5:1), et ça échoue *surtout* en plein soleil dakarois, exactement là où tu ne peux pas te le permettre.
>
> **Correction : le CTA passe au vert profond `#05301C`** (14,5:1 en blanc dessus). Le vert vif reste, mais **comme accent uniquement** — points, pastilles, états actifs. **Jamais de texte blanc sur `#00B368`.** C'est plus beau *et* plus lisible : un CTA vert-très-foncé sur blanc, c'est la signature des interfaces modernes de 2026.

## 2. Tokens — à écrire dans `lib/shared/theme/tokens.dart` le jour 2

```dart
class AppColors {
  // ── Primaire — vert profond. Distinct de Wave (bleu) et Orange Money (orange).
  static const primary       = Color(0xFF05301C);  // CTA, texte fort, avatars. 14,5:1 en blanc dessus.
  static const primaryVivid  = Color(0xFF00B368);  // ACCENT SEULEMENT : points, pastilles, états actifs.
                                                   // ⚠️ JAMAIS de texte blanc dessus (2,7:1 — illisible au soleil).
  static const primaryMint   = Color(0xFF6EE7A8);  // texte/icônes SUR primary (9,4:1)
  static const primarySurface= Color(0xFFF4F7F5);  // panneaux, fonds de section

  // ── Neutres — TEINTÉS VERT, jamais gris pur. C'est ce qui fait la cohérence.
  static const ink           = Color(0xFF05301C);  // texte principal (= primary, volontairement)
  static const inkMuted      = Color(0xFF7A8B82);  // texte secondaire, labels
  static const line          = Color(0xFFD3DED8);  // bordures, séparateurs
  static const surface       = Color(0xFFFFFFFF);  // cartes
  static const background    = Color(0xFFEFF1F0);  // fond d'écran

  // ── Sémantiques
  static const success       = Color(0xFF00B368);  // accepté, confirmé
  static const warning       = Color(0xFFF2A900);  // prix hors fourchette, étoiles
  static const danger        = Color(0xFFD92D20);  // refus, annulation
}

class AppSpacing {
  static const xs = 4.0;  static const sm = 8.0;   static const md = 16.0;
  static const lg = 24.0; static const xl = 32.0;  static const xxl = 48.0;
}

class AppRadius {
  static const sm = 10.0;   // pastilles, petits éléments
  static const md = 14.0;   // boutons, champs, panneaux internes
  static const lg = 22.0;   // cartes — le geste signature de la direction B
  static const full = 999.0;
}

class AppText {
  // Plus Jakarta Sans via google_fonts. Poids 500/700/800 uniquement — jamais de light.
  // L'échelle est VOLONTAIREMENT très contrastée : c'est elle qui porte la hiérarchie.
  static const display = TextStyle(fontSize: 34, fontWeight: FontWeight.w800, height: 1.0,  letterSpacing: -1.0);  // LE PRIX
  static const h1      = TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2,  letterSpacing: -0.5);
  static const h2      = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.35, letterSpacing: -0.2);
  static const body    = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.5);
  static const bodySm  = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.45);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.4);
  static const label   = TextStyle(fontSize: 10, fontWeight: FontWeight.w700, height: 1.3,  letterSpacing: 0.9);  // UPPERCASE
}
```

**Contraintes non négociables :**
- **Taille minimum : 12** (uniquement pour `label` en majuscules et `caption`). Le corps de texte ne descend jamais sous **13**. Pas de light, jamais : poids 500 minimum.
- Cible tactile minimum : **48 × 48**.
- **Contraste 4.5:1 minimum, vérifié.** C'est la contrainte qui a tué le CTA vert vif — elle n'est pas décorative, c'est du soleil dakarois.
- Le CTA principal d'un écran est **toujours** en bas, pleine largeur, **56 de haut, `AppRadius.md`, fond `primary`, texte blanc**.
- **Chiffres en `tabular-nums`** partout (prix, heures). Sinon les colonnes dansent d'une carte à l'autre.
- **Le prix est toujours le plus gros élément de sa carte.** C'est la règle qui définit cette direction — si un écran la viole, c'est l'écran qui a tort.

## 3. Les 13 composants du design system

Rien d'autre n'existe. Tous les écrans se composent de ces 13 briques.

**Socle — les 9 du J2.** Ils sont transverses : plusieurs écrans en dépendent, et `UserCard`/`TripCard` en dépendent entre eux.

| Composant | Fichier | Rôle |
|---|---|---|
| `YobuButton` | `shared/widgets/yobu_button.dart` | variants: `primary`, `secondary`, `ghost`, `danger` · états: normal/loading/disabled |
| `YobuTextField` | `yobu_text_field.dart` | label, hint, erreur, suffixe |
| `YobuAvatar` | `yobu_avatar.dart` | photo + fallback initiales + pastille « vérifié » |
| `StarRating` | `star_rating.dart` | 1-5 étoiles. **Deux modes : lecture** (dans `UserCard`, dès le J5) **et saisie** (écran `rating`, J14) |
| `UserCard` | `user_card.dart` | avatar + nom + `StarRating` en lecture + nb trajets + badges |
| `TripCard` | `trip_card.dart` | **le composant central** — origine→destination, heure, prix, places, conducteur |
| `RouteDisplay` | `route_display.dart` | la ligne verticale point A → point B avec les labels |
| `DayPicker` | `day_picker.dart` | L M M J V S D en pastilles sélectionnables |
| `EmptyState` | `empty_state.dart` | illustration + message + CTA |

**Ajoutés au fil des features.** Chacun arrive **le jour où son premier écran est codé** — inutile de les faire au J2.

| Composant | Fichier | Pour | Quand |
|---|---|---|---|
| `PlaceField` | `place_field.dart` | `trip_create` (J7), `search` (J9) — `YobuTextField` + suggestions Places + état « sélectionné » | J7 |
| `WhatsAppButton` | `whatsapp_button.dart` | `trip_detail`, `trip_requests` (J11), `bookings` (J13) — ouvre `wa.me/221...` | J11 |
| `RouteMap` | `route_map.dart` | `trip_detail` (J11) — la carte avec l'itinéraire + le point de pickup | J11 |
| `TagChip` | `tag_chip.dart` | `rating` (J14) — tags rapides sélectionnables | J14 |

> **`TripCard` mérite 80 % du soin du design.** Il apparaît sur `search_results`, `trip_my_list`, `bookings`, `home`. Si cette carte est bonne, l'app est bonne. Fais-la en premier, fais-la bien.

> **Plus de `ChatBubble` ni de `MessageComposer`** — le chat intégré est coupé (`01-produit.md §2`). Le contact passe par WhatsApp. Si tu vois une bulle de message dans une maquette, quelqu'un travaille sur l'ancienne version du plan.

> **Trois exceptions assumées** : le champ OTP segmenté (`otp_verify`), le pager 3 slides (`welcome`) et le time picker (`trip_create`) se font en Flutter natif, dans leur écran. Ils ne servent qu'une fois — les promouvoir en composants serait de l'abstraction préventive. Pour le time picker, `showTimePicker` de Material suffit : ne le redessine pas.

## 4. Le prompt à donner à Claude pour le design

Copie-colle ça, en joignant ce fichier et `01-produit.md` :

```
Tu es le designer produit de YOBU, une app de covoiturage domicile-travail à Dakar.
Contexte : docs/01-produit.md et docs/03-design-brief.md (joints).

Produis les maquettes de l'écran [NOM] en HTML+Tailwind, format mobile 390×844.

CONTRAINTES ABSOLUES :
- Utilise UNIQUEMENT les couleurs, espacements et typos définis dans les tokens du brief.
  Traduis-les en classes Tailwind arbitraires si besoin : bg-[#0F8B4C], p-[16px]...
- Utilise UNIQUEMENT les 13 composants du design system (§3). Si tu as besoin d'autre
  chose, DIS-LE au lieu de l'inventer.
- Texte en français, du vrai contenu sénégalais : "Keur Massar → Plateau", "6:45",
  "1 000 F", des prénoms réels (Awa, Moussa, Fatou, Ibrahima).
- Pas de lorem ipsum. Pas d'icônes décoratives.
- Montre les 3 états : normal, chargement, vide/erreur.
- **Le prix est le plus gros élément de sa carte.** C'est la règle de la direction B (§1).
- **JAMAIS de texte blanc sur #00B368** — 2,7:1, illisible au soleil. Le vert vif est un accent.

Livrable : un seul fichier HTML, les 3 états côte à côte.
```

Puis, pour passer à Claude Code :

```
Implémente l'écran [NOM] en Flutter d'après la maquette jointe.
Consomme lib/shared/theme/tokens.dart et lib/shared/widgets/ — n'écris AUCUNE
valeur en dur. Si la maquette utilise une valeur absente des tokens, arrête-toi
et dis-le-moi.
```

## 5. Quand designer — la règle qui évite le piège

**Ne planifie pas de « vagues de design » séparées de la roadmap.** C'est la façon la plus sûre de te retrouver à dessiner au J15 un écran que tu as codé au J5 — et donc soit à jeter la maquette, soit à réécrire le code. Un dev solo qui fait les deux métiers n'a pas besoin d'un calendrier de design : il a besoin d'une **règle**.

> **La règle : le design d'un écran se fait au début de la session du jour où tu le codes.**
> 30 à 45 minutes, en ouverture de journée. Maquette → validation → code. Même journée, même contexte, aucun pont à faire.

Ça marche parce que le design system existe depuis le J2 : tu ne dessines pas *ex nihilo*, tu **composes** avec des briques déjà implémentées (9 au J2, 13 au total). Une maquette d'écran devient une décision de composition, pas un travail graphique.

**Les deux seules exceptions :**

- **`TripCard`, au J2**, avec le design system. C'est le composant central, il apparaît sur 4 écrans, et tout le reste en dépend. Celui-là, tu le soignes hors de toute urgence d'écran. Prends la demi-journée.
- **L'onboarding (`welcome`), au J16.** Il se dessine **en dernier**, une fois que tu sais ce que tu vends. C'est contre-intuitif et c'est le bon ordre — l'onboarding promet ce que le produit tient, et tu ne le sais qu'à la fin.

**Ce que tu ne fais jamais :** designer le soir, ou le week-end. Le week-end est ta marge (`04-roadmap.md §Les règles du mois`). Si le design d'un écran ne tient pas dans les 45 minutes du matin, c'est que l'écran est trop chargé — **coupe l'écran, pas ton sommeil.**
