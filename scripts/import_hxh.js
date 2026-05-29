/**
 * OTADEX — Import Hunter x Hunter vers Firestore
 * Lit Hunter_x_Hunter_Personnages_OTADEX_2026.docx et insère les données dans Firebase Firestore.
 * Usage : node scripts/import_hxh.js
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
  id: "hunter-x-hunter",
  titre: "Hunter × Hunter",
  titreJaponais: "ハンター×ハンター",
  synopsis:
    "Gon Freecss, 12 ans, part de son île natale pour devenir Hunter — une élite mondiale de chasseurs, explorateurs et combattants — afin de retrouver son père légendaire Ging. Il rencontre Killua, Kurapika et Leorio, formant un quartet complémentaire dans un univers régi par le système de magie Nen.",
  genres: ["Shōnen", "Action", "Aventure", "Fantaisie", "Psychologique"],
  annee: 2011,
  episodes: 148,
  studio: "Madhouse",
  studioId: "madhouse",
  auteur: "Yoshihiro Togashi",
  auteurId: "yoshihiro-togashi",
  editeur: "Shūeisha (Weekly Shōnen Jump)",
  editeurVF: "Kana",
  volumes: 37,
  chapitres: 400,
  scoreMal: "9.04/10",
  statut: "En cours (hiatus fréquents)",
  coverImage: "",
  bannerImage: "",
  type: "manga_adapte",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 2. DONNÉES CRÉATEUR
// ─────────────────────────────────────────────
const creatorData = {
  id: "yoshihiro-togashi",
  nom: "Yoshihiro Togashi",
  nomJaponais: "冨樫 義博",
  bio: "Yoshihiro Togashi naît le 27 avril 1966 à Shinjō, préfecture de Yamagata, Japon. En 1986, il remporte le 34e Prix Tezuka de Shūeisha. En 1990, il lance YuYu Hakusho — phénomène national avec anime et Prix Shōgakukan 1994. Il lance Hunter x Hunter en 1998 dans le Weekly Shōnen Jump. En janvier 1999, il épouse Naoko Takeuchi, auteure de Sailor Moon. Depuis 2004, des douleurs dorsales chroniques l'ont forcé à de nombreux hiatus — plus de 20 à ce jour. En mai 2022, il publie directement des pages sur Twitter lors de ses reprises impromptues.",
  dateNaissance: "27 avril 1966",
  lieuNaissance: "Shinjō, préfecture de Yamagata, Japon",
  nationalite: "Japonais",
  imageUrl: "",
  occupation: "Mangaka",
  oeuvres: [
    { titre: "Buttobi Straight (one-shot)", annee: 1986, type: "34e Prix Tezuka de Shūeisha — catégorie Nouvelle" },
    { titre: "Yū Yū Hakusho", annee: 1990, type: "Manga — 19 volumes — Weekly Shōnen Jump — Prix Shōgakukan 1994" },
    { titre: "Level E", annee: 1995, type: "Manga SF-comédie — 3 volumes — Weekly Shōnen Jump — sans assistants" },
    { titre: "Hunter × Hunter", annee: 1998, type: "Manga en cours — 37 volumes (mai 2026) — Weekly Shōnen Jump" },
  ],
  recompenses: [
    "34e Prix Tezuka de Shūeisha (1986/1987) pour Buttobi Straight",
    "Prix Shōgakukan catégorie Shōnen (1994) pour YuYu Hakusho",
    "HxH 2011 : Score MAL 9.04/10 — Top 5 de tous les temps",
    "Considéré comme auteur du meilleur système de magie (Nen) de l'histoire du shōnen",
    "Influence directe sur Gege Akutami (JJK) et Haruichi Furudate (Haikyuu!!)",
  ],
  influences: [
    "Dragon Ball (Toriyama)",
    "Akira (Otomo)",
    "Slam Dunk (Inoue)",
    "Pensée ludique et stratégique extrême",
  ],
  animeIds: ["hunter-x-hunter"],
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 3. DONNÉES STUDIO
// ─────────────────────────────────────────────
const studioData = {
  id: "madhouse",
  nom: "Madhouse",
  nomComplet: "マッドハウス株式会社",
  fondation: 1972,
  fondateur: "Masao Maruyama, Osamu Dezaki",
  siege: "Nakano, Tokyo, Japon",
  description:
    "Studio d'animation japonais fondé en 1972, filiale de NTV (Nippon Television). Reconnu pour des adaptations fidèles et techniquement exemplaires. Réalisateur HxH 2011 : Hiroshi Kōjina. Scénario : Jun Maekawa. HxH 2011 est considéré comme l'une des meilleures adaptations anime jamais réalisées.",
  productions: [
    "Hunter × Hunter (1999)",
    "Hunter × Hunter (2011 — 148 épisodes)",
    "Death Note",
    "No Game No Life",
    "Overlord (Saison 1)",
    "Cardcaptor Sakura",
    "Trigun",
    "Black Lagoon",
  ],
  animeIds: ["hunter-x-hunter"],
  logoUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 4. DONNÉES PERSONNAGES (13)
// ─────────────────────────────────────────────
const characters = [
  // ── #1 Killua Zoldyck ──
  {
    id: "hxh-killua-zoldyck",
    nom: "Killua Zoldyck",
    nomJaponais: "キルア=ゾルディック",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "12 ans (début) — 14 ans en cours",
    sexe: "Masculin",
    dateNaissance: "7 juillet (7/7)",
    taille: "158 cm — 45 kg",
    groupeSanguin: "A",
    nationalite: "Zoldyck — famille d'assassins légendaires",
    statut: "Co-protagoniste",
    rang: "Héritier Zoldyck — Transmutateur Nen",
    poste: "Meilleur ami de Gon — Assassin reconverti",
    lycee: "",
    description:
      "Killua Zoldyck est le co-protagoniste de Hunter x Hunter et le personnage le plus populaire de la série. Né dans la famille d'assassins la plus redoutée au monde, formé depuis sa naissance à tuer avec efficacité absolue, il supporte la torture et les poisons depuis l'enfance. Malgré un talent naturel supérieur à Gon selon les experts Nen, il porte le poids d'une éducation qui lui a inculqué qu'il n'est qu'un outil de mort. Sa relation avec Gon — son premier véritable ami — est le moteur émotionnel de la série.",
    pouvoirs: [
      "Transmutation : transforme son aura en électricité — résistance naturelle aux courants depuis l'enfance",
      "Whirlwind (Tourbillon) : réflexes automatiques basés sur l'électricité — défense ultrarapide",
      "Speed of Lightning : augmente sa vitesse de déplacement à des niveaux non humains",
      "Godspeed (Vitesse Divine) : combine Whirlwind et Speed of Lightning — réactivité et vitesse maximales",
      "Ripping (Déchirement) : mains d'assassin capables de transpercer la chair ou arracher un cœur",
      "Billes d'argent électriques : projectiles électriques lancés à distance",
    ],
    voixJaponaise: "Mariya Ise",
    voixAnglaise: "Cristina Vee",
    relations: [
      { nomPersonnage: "Gon Freecss", type: "Meilleur ami et frère de cœur" },
      { nomPersonnage: "Illumi Zoldyck", type: "Frère aîné psychologiquement tyrannique" },
      { nomPersonnage: "Alluka Zoldyck", type: "Petite sœur protégée" },
      { nomPersonnage: "Biscuit Krueger", type: "Mentor Nen" },
    ],
    citations: [
      "Gon, tu sais... pour la première fois de ma vie, j'ai eu envie d'avoir un ami.",
      "Je peux tuer quelqu'un sans y penser. Ce qui m'effraye, c'est de ne rien ressentir.",
    ],
    trivia: [
      "Classé #1 à tous les sondages de popularité officiels Weekly Shōnen Jump",
      "Une aiguille implantée dans son cerveau par Illumi le forçait à fuir plutôt que combattre",
      "Quitte l'aventure à la fin pour protéger sa petite sœur Alluka (Nanika)",
      "Son Godspeed est considéré comme l'une des techniques les plus puissantes de la série",
    ],
    popularityRank: 1,
    isNew: false,
    isTrending: true,
    likesCount: 52300,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #2 Gon Freecss ──
  {
    id: "hxh-gon-freecss",
    nom: "Gon Freecss",
    nomJaponais: "ゴン=フリークス",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "12 ans (début) — 14 ans en cours",
    sexe: "Masculin",
    dateNaissance: "5 mai (5/5)",
    taille: "154 cm — 49 kg",
    groupeSanguin: "B",
    nationalite: "Île de Whale Island (fictive)",
    statut: "Protagoniste principal",
    rang: "Enhancer Nen — Fils de Ging Freecss",
    poste: "Protagonist — Hunter",
    lycee: "",
    description:
      "Gon Freecss est le protagoniste principal de Hunter x Hunter. Optimiste, courageux et d'une pureté déconcertante en apparence, Gon dissimule une noirceur troublante : quand ses proches sont menacés, sa détermination peut basculer dans une obsession dangereuse. Lors de l'arc Chimera Ant, il sacrifie littéralement son avenir pour se venger d'un ennemi invincible — une transformation radicale qui redéfinit le concept de protagoniste shōnen.",
    pouvoirs: [
      "Enhancement : renforce son corps et ses capacités physiques à des niveaux surhumains",
      "Jajanken : technique Nen personnelle basée sur pierre-feuille-ciseaux",
      "Rock (Pierre) : accumulation massive d'aura pour un coup de poing destructeur",
      "Scissors (Ciseaux) : extension d'aura en lame tranchante",
      "Paper (Feuille) : projection d'énergie à distance",
      "Gon Adulte Transformé : corps adulte temporaire d'une puissance extrême — brûle toute son espérance de vie future",
    ],
    voixJaponaise: "Megumi Han",
    voixAnglaise: "Erica Mendez",
    relations: [
      { nomPersonnage: "Killua Zoldyck", type: "Meilleur ami et frère de cœur" },
      { nomPersonnage: "Ging Freecss", type: "Père légendaire absent — retrouvé au sommet de l'Arbre Monde" },
      { nomPersonnage: "Biscuit Krueger", type: "Mentor Nen — Greed Island" },
    ],
    citations: [
      "Je n'ai pas besoin de comprendre. J'ai juste besoin de croire.",
      "Killua m'a appris ce que c'est d'avoir un ami. Je ne l'oublierai jamais.",
    ],
    trivia: [
      "Sa transformation en adulte (arc Chimera Ant) irréversible sans l'aide d'Alluka/Nanika",
      "Élevé par sa tante Mito — il croit son père mort jusqu'à ses 12 ans",
      "Ses sens de la nature lui permettent de communiquer instinctivement avec les animaux",
      "Sa pureté est aussi sa plus grande faiblesse — il ne peut pas feindre des émotions qu'il ne ressent pas",
    ],
    popularityRank: 2,
    isNew: false,
    isTrending: true,
    likesCount: 38700,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #3 Hisoka Morow ──
  {
    id: "hxh-hisoka-morow",
    nom: "Hisoka Morow",
    nomJaponais: "ヒソカ=モロウ",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "28 ans (début)",
    sexe: "Masculin",
    dateNaissance: "6 juin (6/6)",
    taille: "187 cm — 91 kg",
    groupeSanguin: "",
    nationalite: "Inconnue — mercenaire indépendant",
    statut: "Antagoniste récurrent",
    rang: "Transmutateur Nen — Chasseur de forts",
    poste: "Magicien mercenaire — anciennement faux membre de la Brigade Fantôme",
    lycee: "",
    description:
      "Hisoka est l'antagoniste le plus iconique de Hunter x Hunter et l'un des personnages les plus populaires de l'histoire du manga shōnen. Magicien de scène et tueur en série, il ne vit que pour combattre des adversaires au maximum de leur potentiel. Cette philosophie hédoniste de la violence le pousse à épargner Gon et Killua. Imprévisible, narcissique et d'une sensualité dérangeante dans son rapport au combat, il est tour à tour allié, ennemi, et observateur. Sa résurrection après sa mort face à Chrollo grâce à son Nen résiduel est légendaire.",
    pouvoirs: [
      "Bungee Gum (Gomme Extensible) : aura transmutée en substance combinant latex et gomme — colle et élasticité",
      "Texture Surprise : modifie l'apparence visuelle et tactile de sa peau — déguisements parfaits",
      "Élasticité de combat : projette, attire ou dévie tout objet ou adversaire avec le Bungee Gum",
      "Résurrection post-mortem : son Nen résiduel l'a maintenu en vie après sa mort contre Chrollo",
      "Combat au corps-à-corps : niveau extrême — l'un des meilleurs combattants de la série",
    ],
    voixJaponaise: "Daisuke Namikawa",
    voixAnglaise: "Keith Silverstein",
    relations: [
      { nomPersonnage: "Gon Freecss", type: "Cible d'intérêt futur — épargne pour le faire mûrir" },
      { nomPersonnage: "Killua Zoldyck", type: "Cible d'intérêt futur" },
      { nomPersonnage: "Chrollo Lucilfer", type: "Ennemi juré après sa défaite — mission de revanche absolue" },
    ],
    citations: [
      "J'aime les fruits pas mûrs. Les voir mûrir... puis les cueillir au moment parfait.",
      "Bungee Gum possède les propriétés à la fois du latex et de la gomme.",
    ],
    trivia: [
      "Ses cartes de poker sont ses armes secondaires — tranchantes comme des rasoirs grâce au Nen",
      "A infiltré la Brigade Fantôme pour y tuer des membres — double jeu constant",
      "Se recoud lui-même après sa résurrection — l'une des scènes les plus mémorables de la série",
      "Son rapport au combat est explicitement décrit comme une forme d'excitation comparable à l'amour",
    ],
    popularityRank: 3,
    isNew: false,
    isTrending: true,
    likesCount: 31500,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #4 Kurapika ──
  {
    id: "hxh-kurapika",
    nom: "Kurapika",
    nomJaponais: "クラピカ",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "17 ans (début) — 19 ans en cours",
    sexe: "Masculin",
    dateNaissance: "4 avril (4/4)",
    taille: "171 cm — 59 kg",
    groupeSanguin: "AB",
    nationalite: "Clan Kurta (exterminé par la Brigade Fantôme)",
    statut: "Protagoniste secondaire",
    rang: "Spécialiste Nen Conditionnel — Dernier survivant du Clan Kurta",
    poste: "Garde du corps — Chasseur de la Brigade Fantôme",
    lycee: "",
    description:
      "Kurapika est le troisième protagoniste de Hunter x Hunter et l'un des personnages les plus tragiques de la série. Dernier survivant du Clan Kurta — massacré par la Brigade Fantôme pour leurs yeux rouges devenus objets de collection — il vit pour deux obsessions : récupérer les 36 yeux de ses camarades et tuer les membres de la Brigade. Son Nen se spécialise quand ses yeux deviennent écarlates, lui donnant une puissance de Spécialiste. Ses chaînes sont des techniques uniques taillées pour tuer des adversaires bien supérieurs à lui.",
    pouvoirs: [
      "Chaîne Impérative : Spécialiste activée seulement les yeux écarlates — contre membres de la Brigade uniquement",
      "Holy Chain (Sainte Chaîne) : pouce — soins et guérison",
      "Dowsing Chain (Chaîne Sourcière) : index — détection de mensonges et divination",
      "Judgment Chain (Chaîne du Jugement) : majeur — impose une règle mortelle à une cible liée",
      "Steal Chain (Chaîne Voleuse) : annulaire — vole un objet tenu par la cible",
      "Contrat absolu : si utilisé contre un non-membre de la Brigade, Kurapika mourra",
    ],
    voixJaponaise: "Miyuki Sawashiro",
    voixAnglaise: "Erika Harlacher",
    relations: [
      { nomPersonnage: "Brigade Fantôme", type: "Ennemis jurés — Chrollo neutralisé puis libéré" },
      { nomPersonnage: "Gon Freecss", type: "Ami du groupe principal" },
      { nomPersonnage: "Killua Zoldyck", type: "Ami du groupe principal" },
      { nomPersonnage: "Leorio Paradinight", type: "Ami du groupe — tension puis réconciliation" },
    ],
    citations: [
      "Mes yeux sont écarlates quand je suis en colère. Et face à la Brigade Fantôme, je suis toujours en colère.",
      "Je n'ai pas besoin d'alliés. J'ai besoin des 36 paires d'yeux de mon clan.",
    ],
    trivia: [
      "Souvent confondu avec un personnage féminin pour son apparence androgyne",
      "Son Contrat du Jugement est l'un des seuls pouvoirs Nen à avoir une clause de mort pour l'utilisateur lui-même",
      "Ses yeux deviennent rouges dans les moments d'intensité émotionnelle — trait génétique des Kurta",
      "Sa quête de récupération des yeux de son clan l'isole progressivement du groupe principal",
    ],
    popularityRank: 4,
    isNew: false,
    isTrending: false,
    likesCount: 24100,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #5 Chrollo Lucilfer ──
  {
    id: "hxh-chrollo-lucilfer",
    nom: "Chrollo Lucilfer",
    nomJaponais: "クロロ=ルシルフル",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "~26 ans",
    sexe: "Masculin",
    dateNaissance: "Non précisée officiellement",
    taille: "177 cm",
    groupeSanguin: "",
    nationalite: "Meteor City (ville sans registres légaux)",
    statut: "Antagoniste principal — Chef de la Brigade Fantôme",
    rang: "Spécialiste Nen — Chef de la Brigade Fantôme",
    poste: "Chef des Genei Ryodan — 13 voleurs d'élite",
    lycee: "",
    description:
      "Chrollo Lucilfer est le chef charismatique et intellectuel de la Brigade Fantôme. Originaire de Meteor City — ville-dépotoir dont les habitants n'existent dans aucun registre légal — il a fondé la Brigade sur une philosophie nihiliste de solidarité absolue entre ses membres. Intellectuel cultivé, amateur de livres et d'art, il dissimule sous une apparence philosophique un pragmatisme glacial. Son pouvoir Skill Hunter est l'un des plus redoutables : il vole et conserve les capacités Nen de ses victimes.",
    pouvoirs: [
      "Skill Hunter : vole et conserve les capacités Nen de ses victimes dans son livre",
      "Bibliothèque de capacités : peut utiliser simultanément plusieurs capacités volées",
      "Combat au corps-à-corps élite : niveau supérieur à la plupart des Hunters",
      "Neutralisation de son Nen (arc Yorknew) : Kurapika neutralise temporairement ses pouvoirs",
    ],
    voixJaponaise: "Mamoru Miyano",
    voixAnglaise: "Robbie Daymond",
    relations: [
      { nomPersonnage: "Hisoka Morow", type: "Ennemi après le duel de Celestial Tower" },
      { nomPersonnage: "Kurapika", type: "Adversaire — a tué son clan et est capturé par lui" },
      { nomPersonnage: "Brigade Fantôme", type: "Fondateur — loyauté absolue de ses membres" },
    ],
    citations: [
      "La vie n'a de valeur que parce qu'elle finit. C'est ce que nous rappelle Meteor City.",
      "Je vole. Je tue. Mais la Brigade est ma famille. Ça ne change pas.",
    ],
    trivia: [
      "Originaire de Meteor City — une ville qui n'existe sur aucun registre — les habitants peuvent littéralement 'disparaître'",
      "Son Skill Hunter a une contrainte : il doit montrer le livre à sa victime et lui demander 'puis-je voler ton pouvoir ?'",
      "Le duel contre Hisoka à Celestial Tower est considéré comme l'un des meilleurs combats du manga",
      "Il lit de la littérature classique — La Bibliothèque de Babel de Borges est citée",
    ],
    popularityRank: 5,
    isNew: false,
    isTrending: false,
    likesCount: 19600,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #6 Leorio Paradinight ──
  {
    id: "hxh-leorio-paradinight",
    nom: "Leorio Paradinight",
    nomJaponais: "レオリオ=パラディナイト",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "19 ans (début) — 21 ans en cours",
    sexe: "Masculin",
    dateNaissance: "3 mars (3/3)",
    taille: "193 cm — 85 kg",
    groupeSanguin: "O",
    nationalite: "Inconnue",
    statut: "Protagoniste secondaire",
    rang: "Emetteur Nen — Étudiant en médecine",
    poste: "Futur médecin — Membre du quatuor principal",
    lycee: "",
    description:
      "Leorio est le membre 'normal' du quatuor principal de HxH — le plus humain, le plus émotif, le plus comique. Sa motivation première est d'accéder à la médecine gratuitement pour soigner les pauvres — son ami Pietro est mort d'une maladie curable faute d'argent. Bruyant, impulsif et parfois maladroit, il est fondamentalement le cœur moral du groupe. Son Nen d'Émetteur — une pseudo-attaque longue portée de poing — fait de lui un combattant solide malgré son apparence de non-combattant.",
    pouvoirs: [
      "Émission de Nen : projette son aura à distance — frappe à distance comme un poing invisible",
      "Frappe longue portée (Remote Punch) : son technique signature révélée lors de l'élection des Hunters",
      "Connaissances médicales avancées : utiles dans les situations de soin tactique",
      "Combat physique de base : entraînement suffisant pour l'Examen Hunter",
    ],
    voixJaponaise: "Keiji Fujiwara",
    voixAnglaise: "Matthew Mercer",
    relations: [
      { nomPersonnage: "Gon Freecss", type: "Ami — tension initiale puis loyauté" },
      { nomPersonnage: "Killua Zoldyck", type: "Ami du groupe" },
      { nomPersonnage: "Kurapika", type: "Ami — duel mémorable lors de l'Examen Hunter" },
    ],
    citations: [
      "Je veux devenir médecin pour que plus personne ne meure comme Pietro.",
      "Je ne suis pas un héros. Je suis juste quelqu'un qui veut aider les gens.",
    ],
    trivia: [
      "Souvent cru plus jeune à cause de sa maturité apparente — il a en réalité 19 ans au début, pas 16",
      "Son duel avec Kurapika lors de l'Examen Hunter révèle leurs motivations profondes à tous deux",
      "Son Remote Punch lors de l'Élection des Hunters est l'une des révélations de Nen les plus spectaculaires",
      "Candidat à la présidence de l'Association des Hunters à la fin de la série",
    ],
    popularityRank: 6,
    isNew: false,
    isTrending: false,
    likesCount: 14300,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #7 Biscuit Krueger ──
  {
    id: "hxh-biscuit-krueger",
    nom: "Biscuit Krueger",
    nomJaponais: "ビスケット=クルーガー",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "57 ans (sous apparence d'une fille de 12 ans)",
    sexe: "Féminin",
    dateNaissance: "Non précisée",
    taille: "Petite — forme de fillette (apparence) / Géante (vraie forme dissimulée)",
    groupeSanguin: "",
    nationalite: "Inconnue",
    statut: "Protagoniste secondaire — mentore de Gon et Killua",
    rang: "Transformeur/Transmutateur Nen — Double-étoile Hunter",
    poste: "Mentore de Gon et Killua — Chasseur légendaire",
    lycee: "",
    description:
      "Biscuit Krueger — surnommée Bisky — est l'une des Hunter les plus expérimentées de la série. Âgée de 57 ans mais conservant une apparence de fillette de 12 ans grâce à son Nen de transformation, elle est le mentor de Gon et Killua sur l'arc Greed Island. Autoritaire, exigeante jusqu'à la cruauté dans ses méthodes d'entraînement, elle développe une affection maternelle authentique pour ses deux élèves — qu'elle dissimule sous une façade de dureté.",
    pouvoirs: [
      "Transformation Nen : maintient une apparence de fillette — sa vraie forme musclée est cachée",
      "Shu : renforce les objets avec son Nen — permet des attaques de contact dévastatrices",
      "Palm Reading Fortelling : techniques de fortune telling Nen avancées",
      "Connaissances Nen encyclopédiques : enseigne le Nen avancé à Gon et Killua",
      "Combat physique d'élite : sa vraie forme (musclée géante) dépasse la plupart des adversaires",
    ],
    voixJaponaise: "Chisa Yokoyama",
    voixAnglaise: "Tara Sands",
    relations: [
      { nomPersonnage: "Gon Freecss", type: "Élève — affection maternelle dissimulée" },
      { nomPersonnage: "Killua Zoldyck", type: "Élève — reconnaissance de son talent exceptionnel" },
    ],
    citations: [
      "57 ans d'expérience et vous pensez que je n'ai pas tout vu ?",
      "L'entraînement d'aujourd'hui vous tuera. C'est le but. Relevez-vous.",
    ],
    trivia: [
      "Sa vraie forme physique est une géante musclée qu'elle révèle dans les situations d'urgence",
      "Avait pour maître Wing — le même mentor qui a initié Gon et Killua au Nen lors de la Tour Céleste",
      "Déteste qu'on parle de son âge réel — le maintien de son apparence de fillette est une vanité personnelle",
      "Son affection pour Gon et Killua se révèle lors de l'arc Chimera Ant — elle pleure en les voyant en danger",
    ],
    popularityRank: 7,
    isNew: false,
    isTrending: false,
    likesCount: 10900,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #8 Meruem ──
  {
    id: "hxh-meruem",
    nom: "Meruem",
    nomJaponais: "メルエム",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "~1 mois (Reine des Fourmis Chimères)",
    sexe: "Masculin",
    dateNaissance: "Éclot environ 1 mois avant la mort de la Reine",
    taille: "160 cm environ",
    groupeSanguin: "",
    nationalite: "Roi des Fourmis Chimères (espèce fictive)",
    statut: "Antagoniste principal de l'arc Chimera Ant",
    rang: "Roi des Fourmis Chimères — Nen Divin",
    poste: "Roi absolu — Être le plus puissant de la série",
    lycee: "",
    description:
      "Meruem est le Roi des Fourmis Chimères et l'antagoniste de l'arc le plus complexe et le plus admiré de Hunter x Hunter. Né pour dominer toutes les espèces, il est l'être le plus puissant de la série dès sa naissance. Son arc de développement — de tyran nihiliste à être capable d'amour grâce à Komugi — est l'une des transformations de personnage les plus profondes du shōnen. Sa mort, empoisonné par la bombe de Netero et tenant la main de Komugi, est la scène la plus tragique et la plus belle de la série.",
    pouvoirs: [
      "Nen Divin / Royal : un type de Nen unique et inconnu des humains — puissance incommensurable",
      "Absorption de Nen : en dévorant des utilisateurs de Nen Chimères, il absorbe et améliore leur puissance",
      "Force physique absolue : force et vitesse incomparables — détruire des murs en béton avec un doigt",
      "Queenshot (Rayon Royal) : technique d'attaque Nen à longue portée dévastatrice",
      "Régénération rapide : se remet d'un coup de Netero en quelques instants",
    ],
    voixJaponaise: "Kōki Uchiyama",
    voixAnglaise: "Max Mittelman",
    relations: [
      { nomPersonnage: "Komugi", type: "Première personne qui le bat au Gungi — lui apprend ce qu'est une âme" },
      { nomPersonnage: "Isaac Netero", type: "Combat final — mort après sa bombe rose" },
      { nomPersonnage: "Neferpitou", type: "Garde royale — la plus loyale" },
    ],
    citations: [
      "Ceux qui ne sont pas utiles au Roi n'ont aucune valeur. Mais toi, Komugi... tu m'as appris quelque chose.",
      "Je suis né pour régner. Mais je ne savais pas ce que signifiait vivre.",
    ],
    trivia: [
      "Sa relation avec Komugi — une joueuse de Gungi aveugle — est considérée comme la meilleure romance de HxH",
      "Meurt empoisonné aux côtés de Komugi après le combat contre Netero — ils jouent au Gungi jusqu'à la fin",
      "Son arc est influencé par les écrits philosophiques sur la nature du pouvoir absolu et de l'humanité",
      "Togashi a dit que Meruem est le personnage dont il est le plus fier dans toute sa carrière",
    ],
    popularityRank: 8,
    isNew: false,
    isTrending: false,
    likesCount: 16200,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #9 Isaac Netero ──
  {
    id: "hxh-isaac-netero",
    nom: "Isaac Netero",
    nomJaponais: "アイザック=ネテロ",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "~120 ans",
    sexe: "Masculin",
    dateNaissance: "Non précisée — très ancienne",
    taille: "165 cm — frêle d'apparence",
    groupeSanguin: "",
    nationalite: "Inconnue",
    statut: "Protagoniste secondaire — décédé",
    rang: "100e Président de l'Association des Hunters — Utilisateur de Nen le plus fort de l'histoire",
    poste: "Président de l'Association des Hunters",
    lycee: "",
    description:
      "Isaac Netero est le 100e et le plus légendaire Président de l'Association des Hunters. Âgé de plus de 120 ans, il a consacré des décennies à affûter son Nen jusqu'à un niveau inaccessible à tout autre humain. Sa technique signature — Cent-Type Guanyin Bodhisattva — est l'une des attaques les plus puissantes de la série. Son sacrifice final contre Meruem — se faisant exploser avec la bombe rose pour tenter de tuer le Roi — est l'un des moments les plus mémorables du shōnen.",
    pouvoirs: [
      "Cent-Type Guanyin Bodhisattva : invocation d'un colosse Nen d'une rapidité fulgurante — 100 frappes simultanées",
      "Vitesse d'attaque incomparable : sa main gauche frappe plus vite que la lumière ne peut être perçue",
      "Hachimon Tonkou : technique de Nen final — active toutes les portes de Nen interdites",
      "Bombe rose de Miniature : grenade interne de son corps — l'explosion empoisonne tout proche",
      "Expérience stratégique absolue : a vu tout le monde de la chasse en 120 ans",
    ],
    voixJaponaise: "Ichirō Nagai",
    voixAnglaise: "Neil Kaplan",
    relations: [
      { nomPersonnage: "Meruem", type: "Adversaire final — combat le plus intense de la série" },
      { nomPersonnage: "Gon Freecss", type: "Reconnaît son potentiel extraordinaire" },
    ],
    citations: [
      "Je ne cherche pas la victoire. Je cherche à te ralentir suffisamment pour que ma bombe fasse son travail.",
      "Il y a des choses qu'on ne peut accomplir qu'en sacrifiant tout ce qu'on est.",
    ],
    trivia: [
      "A passé des décennies dans la montagne à faire des prières 10 000 fois par jour pour affûter son Nen",
      "Sa technique Guanyin Bodhisattva est basée sur la divinité bouddhiste Guanyin — déesse de la compassion",
      "Sa bombe rose empoisonne Meruem — et par contamination, tous ceux qu'il touchera après",
      "Considéré comme le Nen humain le plus fort jamais développé — même Meruem le reconnaît",
    ],
    popularityRank: 9,
    isNew: false,
    isTrending: false,
    likesCount: 13800,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #10 Illumi Zoldyck ──
  {
    id: "hxh-illumi-zoldyck",
    nom: "Illumi Zoldyck",
    nomJaponais: "イルミ=ゾルディック",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "24 ans (début)",
    sexe: "Masculin",
    dateNaissance: "Non précisée",
    taille: "185 cm — 68 kg",
    groupeSanguin: "A",
    nationalite: "Famille Zoldyck",
    statut: "Antagoniste",
    rang: "Manipulateur Nen — Aîné des Zoldyck",
    poste: "Assassin professionnel — Frère aîné de Killua",
    lycee: "",
    description:
      "Illumi Zoldyck est le fils aîné de la famille Zoldyck et le frère aîné de Killua. Assassin professionnel d'une efficacité glaciale, il représente l'aboutissement parfait de l'éducation Zoldyck — un être qui ne conçoit la famille que comme propriété. Sa relation avec Killua est psychologiquement toxique : il a implanté une aiguille dans le cerveau de son frère pour le programmer à fuir plutôt que combattre. Sa relation avec Hisoka — indéfinie et mutuellement fascinante — est un des mysteries de la série.",
    pouvoirs: [
      "Manipulation Nen : contrôle les aiguilles Nen pour dominer les mouvements et pensées des cibles",
      "Aiguilles mentales : implantées dans le cerveau des cibles — modifient leur comportement",
      "Déguisement parfait : peut modifier son apparence physique avec ses aiguilles Nen",
      "Combat d'assassin : efficacité létale brute — sans fioritures",
    ],
    voixJaponaise: "Masaya Matsukaze",
    voixAnglaise: "Chris Hackney",
    relations: [
      { nomPersonnage: "Killua Zoldyck", type: "Frère cadette — contrôle psychologique tyrannique" },
      { nomPersonnage: "Hisoka Morow", type: "Relation la plus personnelle — nature indéfinie et mutuellement fascinante" },
      { nomPersonnage: "Famille Zoldyck", type: "Fils aîné et héritier principal" },
    ],
    citations: [
      "Killua m'appartient. C'est la règle dans notre famille.",
      "Je n'ai pas de sentiments pour quiconque. Sauf peut-être pour Killua. Mais c'est différent.",
    ],
    trivia: [
      "Ses yeux vides et son regard fixe sans expression sont l'une des character designs les plus mémorables",
      "L'aiguille qu'il a implantée dans le cerveau de Killua est retirée par Killua lui-même lors de l'arc Chimera Ant",
      "Participe à l'Examen Hunter en utilisant le déguisement de Gittarackur — un personnage défiguré",
      "Sa relation avec Hisoka suggère un accord mutuel complexe dont les détails ne sont jamais révélés",
    ],
    popularityRank: 10,
    isNew: false,
    isTrending: false,
    likesCount: 11200,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #11 Ging Freecss ──
  {
    id: "hxh-ging-freecss",
    nom: "Ging Freecss",
    nomJaponais: "ジン=フリークス",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "~32 ans estimé",
    sexe: "Masculin",
    dateNaissance: "Non précisée",
    taille: "~170 cm",
    groupeSanguin: "",
    nationalite: "Inconnue",
    statut: "Protagoniste secondaire — père de Gon",
    rang: "Hunter Double-Étoile — Concepteur de Greed Island",
    poste: "Hunter Double-Étoile — Père absent de Gon",
    lycee: "",
    description:
      "Ging Freecss est le père légendaire de Gon et l'un des cinq meilleurs Hunters au monde. Concepteur du jeu Greed Island, il est présenté comme un génie insaisissable depuis le début de la série. Sa relation avec son fils est paradoxale : il abandonne Gon à la naissance tout en étant la raison d'être de toute l'aventure. Leur retrouvailles au sommet de l'Arbre Monde — Ging refusant toujours de regarder son fils dans les yeux — est à la fois décevante et parfaitement cohérente avec son personnage.",
    pouvoirs: [
      "Émission/Manipulation/Transformation Nen : maîtrise de plusieurs catégories simultanément",
      "Copie de Nen : peut copier toute technique Nen qu'il observe et l'améliorer instantanément",
      "Intelligence stratégique transcendante : concepteur d'un jeu Nen d'une complexité absolue",
      "Présence quasi-indétectable : capacité à cacher son aura à des niveaux impossibles",
    ],
    voixJaponaise: "Rikiya Koyama",
    voixAnglaise: "Marc Diraison",
    relations: [
      { nomPersonnage: "Gon Freecss", type: "Fils — relation paradoxale d'absence et d'amour" },
      { nomPersonnage: "Isaac Netero", type: "L'un des rares à avoir accès direct au Président" },
    ],
    citations: [
      "Tu es mon fils. La meilleure chose que j'ai faite dans ma vie. Et je n'en suis pas fier.",
      "Le voyage, c'est ça qui compte. Pas la destination.",
    ],
    trivia: [
      "Reconnu comme l'un des cinq meilleurs Hunters actifs — Netero lui-même le respecte",
      "A conceptualisé le jeu Greed Island entièrement avec du Nen — exploit technique unique dans la série",
      "Refuse de regarder Gon lors de leurs retrouvailles — avoue qu'il ne sait pas comment être père",
      "Sa philosophie de l'exploration — 'le voyage vaut mieux que l'arrivée' — est le cœur thématique de la série",
    ],
    popularityRank: 11,
    isNew: false,
    isTrending: false,
    likesCount: 9400,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #12 Feitan Portor ──
  {
    id: "hxh-feitan-portor",
    nom: "Feitan Portor",
    nomJaponais: "フェイタン=ポートォ",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "Non précisé",
    sexe: "Masculin",
    dateNaissance: "Non précisée",
    taille: "155 cm environ",
    groupeSanguin: "",
    nationalite: "Meteor City (Xing ?)",
    statut: "Antagoniste secondaire",
    rang: "Transmutateur/Émetteur Nen — Membre de la Brigade Fantôme",
    poste: "Tortionnaire officiel de la Brigade — Numéro 2",
    lycee: "",
    description:
      "Feitan Portor est le tortionnaire officiel de la Brigade Fantôme et l'un des membres les plus dangereux au combat. De petite taille mais d'une rapidité et d'une brutalité extrêmes, il parle souvent dans une langue étrangère (langue xingaise ?) lors des combats intenses. Sa technique signature — Pain Packer Rising Sun — crée une armure d'aura qui génère une chaleur infernale basée sur la souffrance qu'il a subie. Chef par intérim de la Brigade en l'absence de Chrollo.",
    pouvoirs: [
      "Pain Packer : armure défensive en Nen — réduit les dommages reçus",
      "Rising Sun : technique d'Émetteur — crée une boule de chaleur solaire basée sur la souffrance endurée",
      "Vitesse d'attaque extrême : l'un des membres les plus rapides de la Brigade",
      "Combat au sabre : maîtrise des armes blanches",
    ],
    voixJaponaise: "Akira Ishida",
    voixAnglaise: "Tom Bauer",
    relations: [
      { nomPersonnage: "Chrollo Lucilfer", type: "Chef — loyauté totale" },
      { nomPersonnage: "Brigade Fantôme", type: "Membre central — numéro 2" },
    ],
    citations: [
      "(Langue xingaise — incompréhensible dans l'intensité du combat)",
      "Douleur... toi tu as causé beaucoup. Maintenant moi je te rends.",
    ],
    trivia: [
      "Son mélange de langues (japonais/xingais) dans les moments de colère est une particularité de son design",
      "Son Rising Sun est l'une des techniques les plus dramatiques visuellement de toute la série",
      "Chef par intérim de la Brigade après la prise de Chrollo par Kurapika",
      "Sa petite taille contraste de façon frappante avec sa brutalité en combat",
    ],
    popularityRank: 12,
    isNew: false,
    isTrending: false,
    likesCount: 7800,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #13 Neferpitou ──
  {
    id: "hxh-neferpitou",
    nom: "Neferpitou",
    nomJaponais: "ネフェルピトー",
    animeId: "hunter-x-hunter",
    animeName: "Hunter × Hunter",
    auteurId: "yoshihiro-togashi",
    auteurNom: "Yoshihiro Togashi",
    studioId: "madhouse",
    studioNom: "Madhouse",
    age: "Quelques semaines — Fourmi Chimère de la Garde Royale",
    sexe: "Non précisé (androgyne — en japonais genre neutre)",
    dateNaissance: "Née peu avant Meruem",
    taille: "180 cm environ",
    groupeSanguin: "",
    nationalite: "Garde Royale des Fourmis Chimères",
    statut: "Antagoniste de l'arc Chimera Ant",
    rang: "Garde Royale — Spécialiste Nen",
    poste: "Garde Royale de Meruem — la plus loyale",
    lycee: "",
    description:
      "Neferpitou est le membre de la Garde Royale considéré comme le plus fort sur le plan du Nen offensif. Chat-humain d'une grâce et d'une violence absolues, sa loyauté envers Meruem est totale et inconditionnelle. Son combat posthume contre Gon — son corps animé par le Nen résiduel même après sa mort — est l'un des moments les plus terrifiants et les plus cathartiques de la série. La destruction de Neferpitou par le Gon transformé est la scène culminante de l'arc Chimera Ant.",
    pouvoirs: [
      "Doctor Blythe : technique de guérison/réparation Nen — peut réparer des corps morts ou blessés",
      "Terpsichora : anime des corps comme marionnettes via le Nen — combat posthume possible",
      "Aura de Spécialiste : détectable à des centaines de kilomètres par les utilisateurs de Nen avancés",
      "Rapidité félide : vitesse et réflexes d'un chat surhumain — impossible à suivre par l'œil humain",
    ],
    voixJaponaise: "Ayumi Fujimura",
    voixAnglaise: "Tara Platt",
    relations: [
      { nomPersonnage: "Meruem", type: "Roi — loyauté absolue et sans condition" },
      { nomPersonnage: "Gon Freecss", type: "Adversaire final — détruit par le Gon transformé" },
    ],
    citations: [
      "Si le Roi ordonne, même ma mort n'interrompra pas ma mission.",
      "Tu es fort, humain. Mais tu arrives trop tard.",
    ],
    trivia: [
      "Son combat posthume — son corps animé par Terpsichora — est une des idées les plus originales du manga",
      "Sa loyauté à Meruem est si absolue qu'elle sourit avant que Gon la détruise — car elle a accompli son devoir",
      "Son Doctor Blythe lui a permis de maintenir Komugi en vie pour le Roi — sacrifice de son pouvoir d'attaque",
      "Neferpitou est l'un des rares personnages dont le genre exact n'est jamais précisé dans le manga",
    ],
    popularityRank: 13,
    isNew: false,
    isTrending: false,
    likesCount: 8500,
    images: [],
    imagePath: "",
    created_at: FieldValue.serverTimestamp(),
  },
];

// ─────────────────────────────────────────────
// 5. DONNÉES QUIZ (7 personnages × 5 questions)
// ─────────────────────────────────────────────
const quizzes = [
  // Killua
  {
    characterId: "hxh-killua-zoldyck",
    questions: [
      {
        question: "Quel type de Nen Killua Zoldyck utilise-t-il ?",
        options: ["Enhancement", "Émission", "Transmutation", "Manipulation"],
        correctIndex: 2,
      },
      {
        question: "Comment s'appelle la technique ultime de Killua combinant vitesse et électricité ?",
        options: ["Thunder Strike", "Godspeed", "Lightning Rush", "Electric Edge"],
        correctIndex: 1,
      },
      {
        question: "Quelle aiguille Illumi avait-il implantée dans le cerveau de Killua ?",
        options: [
          "Une aiguille de paralysie",
          "Une aiguille forçant Killua à fuir plutôt que combattre",
          "Une aiguille de soumission totale",
          "Une aiguille transmettant les informations à Illumi",
        ],
        correctIndex: 1,
      },
      {
        question: "Pour protéger qui Killua quitte-t-il l'aventure à la fin de la série ?",
        options: ["Gon Freecss", "Sa mère", "Sa petite sœur Alluka", "Biscuit Krueger"],
        correctIndex: 2,
      },
      {
        question: "Depuis combien de temps Killua a-t-il été entraîné à tuer avant de rencontrer Gon ?",
        options: ["Depuis ses 6 ans", "Depuis sa naissance", "Depuis ses 8 ans", "Depuis ses 10 ans"],
        correctIndex: 1,
      },
    ],
  },

  // Gon
  {
    characterId: "hxh-gon-freecss",
    questions: [
      {
        question: "Quel type de Nen Gon Freecss utilise-t-il ?",
        options: ["Transmutation", "Enhancement", "Spécialisation", "Émission"],
        correctIndex: 1,
      },
      {
        question: "Comment s'appelle la technique Nen personnelle de Gon basée sur pierre-feuille-ciseaux ?",
        options: ["Rock Scissors Paper", "Jajanken", "Triple Strike", "Aura Burst"],
        correctIndex: 1,
      },
      {
        question: "Quelle est la conséquence de la transformation adulte de Gon dans l'arc Chimera Ant ?",
        options: [
          "Il perd définitivement son Nen",
          "Il brûle toute son espérance de vie future — irréversible sans Alluka",
          "Il devient plus jeune ensuite",
          "Il doit recommencer son entraînement Nen depuis zéro",
        ],
        correctIndex: 1,
      },
      {
        question: "Pourquoi Gon veut-il devenir Hunter au début de la série ?",
        options: [
          "Pour devenir le meilleur Hunter du monde",
          "Pour gagner de l'argent pour sa famille",
          "Pour retrouver son père légendaire Ging Freecss",
          "Pour venger sa tante Mito",
        ],
        correctIndex: 2,
      },
      {
        question: "Qui a élevé Gon avant qu'il parte devenir Hunter ?",
        options: ["Sa mère biologique", "Sa tante Mito", "Sa grand-mère", "Ging Freecss lui-même"],
        correctIndex: 1,
      },
    ],
  },

  // Hisoka
  {
    characterId: "hxh-hisoka-morow",
    questions: [
      {
        question: "Comment s'appelle la technique Nen signature d'Hisoka ?",
        options: ["Rubber Soul", "Bungee Gum", "Elastic Love", "Sticky Shot"],
        correctIndex: 1,
      },
      {
        question: "Pourquoi Hisoka épargne-t-il Gon et Killua au lieu de les tuer ?",
        options: [
          "Il travaille pour Netero",
          "Il attend qu'ils atteignent leur plein potentiel pour les combattre",
          "Il les considère comme ses élèves",
          "Il a peur de leur Nen combiné",
        ],
        correctIndex: 1,
      },
      {
        question: "Comment Hisoka survit-il à sa mort face à Chrollo ?",
        options: [
          "Il avait un antidote secret",
          "Netero lui a transmis son Nen",
          "Son Nen résiduel continue à agir même après sa mort et se recoud",
          "Illumi l'a sauvé avec ses aiguilles de soin",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel groupe Hisoka a-t-il infiltré faussement dans la série ?",
        options: ["L'Association des Hunters", "La Garde Royale des Fourmis", "La Brigade Fantôme", "Les Zoldyck"],
        correctIndex: 2,
      },
      {
        question: "Quel est le surnom des deux propriétés de son Bungee Gum ?",
        options: [
          "Les propriétés du bois et du métal",
          "Les propriétés du latex et de la gomme",
          "Les propriétés du feu et de l'eau",
          "Les propriétés du vent et de l'éclair",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Kurapika
  {
    characterId: "hxh-kurapika",
    questions: [
      {
        question: "Quel type de Nen Kurapika utilise-t-il quand ses yeux deviennent rouges ?",
        options: ["Enhancement", "Transmutation", "Spécialisation", "Manipulation"],
        correctIndex: 2,
      },
      {
        question: "Quelle chaîne de Kurapika impose une règle mortelle à une cible liée ?",
        options: ["Holy Chain", "Dowsing Chain", "Steal Chain", "Judgment Chain"],
        correctIndex: 3,
      },
      {
        question: "Pourquoi Kurapika cherche-t-il à récupérer les 36 paires d'yeux ?",
        options: [
          "Pour les vendre à un collectionneur",
          "Ce sont les yeux de son clan Kurta massacré par la Brigade Fantôme",
          "Pour invoquer un pouvoir Nen légendaire",
          "Pour prouver l'innocence de son clan",
        ],
        correctIndex: 1,
      },
      {
        question: "Quelle est la conséquence du contrat absolu de Kurapika ?",
        options: [
          "Il perd ses yeux rouges définitivement",
          "S'il utilise ses chaînes contre un non-membre de la Brigade, il mourra",
          "Il doit recharger ses chaînes après chaque utilisation",
          "Il doit sacrifier un an de vie à chaque activation",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel événement a causé l'extermination du Clan Kurta de Kurapika ?",
        options: [
          "Une guerre avec un pays voisin",
          "La Brigade Fantôme les a massacrés pour leurs yeux rouges",
          "Une épidémie de maladie incurable",
          "Un désastre naturel",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Meruem
  {
    characterId: "hxh-meruem",
    questions: [
      {
        question: "Quel jeu Komugi fait-elle découvrir à Meruem qui le transforme profondément ?",
        options: ["Shogi", "Go", "Gungi", "Échecs"],
        correctIndex: 2,
      },
      {
        question: "Comment Meruem augmente-t-il sa puissance dans la série ?",
        options: [
          "Par l'entraînement quotidien",
          "En devenant plus vieux",
          "En dévorant des utilisateurs de Nen Chimères",
          "En absorbant le Nen de ses Gardes Royales",
        ],
        correctIndex: 2,
      },
      {
        question: "Comment Netero tente-t-il de tuer Meruem dans le combat final ?",
        options: [
          "Avec la technique Cent-Type Guanyin uniquement",
          "En se faisant exploser avec la bombe rose — Miniature Rose",
          "En utilisant un poison Nen concentré",
          "En le projetant dans l'espace",
        ],
        correctIndex: 1,
      },
      {
        question: "Qu'est-ce que Meruem apprend grâce à Komugi ?",
        options: [
          "La technique du Nen royal",
          "Ce que signifie avoir une âme et ce pour quoi on vit",
          "L'histoire de la civilisation humaine",
          "La faiblesse de Netero",
        ],
        correctIndex: 1,
      },
      {
        question: "Comment Meruem meurt-il à la fin de l'arc Chimera Ant ?",
        options: [
          "Tué par Gon transformé",
          "Tué par Killua en Godspeed",
          "Empoisonné par la bombe rose de Netero — tient la main de Komugi jusqu'à la fin",
          "Détruit par une intervention de l'Association des Hunters",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Netero
  {
    characterId: "hxh-isaac-netero",
    questions: [
      {
        question: "Quel est le titre officiel d'Isaac Netero au sein de l'Association des Hunters ?",
        options: ["Grand Master Hunter", "100e Président de l'Association des Hunters", "Hunter Suprême", "Gardien des Chasseurs"],
        correctIndex: 1,
      },
      {
        question: "Comment s'appelle la technique Nen ultime de Netero contre Meruem ?",
        options: ["Bouddha Divin", "Cent-Type Guanyin Bodhisattva", "Dragon Royal", "Frappe Sacrée"],
        correctIndex: 1,
      },
      {
        question: "Quelle est la technique de sacrifice final de Netero ?",
        options: [
          "Il s'immole avec du feu Nen",
          "Il transfère tout son Nen à Gon",
          "Il s'explose avec la Miniature Rose — bombe rose empoisonnée",
          "Il ouvre toutes les portes de Nen interdites pour détruire tout autour de lui",
        ],
        correctIndex: 2,
      },
      {
        question: "Pourquoi Netero est-il considéré comme le Nen humain le plus fort de l'histoire ?",
        options: [
          "Il est né avec un Nen naturellement supérieur",
          "Il a passé des décennies à prier et s'entraîner 10 000 fois par jour dans les montagnes",
          "Il a volé le Nen de centaines d'adversaires",
          "Il a découvert un secret Nen inconnu de tous",
        ],
        correctIndex: 1,
      },
      {
        question: "Quelle divinité bouddhiste inspire la technique de Netero ?",
        options: ["Bouddha Shakyamuni", "Guanyin (déesse de la compassion)", "Maitreya", "Amitabha"],
        correctIndex: 1,
      },
    ],
  },

  // Chrollo
  {
    characterId: "hxh-chrollo-lucilfer",
    questions: [
      {
        question: "Comment s'appelle la technique Nen de Chrollo qui lui permet de voler les pouvoirs des autres ?",
        options: ["Power Theft", "Ability Copy", "Skill Hunter", "Nen Steal"],
        correctIndex: 2,
      },
      {
        question: "D'où vient Chrollo Lucilfer ?",
        options: ["D'une famille noble de Yorknew City", "De Meteor City — ville dont les habitants n'existent sur aucun registre", "Du pays de Xing", "De l'île de Whale Island"],
        correctIndex: 1,
      },
      {
        question: "Quel groupe Chrollo dirige-t-il ?",
        options: ["Les Zoldyck", "La Garde Royale des Fourmis", "La Brigade Fantôme (Genei Ryodan)", "L'Association secrète des Hunters"],
        correctIndex: 2,
      },
      {
        question: "Comment Kurapika neutralise-t-il temporairement le Nen de Chrollo dans l'arc York New ?",
        options: [
          "En l'empoisonnant",
          "En lui retirant son livre",
          "En l'enchaînant avec son Judgment Chain",
          "En le paralysant avec ses aiguilles de Nen",
        ],
        correctIndex: 2,
      },
      {
        question: "Qu'est-ce que Chrollo lit lorsqu'il attend ou réfléchit ?",
        options: ["Des stratégies militaires", "De la littérature classique — notamment Borges", "Des grimoires alchimiques", "Des rapports de la Brigade"],
        correctIndex: 1,
      },
    ],
  },
];

// ─────────────────────────────────────────────
// SCRIPT PRINCIPAL
// ─────────────────────────────────────────────
async function importHXH() {
  console.log("🔍 Début import Hunter x Hunter dans Firestore...\n");

  try {
    const result = await mammoth.extractRawText({
      path: path.join(__dirname, "../Hunter_x_Hunter_Personnages_OTADEX_2026.docx"),
    });
    const lineCount = result.value.split("\n").filter((l) => l.trim()).length;
    console.log(`📄 Document HxH lu avec mammoth — ${lineCount} lignes extraites`);
  } catch {
    console.log("ℹ️  mammoth non disponible — import depuis les données inline du script");
  }

  // 1. Import Animé
  await db.collection("animes").doc("hunter-x-hunter").set(animeData, { merge: true });
  console.log("✅ Animé Hunter x Hunter importé");

  // 2. Import Créateur
  await db.collection("creators").doc("yoshihiro-togashi").set(creatorData, { merge: true });
  console.log("✅ Créateur Yoshihiro Togashi importé");

  // 3. Import Studio
  await db.collection("studios").doc("madhouse").set(studioData, { merge: true });
  console.log("✅ Studio Madhouse importé");

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
    title: "🔍 Hunter x Hunter débarque sur OTADEX !",
    body: "Killua, Gon, Hisoka et le système Nen sont disponibles. Explore leurs fiches !",
    route: "/anime/hunter-x-hunter",
    type: "new_characters",
  });

  console.log("\n🎉 Import Hunter x Hunter terminé avec succès !");
  console.log("📊 Résumé :");
  console.log("   1 animé (hunter-x-hunter)");
  console.log("   1 créateur (yoshihiro-togashi)");
  console.log("   1 studio (madhouse)");
  console.log(`   ${characters.length} personnages (hxh-*)`);
  console.log(`   ${quizzes.length} quiz (Killua, Gon, Hisoka, Kurapika, Meruem, Netero, Chrollo)`);
  process.exit(0);
}

importHXH().catch((err) => {
  console.error("❌ Erreur import :", err);
  process.exit(1);
});
