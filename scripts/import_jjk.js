/**
 * OTADEX — Import JJK vers Firestore
 * Lit JJK_Personnages_OTADEX_v2.docx et insère les données dans Firebase Firestore.
 * Usage : node scripts/import_jjk.js
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
  id: "jujutsu-kaisen",
  titre: "Jujutsu Kaisen",
  titreJaponais: "呪術廻戦",
  synopsis:
    "Dans un Japon moderne où des entités surnaturelles appelées fléaux, nées des émotions négatives humaines, menacent la population. Des exorcistes capables de manipuler l'énergie occulte sont chargés de les combattre dans l'ombre.",
  genres: ["Shōnen", "Dark Fantasy", "Action", "Surnaturel", "Horreur"],
  annee: 2020,
  episodes: {
    saison1: 24,
    saison2: 23,
    saison3: 12,
  },
  studio: "MAPPA",
  studioId: "mappa",
  auteur: "Gege Akutami",
  auteurId: "gege-akutami",
  editeur: "Shueisha — Weekly Shōnen Jump",
  editeurVF: "Ki-oon",
  copiesVendues: "Plus de 150 millions (décembre 2025)",
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
  id: "gege-akutami",
  nom: "Gege Akutami",
  nomJaponais: "芥見 下々",
  bio: "Gege Akutami est le mangaka japonais créateur de Jujutsu Kaisen. Né le 26 février 1992 dans la préfecture d'Iwate, il déménage à Sendai en CM2. Extrêmement discret, son vrai nom est inconnu, il ne montre jamais son visage et se représente sous la forme d'un chat borgne ou d'un panda. Daltonien, ce qui explique ses choix de couleurs atypiques.",
  dateNaissance: "26 février 1992",
  lieuNaissance: "Préfecture d'Iwate, Japon",
  nationalite: "Japonais",
  imageUrl: "",
  occupation: "Mangaka",
  oeuvres: [
    { titre: "Kamishiro Sōsa", annee: 2014, type: "One-shot" },
    { titre: "No.9", annee: 2015, type: "One-shot" },
    { titre: "Jujutsu Kaisen 0", annee: 2017, type: "Préquel manga" },
    { titre: "Jujutsu Kaisen", annee: 2018, type: "Manga — 30 volumes" },
    { titre: "Jujutsu Kaisen Modulo", annee: 2025, type: "Suite manga" },
  ],
  recompenses: [
    "Prix 10e Jump Treasure Newcomer Manga Awards (2015)",
    "Grand Prix Mandō Kobayashi Manga (2020)",
    "Anime de l'Année Crunchyroll Awards (2021)",
  ],
  influences: [
    "Yoshihiro Togashi",
    "Tite Kubo",
    "Masashi Kishimoto",
    "Neon Genesis Evangelion",
  ],
  animeIds: ["jujutsu-kaisen"],
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 3. DONNÉES STUDIO
// ─────────────────────────────────────────────
const studioData = {
  id: "mappa",
  nom: "MAPPA",
  nomComplet: "株式会社MAPPA",
  fondation: 2011,
  fondateur: "Masao Maruyama",
  siege: "Tokyo, Japon",
  description:
    "Studio d'animation japonais fondé en 2011 par Masao Maruyama, ancien co-fondateur de Madhouse. Réputé pour la qualité exceptionnelle de ses animations et ses adaptations fidèles de mangas populaires.",
  productions: [
    "Jujutsu Kaisen (Saisons 1, 2, 3)",
    "Chainsaw Man",
    "Attack on Titan — Final Season",
    "Zombie Land Saga",
    "Yuri on Ice",
    "The God of High School",
  ],
  animeIds: ["jujutsu-kaisen"],
  logoUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 4. DONNÉES PERSONNAGES (20)
// ─────────────────────────────────────────────
const characters = [
  // ── #1 Satoru Gojo ──
  {
    id: "jjk-gojo-satoru",
    nom: "Satoru Gojo",
    nomJaponais: "五条 悟",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "28 ans (début de série)",
    sexe: "Masculin",
    dateNaissance: "7 décembre 1989 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Grade Spécial",
    description:
      "Satoru Gojo est l'exorciste de classe S le plus puissant de son époque et l'un des personnages les plus iconiques du shōnen moderne. Issu du prestigieux clan Gojo, il est le premier en 400 ans à maîtriser simultanément le Pouvoir de l'Infini (Limitless) et les Six Yeux (Rokugan). Grand, svelte, arborant des cheveux blancs et des yeux d'un bleu surnaturel dissimulés sous un bandeau noir, il allie charisme insolent et puissance quasi divine. Derrière son humour désinvolte se cache un idéaliste profond, déterminé à réformer le monde des exorcistes par l'éducation. Sa mort face à Sukuna au chapitre 236 du manga — souriant jusqu'au bout — est l'un des moments les plus tragiques de la franchise.",
    pouvoirs: [
      "Technique du Limitless (Mugen) — manipulation atomique de l'espace",
      "Infinity (Mukagen) — barrière passive contre toute attaque",
      "Blue (Ao) — attraction compressive d'un point dans l'espace",
      "Red (Aka) — répulsion explosive d'un point dans l'espace",
      "Purple Hollow — fusion Blue + Red, destruction totale linéaire",
      "Six Eyes (Rokugan) — perception divine du flux d'énergie occulte",
      "Expansion du Territoire : Infinite Void — tempête sensorielle infinie",
      "Technique Occulte Inversée — guérison et régénération",
    ],
    voixJaponaise: "Yuichi Nakamura",
    voixAnglaise: "Kaiji Tang",
    relations: [
      { nomPersonnage: "Yuji Itadori", type: "Élève" },
      { nomPersonnage: "Megumi Fushiguro", type: "Élève" },
      { nomPersonnage: "Nobara Kugisaki", type: "Élève" },
      { nomPersonnage: "Suguru Geto", type: "Rival" },
      { nomPersonnage: "Ryomen Sukuna", type: "Ennemi" },
      { nomPersonnage: "Yuta Okkotsu", type: "Élève" },
    ],
    citations: [
      "Tout seul, tu comprends ? Je suis le plus fort.",
      "Je t'apprendrai les deux choses essentielles : comment utiliser ton énergie maudite, et comment ne pas mourir.",
    ],
    trivia: [
      'Sa musique thème selon Akutami : "Mada Minu Asu Ni" (Asian Kung-Fu Generation)',
      "Fan de Digimon selon les extras officiels du manga",
      "Décédé au chapitre 236 — mort confirmée et définitive à la fin de la série",
      "Premier sorcier en 400 ans à maîtriser simultanément Limitless et les Six Yeux",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo9.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo10.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 1,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #2 Yuji Itadori ──
  {
    id: "jjk-yuji-itadori",
    nom: "Yuji Itadori",
    nomJaponais: "虎杖 悠仁",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "15–16 ans (début de série)",
    sexe: "Masculin",
    dateNaissance: "20 mars 2003 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Grade Spécial (de facto)",
    description:
      "Yuji Itadori est le protagoniste central de Jujutsu Kaisen. Lycéen ordinaire de Sendai aux capacités physiques hors du commun, il bascule dans le monde des exorcistes après avoir avalé un doigt de Ryomen Sukuna pour sauver ses amis. Condamné à mort mais obtenant un sursis de Gojo, il entreprend de collecter les 20 doigts de Sukuna. Courageux, empathique, guidé par les dernières paroles de son grand-père Wasuke, il représente l'humanité brute dans un monde de violence. Selon Jujutsu Kaisen Modulo, il est devenu immortel à la suite de la défaite de Sukuna.",
    pouvoirs: [
      "Force et vitesse physiques surhumaines — 50 mètres en 3 secondes",
      "Résistance exceptionnelle",
      "Black Flash (Rayon Noir) — record de 4 consécutifs",
      "Divergent Fist — frappe avec onde d'énergie décalée",
      "Blood Manipulation (Sekketsu Sōjutsu) — hérité des Death Painting Wombs",
      "Shrine (Mizushi) — technique occulte innée de Sukuna éveillée",
      "Expansion du Territoire — débloquée en fin de série",
    ],
    voixJaponaise: "Junya Enoki",
    voixAnglaise: "Adam McArthur",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Maître" },
      { nomPersonnage: "Megumi Fushiguro", type: "Ami" },
      { nomPersonnage: "Nobara Kugisaki", type: "Ami" },
      { nomPersonnage: "Kento Nanami", type: "Mentor" },
      { nomPersonnage: "Aoi Todo", type: "Ami" },
      { nomPersonnage: "Choso", type: "Famille" },
      { nomPersonnage: "Ryomen Sukuna", type: "Ennemi" },
    ],
    citations: [
      "Je veux mourir entouré de mes proches.",
      "Je ne sais pas si j'ai eu raison... mais je n'ai aucun regret.",
    ],
    trivia: [
      "Classé n°1 fan-favorite sur MyAnimeList en juin 2021",
      "Inspiré du prénom d'un camarade de classe de Gege Akutami",
      "Selon JJK Modulo (2025), il est devenu immortel et le plus grand sorcier de son ère en 2086",
      "A exécuté 17 Black Flash au total sur l'ensemble de la série",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_yuji1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_toji8.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_yuji1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 2,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #3 Ryomen Sukuna ──
  {
    id: "jjk-ryomen-sukuna",
    nom: "Ryomen Sukuna",
    nomJaponais: "両面 宿儺",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "Plus de 1 000 ans",
    sexe: "Masculin",
    dateNaissance: "Époque Heian (794–1185 ap. J.-C.)",
    nationalite: "Japonaise antique (fictive)",
    statut: "Antagoniste",
    rang: "Grade Spécial",
    description:
      "Ryomen Sukuna, surnommé le Roi des Fléaux, est l'antagoniste principal de Jujutsu Kaisen. Né humain à l'époque Heian, il était un exorciste si puissant que ses pairs ne pouvaient que le sceller après sa mort, disséminant ses 20 doigts aux quatre coins du Japon. Scellé dans le corps de Yuji Itadori, il attend de recouvrer sa pleine puissance. Froid, arrogant et n'obéissant qu'à ses propres désirs, Sukuna représente la malveillance absolue. Il est définitivement vaincu par Yuji Itadori au chapitre 261+ de la série.",
    pouvoirs: [
      "Énergie maudite d'un niveau incomparable",
      "Technique du Sanctuaire : Dismantle (Kai) — lames tranchantes à distance",
      "Technique du Sanctuaire : Cleave (Hachi) — attaques adaptatives",
      "Divine Flame (Kamino) — manipulation du feu et de la foudre",
      "Expansion du Territoire : Malevolent Shrine — lacère tout dans 200 m",
      "Mahoraga — invocation du shikigami adaptatif absolu",
      "Régénération quasi-instantanée",
      "Technique Occulte Inversée avancée",
    ],
    voixJaponaise: "Junichi Suwabe",
    voixAnglaise: "Ray Chase",
    relations: [
      { nomPersonnage: "Yuji Itadori", type: "Hôte" },
      { nomPersonnage: "Megumi Fushiguro", type: "Hôte" },
      { nomPersonnage: "Satoru Gojo", type: "Rival" },
      { nomPersonnage: "Kenjaku", type: "Allié" },
    ],
    citations: [
      "Ce monde m'appartient.",
      "Je suis le seul à qui il soit permis d'aller au-delà des limites.",
    ],
    trivia: [
      "Inspiré du folklore japonais — cité dans le Nihon Shoki (VIIIe siècle)",
      "Son vrai corps possède quatre bras et deux visages",
      "Définitivement vaincu au chapitre 261+ par Yuji Itadori",
      "A possédé le corps de Megumi Fushiguro dans les arcs tardifs",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_suku.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_sugu8.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_suku.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 3,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #4 Megumi Fushiguro ──
  {
    id: "jjk-megumi-fushiguro",
    nom: "Megumi Fushiguro",
    nomJaponais: "伏黒 恵",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "15 ans (début de série)",
    sexe: "Masculin",
    dateNaissance: "22 décembre 2003 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Grade 2",
    description:
      "Megumi Fushiguro est le deutéragoniste de Jujutsu Kaisen, le personnage le plus mystérieux et stratégique parmi les élèves de Gojo. Fils de Toji Fushiguro, il a été élevé sous la tutelle de Gojo pour éviter au clan Zenin de le récupérer. Héritier de la Technique des Dix Ombres, il invoque des shikigamis aux formes animales avec une intelligence tactique redoutable. Son caractère froid et utilitariste cache une profonde empathie. Sa possession par Sukuna dans les arcs tardifs constitue l'un des tournants dramatiques les plus forts de la série.",
    pouvoirs: [
      "Technique des Dix Ombres (Tokusa no Kage Bōjutsu) — invocation de shikigamis",
      "Chiens Divins, Nue, Toad, Great Serpent, Max Elephant, Rabbit Escape, Mahoraga",
      "Stockage d'armes et d'objets dans ses ombres",
      "Chimera Shadow Garden — Expansion du Territoire",
      "Mahamudra du Néant — attaque finale dévastatrice",
    ],
    voixJaponaise: "Yuma Uchida",
    voixAnglaise: "Robbie Daymond",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Maître" },
      { nomPersonnage: "Yuji Itadori", type: "Ami" },
      { nomPersonnage: "Nobara Kugisaki", type: "Ami" },
      { nomPersonnage: "Toji Fushiguro", type: "Famille" },
      { nomPersonnage: "Ryomen Sukuna", type: "Ennemi" },
    ],
    citations: [
      "Je ne suis pas là pour sauver tout le monde. Seulement les gens que je veux sauver.",
      "Je déteste perdre plus que tout.",
    ],
    trivia: [
      "2e personnage le plus populaire selon Viz Media (mars 2021)",
      "Son corps est finalement libéré après la défaite de Sukuna",
      "Héritier des 10 Ombres, l'une des techniques héréditaires les plus puissantes",
      "A été élevé par Gojo depuis l'enfance pour le soustraire au clan Zenin",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu8.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 4,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #5 Nobara Kugisaki ──
  {
    id: "jjk-nobara-kugisaki",
    nom: "Nobara Kugisaki",
    nomJaponais: "釘崎 野薔薇",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "16 ans (début de série)",
    sexe: "Féminin",
    dateNaissance: "7 août 2002 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Grade 3",
    description:
      "Nobara Kugisaki est la troisième membre du trio principal de Jujutsu Kaisen. Originaire de la campagne, elle rejoint Tokyo pour vivre pleinement et retrouver son amie d'enfance Saori. Franche, directe, refusant toute convention, sa technique du Vaudou lui permet de créer un lien entre une poupée et sa cible, infligeant des dommages à distance. Gravement blessée par Mahito à l'arc Drame de Shibuya (chapitre 123), elle réapparaît pour porter le coup décisif final contre Sukuna.",
    pouvoirs: [
      "Technique Straw Doll (Poupée de Paille) — frappe clous + poupée liée = dégâts transmis",
      "Résonance — amplification des dégâts sur les chairs maudites",
      "Hairpin (Épingle) — explosions d'énergie maudite sur une zone",
      "Marteau maudit — arme physique de corps-à-corps",
    ],
    voixJaponaise: "Asami Seto",
    voixAnglaise: "Anne Yatco",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Maître" },
      { nomPersonnage: "Yuji Itadori", type: "Ami" },
      { nomPersonnage: "Megumi Fushiguro", type: "Ami" },
      { nomPersonnage: "Mahito", type: "Ennemi" },
    ],
    citations: [
      "So what? I am me. (Et alors ? Je suis moi.)",
      "Je suis venue à Tokyo pour vivre, pas pour survivre.",
    ],
    trivia: [
      "Gravement blessée par Mahito au chapitre 123 (arc Shibuya)",
      "Réapparaît dans les arcs finaux pour infliger le coup décisif sur Sukuna",
      "Sa technique Straw Doll est basée sur le vaudou/magie de paille japonaise traditionnelle",
    ],
    images: [
      "https://s4.anilist.co/file/anilistcdn/character/large/b131940-SBIiJ8lQJBxd.jpg",
    ],
    imagePath:
      "https://s4.anilist.co/file/anilistcdn/character/large/b131940-SBIiJ8lQJBxd.jpg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 5,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #6 Suguru Geto ──
  {
    id: "jjk-suguru-geto",
    nom: "Suguru Geto",
    nomJaponais: "夏油 傑",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "27–28 ans",
    sexe: "Masculin",
    dateNaissance: "3 septembre 1989 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste",
    rang: "Grade Spécial",
    description:
      "Suguru Geto est l'antagoniste principal de Jujutsu Kaisen 0 et l'un des plus complexes de la série. Ancien camarade et meilleur ami de Satoru Gojo, il bascula dans une idéologie radicale après de profonds traumatismes. Charismatique, tragique et intellectuellement cohérent dans son délire, il incarne le villain dont on comprend le chemin sans approuver la destination. Son corps est usurpé post-mortem par Kenjaku, générant une confusion identitaire tout au long de la série.",
    pouvoirs: [
      "Manipulation des Esprits Maudits — absorption et contrôle de fléaux",
      "Stockage de 4 000+ esprits maudits contrôlables simultanément",
      "Maximum : Uzumaki — libération simultanée de tous ses fléaux",
      "Extraction de techniques depuis les esprits absorbés",
    ],
    voixJaponaise: "Takahiro Sakurai",
    voixAnglaise: "Lex Lang",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Rival" },
      { nomPersonnage: "Shoko Ieiri", type: "Ami" },
      { nomPersonnage: "Kenjaku", type: "Victime" },
    ],
    citations: [
      "Purifier le monde de cette espèce faible — c'est mon idéal.",
      "Gojo... tu es l'unique exception.",
    ],
    trivia: [
      "Son corps est usurpé post-mortem par Kenjaku",
      "Sa relation avec Gojo est explorée en profondeur dans l'arc Trésor Caché (Saison 2)",
      "Sa technique inflige des dommages psychologiques à chaque fléau absorbé",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu9.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu10.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 6,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #7 Kento Nanami ──
  {
    id: "jjk-kento-nanami",
    nom: "Kento Nanami",
    nomJaponais: "七海 健人",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "28 ans",
    sexe: "Masculin",
    dateNaissance: "20 juillet 1990 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Grade 1",
    description:
      "Kento Nanami est un ancien salaryman reconverti en exorciste de Grade 1. Pragmatique, méthodique et d'une rigueur quasi administrative, il représente l'adulte mature au milieu d'un monde chaotique. Sa relation avec Yuji est celle d'un mentor bienveillant. Sa mort sous les coups de Mahito à Shibuya — ses derniers mots \"Je te laisse ça\" — est l'une des scènes les plus dévastatrices émotionnellement de toute la franchise.",
    pouvoirs: [
      "Technique Ratio (7:3) — frappe le point faible structurel au ratio doré exact",
      'Overtime — renforcement exceptionnel hors de ses "heures de travail"',
      "Extension du Territoire : Coffin of the Iron Mountain",
      "Black Flash maîtrisé",
      "Combat corps-à-corps à la lame bandée",
    ],
    voixJaponaise: "Kenjirou Tsuda",
    voixAnglaise: "David Vincent",
    relations: [
      { nomPersonnage: "Yuji Itadori", type: "Élève" },
      { nomPersonnage: "Satoru Gojo", type: "Ami" },
      { nomPersonnage: "Shoko Ieiri", type: "Ami" },
      { nomPersonnage: "Mahito", type: "Ennemi" },
    ],
    citations: [
      "Je te laisse ça.",
      "Je fais des heures supplémentaires pour vous, les jeunes.",
    ],
    trivia: [
      "Plébiscité par les fans adultes pour son réalisme et son code moral rigoureux",
      "Ancien salaryman avant de redevenir exorciste",
      "Décédé lors de l'arc Drame de Shibuya — l'une des morts les plus marquantes",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana9.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 7,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #8 Yuta Okkotsu ──
  {
    id: "jjk-yuta-okkotsu",
    nom: "Yuta Okkotsu",
    nomJaponais: "乙骨 憂太",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "16–18 ans",
    sexe: "Masculin",
    dateNaissance: "7 mars 2000 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Grade Spécial",
    description:
      "Yuta Okkotsu est le protagoniste de Jujutsu Kaisen 0 et l'un des exorcistes les plus puissants de la franchise. Hanté par l'esprit vengeur de Rika Orimoto, son amour d'enfance décédée, il intègre l'École de Tokyo sous la tutelle de Gojo. Timide et introverti au départ, il se révèle être un exorciste de classe spéciale d'une puissance monumentale. Il est également descendant de Sugawara no Michizane.",
    pouvoirs: [
      "Rika (shikigami résiduel) — version affaiblie de l'esprit de Rika, puissance colossale",
      "Copy (Mōhō) — réplication de n'importe quelle technique occulte",
      "Réserves d'énergie occulte comparables à Gojo",
      "Technique Occulte Inversée — guérison avancée",
      "Expansion du Territoire : Authentic Mutual Love",
      "Maîtrise du combat à l'épée",
    ],
    voixJaponaise: "Megumi Ogata (JJK 0) / Gakuto Kajiwara (série TV)",
    voixAnglaise: "Kayleigh McKee / Zeno Robinson",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Maître" },
      { nomPersonnage: "Maki Zenin", type: "Ami" },
      { nomPersonnage: "Toge Inumaki", type: "Ami" },
      { nomPersonnage: "Panda", type: "Ami" },
    ],
    citations: [
      "Je veux être fort pour protéger les gens que j'aime.",
      "Rika... tu peux te reposer maintenant.",
    ],
    trivia: [
      "Protagoniste du film JJK 0 (2021) — succès mondial dépassant 13 milliards de yens",
      "Descendant de Sugawara no Michizane",
      "Utilise temporairement le corps de Gojo décédé via une technique de Kenjaku",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta9.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta10.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta11.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta12.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta13.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 8,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #9 Maki Zenin ──
  {
    id: "jjk-maki-zenin",
    nom: "Maki Zenin",
    nomJaponais: "禪院 真希",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "16–18 ans",
    sexe: "Féminin",
    dateNaissance: "20 janvier 2002 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Grade Spécial (de facto)",
    description:
      "Maki Zenin est l'une des personnalités les plus emblématiques de Jujutsu Kaisen — figure de résilience. Sa Restriction Céleste l'empêche d'utiliser l'énergie occulte, considérée comme une honte par sa famille. Plutôt que d'abandonner, elle exploite cette \"faiblesse\" pour développer des capacités physiques surhumaines et une maîtrise absolue des armes maudites. Après la destruction du clan Zenin, elle atteint un niveau de puissance comparable à Toji Fushiguro.",
    pouvoirs: [
      "Restriction Céleste (Heavenly Restriction) — physique surhumain absolu",
      "Maîtrise de toutes les armes maudites (lances, épées, katanas)",
      "Vision des fléaux grâce à des lunettes spéciales",
      "Invisibilité aux perceptions naturelles des fléaux",
      "Playful Cloud (Grade Spécial) — triple flail surpuissant",
    ],
    voixJaponaise: "Mikako Komatsu",
    voixAnglaise: "Allegra Clark",
    relations: [
      { nomPersonnage: "Yuta Okkotsu", type: "Ami" },
      { nomPersonnage: "Toge Inumaki", type: "Ami" },
      { nomPersonnage: "Megumi Fushiguro", type: "Ami" },
    ],
    citations: [
      "Je n'ai pas besoin d'énergie maudite pour être plus forte que vous.",
      "Le clan Zenin... je vais le détruire de mes propres mains.",
    ],
    trivia: [
      "L'arc massacre du clan Zenin est l'un des moments les plus violents du manga",
      "Symbole de résilience — progresse sans énergie occulte",
      "Sa jumelle Mai s'est sacrifiée pour lui donner une lame de Grade Spécial",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki8.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 9,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #10 Aoi Todo ──
  {
    id: "jjk-aoi-todo",
    nom: "Aoi Todo",
    nomJaponais: "東堂 葵",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "18 ans",
    sexe: "Masculin",
    dateNaissance: "23 septembre 2001 (fictif)",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Grade 1",
    description:
      "Aoi Todo est l'une des plus grandes surprises de Jujutsu Kaisen. Élève de l'École de Kyoto, colossal et exubérant, obsédé par son idol Takada-chan. Mais il se révèle rapidement comme l'un des combattants les plus intelligents et stratégiques. Sa philosophie : \"avoir un meilleur ami, c'est partager ses goûts musicaux.\"",
    pouvoirs: [
      "Boogie Woogie — échange instantané de position via claquement de mains",
      "Force physique colossale — Grade 1",
      "Intelligence tactique exceptionnelle",
      "Maîtrise du combat corps-à-corps",
    ],
    voixJaponaise: "Subaru Kimura",
    voixAnglaise: "Anairis Quiñones",
    relations: [
      { nomPersonnage: "Yuji Itadori", type: "Ami" },
      { nomPersonnage: "Noritoshi Kamo", type: "Ami" },
      { nomPersonnage: "Kasumi Miwa", type: "Ami" },
    ],
    citations: [
      "Quelle musique tu écoutes ?",
      "Yuji, tu es mon meilleur frère.",
    ],
    trivia: [
      "Sa philosophie sur les goûts musicaux est devenue un mème culte dans la communauté JJK",
      "Régulièrement cité comme personnage préféré malgré son rôle secondaire",
      "Sa technique Boogie Woogie, simple en apparence, est redoutablement efficace",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi6.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 10,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #11 Toge Inumaki ──
  {
    id: "jjk-toge-inumaki",
    nom: "Toge Inumaki",
    nomJaponais: "狗巻 棘",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "16–17 ans",
    sexe: "Masculin",
    dateNaissance: "23 octobre",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Demi-Grade 1",
    description:
      "Toge Inumaki est descendant du clan Inumaki et héritier de la Parole Maudite, technique permettant à ses mots d'agir directement sur la réalité. Pour éviter de nuire involontairement, il communique exclusivement via des noms d'ingrédients de sushis. Discret, attentionné et d'une loyauté absolue.",
    pouvoirs: [
      "Parole Maudite (Kotodama) — ses mots deviennent des ordres absolus",
      'Commandes : "Éclate !", "Ne bouge plus !", "Cours !", "Dors !", "Explose !"',
      "Portée et puissance proportionnelles à l'énergie dépensée",
    ],
    voixJaponaise: "Koki Uchiyama",
    voixAnglaise: "Xander Mobus",
    relations: [
      { nomPersonnage: "Yuta Okkotsu", type: "Ami" },
      { nomPersonnage: "Maki Zenin", type: "Ami" },
      { nomPersonnage: "Panda", type: "Ami" },
    ],
    citations: ["Bonite séchée.", "Saumon."],
    trivia: [
      "Sa communication via des ingrédients de sushis est devenue un mème culte mondial",
      "Son tatouage facial représente des symboles du clan Inumaki",
      "L'utilisation excessive de sa technique peut lui blesser la gorge et le corps",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge6.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 11,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #12 Panda ──
  {
    id: "jjk-panda",
    nom: "Panda",
    nomJaponais: "パンダ",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "Inconnu — Cadavre Maudit Muté",
    sexe: "Masculin (auto-identifié)",
    dateNaissance: "5 mars",
    nationalite: "N/A — Créé à Tokyo Jujutsu High",
    statut: "Secondaire",
    rang: "Grade 1",
    description:
      'Panda n\'est pas réellement un panda — c\'est un "Cadavre Maudit Muté Abrupt" créé par le directeur Masamichi Yaga. Il possède trois noyaux (cores) représentant différentes "personnalités" : Panda (équilibré), Gorilla (puissance brute), et un troisième mystérieux. Plus humain que beaucoup de sorciers, il est un pilier jovial de la 2e année.',
    pouvoirs: [
      'Trois noyaux (Cores) — changement de "mode" selon le noyau actif',
      "Mode Gorilla — puissance brute colossale",
      "Résistance aux techniques ciblant les âmes",
      "Régénération partielle si un noyau survit",
    ],
    voixJaponaise: "Tomokazu Seki",
    voixAnglaise: "Matthew David Rudd",
    relations: [
      { nomPersonnage: "Yuta Okkotsu", type: "Ami" },
      { nomPersonnage: "Maki Zenin", type: "Ami" },
      { nomPersonnage: "Toge Inumaki", type: "Ami" },
    ],
    citations: [
      "Je suis Panda. C'est tout ce que tu as besoin de savoir.",
      "Ne te laisse pas avoir par les apparences.",
    ],
    trivia: [
      "Son créateur Yaga a été exécuté pour avoir refusé de révéler le secret de sa création",
      "N'a pas d'âme humaine, ce qui le rend résistant à certaines techniques",
      "Possède 3 noyaux dont un troisième mystérieux jamais pleinement révélé",
    ],
    images: [
      "https://s4.anilist.co/file/anilistcdn/character/large/b131945-AtqEFjEJGObm.jpg",
    ],
    imagePath:
      "https://s4.anilist.co/file/anilistcdn/character/large/b131945-AtqEFjEJGObm.jpg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 12,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #13 Toji Fushiguro ──
  {
    id: "jjk-toji-fushiguro",
    nom: "Toji Fushiguro",
    nomJaponais: "伏黒 甚爾",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "27 ans (arc Hidden Inventory)",
    sexe: "Masculin",
    dateNaissance: "Non spécifié",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste",
    rang: "Assassin",
    description:
      "Toji Fushiguro, né Toji Zenin, est le père de Megumi et l'un des personnages les plus impressionnants de la série. Rejeté par le clan Zenin pour son absence totale d'énergie occulte, il est devenu l'assassin de sorciers le plus redouté de son époque. Sa Restriction Céleste lui donne un corps physiquement parfait. Il a failli tuer Satoru Gojo, forçant Gojo à éveiller ses Six Eyes.",
    pouvoirs: [
      "Restriction Céleste — corps sans énergie occulte, physiquement surhumain",
      "Invisibilité aux perceptions des fléaux",
      "Maîtrise : Inverted Spear of Heaven, Playful Cloud, Split Soul Katana",
    ],
    voixJaponaise: "Takehito Koyasu",
    voixAnglaise: "Eric Vale",
    relations: [
      { nomPersonnage: "Megumi Fushiguro", type: "Famille" },
      { nomPersonnage: "Satoru Gojo", type: "Ennemi" },
    ],
    citations: [
      "Intéressant. Tu mérites de porter le nom Fushiguro.",
      "L'énergie occulte ne fait pas un sorcier.",
    ],
    trivia: [
      "Sa mort volontaire face à Megumi — reconnaissant son fils — est l'une des scènes les plus poignantes",
      "Né dans le clan Zenin mais renié pour absence d'énergie occulte",
      "A forcé Gojo à éveiller ses Six Eyes lors de leur combat",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji9.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 13,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #14 Mahito ──
  {
    id: "jjk-mahito",
    nom: "Mahito",
    nomJaponais: "真人",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "Récent (né de la haine humaine)",
    sexe: "Masculin (apparence)",
    dateNaissance: "Non spécifié",
    nationalite: "N/A — Esprit Maudit",
    statut: "Antagoniste",
    rang: "Grade Spécial",
    description:
      'Mahito est un Esprit Maudit de Grade Spécial né de la haine humaine. Nihiliste, sadique, d\'une curiosité "enfantine" pour la mort et la souffrance. Responsable de la mort de Nanami et de la blessure quasi-fatale de Nobara à Shibuya. Son absorption finale par Kenjaku est presque plus choquante que sa défaite.',
    pouvoirs: [
      "Transmutation Oisive (Idle Transfiguration) — modifie les âmes à volonté",
      "Transformation de corps humains en créatures monstrueuses",
      "Instant Spirit Body of Distorted Killing — forme de combat transformée",
      "Expansion du Territoire : Idle Death Gamble",
      "Black Flash maîtrisé",
    ],
    voixJaponaise: "Nobunaga Shimazaki",
    voixAnglaise: "Lucien Dodge",
    relations: [
      { nomPersonnage: "Kenjaku", type: "Allié" },
      { nomPersonnage: "Kento Nanami", type: "Ennemi" },
      { nomPersonnage: "Yuji Itadori", type: "Ennemi" },
      { nomPersonnage: "Nobara Kugisaki", type: "Ennemi" },
    ],
    citations: [
      "Les humains sont si fascinants. Particulièrement quand ils souffrent.",
      "L'âme est tout. Le corps n'est qu'argile.",
    ],
    trivia: [
      "Cité comme l'un des meilleurs antagonistes du shōnen moderne",
      "Tué Kento Nanami et Junpei Yoshino (ami de Yuji)",
      "Absorbé par Kenjaku à la fin de l'arc Shibuya",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi8.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 14,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #15 Kenjaku ──
  {
    id: "jjk-kenjaku",
    nom: "Kenjaku",
    nomJaponais: "羂索",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "Plusieurs siècles",
    sexe: "Masculin",
    dateNaissance: "Ère antérieure à Heian",
    nationalite: "Japonaise antique (fictive)",
    statut: "Antagoniste",
    rang: "Antagoniste",
    description:
      "Kenjaku survit depuis des siècles en transplantant son cerveau dans de nouveaux corps — dont Suguru Geto et Kaori Itadori (mère de Yuji). Véritable architecte des Culling Games, cherchant à fusionner l'humanité avec Tengen pour \"faire évoluer\" l'espèce. Manipulateur d'une intelligence machiavélique.",
    pouvoirs: [
      "Transplantation cérébrale — transfert dans n'importe quel corps",
      "Manipulation des Esprits Maudits (hérité de Geto)",
      "Accumulation de techniques de tous les corps précédents",
      "Absorption de Mahito — Transmutation Oisive obtenue",
    ],
    voixJaponaise: "Takahiro Sakurai",
    voixAnglaise: "Lex Lang",
    relations: [
      { nomPersonnage: "Suguru Geto", type: "Victime" },
      { nomPersonnage: "Yuji Itadori", type: "Famille" },
      { nomPersonnage: "Ryomen Sukuna", type: "Allié" },
    ],
    citations: [
      "L'évolution de l'humanité requiert des sacrifices.",
      "Je suis bien plus vieux que tu ne l'imagines.",
    ],
    trivia: [
      "Le personnage avec le plus grand arc temporel — plusieurs siècles de manipulation",
      "A possédé le corps de la mère de Yuji, Kaori Itadori",
      "Père biologique de Yuji Itadori",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj9.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 15,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #16 Choso ──
  {
    id: "jjk-choso",
    nom: "Choso",
    nomJaponais: "張相",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "Plus de 150 ans (hybride)",
    sexe: "Masculin",
    dateNaissance: "Ère Meiji",
    nationalite: "N/A — Hybride Humain/Fléau",
    statut: "Protagoniste",
    rang: "Secondaire",
    description:
      "Choso est l'aîné des Death Painting Wombs. Initialement ennemi de Yuji, il le rejoint après avoir reconnu en lui un frère. Son arc de rédemption est l'un des plus inattendus et touchants de la série.",
    pouvoirs: [
      "Manipulation du Sang (Blood Manipulation) — contrôle total du sang",
      "Piercing Blood — jets supersoniques",
      "Convergence — projectile super-dense",
      "Supernova — explosion 360°",
    ],
    voixJaponaise: "Daisuke Namikawa",
    voixAnglaise: "Robb Moody",
    relations: [
      { nomPersonnage: "Yuji Itadori", type: "Famille" },
      { nomPersonnage: "Kenjaku", type: "Ennemi" },
    ],
    citations: [
      "Yuji... tu es mon frère.",
      "Je protégerai ma famille, même si je dois mourir pour ça.",
    ],
    trivia: [
      "Seul antagoniste principal à opérer un vrai retournement d'alliance",
      "Créé par Kenjaku (dans le corps de Noritoshi Kamo historique)",
      "Ses frères Eso (n°2) et Kechizu (n°3) sont décédés au cours de la série",
    ],
    images: [
      "https://s4.anilist.co/file/anilistcdn/character/large/b138634-SBIiJ8lQJBxd.jpg",
    ],
    imagePath:
      "https://s4.anilist.co/file/anilistcdn/character/large/b138634-SBIiJ8lQJBxd.jpg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 16,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #17 Shoko Ieiri ──
  {
    id: "jjk-shoko-ieiri",
    nom: "Shoko Ieiri",
    nomJaponais: "家入 硝子",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "28–29 ans",
    sexe: "Féminin",
    dateNaissance: "Non spécifié",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Grade 1",
    description:
      "Shoko Ieiri est la médecin officielle de Tokyo Jujutsu High, ancienne camarade de promotion de Gojo et Geto. Seule sorcière connue capable d'utiliser la Technique Occulte Inversée à des fins médicales. Sans ses soins, nombre de sorciers blessés n'auraient pas survécu.",
    pouvoirs: [
      "Technique Occulte Inversée — guérison médicale avancée de blessures graves",
    ],
    voixJaponaise: "Aya Endo",
    voixAnglaise: "Cherami Leigh",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Ami" },
      { nomPersonnage: "Suguru Geto", type: "Ami" },
    ],
    citations: [
      "Je guéris. Je ne me bats pas.",
      "Quelqu'un doit rester en vie pour soigner les survivants.",
    ],
    trivia: [
      "Seule utilisatrice connue de la Technique Occulte Inversée à des fins médicales",
      "Ancienne camarade de Gojo, Geto et Haibara Yu (décédé)",
      "Indispensable à la survie de nombreux exorcistes blessés",
    ],
    images: [
      "https://s4.anilist.co/file/anilistcdn/character/large/b138635-LW5OWLKQMQBH.jpg",
    ],
    imagePath:
      "https://s4.anilist.co/file/anilistcdn/character/large/b138635-LW5OWLKQMQBH.jpg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 17,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #18 Mei Mei ──
  {
    id: "jjk-mei-mei",
    nom: "Mei Mei",
    nomJaponais: "冥冥",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "33 ans",
    sexe: "Féminin",
    dateNaissance: "Non spécifié",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Grade 1",
    description:
      "Mei Mei opère principalement pour l'argent — sa seule motivation déclarée. Froide, calculatrice et redoutablement efficace. Elle quitte le Japon après l'Incident de Shibuya.",
    pouvoirs: [
      "Black Bird Manipulation — corbeaux maudits sacrificiels",
      "Hache de combat — maîtrise brutale",
    ],
    voixJaponaise: "Kotono Mitsuishi",
    voixAnglaise: "Catherine Taber",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Ami" },
      { nomPersonnage: "Suguru Geto", type: "Ami" },
    ],
    citations: [
      "L'argent. C'est mon seul intérêt.",
      "Je ne me bats que si ça vaut le coup financièrement.",
    ],
    trivia: [
      "Quitte le Japon après l'Incident de Shibuya",
      "Sa relation avec son jeune frère Ui Ui est ambiguë et controversée chez les fans",
      "L'une des sorcières de Grade 1 les plus expérimentées de la série",
    ],
    images: [
      "https://s4.anilist.co/file/anilistcdn/character/large/b138636-xXKbmfNECRNr.jpg",
    ],
    imagePath:
      "https://s4.anilist.co/file/anilistcdn/character/large/b138636-xXKbmfNECRNr.jpg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 18,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #19 Noritoshi Kamo ──
  {
    id: "jjk-noritoshi-kamo",
    nom: "Noritoshi Kamo",
    nomJaponais: "加茂 憲紀",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "18 ans",
    sexe: "Masculin",
    dateNaissance: "5 juin 2000",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Grade 1",
    description:
      "Noritoshi Kamo est le représentant du Clan Kamo. Héritier d'un clan prestigieux, il souffre d'être le fils d'une maîtresse plutôt que de l'épouse principale. Son homonyme historique, possédé par Kenjaku, est responsable de la création des Death Painting Wombs.",
    pouvoirs: [
      "Manipulation du Sang héréditaire",
      "Tir à l'arc maudit de précision",
    ],
    voixJaponaise: "Toshiyuki Toyonaga",
    voixAnglaise: "Lucien Dodge",
    relations: [
      { nomPersonnage: "Aoi Todo", type: "Ami" },
      { nomPersonnage: "Kasumi Miwa", type: "Ami" },
      { nomPersonnage: "Choso", type: "Rival" },
    ],
    citations: [
      "Je porterai le clan Kamo avec honneur.",
      "Mon sang est ma technique et mon arme.",
    ],
    trivia: [
      "Son ancêtre homonyme a été possédé par Kenjaku pour créer les Death Painting Wombs",
      "Souffre de sa position comme fils de maîtresse au sein du clan Kamo",
      "L'une des Trois Grandes Familles de sorciers au Japon",
    ],
    images: [
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo1.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo2.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo3.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo4.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo5.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo6.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo7.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo8.jpeg",
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo9.jpeg",
    ],
    imagePath:
      "assets/images/Animé pictures/Jujutsu kaizen/Chojo Kamo/jj_chojo1.jpeg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 19,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #20 Kasumi Miwa ──
  {
    id: "jjk-kasumi-miwa",
    nom: "Kasumi Miwa",
    nomJaponais: "三輪 霞",
    animeId: "jujutsu-kaisen",
    animeName: "Jujutsu Kaisen",
    auteurId: "gege-akutami",
    auteurNom: "Gege Akutami",
    studioId: "mappa",
    studioNom: "MAPPA",
    age: "17 ans",
    sexe: "Féminin",
    dateNaissance: "4 avril",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Grade 3",
    description:
      "Kasumi Miwa a rejoint le monde des sorciers pour subvenir aux besoins de sa famille. Grande admiratrice de Gojo Satoru, elle est une exorciste sérieuse et appliquée malgré son grade. Sa détermination et sa loyauté en font un personnage attachant de l'École de Kyoto.",
    pouvoirs: [
      "Simple Domains — combat au katana basique",
      "New Shadow Style — escrime maudite",
    ],
    voixJaponaise: "Yoshino Aoyama",
    voixAnglaise: "Laura Post",
    relations: [
      { nomPersonnage: "Satoru Gojo", type: "Idole" },
      { nomPersonnage: "Aoi Todo", type: "Ami" },
      { nomPersonnage: "Noritoshi Kamo", type: "Ami" },
    ],
    citations: [
      "Je deviendrai forte pour ma famille.",
      "Gojo-senpai est vraiment impressionnant...",
    ],
    trivia: [
      "A rejoint le monde des sorciers pour des raisons financières (soutenir sa famille)",
      "Grande admiratrice de Satoru Gojo",
      "L'une des rares personnages à n'avoir pas de technique héréditaire particulièrement puissante",
    ],
    images: [
      "https://s4.anilist.co/file/anilistcdn/character/large/b138638-F4oJSONhNVCB.jpg",
    ],
    imagePath:
      "https://s4.anilist.co/file/anilistcdn/character/large/b138638-F4oJSONhNVCB.jpg",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 20,
    created_at: FieldValue.serverTimestamp(),
  },
];

// ─────────────────────────────────────────────
// 5. DONNÉES QUIZ (5+ questions par personnage principal)
// ─────────────────────────────────────────────
const quizzes = [
  // Gojo
  {
    characterId: "jjk-gojo-satoru",
    questions: [
      {
        question: "Quel est le grade officiel de Satoru Gojo ?",
        options: ["Grade 1", "Grade Spécial", "Grade 2", "Sans grade"],
        correctIndex: 1,
      },
      {
        question:
          "Quelle technique permet à Gojo de créer une barrière passive contre toute attaque ?",
        options: ["Blue", "Red", "Infinity", "Purple Hollow"],
        correctIndex: 2,
      },
      {
        question:
          "Comment s'appelle l'Expansion du Territoire de Satoru Gojo ?",
        options: [
          "Malevolent Shrine",
          "Infinite Void",
          "Chimera Shadow Garden",
          "Coffin of the Iron Mountain",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel est le numéro du chapitre où Gojo est tué par Sukuna ?",
        options: [
          "Chapitre 200",
          "Chapitre 236",
          "Chapitre 250",
          "Chapitre 220",
        ],
        correctIndex: 1,
      },
      {
        question:
          "Gojo est le premier sorcier en combien d'années à maîtriser simultanément Limitless et les Six Yeux ?",
        options: ["100 ans", "200 ans", "400 ans", "1000 ans"],
        correctIndex: 2,
      },
      {
        question:
          "Qui était le meilleur ami de Gojo avant de devenir son ennemi ?",
        options: [
          "Kento Nanami",
          "Yuta Okkotsu",
          "Suguru Geto",
          "Masamichi Yaga",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Yuji
  {
    characterId: "jjk-yuji-itadori",
    questions: [
      {
        question:
          "Quel est l'exploit physique remarquable de Yuji avant d'entrer à Jujutsu High ?",
        options: [
          "Soulever 300 kg",
          "50 mètres en 3 secondes",
          "Tenir un Black Flash pendant 10 secondes",
          "Nager 1 km en 5 min",
        ],
        correctIndex: 1,
      },
      {
        question:
          "Comment s'appelle la technique signature de Yuji qui concentre l'énergie maudite sur un impact ?",
        options: ["Divergent Fist", "Piercing Blood", "Black Flash", "Shrine"],
        correctIndex: 2,
      },
      {
        question:
          "Quelle était la dernière parole de testament du grand-père de Yuji ?",
        options: [
          "Deviens le plus fort",
          "Ne meurs pas seul, entouré de tes proches",
          "Protège les innocents",
          "Tue les fléaux sans pitié",
        ],
        correctIndex: 1,
      },
      {
        question: "De qui Yuji a-t-il hérité la technique Blood Manipulation ?",
        options: [
          "Des Death Painting Wombs",
          "Du clan Zenin",
          "De Kenjaku",
          "De Sukuna",
        ],
        correctIndex: 0,
      },
      {
        question: 'Quel personnage se proclame "meilleur frère" de Yuji ?',
        options: ["Megumi Fushiguro", "Choso", "Aoi Todo", "Yuta Okkotsu"],
        correctIndex: 2,
      },
      {
        question:
          "Combien de Black Flash consécutifs Yuji a-t-il exécutés (record) ?",
        options: ["2", "3", "4", "5"],
        correctIndex: 2,
      },
    ],
  },

  // Sukuna
  {
    characterId: "jjk-ryomen-sukuna",
    questions: [
      {
        question: "Quel surnom est donné à Ryomen Sukuna ?",
        options: [
          "Le Roi des Exorcistes",
          "Le Roi des Fléaux",
          "L'Ancestral Maudit",
          "Le Dieu des Ombres",
        ],
        correctIndex: 1,
      },
      {
        question: "Dans quel corps Sukuna est-il scellé au début de la série ?",
        options: [
          "Megumi Fushiguro",
          "Yuta Okkotsu",
          "Yuji Itadori",
          "Kenjaku",
        ],
        correctIndex: 2,
      },
      {
        question: "Combien de doigts de Sukuna existent au total ?",
        options: ["10", "15", "20", "25"],
        correctIndex: 2,
      },
      {
        question: "Comment s'appelle l'Expansion du Territoire de Sukuna ?",
        options: [
          "Infinite Void",
          "Malevolent Shrine",
          "Idle Death Gamble",
          "Chimera Shadow Garden",
        ],
        correctIndex: 1,
      },
      {
        question:
          "De quelle époque historique japonaise Sukuna est-il originaire ?",
        options: ["Époque Edo", "Époque Heian", "Époque Meiji", "Époque Yayoi"],
        correctIndex: 1,
      },
    ],
  },

  // Megumi
  {
    characterId: "jjk-megumi-fushiguro",
    questions: [
      {
        question:
          "Comment s'appelle la technique héréditaire de Megumi Fushiguro ?",
        options: [
          "Technique des Cinq Éléments",
          "Technique des Dix Ombres",
          "Technique des Sept Sceaux",
          "Technique du Sang Maudit",
        ],
        correctIndex: 1,
      },
      {
        question:
          "Quel est le shikigami le plus puissant et incontrôlable de Megumi ?",
        options: ["Nue", "Great Serpent", "Max Elephant", "Mahoraga"],
        correctIndex: 3,
      },
      {
        question: "Qui est le père de Megumi Fushiguro ?",
        options: ["Satoru Gojo", "Toji Fushiguro", "Suguru Geto", "Kenjaku"],
        correctIndex: 1,
      },
      {
        question: "Quel est le rang officiel de Megumi au début de la série ?",
        options: ["Grade 1", "Grade 3", "Grade 2", "Sans grade"],
        correctIndex: 2,
      },
      {
        question: "Quel clan a écarté Megumi de sa généalogie ?",
        options: ["Clan Inumaki", "Clan Kamo", "Clan Zenin", "Clan Gojo"],
        correctIndex: 2,
      },
    ],
  },

  // Nobara
  {
    characterId: "jjk-nobara-kugisaki",
    questions: [
      {
        question: "Quelle est la ville d'origine de Nobara Kugisaki ?",
        options: ["Tokyo", "La campagne (Aomori)", "Kyoto", "Sendai"],
        correctIndex: 1,
      },
      {
        question:
          "Quelle technique permet à Nobara de transmettre des dégâts à distance via une poupée ?",
        options: [
          "Résonance",
          "Hairpin",
          "Straw Doll Technique",
          "Divergent Fist",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel antagoniste a gravement blessé Nobara à Shibuya ?",
        options: ["Sukuna", "Jogo", "Mahito", "Kenjaku"],
        correctIndex: 2,
      },
      {
        question: "Quelle est la citation culte de Nobara en anglais ?",
        options: [
          '"Fight me if you dare"',
          '"So what? I am me."',
          '"I will never lose"',
          '"Death is just the beginning"',
        ],
        correctIndex: 1,
      },
      {
        question: "Pourquoi Nobara rejoint-elle Tokyo ?",
        options: [
          "Pour fuir ses parents",
          "Pour retrouver Saori, son amie d'enfance",
          "Pour devenir la plus forte",
          "Pour rencontrer Gojo",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Geto
  {
    characterId: "jjk-suguru-geto",
    questions: [
      {
        question: "Quelle est la technique principale de Suguru Geto ?",
        options: [
          "Parole Maudite",
          "Manipulation des Esprits Maudits",
          "Transmutation Oisive",
          "Blood Manipulation",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui usurpe le corps de Suguru Geto après sa mort ?",
        options: ["Sukuna", "Mahito", "Kenjaku", "Jogo"],
        correctIndex: 2,
      },
      {
        question:
          "Comment s'appelle l'attaque ultime de Geto libérant tous ses fléaux simultanément ?",
        options: [
          "Maximum : Uzumaki",
          "Maximum : Meteor",
          "Maximum : Void",
          "Maximum : Infinity",
        ],
        correctIndex: 0,
      },
      {
        question:
          "De quelle école Geto est-il le protagoniste antagoniste principal ?",
        options: [
          "Jujutsu Kaisen Saison 2",
          "Jujutsu Kaisen 0",
          "Jujutsu Kaisen Saison 1",
          "Jujutsu Kaisen Modulo",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel événement a déclenché la rupture idéologique de Geto ?",
        options: [
          "La mort de Gojo",
          "Des traumatismes répétés et la mort de Haibara",
          "Le refus de Yaga",
          "Une mission ratée",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Nanami
  {
    characterId: "jjk-kento-nanami",
    questions: [
      {
        question:
          "Quelle profession Nanami exerçait-il avant de redevenir exorciste ?",
        options: ["Médecin", "Salaryman", "Professeur", "Policier"],
        correctIndex: 1,
      },
      {
        question:
          "Comment s'appelle la technique de Nanami qui frappe le point faible structurel au ratio 7:3 ?",
        options: [
          "Technique Ratio",
          "Overtime",
          "Black Flash",
          "Coffin of the Iron Mountain",
        ],
        correctIndex: 0,
      },
      {
        question: "Qui a tué Kento Nanami ?",
        options: ["Sukuna", "Kenjaku", "Mahito", "Jogo"],
        correctIndex: 2,
      },
      {
        question: "Quels sont les derniers mots de Nanami à Yuji ?",
        options: [
          '"Deviens fort"',
          '"Je te laisse ça"',
          '"N\'abandonne jamais"',
          '"Vis pour nous deux"',
        ],
        correctIndex: 1,
      },
      {
        question: "Lors de quel arc Kento Nanami meurt-il ?",
        options: [
          "Arc Hidden Inventory",
          "Arc Tournoi de Kyoto",
          "Arc Drame de Shibuya",
          "Arc Culling Games",
        ],
        correctIndex: 2,
      },
    ],
  },
];

// ─────────────────────────────────────────────
// SCRIPT PRINCIPAL
// ─────────────────────────────────────────────
async function importJJK() {
  console.log("🔥 Début import JJK dans Firestore...\n");

  // Vérification optionnelle du docx (mammoth)
  try {
    const mammoth = require("mammoth");
    const result = await mammoth.extractRawText({
      path: path.join(__dirname, "../JJK_Personnages_OTADEX_v2.docx"),
    });
    const lineCount = result.value.split("\n").filter((l) => l.trim()).length;
    console.log(
      `📄 Document JJK lu avec mammoth — ${lineCount} lignes extraites`,
    );
  } catch {
    console.log(
      "ℹ️  mammoth non disponible — import depuis les données inline du script",
    );
  }

  // 1. Import Animé
  await db
    .collection("animes")
    .doc("jujutsu-kaisen")
    .set(animeData, { merge: true });
  console.log("✅ Animé Jujutsu Kaisen importé");

  // 2. Import Créateur
  await db
    .collection("creators")
    .doc("gege-akutami")
    .set(creatorData, { merge: true });
  console.log("✅ Créateur Gege Akutami importé");

  // 3. Import Studio
  await db.collection("studios").doc("mappa").set(studioData, { merge: true });
  console.log("✅ Studio MAPPA importé");

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
    title: "🎉 Nouveaux personnages disponibles !",
    body: "Jujutsu Kaisen vient d'être mis à jour sur OTADEX",
    route: "/anime/jujutsu-kaisen",
    type: "new_characters",
  });

  console.log("\n🎉 Import JJK terminé avec succès !");
  console.log("📊 Résumé :");
  console.log("   1 animé | 1 créateur | 1 studio");
  console.log(`   ${characters.length} personnages | ${quizzes.length} quiz`);
  process.exit(0);
}

importJJK().catch((err) => {
  console.error("❌ Erreur import :", err);
  process.exit(1);
});
