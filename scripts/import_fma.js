/**
 * OTADEX — Import Fullmetal Alchemist Brotherhood vers Firestore
 * Lit Fullmetal_Alchemist_Personnages_OTADEX_2026.docx et insère les données dans Firebase Firestore.
 * Usage : node scripts/import_fma.js
 * Prérequis : npm install mammoth firebase-admin (à la racine du projet)
 *
 * Images GitHub raw base URL (quand les images seront poussées dans otadex-assets) :
 * https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/
 * Dossiers disponibles : Edward Elric, Alphonse Elric, Roy Mustang, Riza Hawkeye, Winry Rockbell,
 *   Van Hohenheim, Father, King Bradley, Scar, Maes Hughes, Pride Selim Bradley, Greed Ling Yao, Izumi Curtis
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
  id: "fullmetal-alchemist",
  titre: "Fullmetal Alchemist: Brotherhood",
  titreJaponais: "鋼の錬金術師 FULLMETAL ALCHEMIST",
  synopsis:
    "Dans un monde où l'alchimie est une science régie par la Loi de l'Échange Équivalent, deux frères — Edward et Alphonse Elric — payent le prix d'une transmutation humaine interdite en cherchant à ressusciter leur mère. Leur quête de la Pierre Philosophale les entraîne dans une conspiration millénaire au cœur du pays.",
  genres: ["Shōnen", "Action", "Aventure", "Fantasy", "Drame", "Philosophie"],
  annee: 2009,
  episodes: 64,
  studio: "Bones",
  studioId: "bones",
  auteur: "Hiromu Arakawa",
  auteurId: "hiromu-arakawa",
  editeur: "Square Enix (Monthly Shōnen Gangan)",
  editeurVF: "Kurokawa",
  volumes: 27,
  chapitres: 108,
  scoreMal: "9.10/10",
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
  id: "hiromu-arakawa",
  nom: "Hiromu Arakawa",
  nomJaponais: "荒川 弘",
  bio: "Hiromu Arakawa naît le 8 mai 1973 à Makubetsu, Hokkaido, Japon. Issue d'une famille de 6 enfants dans une laiterie familiale, elle développe une éthique du travail rigoureuse. Son pseudonyme masculin est choisi délibérément pour éviter les préjugés dans l'industrie. Elle lance Fullmetal Alchemist en 2001 dans le Monthly Shōnen Gangan — 80 millions d'exemplaires vendus dans le monde. La série remporte le Prix Shōgakukan en 2004. Après FMA, elle publie Silver Spoon (Prix Shōgakukan 2013) et Tsugai - Daemons of the Shadow Realm (2022).",
  dateNaissance: "8 mai 1973",
  lieuNaissance: "Makubetsu, Hokkaido, Japon",
  nationalite: "Japonaise",
  imageUrl: "",
  occupation: "Mangaka",
  oeuvres: [
    { titre: "Stray Dog (one-shot)", annee: 1998, type: "One-shot Square Enix" },
    { titre: "Fullmetal Alchemist (鋼の錬金術師)", annee: 2001, type: "Manga — 27 volumes — Monthly Shōnen Gangan — 80M+ copies" },
    { titre: "Hero Tales (Jūshin Enbu)", annee: 2006, type: "Manga — 5 volumes — Monthly Shōnen Gangan" },
    { titre: "Silver Spoon (Gin no Saji)", annee: 2011, type: "Manga — 15 volumes — Weekly Shōnen Sunday — Prix Shōgakukan 2013" },
    { titre: "The Heroic Legend of Arslan (Arslan Senki)", annee: 2013, type: "Manga — 15 volumes — Monthly Shōnen Magazine" },
    { titre: "Tsugai — Daemons of the Shadow Realm", annee: 2022, type: "Manga en cours — Monthly Shōnen Gangan" },
  ],
  recompenses: [
    "Prix Shōgakukan 49e édition (2004) — catégorie Shōnen — pour Fullmetal Alchemist",
    "Prix Shōgakukan 58e édition (2013) — pour Silver Spoon",
    "FMA:Brotherhood : Score MAL 9.10/10 — Top 3 anime de tous les temps — 2,2M votes",
    "80+ millions de volumes de FMA vendus dans le monde",
    "Première auteure à avoir deux séries consécutives récompensées au Prix Shōgakukan dans la même décennie",
  ],
  influences: [
    "Éthique du travail de la ferme familiale",
    "Lecture de manga shōnen classique",
    "Visite en Égypte (inspiration pour Brigade Fantôme)",
    "Kohei Horikoshi (My Hero Academia) cite FMA comme référence directe",
  ],
  animeIds: ["fullmetal-alchemist"],
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 3. DONNÉES STUDIO
// ─────────────────────────────────────────────
const studioData = {
  id: "bones",
  nom: "Bones",
  nomComplet: "株式会社ボンズ",
  fondation: 1998,
  fondateur: "Masahiko Minami, Hiroshi Ōsaka, Tensai Okamura",
  siege: "Nerima, Tokyo, Japon",
  description:
    "Studio d'animation japonais fondé en 1998 par d'anciens membres de Sunrise. Reconnu pour la qualité de ses chorégraphies d'action et ses animations fluides. Réalisateur FMA:Brotherhood : Yasuhiro Irie. Musique : Akira Senju. L'OST de Brotherhood est considérée parmi les meilleures de l'histoire de l'animation.",
  productions: [
    "Fullmetal Alchemist (2003)",
    "Fullmetal Alchemist: Brotherhood (2009–2010)",
    "Ouran High School Host Club",
    "Soul Eater",
    "Bungo Stray Dogs",
    "My Hero Academia (Saisons 1-7)",
    "Mob Psycho 100",
    "Carole & Tuesday",
  ],
  animeIds: ["fullmetal-alchemist"],
  logoUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 4. DONNÉES PERSONNAGES (13)
// ─────────────────────────────────────────────
const characters = [
  // ── #1 Edward Elric ──
  {
    id: "fma-edward-elric",
    nom: "Edward Elric",
    nomJaponais: "エドワード・エルリック",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "15 ans (début) — 16 ans en cours",
    sexe: "Masculin",
    dateNaissance: "Vers 1899",
    taille: "149 cm (début) — complexe de taille légendaire",
    groupeSanguin: "O",
    nationalite: "Amestris (fictive)",
    statut: "Protagoniste principal",
    rang: "Alchimiste d'État — Major (le plus jeune à 12 ans)",
    poste: "Fullmetal Alchemist — Alchimiste d'État",
    lycee: "",
    description:
      "Edward Elric est le protagoniste principal de Fullmetal Alchemist. Surnommé le 'Fullmetal Alchemist' en référence à ses prothèses en métal (automail), il est à 12 ans le plus jeune Alchimiste d'État de l'histoire d'Amestris. Après la mort de leur mère Trisha, lui et son frère Alphonse tentent une transmutation humaine — acte absolument interdit. L'expérience échoue : Ed perd son bras droit et sa jambe gauche, Alphonse perd tout son corps. Colérique, orgueilleux et obsédé par sa petite taille, Ed cache sous cette carapace une loyauté absolue et une détermination inébranlable.",
    pouvoirs: [
      "Transmutation sans cercle : capacité rarissime — transmute directement en joignant ses mains",
      "Alchimie de combat offensif : reconstruction de l'environnement en armes, armures, pièges en temps réel",
      "Automail intégré : son bras droit est directement transmutable en lame ou pique de métal",
      "Connaissances encyclopédiques en alchimie : autodidacte puis formé par Izumi Curtis",
      "Résistance physique exceptionnelle : corps conditionné pour encaisser des chocs extrêmes",
      "Vision de la Vérité : accède à une connaissance alchimique totale après la transmutation humaine",
    ],
    voixJaponaise: "Romi Park",
    voixAnglaise: "Vic Mignogna",
    relations: [
      { nomPersonnage: "Alphonse Elric", type: "Frère — raison d'être du voyage" },
      { nomPersonnage: "Winry Rockbell", type: "Amour romantique — déclaration finale" },
      { nomPersonnage: "Van Hohenheim", type: "Père absent — réconciliation progressive" },
      { nomPersonnage: "Roy Mustang", type: "Supérieur hiérarchique — allié" },
      { nomPersonnage: "Izumi Curtis", type: "Mentor alchimiste" },
    ],
    citations: [
      "Un humain qui sacrifie quelque chose d'humain peut récupérer quelque chose d'équivalent — c'est la Loi de l'Échange Équivalent.",
      "Je ne peux pas m'arrêter. Tant qu'Al n'a pas récupéré son corps, je n'ai pas le droit de m'arrêter.",
    ],
    trivia: [
      "Son complexe de taille est un gag récurrent — il réagit avec violence à tout commentaire sur sa petite taille",
      "Voix japonaise : Romi Park — une femme adulte doublant un adolescent avec un naturel absolu",
      "Sa déclaration d'amour à Winry est formulée comme une équation alchimique — 'équivalent à ma vie entière'",
      "À la fin de la série, il sacrifie sa capacité alchimique pour ramener Alphonse — acte rédempteur total",
    ],
    popularityRank: 1,
    isNew: false,
    isTrending: true,
    likesCount: 48750,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar7.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar8.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar9.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar10.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Edward%20Elric/fma_edwar1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #2 Roy Mustang ──
  {
    id: "fma-roy-mustang",
    nom: "Roy Mustang",
    nomJaponais: "ロイ・マスタング",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "29 ans (début) — 30 ans (fin)",
    sexe: "Masculin",
    dateNaissance: "Non précisée officiellement",
    taille: "173 cm",
    groupeSanguin: "",
    nationalite: "Amestris (fictive)",
    statut: "Protagoniste secondaire",
    rang: "Colonel (début) — Brigadier-Général (fin) — Promesse de devenir Führer",
    poste: "Colonel — Alchimiste de Flamme",
    lycee: "",
    description:
      "Roy Mustang est le personnage secondaire le plus populaire de la série. Alchimiste de Flamme redouté et stratège de génie, il poursuit un objectif politique précis : devenir Führer et réformer le pays, notamment pour réparer les crimes de la Guerre d'Ishbal. Derrière sa façade nonchalante et séductrice se cache un manipulateur de longue vue. Sa cécité temporaire lors du combat final — guidé par Riza pour lancer ses flammes — est l'un des moments les plus poignants de Brotherhood.",
    pouvoirs: [
      "Alchimie de Flamme : décompose l'oxygène de l'air par ses gants à étincelles — flammes d'une précision chirurgicale",
      "Contrôle de l'humidité : ses flammes sont inutilisables sous la pluie (faiblesse connue)",
      "Stratégie militaire : planification tactique de longue durée — maître de la manipulation politique",
      "Gants à friction : claquements de doigts suffisants pour déclencher l'alchimie",
      "Régénération Homunculus négociée : temporairement aveugle pendant le combat final",
    ],
    voixJaponaise: "Shin-ichiro Miki",
    voixAnglaise: "Travis Willingham",
    relations: [
      { nomPersonnage: "Riza Hawkeye", type: "Lieutenant — loyauté réciproque absolue" },
      { nomPersonnage: "Maes Hughes", type: "Meilleur ami décédé — catalyseur de sa quête" },
      { nomPersonnage: "Edward Elric", type: "Subordonné encombrant et respecté" },
    ],
    citations: [
      "Je deviendrai Führer d'Amestris. Ce n'est pas un rêve — c'est un objectif.",
      "Un homme sait quand il doit pleurer. Et moi, je pleure dans la pluie.",
    ],
    trivia: [
      "Sa capacité est inutilisable sous la pluie — une faiblesse délibérément exploitée par ses ennemis",
      "Voix japonaise : Shin-ichiro Miki — voix signature qui définit l'archétype du personnage séducteur sérieux",
      "Sa cécité temporaire (Pride lui a volé ses yeux) est résolue par une transmutation de Roy lui-même",
      "A participé à la Guerre d'Ishbal — une culpabilité qui motive tout son arc politique",
    ],
    popularityRank: 2,
    isNew: false,
    isTrending: true,
    likesCount: 35200,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy7.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy8.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy9.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy10.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Roy%20Mustang/fma_roy1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #3 Alphonse Elric ──
  {
    id: "fma-alphonse-elric",
    nom: "Alphonse Elric",
    nomJaponais: "アルフォンス・エルリック",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "14 ans (début) — 15 ans en cours",
    sexe: "Masculin",
    dateNaissance: "Vers 1900",
    taille: "Armure d'acier de 2 mètres environ — âme scellée dedans",
    groupeSanguin: "",
    nationalite: "Amestris (fictive)",
    statut: "Co-protagoniste",
    rang: "Alchimiste — Âme sans corps",
    poste: "Partenaire d'Edward — Armure Vivante",
    lycee: "",
    description:
      "Alphonse Elric est le co-protagoniste et l'incarnation la plus poignante du concept central de la série. Son âme scellée dans une armure par son frère après la transmutation humaine ratée, il voyage sans corps depuis ses 10 ans — incapable de manger, dormir ou ressentir. Malgré cette situation tragique, Alphonse est le membre le plus gentil et le plus réfléchi du duo. Il adore les chats (comique récurrent) et sa bonté naturelle lui permet de tisser des liens avec des ennemis que la force ne pourrait jamais convaincre.",
    pouvoirs: [
      "Transmutation sans cercle : même capacité qu'Edward acquise après leur transmutation humaine",
      "Alchimie de combat défensive : reconstruction de l'environnement — style plus défensif qu'Edward",
      "Force physique colossale : son armure lui confère résistance et puissance surhumaines",
      "Sceau de sang : le pentacle de sang d'Edward sur l'armure est sa seule vulnérabilité",
      "Maîtrise des techniques Xingaises : apprend l'Alkaestrie auprès de May Chang",
    ],
    voixJaponaise: "Rie Kugimiya",
    voixAnglaise: "Maxey Whitehead",
    relations: [
      { nomPersonnage: "Edward Elric", type: "Frère aîné — raison du voyage" },
      { nomPersonnage: "Winry Rockbell", type: "Amie d'enfance" },
      { nomPersonnage: "May Chang", type: "Amie précieuse — relation inattendue" },
    ],
    citations: [
      "Je ne suis pas sûr d'être réel. Est-ce que mes souvenirs sont vrais ou juste ce que Ed a mis en moi ?",
      "Frère ne ment pas. Il fait juste tout pour que je ne remarque pas ce qu'il sacrifie.",
    ],
    trivia: [
      "Son armure pèse environ 500 kg — mais son âme le rend parfaitement agile grâce à l'alchimie",
      "Ramasse des chats partout et les cache dans son armure — comique récurrent",
      "Ses doutes sur son existence — est-il réel ou une construction ? — sont le questionnement philosophique le plus riche",
      "À la fin, Edward sacrifie son alchimie pour lui rendre son corps — acte qui inverse le sacrifice initial",
    ],
    popularityRank: 3,
    isNew: false,
    isTrending: true,
    likesCount: 28900,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho6.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Alphonse%20Elric/fma_alpho1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #4 Riza Hawkeye ──
  {
    id: "fma-riza-hawkeye",
    nom: "Riza Hawkeye",
    nomJaponais: "リザ・ホークアイ",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "25 ans (début) — 28 ans (fin)",
    sexe: "Féminin",
    dateNaissance: "2 octobre",
    taille: "168 cm",
    groupeSanguin: "",
    nationalite: "Amestris (fictive)",
    statut: "Protagoniste secondaire",
    rang: "Lieutenant Premier — Bras droit de Mustang",
    poste: "Lieutenant — Tireuse d'élite",
    lycee: "",
    description:
      "Riza Hawkeye est le lieutenant personnel de Roy Mustang et l'un des personnages les plus complets de la série. Tireuse d'élite de talent exceptionnel, elle est le 'fusil' de Mustang. Fille de Berthold Hawkeye, elle porte les tatouages alchimiques de son père sur son dos — faisant d'elle la gardienne et la clé des pouvoirs de Mustang. Sa relation avec Mustang est le sous-texte émotionnel le plus fort de la série — une loyauté réciproque totale, jamais exprimée ouvertement mais constamment présente.",
    pouvoirs: [
      "Tir de précision élite : maîtrise de multiples armes à feu — précision absolue à longue et courte portée",
      "Double pistolets : combat rapproché avec deux armes simultanées",
      "Maîtrise tactique du champ de bataille : guide les flammes de Mustang quand il est aveugle",
      "Tatouages alchimiques dorsaux : contiennent les secrets de l'alchimie de flamme de son père",
      "Sang-froid absolu : capacité à agir même dans les situations les plus extrêmes",
    ],
    voixJaponaise: "Fumiko Orikasa",
    voixAnglaise: "Colleen Clinkenbeard",
    relations: [
      { nomPersonnage: "Roy Mustang", type: "Loyauté absolue — relation tacite non déclarée" },
      { nomPersonnage: "Edward Elric", type: "Alliée bienveillante" },
    ],
    citations: [
      "Je suis le lieutenant Hawkeye. Mon travail est de garder le colonel en vie.",
      "Si le colonel s'égare, c'est moi qui l'abattrai. C'est notre pacte.",
    ],
    trivia: [
      "Son chien Black Hayate — Shiba Inu — a été entraîné par elle à la rigueur absolue",
      "Sa cicatrice à la gorge (infligée par Pride) symbolise la violence de leur mission partagée",
      "Les tatouages alchimiques dans son dos sont la seule copie de l'alchimie de flamme de son père",
      "Elle est l'une des rares à connaître la véritable identité de l'Homunculus Père et de Bradley",
    ],
    popularityRank: 4,
    isNew: false,
    isTrending: false,
    likesCount: 22400,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza7.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza8.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza9.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Riza%20Hawkeye/fma_riza1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #5 Winry Rockbell ──
  {
    id: "fma-winry-rockbell",
    nom: "Winry Rockbell",
    nomJaponais: "ウィンリィ・ロックベル",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "15 ans (début) — 16 ans en cours",
    sexe: "Féminin",
    dateNaissance: "Vers 1900",
    taille: "165 cm environ",
    groupeSanguin: "",
    nationalite: "Amestris (fictive) — Resembool",
    statut: "Protagoniste secondaire — intérêt romantique d'Edward",
    rang: "Mécanicienne Automail de génie",
    poste: "Ingénieure Automail — Amie des frères Elric",
    lycee: "",
    description:
      "Winry Rockbell est l'amie d'enfance d'Edward et Alphonse et la figure émotionnelle centrale de la série. Mécanicienne Automail de génie, elle fabrique et entretient les membres d'Edward depuis son enfance, représentant le seul lien de normalité des frères Elric. Sa passion pour les machines contraste avec son histoire personnelle : ses parents médecins militaires ont été tués lors de la Guerre d'Ishbal par Scar, qu'elle finira par soigner. Ce pardon accordé est l'un des moments moralement les plus courageux de la série.",
    pouvoirs: [
      "Automail Engineering : fabrication et réparation des prothèses mécaniques d'Edward",
      "Adaptation du design : améliore constamment l'automail en fonction des besoins de combat",
      "Clé à molette offensive : arme de choix pour punir Ed de ses imprudences (comique récurrent)",
      "Soins médicaux : héritage de ses parents médecins — soigne même ses ennemis",
    ],
    voixJaponaise: "Megumi Toyoguchi",
    voixAnglaise: "Caitlin Glass",
    relations: [
      { nomPersonnage: "Edward Elric", type: "Amour romantique — déclaration finale" },
      { nomPersonnage: "Alphonse Elric", type: "Frère du cœur" },
      { nomPersonnage: "Scar", type: "A tué ses parents — lui pardonne finalement" },
    ],
    citations: [
      "Vous savez ce que vous avez fait ? Vous avez abîmé mon automail sans raison !",
      "Je vous attends ici à Resembool. Revenez vivants, tous les deux.",
    ],
    trivia: [
      "Tombe systématiquement en extase face à un mécanisme sophistiqué — running gag emblématique",
      "A forgé les prothèses d'Edward plusieurs fois en conditions de combat extrêmes",
      "Sa clé à molette est son arme de punition récurrente contre Edward — symbole de leur relation",
      "Son pardon à Scar (qui a tué ses parents) est considéré comme l'un des actes moraux les plus forts de la série",
    ],
    popularityRank: 5,
    isNew: false,
    isTrending: false,
    likesCount: 19800,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry7.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry8.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry9.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Winry%20Rockbell/fma_winry1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #6 Van Hohenheim ──
  {
    id: "fma-van-hohenheim",
    nom: "Van Hohenheim",
    nomJaponais: "ヴァン・ホーエンハイム",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "Plusieurs centaines d'années — né dans l'empire de Xerxès",
    sexe: "Masculin",
    dateNaissance: "Ère de l'empire de Xerxès (plusieurs siècles avant la série)",
    taille: "185 cm environ",
    groupeSanguin: "",
    nationalite: "Xerxès (empire disparu)",
    statut: "Protagoniste secondaire — père d'Edward et Alphonse",
    rang: "Alchimiste légendaire — Humain-Pierre Philosophale",
    poste: "Père des frères Elric — Porteur de 536 000 âmes",
    lycee: "",
    description:
      "Van Hohenheim est le père d'Edward et Alphonse et l'un des personnages les plus complexes de la série. Ancien esclave de Xerxès, il a été utilisé par le premier Homunculus pour créer une Pierre Philosophale à partir de toute la population de Xerxès. Il porte dans son corps 536 000 âmes depuis des siècles, incapable de vieillir ou de mourir. Sa rencontre avec Trisha Elric lui offre enfin une raison de vivre — mais son incapacité à rester condamne sa famille. Son sacrifice final pour contrer Père est l'acte rédempteur le plus puissant de la série.",
    pouvoirs: [
      "Transmutation sans cercle de niveau absolu : niveau alchimique non quantifiable — accumulé sur des siècles",
      "Corps de Pierre Philosophale : 536 000 âmes — source d'énergie quasi-illimitée",
      "Transmutation corporelle : peut modifier son propre corps à volonté",
      "Contrôle des âmes internes : dialogue avec les âmes en lui, les mobilise comme armée",
      "Connaissance historique absolue : a observé 400 ans d'histoire d'Amestris",
    ],
    voixJaponaise: "Unsho Ishizuka",
    voixAnglaise: "John Swasey",
    relations: [
      { nomPersonnage: "Edward Elric", type: "Fils aîné — relation tendue — réconciliation progressive" },
      { nomPersonnage: "Alphonse Elric", type: "Fils cadet — moins hostile qu'Edward" },
      { nomPersonnage: "Father", type: "Ennemi de toujours — créés ensemble à Xerxès" },
    ],
    citations: [
      "J'ai vécu si longtemps, et j'ai tout perdu. Trisha était la seule chose qui me donnait envie de rester humain.",
      "Père... c'est l'heure de rembourser cette dette. Avec toutes les âmes que tu m'as données.",
    ],
    trivia: [
      "Porte 536 000 âmes de Xerxès dans son corps depuis des siècles — chaque âme lui parle",
      "Son nom de famille 'Hohenheim' est une référence à Paracelse, fondateur de l'alchimie médicale",
      "Il meurt paisiblement sur la tombe de Trisha — l'une des fins les plus émouvantes de la série",
      "Sa relation avec ses fils est renversée : Alphonse est plus indulgent, Edward est le plus hostile",
    ],
    popularityRank: 6,
    isNew: false,
    isTrending: false,
    likesCount: 15600,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van7.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Van%20Hohenheim/fma_van1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #7 Père (Father) ──
  {
    id: "fma-father",
    nom: "Père (Father)",
    nomJaponais: "お父様",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "Plusieurs centaines d'années — né à Xerxès",
    sexe: "Masculin (aspect humain mature)",
    dateNaissance: "Ère de l'empire de Xerxès",
    taille: "Variable — peut prendre la forme de Hohenheim",
    groupeSanguin: "",
    nationalite: "Xerxès (empire disparu)",
    statut: "Antagoniste principal",
    rang: "Premier Homunculus — Créateur des Sept Péchés Capitaux",
    poste: "Antagoniste absolu — Dieu raté",
    lycee: "",
    description:
      "Père est l'antagoniste principal et absolu de Fullmetal Alchemist Brotherhood. Né d'un flacon dans l'empire de Xerxès il y a plusieurs siècles, il est le Premier Homunculus. Son objectif : transcender la condition humaine et devenir Dieu. Pour cela, il a manipulé l'histoire d'Amestris sur des siècles, déclenchant des guerres stratégiquement pour créer un immense cercle de transmutation. Sa victoire temporaire — absorber Dieu lui-même — révèle son échec fondamental : un être qui a voulu tout posséder sans comprendre ce qui donne valeur à la vie.",
    pouvoirs: [
      "Alchimie absolue : manipulation de la matière sans aucune contrainte ni cercle",
      "Absorption d'Homunculi : peut absorber ses enfants Homunculus et leurs pouvoirs",
      "Absorption de Dieu/Vérité (temporaire) : absorbe le pouvoir divin lors de l'Éclipse de Sang",
      "Création des Sept Homunculi : a extrait ses propres vices pour les personnifier",
      "Corps parfait : régénération illimitée, force et vitesse quasi-divines",
      "Répression alchimique : peut bloquer l'alchimie de tous les Alchimistes d'État",
    ],
    voixJaponaise: "Rikiya Koyama",
    voixAnglaise: "Kent Williams",
    relations: [
      { nomPersonnage: "Van Hohenheim", type: "Ennemi historique — créés ensemble à Xerxès" },
      { nomPersonnage: "King Bradley", type: "Marionnette politique — Homunculus Wrath" },
      { nomPersonnage: "Edward Elric", type: "Sacrifice nécessaire — Human Sacrifice" },
    ],
    citations: [
      "Vous, les humains, vous appelez ça un péché. Mais je l'appelle le progrès.",
      "Je voulais tout avoir — la connaissance, la liberté, la perfection. Et maintenant je n'ai plus rien.",
    ],
    trivia: [
      "A extrait ses propres vices (Orgueil, Avarice, Envie, etc.) pour créer les Sept Homunculi",
      "Sa forme finale — absorbant Dieu — révèle un être fondamentalement vide sans ambition plus haute",
      "Créé à partir de l'ombre de la Vérité — il est essentiellement une copie dégradée de Dieu",
      "Son renvoi dans la Vérité est puni par la perte de toutes les âmes qu'il avait accumulées",
    ],
    popularityRank: 7,
    isNew: false,
    isTrending: false,
    likesCount: 12100,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe6.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Father/fma_fathe1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #8 King Bradley / Wrath ──
  {
    id: "fma-king-bradley",
    nom: "King Bradley / Wrath",
    nomJaponais: "キング・ブラッドレイ",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "Apparence ~60 ans — véritablement un homme âgé transformé en Homunculus",
    sexe: "Masculin",
    dateNaissance: "Non précisée",
    taille: "180 cm environ",
    groupeSanguin: "",
    nationalite: "Amestris (fictive)",
    statut: "Antagoniste — Führer d'Amestris",
    rang: "Führer suprême d'Amestris — Homunculus Wrath",
    poste: "Führer — Chef Commandant Suprême des Forces Armées",
    lycee: "",
    description:
      "King Bradley est l'une des figures les plus ambivalentes de la série. Führer suprême d'Amestris, il est en réalité l'Homunculus Wrath, placé par Père à la tête du pays. Sa particularité absolue parmi les Homunculi : il est né d'un humain, conserve une mort humaine et vieillit réellement. Son Ultimate Eye lui permet de percevoir tous les mouvements adverses — il peut couper un obus en vol. Sa relation avec sa femme — assignée mais authentiquement aimée — humanise un antagoniste d'abord froid et politique.",
    pouvoirs: [
      "Ultimate Eye (Œil Ultime) : œil gauche caché — perçoit tous les mouvements adverses avec anticipation parfaite",
      "Escrime insurpassable : vitesse et précision d'épée dépassant tout autre combattant de la série",
      "Coupe de projectiles en vol : peut trancher des balles et des obus lancés vers lui",
      "Capacités physiques Homunculus : force et vitesse surhumaines — sans régénération contrairement aux autres",
      "Autorité politique absolue : commande l'armée entière d'Amestris par son rang de Führer",
    ],
    voixJaponaise: "Hidekatsu Shibata",
    voixAnglaise: "Ed Blaylock",
    relations: [
      { nomPersonnage: "Father", type: "Maître et créateur" },
      { nomPersonnage: "Scar", type: "Ennemi final — mort face à lui" },
      { nomPersonnage: "Roy Mustang", type: "Adversaire politique et militaire" },
    ],
    citations: [
      "Le Führer n'a pas d'erreurs. C'est son existence même qui définit ce qu'est la juste décision.",
      "Je suis né humain. Et je mourrai humain. C'est ma seule fierté en tant qu'Homunculus.",
    ],
    trivia: [
      "Seul Homunculus à vieillir et à pouvoir mourir d'une mort humaine",
      "Son combat contre Scar sur le pont est considéré comme l'une des meilleures scènes d'action de la série",
      "Son fils adoptif Selim est en réalité Pride — le plus puissant des Homunculi — ironie absolue",
      "Sa femme lui a été 'assignée' par Père mais Bradley l'a vraiment aimée — humanisation de l'antagoniste",
    ],
    popularityRank: 8,
    isNew: false,
    isTrending: false,
    likesCount: 10800,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king7.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king8.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king9.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/King%20Bradley/fma_king1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #9 Scar ──
  {
    id: "fma-scar",
    nom: "Scar",
    nomJaponais: "スカー",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "~30 ans estimé",
    sexe: "Masculin",
    dateNaissance: "Non révélée",
    taille: "190 cm environ",
    groupeSanguin: "",
    nationalite: "Ishbal (peuple génocidé)",
    statut: "Antagoniste reconverti — allié",
    rang: "Moine Guerrier Ishbalan — Tueur d'Alchimistes d'État",
    poste: "Survivant d'Ishbal — Vengeur converti en allié",
    lycee: "",
    description:
      "Scar est l'antagoniste moral le plus nuancé de Brotherhood. Survivant de la Guerre d'Ishbal — un génocide orchestré par l'armée d'Amestris — il a perdu son frère, sa nation et sa foi. Portant le bras de son frère décédé, gravé de tatouages alchimiques, il a juré de tuer tous les Alchimistes d'État. Son arc de rédemption progressive — comprenant que le vrai ennemi est Père — et sa coopération forcée puis volontaire avec les Elric constitue l'un des développements de personnage les plus riches de la série.",
    pouvoirs: [
      "Déconstruction alchimique (bras droit) : détruit immédiatement la structure moléculaire de tout ce qu'il touche",
      "Reconstruction alchimique (tatouages du frère) : crée de nouvelles structures à partir de matériaux décomposés",
      "Alchimie d'Ishbal fusionnée : combine les principes alchimiques amestris et xingais",
      "Force physique imposante : combattant redoutable au corps-à-corps sans alchimie",
    ],
    voixJaponaise: "Ryotaro Okiayu",
    voixAnglaise: "J. Michael Tatum",
    relations: [
      { nomPersonnage: "Edward Elric", type: "Ennemi devenu allié" },
      { nomPersonnage: "May Chang", type: "Alliée inattendue — comprend l'alchimie d'Ishbal" },
      { nomPersonnage: "Roy Mustang", type: "Confrontation symbolique — tous deux coupables de la même guerre" },
    ],
    citations: [
      "Je ne cherche pas la rédemption. Je cherche juste à protéger ce qui reste de mon peuple.",
      "L'alchimie est une abomination contre Dieu. Je me sers d'une abomination pour punir d'autres abominateurs.",
    ],
    trivia: [
      "Son vrai nom n'est jamais révélé pendant la quasi-totalité de la série",
      "Yeux rouges caractéristiques du peuple Ishbalan — trait génétique distinctif",
      "Ses parents de Winry Rockbell ont été tués par lui lors de la guerre — elle lui pardonne malgré tout",
      "Son arc moral — de tueur à allié — est l'une des évolutions les plus nuancées du shōnen",
    ],
    popularityRank: 9,
    isNew: false,
    isTrending: false,
    likesCount: 9600,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar7.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Scar/fma_scar1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #10 Maes Hughes ──
  {
    id: "fma-maes-hughes",
    nom: "Maes Hughes",
    nomJaponais: "マース・ヒューズ",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "~29 ans estimé",
    sexe: "Masculin",
    dateNaissance: "Non précisée",
    taille: "180 cm environ",
    groupeSanguin: "",
    nationalite: "Amestris (fictive)",
    statut: "Protagoniste secondaire — décédé",
    rang: "Lieutenant-Colonel — Chef du bureau des affaires générales",
    poste: "Lieutenant-Colonel — Meilleur ami de Mustang",
    lycee: "",
    description:
      "Maes Hughes est le personnage dont la mort est unanimement considérée comme la plus bouleversante de FMA Brotherhood et l'une des plus impactantes du shōnen en général. Lieutenant-Colonel exubérant, obsédé par sa fille Elicia et sa femme Gracia, il semble être le personnage comique de service — jusqu'à ce qu'il révèle sa profonde intelligence en recoupant les secrets de la conspiration de Père. Son assassinat par Envy, qui a pris l'apparence de sa femme pour approcher, est le tournant émotionnel de toute la série.",
    pouvoirs: [
      "Analyse d'informations militaires : intelligence tactique et recoupement de données supérieur",
      "Combat au couteau : adresse exceptionnelle au lancer de couteaux — affûtés par amour de sa fille",
      "Réseau de renseignements : accès aux archives militaires confidentielles",
      "Enquête sous couverture : recoupement de données sur la conspiration sans éveiller les soupçons",
    ],
    voixJaponaise: "Keiji Fujiwara",
    voixAnglaise: "Sonny Strait",
    relations: [
      { nomPersonnage: "Roy Mustang", type: "Meilleur ami — sa mort catalyse toute la quête de Mustang" },
      { nomPersonnage: "Edward Elric", type: "Mentor bienveillant" },
    ],
    citations: [
      "Ma fille Elicia a dit ses premiers mots hier ! Vous voulez voir la photo ?",
      "Mustang. J'ai trouvé quelque chose de très important. Ne t'approche pas de Central pour l'instant.",
    ],
    trivia: [
      "Montre obsessionnellement des photos de sa fille Elicia à tout le monde — running gag touchant",
      "Sa mort est orchestrée par Envy qui prend l'apparence de sa femme Gracia — torture psychologique maximale",
      "Son enterrement — où Elicia ne comprend pas pourquoi son père 'dort' — est la scène la plus déchirante de la série",
      "Ses couteaux sont aiguisés avec soin — il les dédicace mentalement à sa fille",
    ],
    popularityRank: 10,
    isNew: false,
    isTrending: false,
    likesCount: 8900,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes6.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Maes%20Hughes/fma_maes1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #11 Pride / Selim Bradley ──
  {
    id: "fma-pride-selim-bradley",
    nom: "Pride / Selim Bradley",
    nomJaponais: "プライド / セリム・ブラッドレイ",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "Apparence d'enfant d'environ 10 ans — véritablement des centaines d'années",
    sexe: "Masculin",
    dateNaissance: "Non précisée — Homunculus très ancien",
    taille: "Petite taille enfantine",
    groupeSanguin: "",
    nationalite: "Amestris (fictive)",
    statut: "Antagoniste — Homunculus Orgueil",
    rang: "Premier-Né — Homunculus le plus puissant de Père",
    poste: "Fils adoptif du Führer — Premier-Né des Homunculi",
    lycee: "",
    description:
      "Pride est l'Homunculus de l'Orgueil et le Premier-Né — le plus ancien et le plus puissant des enfants de Père. Dissimulé sous l'apparence du fils adoptif du Führer Bradley, Selim Bradley, il vit parmi les humains comme un enfant innocent. Sa véritable forme — des tentacules d'ombre aux yeux et bouches multiples surgissant de l'obscurité — est l'une des plus terrifiantes de la série. Il ne peut exister qu'à l'intérieur de son domaine délimité par des barrières d'ombre.",
    pouvoirs: [
      "Tentacules d'ombre : manipulation absolue des ombres — extensions tranchantes et prehensiles",
      "Absorption temporaire d'Homunculi : peut dévorer d'autres Homunculi pour utiliser leurs capacités",
      "Absorption d'êtres humains : peut absorber des humains — prend leur forme et leurs mémoires",
      "Vitesse et réflexes d'Homunculus : supérieurs à tout humain",
      "Domaine délimité : doit rester dans son espace d'ombre — vulnérabilité majeure",
    ],
    voixJaponaise: "Yūko Sanpei",
    voixAnglaise: "Alex Organ",
    relations: [
      { nomPersonnage: "Father", type: "Créateur — Premier-Né" },
      { nomPersonnage: "King Bradley", type: "Père adoptif — ironie absolue" },
      { nomPersonnage: "Edward Elric", type: "Cible principale" },
    ],
    citations: [
      "Je suis l'Orgueil. Le Premier-Né. Vous ne pouvez pas me battre dans les ténèbres.",
      "C'est ça la différence entre nous, les humains. Vous vous battez pour des gens. Moi, je me bats pour la perfection.",
    ],
    trivia: [
      "Dissimulé comme fils adoptif du Führer — le masque de l'innocence enfantine parfaitement maintenu",
      "Sa forme d'ombre avec des centaines d'yeux et de bouches est l'une des plus terrifiantes du shōnen",
      "Absorbe Kimblee et utilise ses capacités alchimiques — démontrant sa puissance d'absorption",
      "Sa défaite finale — enfermé dans une poche d'obscurité par la transmutation d'Edward — le réduit à un bébé humain",
    ],
    popularityRank: 11,
    isNew: false,
    isTrending: false,
    likesCount: 7400,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride6.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Pride%20Selim%20Bradley/fma_pride1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #12 Greed / Ling Yao ──
  {
    id: "fma-greed-ling-yao",
    nom: "Greed / Ling Yao",
    nomJaponais: "グリード / リン・ヤオ",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "~17 ans (Ling) — plusieurs décennies (Greed premier) / siècles (Greed final)",
    sexe: "Masculin",
    dateNaissance: "Non précisée",
    taille: "173 cm environ (Ling / Greed partagent le corps)",
    groupeSanguin: "",
    nationalite: "Xing (pays de l'Est fictif) — Ling Yao",
    statut: "Protagoniste secondaire devenu antagoniste temporaire — allié final",
    rang: "12e Prince de Xing — Homunculus Avarice",
    poste: "Prince de Xing / Homunculus Greed (corps partagé)",
    lycee: "",
    description:
      "Greed/Ling Yao représente l'une des relations les plus fascinantes de la série : un Prince de Xing ambitieux partageant son corps avec l'Homunculus de l'Avarice. Ling est venu à Amestris chercher le secret de l'immortalité pour protéger son clan. Greed, le plus ambigu des Homunculi, veut 'tout avoir' mais réalise progressivement que ce qu'il veut vraiment, c'est des compagnons. Leur fusion produit une dynamique unique — compétition interne constante pour le contrôle du corps.",
    pouvoirs: [
      "Bouclier de Carbone (Greed) : transforme sa peau en carbone ultra-dense — armure quasi indestructible",
      "Maîtrise du corps de carbone (Ling) : utilise l'armure de Greed avec sa propre agilité de combattant",
      "Zui Quan (Ling) : style de combat ivrogne — mouvements imprévisibles et instinctifs",
      "Régénération Homunculus : restauration rapide des blessures",
      "Conscience double : Greed et Ling communiquent en interne — stratégie partagée",
    ],
    voixJaponaise: "Yuichi Nakamura (Ling) / Junichi Suwabe (Greed seul)",
    voixAnglaise: "Troy Baker",
    relations: [
      { nomPersonnage: "Edward Elric", type: "Allié progressif — combat côte à côte" },
      { nomPersonnage: "Father", type: "Créateur — sacrifice final contre lui" },
      { nomPersonnage: "Lan Fan", type: "Gardienne de corps loyale de Ling" },
    ],
    citations: [
      "Je veux tout — argent, femmes, pouvoir, liberté. Non, ce que je veux vraiment, c'est des camarades.",
      "Ne te plains pas, gamin. Le monde appartient à ceux qui le veulent assez fort.",
    ],
    trivia: [
      "Greed est le seul Homunculus à se retourner ouvertement contre Père à la fin",
      "La cohabitation Ling/Greed dans un seul corps est l'une des dynamiques les plus comiques et touchantes",
      "Son sacrifice final — rompre volontairement sa connexion à Père pour permettre sa destruction — est rédempteur",
      "Ling Yao devient l'Empereur de Xing à la fin de la série",
    ],
    popularityRank: 12,
    isNew: false,
    isTrending: false,
    likesCount: 6900,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed6.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed7.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed8.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Greed%20Ling%20Yao/fma_greed1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #13 Izumi Curtis ──
  {
    id: "fma-izumi-curtis",
    nom: "Izumi Curtis",
    nomJaponais: "イズミ・カーティス",
    animeId: "fullmetal-alchemist",
    animeName: "Fullmetal Alchemist: Brotherhood",
    auteurId: "hiromu-arakawa",
    auteurNom: "Hiromu Arakawa",
    studioId: "bones",
    studioNom: "Bones",
    age: "~35 ans estimé",
    sexe: "Féminin",
    dateNaissance: "Non précisée",
    taille: "170 cm environ",
    groupeSanguin: "",
    nationalite: "Amestris (fictive) — Dublith",
    statut: "Protagoniste secondaire",
    rang: "Alchimiste indépendante — Maîtresse des frères Elric",
    poste: "Bouchère / Alchimiste — Maîtresse d'Edward et Alphonse",
    lycee: "",
    description:
      "Izumi Curtis est l'alchimiste qui a formé Edward et Alphonse. Bouchère de son état à Dublith, elle cache sous une apparence ordinaire une alchimiste de niveau exceptionnel. Après avoir tenté une transmutation humaine pour ressusciter son enfant mort-né — et avoir survécu avec des organes internes endommagés de façon permanente — elle comprend les frères Elric comme personne d'autre. Sévère jusqu'à la brutalité dans l'entraînement, elle est profondément maternelle dans les moments de crise.",
    pouvoirs: [
      "Transmutation sans cercle : capacité acquise après sa propre tentative de transmutation humaine",
      "Alchimie de combat avancée : reconstruction de l'environnement — puissance et rapidité élevées",
      "Combat physique exceptionnel : entraîne ses élèves à mains nues avant toute alchimie",
      "Connaissances théoriques : niveau encyclopédique — a transmis l'essentiel à Edward et Alphonse",
      "Résistance malgré les dommages internes : combat efficacement malgré ses blessures permanentes",
    ],
    voixJaponaise: "Yoshino Takamori",
    voixAnglaise: "Lydia Mackay",
    relations: [
      { nomPersonnage: "Edward Elric", type: "Disciple — lien maître-élève" },
      { nomPersonnage: "Alphonse Elric", type: "Disciple — lien maître-élève" },
      { nomPersonnage: "Van Hohenheim", type: "Connaissance — tous deux sacrifiés à la Vérité" },
    ],
    citations: [
      "Je suis une belle femme forte et quelque peu violente qui sait cuisiner — et je suis votre maîtresse.",
      "Si vous n'avez pas souffert, vous n'avez pas appris l'alchimie.",
    ],
    trivia: [
      "Régurgite du sang régulièrement à cause de ses organes internes manquants — traité sur le ton comique",
      "Son mari Sig Curtis est le seul homme qu'Izumi craint légèrement — running gag amusant",
      "Elle appartient au cercle des 'Sacrifices Humains' — a vu la Vérité et survécu comme Ed, Al, Mustang",
      "Sa philosophie d'entraînement : survival training d'un mois dans les montagnes pour les nouveaux élèves",
    ],
    popularityRank: 13,
    isNew: false,
    isTrending: false,
    likesCount: 5800,
    images: [
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi1.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi2.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi3.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi4.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi5.jpeg",
        "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi6.jpeg"
      ],
    imagePath: "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/Fullmetal%20Alchemist/Izumi%20Curtis/fma_izumi1.jpeg",
    created_at: FieldValue.serverTimestamp(),
  },
];

// ─────────────────────────────────────────────
// 5. DONNÉES QUIZ (7 personnages × 5 questions)
// ─────────────────────────────────────────────
const quizzes = [
  // Edward Elric
  {
    characterId: "fma-edward-elric",
    questions: [
      {
        question: "Quel surnom Edward Elric déteste-t-il le plus entendre ?",
        options: ["Petit frère", "Gamin en métal", "Alchimiste Nain", "Fullmetal"],
        correctIndex: 2,
      },
      {
        question: "Pourquoi Edward peut-il effectuer de l'alchimie sans cercle de transmutation ?",
        options: [
          "Il a mémorisé tous les cercles existants",
          "Il a vu la Vérité lors de la transmutation humaine ratée",
          "Il utilise son automail comme catalyseur",
          "C'est un pouvoir génétique transmis par Hohenheim",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel membre corporel Edward perd-il lors de la transmutation humaine ratée ?",
        options: ["Jambe gauche et bras gauche", "Bras droit et jambe gauche", "Bras gauche et jambe droite", "Jambe droite et bras droit"],
        correctIndex: 1,
      },
      {
        question: "Comment Edward formule-t-il sa déclaration d'amour à Winry ?",
        options: [
          "Directement et simplement",
          "Par une lettre",
          "Comme une équation alchimique — 'équivalent à ma vie entière'",
          "En lui offrant une bague",
        ],
        correctIndex: 2,
      },
      {
        question: "Que sacrifie Edward pour ramener le corps d'Alphonse à la fin de la série ?",
        options: ["Sa jambe gauche", "Son automail", "Sa capacité d'effectuer de l'alchimie", "Sa vie"],
        correctIndex: 2,
      },
    ],
  },

  // Roy Mustang
  {
    characterId: "fma-roy-mustang",
    questions: [
      {
        question: "Quelle est la principale faiblesse de l'alchimie de flamme de Roy Mustang ?",
        options: ["Le vent", "La pluie", "L'obscurité", "Les surfaces métalliques"],
        correctIndex: 1,
      },
      {
        question: "Comment Roy Mustang active-t-il son alchimie de flamme ?",
        options: [
          "En traçant un cercle au sol",
          "En claquant des doigts avec ses gants à friction",
          "En prononçant une formule alchimique",
          "En combinant ses mains comme Edward",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel est l'objectif politique ultime de Roy Mustang ?",
        options: [
          "Devenir le chef des Alchimistes d'État",
          "Réformer le système militaire de l'intérieur",
          "Devenir Führer d'Amestris",
          "Découvrir la Pierre Philosophale",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel événement tragique catalyse la détermination de Mustang tout au long de la série ?",
        options: [
          "L'assassinat de Riza Hawkeye",
          "La mort de Maes Hughes",
          "La capture d'Alphonse Elric",
          "La révélation de la nature de Bradley",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel conflit passé ronge la conscience de Roy Mustang ?",
        options: ["La Rébellion du Nord", "La Guerre d'Ishbal", "Le Génocide de Xerxès", "La Bataille de Central"],
        correctIndex: 1,
      },
    ],
  },

  // Alphonse Elric
  {
    characterId: "fma-alphonse-elric",
    questions: [
      {
        question: "Dans quoi l'âme d'Alphonse est-elle scellée au début de la série ?",
        options: ["Un golem de pierre", "Une armure d'acier", "Un corps de métal automail", "Un miroir alchimique"],
        correctIndex: 1,
      },
      {
        question: "Quelle est la seule vulnérabilité de l'armure d'Alphonse ?",
        options: [
          "Son articulation gauche",
          "Le pentacle de sang d'Edward inscrit à l'intérieur",
          "Les jointures entre les plaques d'armure",
          "Son heaume qui peut être retiré",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel animal Alphonse cache-t-il régulièrement dans son armure ?",
        options: ["Des lapins", "Des chiens", "Des chats", "Des oiseaux"],
        correctIndex: 2,
      },
      {
        question: "Quelle technique alchimique Alphonse apprend-il auprès de May Chang ?",
        options: ["L'Alchimie de Sang", "L'Alkaestrie Xingaise", "La Transmutation de Vide", "L'Alchimie Inversée"],
        correctIndex: 1,
      },
      {
        question: "Que se passe-t-il quand Edward sacrifie sa capacité alchimique à la fin ?",
        options: [
          "Alphonse reçoit un automail",
          "Alphonse retrouve son corps humain",
          "Alphonse reste dans l'armure mais peut ressentir",
          "Alphonse est libéré de la porte de la Vérité",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Riza Hawkeye
  {
    characterId: "fma-riza-hawkeye",
    questions: [
      {
        question: "Que contiennent les tatouages dans le dos de Riza Hawkeye ?",
        options: [
          "Des formules de guérison alchimique",
          "Les secrets de l'alchimie de flamme de son père",
          "Une carte de la Pierre Philosophale",
          "Des tatouages décoratifs sans signification alchimique",
        ],
        correctIndex: 1,
      },
      {
        question: "Comment Riza aide-t-elle Mustang lors du combat final alors qu'il est aveugle ?",
        options: [
          "Elle lui décrit verbalement les positions ennemies",
          "Elle guide ses mains pour tracer les cercles",
          "Elle tire elle-même sur les ennemis",
          "Elle lui sert d'yeux pour diriger ses flammes avec précision",
        ],
        correctIndex: 3,
      },
      {
        question: "Quel Homunculus inflige une cicatrice à la gorge de Riza ?",
        options: ["Envie", "Wrath", "Pride", "Gloutonnerie"],
        correctIndex: 2,
      },
      {
        question: "Quel est le nom du chien de Riza Hawkeye ?",
        options: ["Hayate", "Black Hayate", "Kuro", "Shadow"],
        correctIndex: 1,
      },
      {
        question: "Quelle promesse Riza a-t-elle faite à Roy Mustang si jamais il s'égarait ?",
        options: [
          "De le rappeler à ses devoirs par une lettre",
          "De le poursuivre jusqu'au bout du monde",
          "De l'abattre elle-même",
          "De démissionner de l'armée",
        ],
        correctIndex: 2,
      },
    ],
  },

  // King Bradley
  {
    characterId: "fma-king-bradley",
    questions: [
      {
        question: "Quel Homunculus représente King Bradley ?",
        options: ["Orgueil (Pride)", "Avarice (Greed)", "Paresse (Sloth)", "Colère (Wrath)"],
        correctIndex: 3,
      },
      {
        question: "Quelle capacité visuelle unique possède King Bradley dans son œil gauche ?",
        options: ["Vision thermique", "Ultimate Eye — anticipation parfaite de tous les mouvements", "Vision nocturne", "Œil du Roi — contrôle mental"],
        correctIndex: 1,
      },
      {
        question: "Quelle est la particularité de Bradley parmi tous les Homunculi de Père ?",
        options: [
          "Il est le plus ancien",
          "Il est le seul créé à partir d'un humain — vieillit et meurt humainement",
          "Il est le seul à ne pas avoir de Pierre Philosophale",
          "Il est le seul à pouvoir se souvenir de ses vies précédentes",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui tue finalement King Bradley ?",
        options: ["Roy Mustang", "Edward Elric", "Scar et Greed/Ling", "Riza Hawkeye"],
        correctIndex: 2,
      },
      {
        question: "Quel est l'exploit de combat le plus célèbre de Bradley dans la série ?",
        options: [
          "Vaincre vingt soldats à mains nues",
          "Couper un obus de char en vol avec son épée",
          "Détruire un tank à lui seul",
          "Battre Roy Mustang en duel",
        ],
        correctIndex: 1,
      },
    ],
  },

  // Maes Hughes
  {
    characterId: "fma-maes-hughes",
    questions: [
      {
        question: "Quelle obsession comique définit Maes Hughes dans la série ?",
        options: [
          "Ses collections de médailles militaires",
          "Ses recettes de cuisine secrètes",
          "Les photos de sa fille Elicia qu'il montre à tout le monde",
          "Ses plans secrets pour devenir Führer",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel Homunculus assassine Maes Hughes ?",
        options: ["Gloutonnerie", "Envie (en prenant l'apparence de sa femme)", "Paresse", "Orgueil"],
        correctIndex: 1,
      },
      {
        question: "Quel est le grade militaire de Maes Hughes au moment de sa mort ?",
        options: ["Major-Général", "Colonel", "Lieutenant-Colonel", "Commandant"],
        correctIndex: 2,
      },
      {
        question: "Quelle information critique Hughes a-t-il découverte avant sa mort ?",
        options: [
          "La localisation de la Pierre Philosophale",
          "La conspiration de Père et la nature des Homunculi",
          "La véritable identité de Scar",
          "Les plans de trahison de Roy Mustang",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel est le prénom de la fille de Maes Hughes ?",
        options: ["Elysia", "Elicia", "Emilia", "Elena"],
        correctIndex: 1,
      },
    ],
  },

  // Izumi Curtis
  {
    characterId: "fma-izumi-curtis",
    questions: [
      {
        question: "Quelle est la profession officielle d'Izumi Curtis à Dublith ?",
        options: ["Alchimiste d'État", "Bouchère", "Guérisseuse", "Institutrice"],
        correctIndex: 1,
      },
      {
        question: "Pourquoi Izumi peut-elle aussi effectuer de l'alchimie sans cercle de transmutation ?",
        options: [
          "Elle a reçu ce pouvoir d'un maître légendaire",
          "C'est un secret de famille transmis par sa mère",
          "Elle a tenté une transmutation humaine pour ressusciter son enfant mort-né",
          "Elle a volé les secrets de Hohenheim",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel symptôme physique permanent résulte de la transmutation humaine d'Izumi ?",
        options: [
          "Elle a perdu un bras",
          "Elle régurgite du sang à cause de ses organes internes manquants",
          "Elle est devenue aveugle d'un œil",
          "Elle a perdu sa capacité à marcher",
        ],
        correctIndex: 1,
      },
      {
        question: "Comment Izumi forme-t-elle Edward et Alphonse au début de leur apprentissage ?",
        options: [
          "Par des cours théoriques dans sa bibliothèque",
          "Par des cercles de transmutation avancés",
          "En les abandonnant un mois dans une île pour un survival training",
          "En leur faisant mémoriser des formules alchimiques",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel est le lien philosophique entre Izumi et les frères Elric ?",
        options: [
          "Tous trois ont tenté une transmutation humaine et ont vu la Vérité",
          "Tous trois sont des Alchimistes d'État",
          "Tous trois ont perdu un parent lors de la Guerre d'Ishbal",
          "Tous trois ont trouvé la Pierre Philosophale",
        ],
        correctIndex: 0,
      },
    ],
  },
];

// ─────────────────────────────────────────────
// SCRIPT PRINCIPAL
// ─────────────────────────────────────────────
async function importFMA() {
  console.log("⚗️ Début import Fullmetal Alchemist Brotherhood dans Firestore...\n");

  try {
    const result = await mammoth.extractRawText({
      path: path.join(__dirname, "../Fullmetal_Alchemist_Personnages_OTADEX_2026.docx"),
    });
    const lineCount = result.value.split("\n").filter((l) => l.trim()).length;
    console.log(`📄 Document FMA lu avec mammoth — ${lineCount} lignes extraites`);
  } catch {
    console.log("ℹ️  mammoth non disponible — import depuis les données inline du script");
  }

  // 1. Import Animé
  await db.collection("animes").doc("fullmetal-alchemist").set(animeData, { merge: true });
  console.log("✅ Animé Fullmetal Alchemist Brotherhood importé");

  // 2. Import Créateur
  await db.collection("creators").doc("hiromu-arakawa").set(creatorData, { merge: true });
  console.log("✅ Créateur Hiromu Arakawa importé");

  // 3. Import Studio
  await db.collection("studios").doc("bones").set(studioData, { merge: true });
  console.log("✅ Studio Bones importé");

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
    title: "⚗️ Fullmetal Alchemist Brotherhood débarque sur OTADEX !",
    body: "Edward, Roy Mustang et les frères Elric sont disponibles. Explore leur fiche !",
    route: "/anime/fullmetal-alchemist",
    type: "new_characters",
  });

  console.log("\n🎉 Import Fullmetal Alchemist Brotherhood terminé avec succès !");
  console.log("📊 Résumé :");
  console.log("   1 animé (fullmetal-alchemist)");
  console.log("   1 créateur (hiromu-arakawa)");
  console.log("   1 studio (bones)");
  console.log(`   ${characters.length} personnages (fma-*)`);
  console.log(`   ${quizzes.length} quiz (Edward, Mustang, Alphonse, Hawkeye, Bradley, Hughes, Izumi)`);
  process.exit(0);
}

importFMA().catch((err) => {
  console.error("❌ Erreur import :", err);
  process.exit(1);
});
