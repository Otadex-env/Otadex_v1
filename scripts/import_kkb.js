/**
 * OTADEX — Import Kuroko no Basket vers Firestore
 * Lit Kuroko_no_Basket_Personnages_OTADEX_2026.docx et insère les données dans Firebase Firestore.
 * Usage : node scripts/import_kkb.js
 * Prérequis : npm install mammoth firebase-admin (à la racine du projet)
 */

const mammoth = require("mammoth");
const admin = require("firebase-admin");
const path = require("path");

// Note sécurité : serviceAccountkey.json ne doit JAMAIS être commité dans git
const serviceAccount = require("../serviceAccountkey.json");
console.log("............................................");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

// ─────────────────────────────────────────────
// 1. DONNÉES ANIMÉ
// ─────────────────────────────────────────────
const animeData = {
  id: "kuroko-no-basket",
  titre: "Kuroko no Basket",
  titreJaponais: "黒子のバスケ",
  synopsis:
    "Tetsuya Kuroko, ancien sixième fantôme de la légendaire Génération des Miracles, rejoint le lycée Seirin avec Taiga Kagami pour affronter les cinq anciens coéquipiers qui ont renié le basket collectif. Ensemble ils vont défier les meilleurs lycées du Japon dans l'Interhigh et la Winter Cup.",
  genres: ["Shōnen", "Sport", "Action", "Comédie", "Drama"],
  annee: 2012,
  episodes: {
    saison1: 25,
    saison2: 25,
    saison3: 25,
    film: 1,
  },
  studio: "Production I.G",
  studioId: "production-ig",
  auteur: "Tadatoshi Fujimaki",
  auteurId: "tadatoshi-fujimaki",
  editeur: "Shūeisha — Weekly Shōnen Jump",
  editeurVF: "Kazé Manga",
  volumes: 30,
  chapitres: 276,
  scoreMal: "8.04/10",
  statut: "Terminé",
  coverImage: "",
  bannerImage: "",
  type: "manga_adapte",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 2. DONNÉES CRÉATEUR
// ─────────────────────────────────────────────
const creatorData = {
  id: "tadatoshi-fujimaki",
  nom: "Tadatoshi Fujimaki",
  nomJaponais: "藤巻 忠俊",
  bio: "Tadatoshi Fujimaki naît le 9 juin 1982 à Tokyo, Japon. Il fait ses études à la Toyama High School puis à l'Université Sophia à Yotsuya. Grand fan de basket depuis l'enfance, il est influencé par Slam Dunk (Takehiko Inoue). En 2006, il participe au Jump Manga Rookie Award avec un one-shot de Kuroko no Basuke. En janvier 2009, la série complète débute dans le Weekly Shōnen Jump et rencontre un succès massif. La série se conclut en septembre 2014 après 30 volumes. Ses passe-temps sont le golf et le Mah-jong ; son équipe NBA préférée est les Los Angeles Clippers.",
  dateNaissance: "9 juin 1982",
  lieuNaissance: "Tokyo, Japon",
  nationalite: "Japonais",
  imageUrl: "",
  occupation: "Mangaka",
  oeuvres: [
    { titre: "One-shot Kuroko no Basuke", annee: 2006, type: "One-shot Jump Rookie Award" },
    { titre: "Kuroko no Basuke (one-shot)", annee: 2007, type: "Publié dans Jump the Revolution!" },
    { titre: "Kuroko no Basuke", annee: 2009, type: "Manga — 30 volumes — Weekly Shōnen Jump" },
    { titre: "Kuroko no Basuke -Replace- (vol.1–5)", annee: 2011, type: "Light novel illustré — Jump J-Books" },
    { titre: "Kuroko no Basuke: Extra Game", annee: 2014, type: "Manga spin-off — 2 volumes — Shōnen Jump NEXT!" },
    { titre: "Kuroko no Basket: Last Game", annee: 2017, type: "Film — supervision scénario" },
  ],
  recompenses: [
    "Jump Manga Rookie Award 2006 (12e rang — one-shot)",
    "Jump Manga Rookie Award nov. 2006 (12e rang — Kuroko no Basuke)",
    "Regain d'intérêt majeur pour le basket au Japon et dans la communauté anime mondiale",
    "Fujimaki classé 19e au 3e sondage de popularité officiel de sa propre série (622 votes)",
  ],
  influences: [
    "Slam Dunk (Takehiko Inoue)",
    "3x3 EYES",
    "JoJo's Bizarre Adventure",
    "Chris Paul (NBA — Los Angeles Clippers)",
  ],
  animeIds: ["kuroko-no-basket"],
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 3. DONNÉES STUDIO
// ─────────────────────────────────────────────
const studioData = {
  id: "production-ig",
  nom: "Production I.G",
  nomComplet: "株式会社プロダクション・アイジー",
  fondation: 1987,
  fondateur: "Mitsuhisa Ishikawa",
  siege: "Musashino, Tokyo, Japon",
  description:
    "Studio d'animation japonais de premier plan fondé en 1987, filiale du groupe IG Port. Reconnu pour ses animations cinématographiques de haute qualité et ses adaptations fidèles de mangas populaires. Réalisateur KnB : Shunsuke Tada (3 saisons + Last Game). Musiques : GRANRODEO (openings) et OLDCODEX (endings).",
  productions: [
    "Kuroko no Basket (Saisons 1, 2, 3 + Last Game)",
    "Ghost in the Shell (1995)",
    "Haikyuu!!",
    "Attack on Titan (Saison 2)",
    "Eden of the East",
    "Psycho-Pass",
  ],
  animeIds: ["kuroko-no-basket"],
  logoUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 4. DONNÉES PERSONNAGES (13)
// ─────────────────────────────────────────────
const characters = [
  // ── #1 Seijūrō Akashi ──
  {
    id: "knb-akashi-seijuro",
    nom: "Seijūrō Akashi",
    nomJaponais: "赤司 征十郎",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "20 décembre — Sagittaire",
    taille: "173 cm — 64 kg",
    groupeSanguin: "AB",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste principal / Capitaine",
    rang: "Génération des Miracles — Meneur",
    poste: "Meneur (Point Guard)",
    lycee: "Rakuzan (anciennement Collège Teikō)",
    description:
      "Seijūrō Akashi est le personnage le plus complexe et le plus redouté de Kuroko no Basket. Ancien capitaine absolu de la Génération des Miracles à Teikō, il est désormais meneur et capitaine du lycée Rakuzan, champion national incontesté. Héritier d'une des familles les plus influentes du Japon, il a développé une dualité de personnalité : sa personnalité originelle bienveillante a été supplantée par une persona froide et tyrannique proclamant ses ordres 'absolus'. Cette deuxième personnalité possède les Emperor Eyes, vision prophétique qui lui permet d'anticiper et de contrer tout mouvement adverse. La bataille finale contre Seirin révèle le retour de son vrai moi.",
    pouvoirs: [
      "Emperor Eye (Œil de l'Empereur) : prédiction infaillible des mouvements et du centre de gravité de tout adversaire",
      "Emperor Eye Renforcé : extension permettant d'observer toute l'équipe simultanément",
      "Ankle Break : déséquilibre et fait tomber l'adversaire via les Emperor Eyes",
      "Passe parfaite : distribution du jeu d'une précision chirurgicale",
      "Zone — Team Zone : capacité unique à faire entrer toute l'équipe de Rakuzan en Zone",
      "Dribble et changement de direction : maîtrise technique absolue",
    ],
    voixJaponaise: "Hiroshi Kamiya",
    voixAnglaise: "Robbie Daymond",
    relations: [
      { nomPersonnage: "Tetsuya Kuroko", type: "Rival / Ancien équipier" },
      { nomPersonnage: "Taiga Kagami", type: "Rival décisif" },
      { nomPersonnage: "Ryōta Kise", type: "Ancien équipier (Teikō)" },
      { nomPersonnage: "Shintarō Midorima", type: "Ancien équipier (Teikō)" },
      { nomPersonnage: "Daiki Aomine", type: "Ancien équipier (Teikō)" },
      { nomPersonnage: "Atsushi Murasakibara", type: "Ancien équipier (Teikō)" },
    ],
    citations: [
      "Je ne perds jamais. Soit je gagne, soit je meurs.",
      "Mes ordres sont absolus. Ils transcendent toute logique humaine.",
    ],
    trivia: [
      "Seul personnage ayant des yeux hétérochromatiques : droit rouge (normal), gauche jaune-orange (Emperor Eye activé)",
      "Classé #1 au 3e sondage de popularité officiel Weekly Shōnen Jump avec 6 276 votes",
      "Héritier d'une des familles les plus influentes du Japon — élevé dans l'excellence absolue",
      "La défaite contre Seirin marque le retour de sa personnalité originelle bienveillante",
    ],
    popularityRank: 1,
    isNew: false,
    isTrending: true,
    likesCount: 6276,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi7.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi8.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi9.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi10.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi11.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi12.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi13.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Seijūrō%20Akashi/knb_akashi1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #2 Tetsuya Kuroko ──
  {
    id: "knb-kuroko-tetsuya",
    nom: "Tetsuya Kuroko",
    nomJaponais: "黒子 テツヤ",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "31 janvier — Verseau",
    taille: "168 cm — 57 kg",
    groupeSanguin: "A",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste principal",
    rang: "Génération des Miracles — Sixième Joueur Fantôme",
    poste: "Sixième joueur / Passeur fantôme",
    lycee: "Seirin (anciennement Collège Teikō)",
    description:
      "Tetsuya Kuroko est le protagoniste principal de Kuroko no Basket. Sixième joueur fantôme de la légendaire Génération des Miracles, sa présence est si ténue que personne ne le remarque sur le terrain. Ce don de quasi-invisibilité est l'arme absolue d'un meneur de jeu altruiste et déterminé. Contrairement aux cinq Miracles qui ont sombré dans l'égocentrisme du talent pur, Kuroko a toujours cru au basket collectif et à la force des liens. Sa philosophie — être l'ombre qui amplifie la lumière de ses partenaires — est le cœur narratif de la série.",
    pouvoirs: [
      "Misdirection : détourne l'attention adverse, rendant ses passes et sa présence invisibles",
      "Invisible Pass : passe sans aucun signe avant-coureur — déchire les défenses",
      "Ignite Pass / Ignite Pass Kai : passe accélérée vers l'extérieur avec version spin renforcée",
      "Vanishing Drive : dribble basé sur la misdirection pour traverser la défense",
      "Phantom Shot : tir à faible parabole avec misdirection — quasi indétectable",
      "Misdirection Overflow : état de misdirection permanente sur tout le terrain",
      "Emperor Eye (version Kuroko) : anticipation des passes, non des mouvements",
    ],
    voixJaponaise: "Kenshō Ono",
    voixAnglaise: "Scott Gibbs",
    relations: [
      { nomPersonnage: "Taiga Kagami", type: "Partenaire — Lumière actuelle" },
      { nomPersonnage: "Daiki Aomine", type: "Ancienne Lumière / Rival" },
      { nomPersonnage: "Seijūrō Akashi", type: "Ancien capitaine" },
      { nomPersonnage: "Satsuki Momoi", type: "Amie — Intérêt romantique" },
      { nomPersonnage: "Riko Aida", type: "Coach" },
    ],
    citations: [
      "Je suis le fantôme qui fait briller les lumières.",
      "Le basket ne se joue pas seul. C'est ça que la Génération des Miracles a oublié.",
    ],
    trivia: [
      "Classé #1 aux 1er et 2e sondages de popularité — détrôné par Akashi au 3e",
      "Son chien Tetsuya n°2 (husky) lui ressemble trait pour trait",
      "Seul membre de la Génération des Miracles dont Kise ne peut pas copier les techniques",
      "Satsuki Momoi est la seule personne capable de percevoir naturellement sa présence",
    ],
    popularityRank: 2,
    isNew: false,
    isTrending: true,
    likesCount: 3505,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok7.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tetsuya%20Kuroko/knb_kurok1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #3 Kazunari Takao ──
  {
    id: "knb-takao-kazunari",
    nom: "Kazunari Takao",
    nomJaponais: "高尾 和成",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "12 août — Lion",
    taille: "175 cm — 64 kg",
    groupeSanguin: "O",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Régulier non-Miracle",
    poste: "Meneur (Point Guard)",
    lycee: "Shūtoku",
    description:
      "Kazunari Takao est le meneur de l'équipe de Shūtoku et le partenaire de Shintarō Midorima. Bien que n'étant pas membre de la Génération des Miracles, il est considéré comme l'un des joueurs les plus talentueux en dehors de ce groupe d'élite. Sa personnalité espiègle et décontractée contraste avec le sérieux rigide de Midorima. Son Hawk Eye lui permet de neutraliser la Misdirection de Kuroko — faisant de lui le rival direct du protagoniste. Il est classé 3e au sondage de popularité officiel, preuve de sa popularité exceptionnelle pour un personnage non-Miracle.",
    pouvoirs: [
      "Hawk Eye (Œil du Faucon) : vision périphérique parfaite de tout le terrain — counter direct à la Misdirection",
      "Passes de précision : distribution rapide et précise pour Midorima",
      "Dribble pénétrant : maîtrise du un-contre-un pour créer des décalages",
      "Intelligence tactique : lecture du jeu supérieure à la plupart des lycéens",
    ],
    voixJaponaise: "Yoshimasa Hosoya",
    voixAnglaise: "Blake Shepard",
    relations: [
      { nomPersonnage: "Shintarō Midorima", type: "Partenaire de jeu indissociable" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Rival respectueux" },
    ],
    citations: [
      "Midorima, accroche-toi ! Je vais te faire briller.",
      "Ton invisibilité ne marche pas sur moi, Kuroko.",
    ],
    trivia: [
      "Classé 3e au sondage de popularité — 1er personnage non-Miracle dans le top 3",
      "Running gag : transporte Midorima sur un pousse-pousse (rickshaw)",
      "Son Hawk Eye est le seul pouvoir capable de contrecarrer la Misdirection de Kuroko",
      "Personnalité espiègle qui force Midorima à sourire malgré lui",
    ],
    popularityRank: 3,
    isNew: false,
    isTrending: true,
    likesCount: 2539,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao6.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Kazunari%20Takao/knb_takao1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #4 Ryōta Kise ──
  {
    id: "knb-kise-ryota",
    nom: "Ryōta Kise",
    nomJaponais: "黄瀬 涼太",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "18 juin — Gémeaux",
    taille: "189 cm — 77 kg",
    groupeSanguin: "A",
    nationalite: "Japonaise (fictive)",
    statut: "Rival / Protagoniste secondaire",
    rang: "Génération des Miracles — Petit Ailier",
    poste: "Petit Ailier (Small Forward)",
    lycee: "Kaijō (anciennement Collège Teikō)",
    description:
      "Ryōta Kise est le membre le plus jeune de la Génération des Miracles et le seul à avoir commencé le basket en lycée junior. Son pouvoir de Perfect Copy lui permet de reproduire instantanément et d'améliorer n'importe quelle technique qu'il observe. Mannequin professionnel aux traits saisissants, sa relation envers Kuroko est empreinte d'un respect sincère. Il est le seul Miracle à appeler Kuroko 'Kurokocchi' avec tendresse.",
    pouvoirs: [
      "Perfect Copy : copie et améliore instantanément toute technique observée",
      "Perfect Copy — Génération des Miracles : reproduction des techniques de TOUS les Miracles simultanément",
      "Agilité surhumaine : vitesse et réactivité exceptionnelle au rebond et en défense",
      "Zone : accès après forte motivation — démultiplie toutes ses capacités",
      "Limites : ne peut pas copier Kuroko (invisible) ni l'Emperor Eye d'Akashi",
    ],
    voixJaponaise: "Ryōhei Kimura",
    voixAnglaise: "Greg Ayres",
    relations: [
      { nomPersonnage: "Daiki Aomine", type: "Mentor admiré — veut le surpasser" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Ami respectueux (l'appelle Kurokocchi)" },
      { nomPersonnage: "Seijūrō Akashi", type: "Ancien capitaine" },
    ],
    citations: [
      "Kurokocchi ! Attends-moi, je vais te surpasser !",
      "Je peux copier n'importe qui… mais pas toi, Kuroko.",
    ],
    trivia: [
      "Le seul de la Génération des Miracles à appeler Kuroko par un surnom affectueux (Kurokocchi)",
      "Mannequin professionnel actif en parallèle de sa carrière lycéenne de basket",
      "Seul Miracle à ne pas avoir eu de background dans le basket avant le lycée junior",
      "Son Perfect Copy des Miracles le rend theoriquement plus puissant que chaque individu",
    ],
    popularityRank: 4,
    isNew: false,
    isTrending: false,
    likesCount: 2392,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Ryōta%20Kise/knb_kise1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Ryōta%20Kise/knb_kise2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Ryōta%20Kise/knb_kise3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Ryōta%20Kise/knb_kise4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Ryōta%20Kise/knb_kise5.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Ryōta%20Kise/knb_kise1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #5 Taiga Kagami ──
  {
    id: "knb-kagami-taiga",
    nom: "Taiga Kagami",
    nomJaponais: "火神 大我",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "2 août — Lion",
    taille: "190 cm — 82 kg",
    groupeSanguin: "A",
    nationalite: "Japonaise (fictive) — formé aux États-Unis",
    statut: "Co-protagoniste",
    rang: "Régulier — Le Miracle qui n'en était pas un",
    poste: "Ailier Fort (Power Forward)",
    lycee: "Seirin",
    description:
      "Taiga Kagami est le co-protagoniste et la 'lumière' de Kuroko. Formé aux États-Unis, il incarne la force brute taillée par un entraînement acharné — à l'opposé des dons naturels des Miracles. Aomine le qualifie de 'Miracle qui n'en était pas un', car il possède les mêmes aptitudes mais les a développées par le travail. Sa détente surhumaine et sa Zone en font progressivement un égal pour chaque membre des Miracles. À la fin de la série, il rejoint la NBA.",
    pouvoirs: [
      "Détente surhumaine : saut qui augmente au fil du match",
      "Zone : état de concentration absolue démultipliant toutes les capacités",
      "Zone Directe : forme améliorée guidant ses coéquipiers en Zone simultanément",
      "Réflexes de défense : bloque des tirs considérés comme indéfendables",
      "Affinité avec Kuroko : instinct naturel pour les passes invisibles de son partenaire",
    ],
    voixJaponaise: "Yūki Ono",
    voixAnglaise: "Leraldo Anzaldua",
    relations: [
      { nomPersonnage: "Tetsuya Kuroko", type: "Partenaire — Ombre" },
      { nomPersonnage: "Tatsuya Himuro", type: "Grand frère américain" },
      { nomPersonnage: "Alexandra Garcia", type: "Entraîneuse américaine" },
      { nomPersonnage: "Daiki Aomine", type: "Rival principal" },
      { nomPersonnage: "Riko Aida", type: "Coach" },
    ],
    citations: [
      "Je suis la lumière qui illumine l'ombre de Kuroko.",
      "Je ne regrette rien. Chaque match m'a rapproché de la NBA.",
    ],
    trivia: [
      "Porte des Nike Air Jordan pointure 47 — détail récurrent dans la série",
      "A grandi aux États-Unis et formé par Alexandra Garcia, ancienne joueuse NBA féminine",
      "Qualifié de 'Miracle qui n'en était pas un' par Aomine — la plus grande reconnaissance possible",
      "À la fin de la série, il rejoint la NBA — seul lycéen à y parvenir dans l'univers KnB",
    ],
    popularityRank: 5,
    isNew: false,
    isTrending: false,
    likesCount: 2288,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam7.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam8.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam9.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam10.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Taiga%20Kagami/knb_kagam1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #6 Shintarō Midorima ──
  {
    id: "knb-midorima-shintaro",
    nom: "Shintarō Midorima",
    nomJaponais: "緑間 真太郎",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "7 juillet — Cancer",
    taille: "195 cm — 79 kg",
    groupeSanguin: "B",
    nationalite: "Japonaise (fictive)",
    statut: "Rival",
    rang: "Génération des Miracles — Arrière",
    poste: "Arrière (Shooting Guard)",
    lycee: "Shūtoku (anciennement Collège Teikō)",
    description:
      "Shintarō Midorima est le tireur absolu de la Génération des Miracles, doté d'une précision 100% depuis n'importe quel point du terrain — y compris depuis le milieu de terrain, voire au-delà. Rigide, arrogant et superstitieux à l'extrême, il consulte son horoscope quotidiennement et transporte un objet chanceux différent chaque jour. Son évolution révèle un tsundere au code d'honneur intact. Son duo avec Takao est l'une des dynamiques les plus appréciées de la série.",
    pouvoirs: [
      "Tir de précision absolue depuis n'importe où sur le terrain : efficacité 100%",
      "Tir longue distance (mi-terrain, ligne opposée) : technique unique dans la série",
      "Gaucher : sa main gauche bandée en dehors des matchs — rituel de protection",
      "Défense solide : niveau correct grâce à sa taille et son envergure",
      "Vice-Capitaine de Teikō : rôle organisationnel sous Akashi",
    ],
    voixJaponaise: "Daisuke Ono",
    voixAnglaise: "David Wald",
    relations: [
      { nomPersonnage: "Kazunari Takao", type: "Partenaire de duo — complémentarité parfaite" },
      { nomPersonnage: "Seijūrō Akashi", type: "Ancien capitaine respecté" },
      { nomPersonnage: "Taiga Kagami", type: "Rival estimé" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Mépris initial → respect croissant" },
    ],
    citations: [
      "Le Cancer est le signe le plus fort. C'est une certitude, pas une opinion.",
      "Je ne manque jamais. C'est un principe, pas une prétention.",
    ],
    trivia: [
      "Consulte l'horoscope télévisé 'Oha-Asa' chaque matin sans exception",
      "Porte un objet chanceux différent chaque jour selon son horoscope — running gag emblématique",
      "Gaucher — bande sa main gauche hors des matchs pour la préserver",
      "Peut tirer depuis n'importe où sur le terrain avec 100% de précision — feat unique dans la série",
    ],
    popularityRank: 6,
    isNew: false,
    isTrending: false,
    likesCount: 1983,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Shintarō%20Midorima/knb_midori1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Shintarō%20Midorima/knb_midori2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Shintarō%20Midorima/knb_midori3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Shintarō%20Midorima/knb_midori4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Shintarō%20Midorima/knb_midori5.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Shintarō%20Midorima/knb_midori1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #7 Daiki Aomine ──
  {
    id: "knb-aomine-daiki",
    nom: "Daiki Aomine",
    nomJaponais: "青峰 大輝",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "31 août — Vierge",
    taille: "192 cm — 85 kg",
    groupeSanguin: "B",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste secondaire",
    rang: "Génération des Miracles — Ailier Fort",
    poste: "Ailier Fort (Power Forward)",
    lycee: "Tōō Academy (anciennement Collège Teikō)",
    description:
      "Daiki Aomine est le joueur le plus athlétiquement dominant de la Génération des Miracles et l'ancien partenaire de Kuroko à Teikō. Il a sombré dans un nihilisme baskettistique total après avoir surpassé tous ses adversaires : 'Le seul qui peut me battre, c'est moi.' Son Formless Shot le rend quasi indéfendable. Sa défaite contre Kagami lors de la Winter Cup marque son véritable réveil et la reconstruction de son amour pour le basket.",
    pouvoirs: [
      "Formless Shot (Tir Sans Forme) : tir depuis des angles et positions impossibles, biomécanique indéchiffrable",
      "Vitesse panther : accélération et changement de direction surhumains — le plus rapide de la série",
      "Zone : entre en zone par instinct pur au contact d'un adversaire fort",
      "Style street-ball : jeu non-orthodoxe inspiré du basket de rue américain",
      "Instinct bestial : adaptation instantanée au niveau de l'adversaire",
    ],
    voixJaponaise: "Junichi Suwabe",
    voixAnglaise: "Andrew Love",
    relations: [
      { nomPersonnage: "Tetsuya Kuroko", type: "Ancienne Lumière / Lien brisé puis réparé" },
      { nomPersonnage: "Satsuki Momoi", type: "Amie d'enfance — Manageuse" },
      { nomPersonnage: "Taiga Kagami", type: "Rival décisif — lui a redonné le goût du basket" },
      { nomPersonnage: "Ryōta Kise", type: "Rival respectueux" },
    ],
    citations: [
      "Le seul qui peut me battre, c'est moi.",
      "Je ne m'ennuie que quand les autres sont trop faibles pour me défier.",
    ],
    trivia: [
      "Son nihilisme est né de n'avoir jamais trouvé d'adversaire à sa hauteur",
      "Sèche les entraînements et joue uniquement par instinct — attitude symbolisant le revers du talent absolu",
      "Fan de magazines de charme — running gag récurrent",
      "Sa défaite contre Kagami est le tournant psychologique central de la série",
    ],
    popularityRank: 7,
    isNew: false,
    isTrending: false,
    likesCount: 1670,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin7.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin8.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin9.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin10.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin11.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin12.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin13.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Daiki%20Aomine/knb_aomin1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #8 Atsushi Murasakibara ──
  {
    id: "knb-murasakibara-atsushi",
    nom: "Atsushi Murasakibara",
    nomJaponais: "紫原 敦",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Masculin",
    dateNaissance: "9 octobre — Balance",
    taille: "208 cm — 99 kg",
    groupeSanguin: "O",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste secondaire",
    rang: "Génération des Miracles — Pivot",
    poste: "Pivot (Center)",
    lycee: "Yōsen (anciennement Collège Teikō)",
    description:
      "Atsushi Murasakibara est le pivot de la Génération des Miracles, le joueur le plus imposant physiquement de toute la série. Mesurant 208 cm, il représente une forteresse défensive quasi infranchissable. Enfantin, indolent et perpétuellement en train de manger des snacks, il se désintéresse du basket qu'il trouve trop facile. Son personnage illustre la thèse inverse de Kuroko : que peut-on faire d'un talent naturel sans amour du jeu ?",
    pouvoirs: [
      "Bouclier d'Égide (Aegis Shield) : défense de raquette hermétique — bloque tout tir dans sa zone",
      "Thor's Hammer : dunk signature à deux mains avec rotation à 180° — inarrêtable hors de la Zone",
      "Envergure naturelle : portée de bras couvrant une surface défensive inégalée",
      "Cancel : annihilation de tout tir à portée de ses bras tendus",
      "Longue foulée : couvre le terrain rapidement malgré sa taille",
    ],
    voixJaponaise: "Kenichi Suzumura",
    voixAnglaise: "David Matranga",
    relations: [
      { nomPersonnage: "Tatsuya Himuro", type: "Meilleur ami — figure de grand frère" },
      { nomPersonnage: "Seijūrō Akashi", type: "Ancien capitaine — seul à lui obéir" },
      { nomPersonnage: "Taiga Kagami", type: "Rival décisif dans la Zone" },
    ],
    citations: [
      "Le basket, c'est ennuyeux. Les autres sont tous trop faibles.",
      "Si Muro-chin dit que c'est important… alors peut-être que je vais jouer pour de vrai.",
    ],
    trivia: [
      "Mange constamment des snacks sucrés — running gag permanent",
      "Seul membre de la Génération des Miracles qui obéissait à Akashi sans discuter",
      "Son amitié avec Himuro est le seul lien émotionnel qui compte vraiment pour lui",
      "Sa confrontation avec Kagami est la première fois qu'il prend le basket au sérieux",
    ],
    popularityRank: 8,
    isNew: false,
    isTrending: false,
    likesCount: 856,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras7.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras8.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras9.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras10.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Atsushi%20Murasakibara/knb_muras1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #9 Tatsuya Himuro ──
  {
    id: "knb-himuro-tatsuya",
    nom: "Tatsuya Himuro",
    nomJaponais: "氷室 辰也",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans (2e année)",
    sexe: "Masculin",
    dateNaissance: "30 octobre — Scorpion",
    taille: "183 cm — 70 kg",
    groupeSanguin: "A",
    nationalite: "Japonaise (fictive) — formé aux États-Unis",
    statut: "Rival / Antagoniste secondaire",
    rang: "Régulier d'élite",
    poste: "Arrière (Shooting Guard)",
    lycee: "Yōsen",
    description:
      "Tatsuya Himuro est l'arrière de Yōsen et l'ami d'enfance de Taiga Kagami aux États-Unis. Calme, élégant et d'une froideur calculée sur le terrain, il incarne le style 'orthodoxe' à l'opposé du jeu instinctif de Kagami. Leur rivalité est teintée d'une affection fraternelle profonde. Son Mirage Shot est une technique de tir en deux temps qui trompe le bloqueur adverse sur le moment réel du lâcher.",
    pouvoirs: [
      "Mirage Shot : tir en deux phases — la première est un leurre, la deuxième est le vrai lâcher",
      "Fake Pass : feinte de passe parfaite rendant ses décisions imprévisibles",
      "Dribble pénétrant élégant : style technique proche du professionnel américain",
      "Leadership émotionnel sur Murasakibara : seul à pouvoir le motiver ou le calmer",
    ],
    voixJaponaise: "Yoshimasa Hosoya",
    voixAnglaise: "Blake Shepard",
    relations: [
      { nomPersonnage: "Taiga Kagami", type: "Petit frère de cœur / Rival" },
      { nomPersonnage: "Atsushi Murasakibara", type: "Coéquipier — ami à protéger" },
    ],
    citations: [
      "Kagami. Notre pacte de jadis… il est terminé ce soir.",
      "Le basket ne ment pas. La technique pure finit toujours par parler.",
    ],
    trivia: [
      "Présente un beauty mark sous l'œil droit — très populaire auprès des personnages féminins",
      "Seul personnage capable de raisonner Murasakibara en situation de match tendu",
      "Son lien avec Kagami remonte à l'enfance aux États-Unis — ils se considèrent comme frères",
      "Son Mirage Shot est l'une des techniques les plus difficiles à contrer de toute la série",
    ],
    popularityRank: 9,
    isNew: false,
    isTrending: false,
    likesCount: 925,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro7.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Tatsuya%20Himuro/knb_himuro1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #10 Satsuki Momoi ──
  {
    id: "knb-momoi-satsuki",
    nom: "Satsuki Momoi",
    nomJaponais: "桃井 さつき",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans",
    sexe: "Féminin",
    dateNaissance: "4 août — Lion",
    taille: "165 cm",
    groupeSanguin: "",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Manageuse — Analyste de génie",
    poste: "Manageuse et analyste de Tōō",
    lycee: "Tōō Academy (anciennement Collège Teikō)",
    description:
      "Satsuki Momoi est la manageuse de l'équipe de Tōō et l'amie d'enfance de Daiki Aomine. Bien qu'elle ne joue pas sur le terrain, ses capacités analytiques font d'elle l'un des personnages les plus redoutables de la série. Elle peut prédire le niveau de jeu de n'importe quel joueur après une seule observation, grâce à une mémoire photographique et une intelligence tactique exceptionnelle. Elle est seule à avoir 'battu' Kuroko dans la mémoire de ce dernier.",
    pouvoirs: [
      "Analyse totale : évaluation précise du potentiel et des limites d'un joueur après observation",
      "Mémoire photographique tactique : retient statistiques, habitudes et faiblesses de tout adversaire",
      "Prédiction de jeu : anticipe les schémas tactiques avec précision",
      "Perception de Kuroko : seule à percevoir naturellement sa présence — contourne la Misdirection",
    ],
    voixJaponaise: "Junko Minagawa",
    voixAnglaise: "Brittney Karbowski",
    relations: [
      { nomPersonnage: "Daiki Aomine", type: "Ami d'enfance — Partenaire" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Intérêt romantique non partagé" },
    ],
    citations: [
      "Kuroko-kun ! Je t'ai cherché partout… comment tu fais pour être invisible ?",
      "Les statistiques ne mentent pas. Je connais chaque adversaire mieux qu'il ne se connaît lui-même.",
    ],
    trivia: [
      "Seul personnage féminin du top 20 du sondage de popularité officiel",
      "Seule à percevoir naturellement la présence de Kuroko — ce qui lui vaut d'avoir 'gagné' contre lui",
      "Amie d'Aomine depuis le primaire — le connaît mieux que quiconque",
      "Son analyse prédit les évolutions de jeu avant qu'elles ne se produisent",
    ],
    popularityRank: 10,
    isNew: false,
    isTrending: false,
    likesCount: 732,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Satsuki%20Momoi/knb_momoi1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Satsuki%20Momoi/knb_momoi2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Satsuki%20Momoi/knb_momoi3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Satsuki%20Momoi/knb_momoi4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Satsuki%20Momoi/knb_momoi5.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Satsuki%20Momoi/knb_momoi1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #11 Junpei Hyūga ──
  {
    id: "knb-hyuga-junpei",
    nom: "Junpei Hyūga",
    nomJaponais: "日向 順平",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "17 ans (2e année)",
    sexe: "Masculin",
    dateNaissance: "4 octobre — Balance",
    taille: "178 cm — 68 kg",
    groupeSanguin: "B",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste secondaire",
    rang: "Régulier — Capitaine Seirin",
    poste: "Arrière (Shooting Guard) — Capitaine",
    lycee: "Seirin",
    description:
      "Junpei Hyūga est le capitaine et l'arrière de l'équipe du lycée Seirin. Leader au caractère tranchant, il cache une détermination farouche et une technique redoutable. Sa spécialité est le tir en conditions de pression extrême — il performe significativement mieux dans les moments décisifs, d'où son surnom de 'Roi du 4e quart-temps' ou Clutch Player.",
    pouvoirs: [
      "Barrier Jumper : tir en reculant pour créer de la distance face au bloqueur",
      "Step-back Shot : maîtrise parfaite du tir en recul",
      "Clutch Player : performance amplifiée dans les situations décisives de fin de match",
      "Leadership vocal : meneur de vestiaire, motivateur principal de l'équipe",
    ],
    voixJaponaise: "Yoshimasa Hosoya",
    voixAnglaise: "Jay Hickman",
    relations: [
      { nomPersonnage: "Riko Aida", type: "Coach" },
      { nomPersonnage: "Teppei Kiyoshi", type: "Co-fondateur de Seirin" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Coéquipier" },
    ],
    citations: [
      "Je suis le Roi du 4e quart-temps. Et les rois ne flanchent pas.",
      "Seirin ne perd pas. Pas sous ma capitainerie.",
    ],
    trivia: [
      "Surnommé 'Roi du 4e quart-temps' car sa précision augmente sous la pression",
      "Co-fondateur du club de basket de Seirin avec Kiyoshi",
      "Personnalité bougonne en façade mais dévoué totalement à son équipe",
      "Ses Barrier Jumper sont pratiquement imprenables — angles que les défenseurs ne peuvent anticiper",
    ],
    popularityRank: 11,
    isNew: false,
    isTrending: false,
    likesCount: 680,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga7.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga8.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Junpei%20Hyūga/knb_hyuga1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #12 Teppei Kiyoshi ──
  {
    id: "knb-kiyoshi-teppei",
    nom: "Teppei Kiyoshi",
    nomJaponais: "木吉 鉄平",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "18 ans (3e année)",
    sexe: "Masculin",
    dateNaissance: "10 novembre — Scorpion",
    taille: "193 cm — 90 kg",
    groupeSanguin: "B",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste secondaire",
    rang: "Roi sans Couronne — Pivot",
    poste: "Pivot (Center)",
    lycee: "Seirin",
    description:
      "Teppei Kiyoshi est le pivot de Seirin et l'un des fondateurs de leur club de basket. Surnommé 'Iron Heart' pour sa résilience mentale absolue, il est l'un des Cinq 'Rois sans Couronne' — joueurs considérés comme les égaux potentiels de la Génération des Miracles. Il a dû interrompre sa première saison à cause d'une blessure grave au genou sabotée par Hanamiya Makoto. Son retour en jouant malgré la douleur est l'un des moments les plus poignants de la série.",
    pouvoirs: [
      "Right of Postponement : permet à ses coéquipiers d'attraper son rebond — passes guidées",
      "Vice Claws : dribble en crochets permettant de contourner les défenses",
      "Rebond stratégique : maîtrise du positionnement pour capter et redistribuer",
      "Résistance physique : continue à jouer sur genou blessé — mental de fer",
    ],
    voixJaponaise: "Toshiyuki Toyonaga",
    voixAnglaise: "Chris Patton",
    relations: [
      { nomPersonnage: "Junpei Hyūga", type: "Co-fondateur de Seirin" },
      { nomPersonnage: "Hanamiya Makoto", type: "Rival — l'a blessé intentionnellement" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Coéquipier / Rôle paternel" },
    ],
    citations: [
      "Un cœur de fer ne se brise pas. Même blessé, je jouerai.",
      "Le basket, c'est fait pour être partagé. C'est pour ça que Seirin est unique.",
    ],
    trivia: [
      "Surnommé 'Iron Heart' pour sa résilience psychologique et physique absolue",
      "L'un des Cinq Rois sans Couronne — joueurs non-Miracles au niveau équivalent",
      "Sa blessure au genou sabotée par Hanamiya est l'une des intrigues les plus sombres de la série",
      "Joue la Winter Cup avec un genou blessé — symbolise le sacrifice ultime pour l'équipe",
    ],
    popularityRank: 12,
    isNew: false,
    isTrending: false,
    likesCount: 744,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos7.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Teppei%20Kiyoshi/knb_kiyos1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #13 Riko Aida ──
  {
    id: "knb-aida-riko",
    nom: "Riko Aida",
    nomJaponais: "相田 リコ",
    animeId: "kuroko-no-basket",
    animeName: "Kuroko no Basket",
    auteurId: "tadatoshi-fujimaki",
    auteurNom: "Tadatoshi Fujimaki",
    studioId: "production-ig",
    studioNom: "Production I.G",
    age: "16 ans (2e année)",
    sexe: "Féminin",
    dateNaissance: "4 décembre — Sagittaire",
    taille: "155 cm",
    groupeSanguin: "",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste secondaire",
    rang: "Coach — Entraîneuse du lycée Seirin",
    poste: "Coach / Entraîneuse",
    lycee: "Seirin",
    description:
      "Riko Aida est l'entraîneuse de l'équipe de basket du lycée Seirin, malgré son jeune âge. Fille du légendaire entraîneur Kagetora Aida, elle a hérité de son talent pour l'analyse physique : en regardant une seule fois le corps d'un joueur, elle évalue instantanément ses statistiques complètes. Cette capacité unique lui permet de concevoir des programmes d'entraînement sur mesure ultra-efficaces. Directe, exigeante et parfois violente avec ses joueurs, elle est profondément dévouée à leur développement.",
    pouvoirs: [
      "Analyse physique visuelle instantanée : évalue les statistiques complètes d'un joueur au premier regard",
      "Conception de programmes d'entraînement ultra-personnalisés",
      "Tactique défensive et offensive : stratège adaptative en temps réel",
      "Cuisine catastrophique : ses plats sont imbuvables — running gag célèbre",
    ],
    voixJaponaise: "Iida Yukana",
    voixAnglaise: "Emily Neves",
    relations: [
      { nomPersonnage: "Kagetora Aida", type: "Père et mentor légendaire" },
      { nomPersonnage: "Junpei Hyūga", type: "Capitaine — relation de confiance" },
      { nomPersonnage: "Tetsuya Kuroko", type: "Joueur clé" },
    ],
    citations: [
      "Je n'ai pas besoin d'être grande pour entraîner les plus grands.",
      "Mes programmes d'entraînement sont parfaits. C'est vous qui devez être à la hauteur.",
    ],
    trivia: [
      "Sa cuisine est connue pour être dangereusement mauvaise — running gag emblématique de la série",
      "Fille de Kagetora Aida — entraîneur légendaire ayant formé certains des Rois sans Couronne",
      "Son analyse physique visuelle est aussi précise que des données médicales",
      "Entraîneuse de lycée à 16 ans — la plus jeune coach compétitive de la série",
    ],
    popularityRank: 13,
    isNew: false,
    isTrending: false,
    likesCount: 390,
    images: [
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida1.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida2.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida3.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida4.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida5.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida6.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida7.jpeg",
      "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida8.jpeg",
    ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Kuroko%20no%20basket/Riko%20Aida/knb_aida1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },
];

// ─────────────────────────────────────────────
// 5. DONNÉES QUIZ (7 personnages × 5 questions)
// ─────────────────────────────────────────────
const quizzes = [
  // Akashi
  {
    characterId: "knb-akashi-seijuro",
    questions: [
      {
        question: "Quel surnom désigne la capacité visuelle signature d'Akashi ?",
        options: ["Hawk Eye", "Emperor Eye", "Phantom Eye", "God Eye"],
        correctIndex: 1,
      },
      {
        question: "De quel lycée Akashi est-il le capitaine dans la série principale ?",
        options: ["Shūtoku", "Tōō", "Kaijō", "Rakuzan"],
        correctIndex: 3,
      },
      {
        question: "Comment s'appelle la technique d'Akashi qui fait tomber ses adversaires ?",
        options: ["Vanishing Drive", "Ankle Break", "Mirage Shot", "Formless Shot"],
        correctIndex: 1,
      },
      {
        question: "Quelle caractéristique physique unique signale l'activation de son Emperor Eye ?",
        options: [
          "Ses cheveux deviennent blancs",
          "Son œil gauche devient jaune-orange",
          "Ses deux yeux deviennent rouges",
          "Il développe un aura bleue",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui est le seul duo à avoir battu Akashi et Rakuzan ?",
        options: [
          "Aomine et Momoi",
          "Midorima et Takao",
          "Kuroko et Kagami",
          "Kise et Kasamatsu",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Kuroko
  {
    characterId: "knb-kuroko-tetsuya",
    questions: [
      {
        question: "Quel surnom désigne le don de quasi-invisibilité de Kuroko ?",
        options: ["Phantom Sight", "Misdirection", "Ghost Presence", "Vanish Aura"],
        correctIndex: 1,
      },
      {
        question: "Comment s'appelle la technique de tir de Kuroko à faible parabole ?",
        options: ["Ignite Pass", "Vanishing Drive", "Phantom Shot", "Emperor Eye"],
        correctIndex: 2,
      },
      {
        question: "Qui est la seule personne pouvant naturellement percevoir la présence de Kuroko ?",
        options: ["Riko Aida", "Akashi Seijūrō", "Satsuki Momoi", "Kazunari Takao"],
        correctIndex: 2,
      },
      {
        question: "Quel animal de compagnie de Kuroko lui ressemble trait pour trait ?",
        options: ["Un chat noir", "Un shiba inu", "Un husky nommé Tetsuya n°2", "Un lapin blanc"],
        correctIndex: 2,
      },
      {
        question: "Quel était le rôle de Kuroko au sein de la Génération des Miracles à Teikō ?",
        options: [
          "Capitaine remplaçant",
          "Sixième joueur fantôme — passeur invisible",
          "Analyste statistique",
          "Meneur titulaire",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Kagami
  {
    characterId: "knb-kagami-taiga",
    questions: [
      {
        question: "Quel qualificatif Aomine donne-t-il à Kagami pour le décrire ?",
        options: [
          "Le Roi du 4e quart-temps",
          "Le Miracle qui n'en était pas un",
          "L'Ombre de Seirin",
          "Le Nouveau Roi sans Couronne",
        ],
        correctIndex: 1,
      },
      {
        question: "Dans quel pays Kagami a-t-il été formé au basket avant de rentrer au Japon ?",
        options: ["Australie", "France", "États-Unis", "Espagne"],
        correctIndex: 2,
      },
      {
        question: "Comment s'appelle l'état de concentration absolue que Kagami peut atteindre ?",
        options: ["Overdrive", "Zone", "Limit Break", "Awakening"],
        correctIndex: 1,
      },
      {
        question: "Qui a entraîné Kagami aux États-Unis ?",
        options: ["Tatsuya Himuro", "Daiki Aomine", "Alexandra Garcia", "Kagetora Aida"],
        correctIndex: 2,
      },
      {
        question: "Quelle est la carrière finale de Kagami à la fin de la série ?",
        options: ["Capitaine de l'équipe nationale japonaise", "Entraîneur à Seirin", "Joue en NBA", "Se retire du basket"],
        correctIndex: 2,
      },
    ],
  },

  // Kise
  {
    characterId: "knb-kise-ryota",
    questions: [
      {
        question: "Comment s'appelle la capacité signature de Ryōta Kise ?",
        options: ["Mirage Copy", "Perfect Copy", "Ultimate Imitation", "Mirror Skill"],
        correctIndex: 1,
      },
      {
        question: "Quelle est l'activité professionnelle de Kise en dehors du basket ?",
        options: ["Chanteur", "Acteur", "Mannequin professionnel", "Joueur de golf"],
        correctIndex: 2,
      },
      {
        question: "Quel membre de la Génération des Miracles a inspiré Kise à jouer au basket ?",
        options: ["Akashi", "Midorima", "Aomine", "Kuroko"],
        correctIndex: 2,
      },
      {
        question: "Quel surnom affectueux Kise donne-t-il à Kuroko ?",
        options: ["Kuroko-chan", "Kuro-kun", "Kurokocchi", "Tsuya"],
        correctIndex: 2,
      },
      {
        question: "Quelle capacité Kise ne peut-il pas copier avec son Perfect Copy ?",
        options: [
          "Le tir de Midorima",
          "Le Formless Shot d'Aomine",
          "La Misdirection de Kuroko",
          "Le Thor's Hammer de Murasakibara",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Aomine
  {
    characterId: "knb-aomine-daiki",
    questions: [
      {
        question: "Quelle est la phrase signature nihiliste d'Aomine sur sa propre invincibilité ?",
        options: [
          "Je suis le plus fort.",
          "Le seul qui peut me battre, c'est moi.",
          "Personne ne peut m'arrêter.",
          "Le basket est trop facile.",
        ],
        correctIndex: 1,
      },
      {
        question: "Comment s'appelle le tir signature d'Aomine depuis des angles impossibles ?",
        options: ["Phantom Shot", "Mirage Shot", "Formless Shot", "Ankle Break"],
        correctIndex: 2,
      },
      {
        question: "Qui était le partenaire de jeu (la lumière) d'Aomine à Teikō ?",
        options: ["Kise Ryōta", "Tetsuya Kuroko", "Akashi Seijūrō", "Himuro Tatsuya"],
        correctIndex: 1,
      },
      {
        question: "Dans quel lycée Aomine joue-t-il la compétition principale ?",
        options: ["Rakuzan", "Yōsen", "Shūtoku", "Tōō Academy"],
        correctIndex: 3,
      },
      {
        question: "Qui est la première personne à battre Aomine en match officiel ?",
        options: ["Tetsuya Kuroko", "Akashi Seijūrō", "Taiga Kagami", "Ryōta Kise"],
        correctIndex: 2,
      },
    ],
  },

  // Midorima
  {
    characterId: "knb-midorima-shintaro",
    questions: [
      {
        question: "Depuis quelle distance maximale Midorima peut-il tirer à 100% de précision ?",
        options: [
          "Depuis la ligne des 3 points",
          "Depuis mi-terrain",
          "Depuis n'importe quel point du terrain",
          "Depuis la ligne de fond opposée",
        ],
        correctIndex: 2,
      },
      {
        question: "Quelle habitude superstitieuse caractérise Midorima ?",
        options: [
          "Prière avant chaque match",
          "Objet chanceux quotidien selon son horoscope",
          "Rituel de brossage de dents",
          "Lecture du journal sportif",
        ],
        correctIndex: 1,
      },
      {
        question: "De quelle main Midorima tire-t-il ?",
        options: ["Droite", "Gauche", "Les deux selon les situations", "Indifférent"],
        correctIndex: 1,
      },
      {
        question: "Quel est le nom de l'émission d'horoscope que Midorima regarde chaque matin ?",
        options: ["Zodiac AM", "Oha-Asa", "Lucky Morning", "Star Guide"],
        correctIndex: 1,
      },
      {
        question: "Quel est le partenaire de jeu de Midorima à Shūtoku ?",
        options: ["Junpei Hyūga", "Taiga Kagami", "Kazunari Takao", "Teppei Kiyoshi"],
        correctIndex: 2,
      },
    ],
  },

  // Murasakibara
  {
    characterId: "knb-murasakibara-atsushi",
    questions: [
      {
        question: "Quelle est la taille exceptionnelle d'Atsushi Murasakibara ?",
        options: ["195 cm", "200 cm", "208 cm", "215 cm"],
        correctIndex: 2,
      },
      {
        question: "Comment s'appelle la défense hermétique de raquette de Murasakibara ?",
        options: ["Thor's Hammer", "Iron Wall", "Bouclier d'Égide (Aegis Shield)", "Cancel Zone"],
        correctIndex: 2,
      },
      {
        question: "Quel est le running gag lié à Murasakibara ?",
        options: [
          "Il dort pendant les entraînements",
          "Il mange constamment des snacks sucrés",
          "Il refuse de parler aux adversaires",
          "Il arrive toujours en retard",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui est le seul à pouvoir motiver et calmer Murasakibara en match ?",
        options: ["Akashi Seijūrō", "Riko Aida", "Tatsuya Himuro", "Taiga Kagami"],
        correctIndex: 2,
      },
      {
        question: "Dans quel lycée Murasakibara joue-t-il la compétition principale ?",
        options: ["Rakuzan", "Tōō", "Yōsen", "Kaijō"],
        correctIndex: 2,
      },
    ],
  },
];

// ─────────────────────────────────────────────
// SCRIPT PRINCIPAL
// ─────────────────────────────────────────────
async function importKKB() {
  console.log("🏀 Début import Kuroko no Basket dans Firestore...\n");

  // Vérification optionnelle du docx (mammoth)
  try {
    const result = await mammoth.extractRawText({
      path: path.join(__dirname, "../Kuroko_no_Basket_Personnages_OTADEX_2026.docx"),
    });
    const lineCount = result.value.split("\n").filter((l) => l.trim()).length;
    console.log(`📄 Document KnB lu avec mammoth — ${lineCount} lignes extraites`);
  } catch {
    console.log("ℹ️  mammoth non disponible — import depuis les données inline du script");
  }

  // 1. Import Animé
  await db
    .collection("animes")
    .doc("kuroko-no-basket")
    .set(animeData, { merge: true });
  console.log("✅ Animé Kuroko no Basket importé");

  // 2. Import Créateur
  await db
    .collection("creators")
    .doc("tadatoshi-fujimaki")
    .set(creatorData, { merge: true });
  console.log("✅ Créateur Tadatoshi Fujimaki importé");

  // 3. Import Studio
  await db
    .collection("studios")
    .doc("production-ig")
    .set(studioData, { merge: true });
  console.log("✅ Studio Production I.G importé");

  // 4. Import Personnages (batch write)
  const batch = db.batch();
  for (const character of characters) {
    const ref = db.collection("characters").doc(character.id);
    batch.set(ref, character, { merge: true });
    console.log(`  → ${character.nom} (${character.id})`);
  }
  await batch.commit();
  console.log(`✅ ${characters.length} personnages importés`);

  // 5. Import Quiz
  const quizBatch = db.batch();
  for (const quiz of quizzes) {
    const ref = db.collection("quizzes").doc(quiz.characterId);
    quizBatch.set(ref, quiz, { merge: true });
  }
  await quizBatch.commit();
  console.log(`✅ ${quizzes.length} quiz importés`);

  // 6. Notifier tous les users via OneSignal
  const sendNotification = require("./send_notification");
  await sendNotification({
    title: "🏀 Kuroko no Basket débarque sur OTADEX !",
    body: "La Génération des Miracles est disponible. Affronte le quiz !",
    route: "/anime/kuroko-no-basket",
    type: "new_characters",
  });

  console.log("\n🎉 Import Kuroko no Basket terminé avec succès !");
  console.log("📊 Résumé :");
  console.log("   1 animé (kuroko-no-basket)");
  console.log("   1 créateur (tadatoshi-fujimaki)");
  console.log("   1 studio (production-ig)");
  console.log(`   ${characters.length} personnages (knb-*)`);
  console.log(`   ${quizzes.length} quiz (Akashi, Kuroko, Kagami, Kise, Aomine, Midorima, Murasakibara)`);
  process.exit(0);
}

importKKB().catch((err) => {
  console.error("❌ Erreur import :", err);
  process.exit(1);
});
