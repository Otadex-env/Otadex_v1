/**
 * OTADEX — Import Classroom of the Elite vers Firestore
 * Usage : node scripts/import_clk.js
 * Prérequis : npm install mammoth firebase-admin (à la racine du projet)
 * Note sécurité : serviceAccountkey.json ne doit JAMAIS être commité dans git
 */

const admin = require("firebase-admin");
const serviceAccount = require("../serviceAccountkey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

const CLK_BASE = "assets/images/Animé pictures/Classroom of Elite";

function clkImages(folder, prefix, n) {
  return Array.from({ length: n }, (_, i) =>
    `${CLK_BASE}/${folder}/${prefix}${i + 1}.jpeg`
  );
}

// ─────────────────────────────────────────────
// 1. DONNÉES ANIMÉ
// ─────────────────────────────────────────────
const animeData = {
  id: "classroom-of-elite",
  titre: "Classroom of the Elite",
  titreJaponais: "ようこそ実力至上主義の教室へ",
  synopsis:
    "À la Kodo Ikusei Senior High School, un lycée d'élite fictif créé par le gouvernement japonais, les élèves reçoivent une bourse mensuelle et bénéficient d'une liberté quasi totale — à condition de la mériter. Kiyotaka Ayanokoji, élève discret de la Classe D, dissimule un génie absolu issu d'un programme d'entraînement extrême appelé la White Room. Derrière l'apparente méritocratie du lycée se cachent manipulations, stratégies et secrets inavouables.",
  genres: ["Seinen", "Psychologique", "Drame scolaire", "Stratégie", "Romance"],
  annee: 2017,
  episodes: {
    saison1: 12,
    saison2: 13,
    saison3: 13,
    saison4: "En cours (2026)",
  },
  studio: "Studio Lerche",
  studioId: "studio-lerche",
  auteur: "Shōgo Kinugasa",
  auteurId: "shogo-kinugasa",
  editeur: "KADOKAWA (MF Bunko J)",
  editeurVF: "Maho Editions / JNC Nina",
  copiesVendues: "44+ volumes publiés (mai 2026)",
  statut: "En cours (Saison 4 diffusée depuis avril 2026)",
  coverImage: "",
  bannerImage: "",
  type: "light_novel_adapte",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 2. DONNÉES CRÉATEUR
// ─────────────────────────────────────────────
const creatorData = {
  id: "shogo-kinugasa",
  nom: "Shōgo Kinugasa",
  nomJaponais: "衣笠彰梧",
  bio: "Shōgo Kinugasa est un auteur japonais de light novels dont l'identité réelle demeure inconnue — il n'apparaît pas publiquement et 'Kinugasa Shōgo' est un pseudonyme littéraire. Il commence sa carrière en 2015 avec Classroom of the Elite (KADOKAWA, MF Bunko J). La série devient un phénomène mondial après l'adaptation animée de 2017 par Studio Lerche. À ce jour, plus de 44 volumes publiés dans l'univers de Classroom of the Elite. Style : psychologie, déconstruction du méritocratisme, personnages aux motivations profondément nuancées.",
  nationalite: "Japonaise",
  occupation: "Auteur de light novels",
  oeuvres: [
    {
      titre: "Classroom of the Elite Year 1",
      annee: 2015,
      type: "Light Novel — 11 volumes + .5 (terminé)",
    },
    {
      titre: "Classroom of the Elite Year 2",
      annee: 2020,
      type: "Light Novel — 12 volumes + .5 (terminé)",
    },
    {
      titre: "Classroom of the Elite Year 3",
      annee: 2024,
      type: "Light Novel — En cours",
    },
    {
      titre: "Classroom of the Elite (Manga)",
      annee: 2016,
      type: "Manga adaptation — Monthly Comic Alive",
    },
  ],
  animeIds: ["classroom-of-elite"],
  imageUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 3. DONNÉES STUDIO
// ─────────────────────────────────────────────
const studioData = {
  id: "studio-lerche",
  nom: "Studio Lerche",
  nomComplet: "Studio Lerche (ラルケ)",
  fondation: 2011,
  siege: "Tokyo, Japon",
  description:
    "Studio d'animation japonais fondé en 2011 par d'anciens membres de Satelight. Connu pour ses adaptations de Classroom of the Elite (4 saisons), Assassination Classroom et Danganronpa. Réalisateur Saison 4 : Noriyuki Nomata.",
  productions: [
    "Classroom of the Elite (Saisons 1–4)",
    "Assassination Classroom",
    "Danganronpa: The Animation",
    "Overlord (saison 1 partielle)",
    "Bokura wa Minna Kawaisou",
  ],
  animeIds: ["classroom-of-elite"],
  logoUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 4. DONNÉES PERSONNAGES (20)
// ─────────────────────────────────────────────
const characters = [
  // ── #1 Kiyotaka Ayanokoji ──
  {
    id: "clk-kiyotaka-ayanokoji",
    nom: "Kiyotaka Ayanokoji",
    nomJaponais: "綾小路 清隆",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "17 ans (1re année) → 18 ans (2e année)",
    sexe: "Masculin",
    dateNaissance: "20 octobre",
    taille: "176 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Protagoniste",
    rang: "Élève Classe D → Classe A",
    description:
      "Kiyotaka Ayanokoji est le protagoniste de Classroom of the Elite et l'un des personnages les plus fascinants de l'anime seinen psychologique. En apparence, un élève discret et médiocre — il a délibérément obtenu exactement 50/100 à chaque matière de l'examen d'entrée. En réalité, il est le produit le plus abouti de la White Room, un programme d'entraînement extrême de son père visant à créer un être humain parfait. Il dissimule ses capacités pour observer et expérimenter la vie ordinaire, manipulant l'ombre pour guider les situations vers l'issue qu'il juge optimale.",
    pouvoirs: [
      "Intelligence stratégique quasi-omnisciente : anticipe plusieurs coups d'avance",
      "Manipulation psychologique de niveau expert sans jamais être soupçonné",
      "Mémoire photographique absolue",
      "Capacités physiques surhumaines : arts martiaux multiples",
      "Analyse instantanée des motivations humaines et failles psychologiques",
      "Simulation de différents niveaux de compétence selon le contexte",
    ],
    voixJaponaise: "Shōya Chiba",
    voixAnglaise: "Justin Briner",
    relations: [
      { nomPersonnage: "Kei Karuizawa", type: "Petite amie (LN Year 2)" },
      { nomPersonnage: "Suzune Horikita", type: "Alliée principale" },
      {
        nomPersonnage: "Arisu Sakayanagi",
        type: "Rival intellectuel (Classe A)",
      },
      { nomPersonnage: "Sae Chabashira", type: "Professeure / chantage" },
      { nomPersonnage: "Takuya Yagami", type: "Rival White Room" },
    ],
    citations: [
      "Les humains ne sont que des instruments.",
      "Je dois devenir le meilleur — non pour moi, mais pour prouver la fausseté de cette phrase.",
    ],
    trivia: [
      "A volontairement répondu à exactement 50 % à tous les examens d'entrée",
      "Son combat contre Manabu Horikita révèle sa puissance physique pour la première fois",
      "Personnage #1 de popularité dans la quasi-totalité des classements internationaux de la série",
      "Sa citation emblématique 'Les humains ne sont que des instruments' résume sa philosophie initiale",
    ],
    images: clkImages("Kiyotaka Ayanokoji", "clk_ayan", 13),
    imagePath: `${CLK_BASE}/Kiyotaka Ayanokoji/clk_ayan1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: true,
    isNew: false,
    popularityRank: 1,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #2 Suzune Horikita ──
  {
    id: "clk-suzune-horikita",
    nom: "Suzune Horikita",
    nomJaponais: "堀北 鈴音",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Féminin",
    dateNaissance: "15 février",
    taille: "156 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Co-protagoniste",
    rang: "Classe D → Présidente du Conseil Étudiant (2e année)",
    description:
      "Suzune Horikita est la co-protagoniste de Classroom of the Elite. Froide, hautaine, antisociale — son unique objectif est d'atteindre la Classe A pour prouver sa valeur à son frère aîné Manabu. Dans la 2e année, transformée par ses épreuves, elle devient un véritable leader de classe et est élue présidente du Conseil Étudiant — première femme à ce poste depuis des années. Pratique le karaté depuis l'enfance.",
    pouvoirs: [
      "Intelligence académique exceptionnelle — parmi les meilleures notes",
      "Analyse froide et logique sans biais émotionnel",
      "Karaté — capable de battre des adversaires physiquement plus imposants",
      "Leadership progressif — de l'isolement total au rôle de présidente reconnue",
      "Négociation et manipulation développées sous l'influence d'Ayanokoji",
    ],
    voixJaponaise: "Akari Kitō",
    voixAnglaise: "Felecia Angelle",
    relations: [
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Partenaire stratégique" },
      { nomPersonnage: "Manabu Horikita", type: "Frère aîné (modèle)" },
      { nomPersonnage: "Honami Ichinose", type: "Rivale (Classe B)" },
      { nomPersonnage: "Kikyo Kushida", type: "Relation conflictuelle cachée" },
    ],
    citations: [
      "Je n'ai besoin de personne pour atteindre mon objectif.",
      "Je me suis trompée. La force véritable ne se construit pas seul.",
    ],
    trivia: [
      "Dispose de son propre manga spin-off : 'Classroom of the Elite: Horikita'",
      "Élue présidente du Conseil Étudiant en 2e année — première femme depuis longtemps",
      "Son surnom non-officiel dans le fanbase : 'La Princesse de Glace'",
      "Sa doubrice Akari Kitō est également la voix de Nezuko Kamado dans Demon Slayer",
    ],
    images: clkImages("Suzune Horikita", "clk_hori", 6),
    imagePath: `${CLK_BASE}/Suzune Horikita/clk_hori1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: true,
    isNew: false,
    popularityRank: 2,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #3 Kei Karuizawa ──
  {
    id: "clk-kei-karuizawa",
    nom: "Kei Karuizawa",
    nomJaponais: "軽井沢 恵",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Féminin",
    dateNaissance: "8 mars",
    taille: "154 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Personnage principal",
    rang: "Classe D → Classe C",
    description:
      "Kei Karuizawa est l'un des personnages les plus complexes et les plus populaires de la franchise. En apparence, la gyaru populaire de la Classe D — leader incontestée du groupe féminin. En réalité, elle cache un traumatisme profond issu d'un harcèlement scolaire sévère au collège. Ce passé est découvert par Ayanokoji — mais cette relation instrumentale se transforme en attachement mutuel sincère. Son arc de dépassement de ses traumatismes est parmi les plus appréciés de la franchise.",
    pouvoirs: [
      "Intelligence sociale et émotionnelle élevée — lecture intuitive des dynamiques",
      "Gestion politique du groupe féminin",
      "Charisme naturel et popularité immédiate",
      "Résilience psychologique — surmonte ses traumatismes de harcèlement",
      "Déduction et analyse améliorées sous l'influence d'Ayanokoji",
    ],
    voixJaponaise: "Ayana Taketatsu",
    voixAnglaise: "Bryn Apprill",
    relations: [
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Petit ami (LN Year 2)" },
      { nomPersonnage: "Yosuke Hirata", type: "Partenaire de façade (1re année)" },
    ],
    citations: [
      "Je ne veux plus jamais être faible.",
      "Tu m'as utilisée... mais c'est toi qui m'as aussi sauvée.",
    ],
    trivia: [
      "Sa relation avec Ayanokoji est l'axe romantique principal de toute la franchise",
      "Son passé de harcèlement révélé à Ayanokoji est l'un des moments les plus émouvants",
      "Sa doubrice Ayana Taketatsu est connue pour Azusa dans K-On! et Kirino dans OreImo",
      "Considérée comme le personnage féminin le plus populaire de la série",
    ],
    images: clkImages("Kei Karuizawa", "clk_karu", 4),
    imagePath: `${CLK_BASE}/Kei Karuizawa/clk_karu1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: true,
    isNew: false,
    popularityRank: 3,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #4 Honami Ichinose ──
  {
    id: "clk-honami-ichinose",
    nom: "Honami Ichinose",
    nomJaponais: "一之瀬 帆波",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "17 ans",
    sexe: "Féminin",
    dateNaissance: "20 juillet",
    taille: "159 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Personnage principal",
    rang: "Classe B (2e place constante)",
    description:
      "Honami Ichinose est la représentante de la Classe B et l'une des élèves les plus appréciées de toute l'école. Sincère, chaleureuse, elle est l'opposé apparent d'Ayanokoji — toute bonté et altruisme. Sa philosophie : progresser par la coopération, aider même les classes adverses. Elle dissimule cependant un secret passé qui constitue une vulnérabilité narrative importante dans les arcs avancés.",
    pouvoirs: [
      "Intelligence sociale et empathie exceptionnelles",
      "Gestion stratégique des points et des alliances inter-classes",
      "Leadership par l'exemple et le consensus",
      "Capacités académiques solides — dans le top de sa classe",
      "Diplomatie naturelle : relations cordiales avec toutes les factions",
    ],
    voixJaponaise: "Nao Tōyama",
    voixAnglaise: "Kristi Rothrock",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Intérêt romantique (LN)",
      },
      { nomPersonnage: "Suzune Horikita", type: "Alliée de circonstance" },
    ],
    citations: [
      "On peut gagner sans écraser les autres.",
      "La force d'une classe, c'est la confiance que ses membres se portent.",
    ],
    trivia: [
      "Son secret passé (LN avancés) ajoute une vulnérabilité inattendue à son personnage",
      "Candidate perdante face à Horikita pour la présidence du CE en 2e année",
      "Sa doubrice Nao Tōyama est une chanteuse anime reconnue au Japon",
      "Sa stratégie 'gagner sans écraser' est citée comme la plus éthique de la série",
    ],
    images: clkImages("honami ichinose", "clk_ichi", 6),
    imagePath: `${CLK_BASE}/honami ichinose/clk_ichi1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 4,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #5 Arisu Sakayanagi ──
  {
    id: "clk-arisu-sakayanagi",
    nom: "Arisu Sakayanagi",
    nomJaponais: "坂柳 有栖",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans",
    sexe: "Féminin",
    dateNaissance: "12 mars",
    taille: "150 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste / Rival principal",
    rang: "Classe A (la plus haute)",
    description:
      "Arisu Sakayanagi est la représentante de la Classe A et la rivale intellectuelle principale d'Ayanokoji. Petite, fragile physiquement — elle se déplace avec une canne en raison d'une malformation cardiaque congénitale — elle est dotée d'une intelligence stratégique rivale du protagoniste. Fille du directeur de l'école, elle occupe la Classe A par mérite absolu. Derrière un sourire de poupée se cache une joueuse d'échecs froide, calculatrice et légèrement sadique.",
    pouvoirs: [
      "Génie stratégique et tactique — rival direct d'Ayanokoji",
      "Connaissance approfondie de la psychologie humaine",
      "Contrôle de la Classe A à distance sans effort apparent",
      "Réseau d'informations privilégié via son père (directeur)",
      "Excellence académique — parmi les meilleures notes de toute l'école",
    ],
    voixJaponaise: "Rina Hidaka",
    voixAnglaise: "Trina Nishimura",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Rival (fascination mutuelle)",
      },
      { nomPersonnage: "Kohei Katsuragi", type: "Éliminée/remplacée" },
    ],
    citations: [
      "Chaque mot que je prononce est un coup planifié.",
      "Il n'existe qu'une seule personne dans cet établissement qui mérite d'être mon adversaire.",
    ],
    trivia: [
      "Souvent comparée à une joueuse d'échecs — chaque mot est un coup planifié",
      "Sa condition cardiaque est l'un des rares éléments de vulnérabilité réelle",
      "Première à identifier qu'Ayanokoji cache quelque chose d'exceptionnel",
      "Classée régulièrement 2e ou 3e dans les sondages de popularité de la franchise",
    ],
    images: clkImages("Arisu Sakayanagi ", "clk_saka", 9),
    imagePath: `${CLK_BASE}/Arisu Sakayanagi /clk_saka1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 5,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #6 Kakeru Ryuen ──
  {
    id: "clk-kakeru-ryuen",
    nom: "Kakeru Ryuen",
    nomJaponais: "龍園 翔",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Masculin",
    dateNaissance: "13 décembre",
    taille: "176 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste (1re année) / Allié nuancé",
    rang: "Classe C → Classe B",
    description:
      "Kakeru Ryuen est le représentant de la Classe C et l'antagoniste physiquement le plus intimidant de la 1re année. Il dirige sa classe par la force brute et la peur. Derrière cette façade de tyran brutal se cache un stratège analytique redoutable. Après sa défaite cinglante face à Ayanokoji, il subit l'une des transformations de personnage les plus inattendues de la franchise.",
    pouvoirs: [
      "Force physique intimidante — le personnage le plus redouté physiquement",
      "Intelligence analytique — identifie schémas et manipulations complexes",
      "Leadership par la domination",
      "Réseau d'informateurs au sein de l'école",
      "Combat physique supérieur — brutal et efficace au corps à corps",
    ],
    voixJaponaise: "Masaaki Mizunaka",
    voixAnglaise: "Eric Vale",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Rival puis allié respectueux",
      },
      { nomPersonnage: "Mio Ibuki", type: "Bras droit" },
    ],
    citations: [
      "La peur est l'outil de gestion le plus efficace.",
      "Tu es le cerveau de la Classe D. Je l'ai compris depuis le début.",
    ],
    trivia: [
      "Sa transformation de tyran brutal en allié nuancé est la plus surprenante de la franchise",
      "Premier antagoniste à comprendre qu'Ayanokoji est le vrai cerveau de la Classe D",
      "Son doubleur anglais Eric Vale est connu pour Future Trunks dans Dragon Ball Super",
      "En 2e année, il collabore ponctuellement avec Ayanokoji — ce retournement surprend les lecteurs",
    ],
    images: clkImages("kakeru ryuen", "clk_ryue", 9),
    imagePath: `${CLK_BASE}/kakeru ryuen/clk_ryue1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 6,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #7 Kikyo Kushida ──
  {
    id: "clk-kikyo-kushida",
    nom: "Kikyo Kushida",
    nomJaponais: "櫛田 桔梗",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Féminin",
    dateNaissance: "5 août",
    taille: "157 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Personnage principal — double visage",
    rang: "Classe D → Classe C",
    description:
      "Kikyo Kushida est le personnage au double visage le plus saisissant de Classroom of the Elite. En public : la fille la plus populaire de la Classe D — mémorisant les noms de tous les élèves, souriante, serviable. En privé : calculatrice, manipulatrice, incapable de faire confiance — suite à une trahison traumatisante au collège. Son vrai visage est découvert accidentellement par Ayanokoji dès les premières semaines.",
    pouvoirs: [
      "Mémoire parfaite des noms et détails personnels de chaque élève",
      "Maîtrise du double visage — cloisonnement parfait façade/vraie personnalité",
      "Réseau d'informateurs dans tous les groupes via sa popularité",
      "Manipulation émotionnelle — exploite la confiance des autres",
      "Excellente actrice — maintient son masque de façon quasi-indétectable",
    ],
    voixJaponaise: "Yurika Kubo",
    voixAnglaise: "Sarah Wiedenheft",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Tension secrète permanente (connaît son vrai visage)",
      },
      {
        nomPersonnage: "Suzune Horikita",
        type: "Cible principale (cherche à l'exclure)",
      },
    ],
    citations: [
      "Je veux être amie avec tout le monde à cette école.",
      "Si tu révèles mon secret... je détruirai tout ce que tu as construit.",
    ],
    trivia: [
      "Classée comme le personnage le plus moralement complexe de la série",
      "Sa haine de Horikita est l'un des mystères narratifs les plus importants de la 1re année",
      "Son double visage est l'une des premières vraies surprises de la série",
      "Sa doubrice Yurika Kubo est connue pour Hanamaru Kunikida dans Love Live! Sunshine!!",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 7,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #8 Manabu Horikita ──
  {
    id: "clk-manabu-horikita",
    nom: "Manabu Horikita",
    nomJaponais: "堀北 学",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "18 ans (3e année)",
    sexe: "Masculin",
    dateNaissance: "4 mai",
    taille: "175 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire important",
    rang: "Conseil Étudiant — 3e année",
    description:
      "Manabu Horikita est le président du Conseil Étudiant et le frère aîné de Suzune. Figure d'autorité respectée de tous, il incarne l'idéal de l'élève parfait. Sa relation avec sa sœur est complexe : il la repousse délibérément pour l'empêcher de devenir dépendante. Sa rencontre avec Ayanokoji — où il tente de le tester physiquement — marque l'une des premières révélations de la série.",
    pouvoirs: [
      "Arts martiaux de haut niveau — l'un des élèves physiquement les plus forts",
      "Excellence académique absolue — meilleur élève de sa promotion",
      "Leadership et gestion institutionnelle",
      "Analyse rapide des personnalités",
    ],
    voixJaponaise: "Yuuichirou Umehara",
    voixAnglaise: "David Matranga",
    relations: [
      { nomPersonnage: "Suzune Horikita", type: "Sœur cadette" },
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Rival respecté" },
    ],
    citations: [
      "Deviens quelqu'un dont tu peux être fier — sans compter sur moi.",
    ],
    trivia: [
      "Sa rencontre physique avec Ayanokoji révèle la vraie puissance du protagoniste",
      "Son traitement froid de Suzune cache un amour fraternel profond",
      "Quitte définitivement l'école à la fin de la 1re année après son diplôme",
      "Son doubleur anglais David Matranga est connu pour Shirou Emiya dans Fate/stay night",
    ],
    images: clkImages("Manabu Horikita", "clk_mana", 6),
    imagePath: `${CLK_BASE}/Manabu Horikita/clk_mana1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 8,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #9 Sae Chabashira ──
  {
    id: "clk-sae-chabashira",
    nom: "Sae Chabashira",
    nomJaponais: "茶柱 佐枝",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "26 ans",
    sexe: "Féminin",
    dateNaissance: "20 mai",
    taille: "160 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire — Professeure",
    rang: "Professeure — Classe D puis Classe C",
    description:
      "Sae Chabashira est la professeure principale de la Classe D et l'une des personnalités les plus ambivalentes de la série. Stricte, distante, elle est elle-même une ancienne élève de la Kodo Ikusei — n'ayant jamais réussi à quitter la Classe D. Elle fait chanter Ayanokoji avec des informations concernant son père pour le forcer à viser la Classe A — révélant une dimension manipulatrice.",
    pouvoirs: [
      "Maîtrise parfaite du règlement de la Kodo Ikusei",
      "Manipulation administrative — utilise sa position stratégiquement",
      "Arts martiaux — ancienne élève performante",
      "Psychologie des classes — comprend les dynamiques collectives",
    ],
    voixJaponaise: "Rina Satou",
    voixAnglaise: "Jennifer Alyx",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Rapport de force / chantage",
      },
    ],
    citations: [
      "Tu vises la Classe A — sinon je révèle ce que je sais sur toi.",
    ],
    trivia: [
      "Elle fait chanter Ayanokoji dès les premières pages du LN",
      "Elle-même ancienne élève de la Kodo Ikusei ayant échoué à quitter la Classe D",
      "Sa doubrice Rina Satou est connue pour Mikoto Misaka dans To Aru Majutsu no Index",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 9,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #10 Yosuke Hirata ──
  {
    id: "clk-yosuke-hirata",
    nom: "Yosuke Hirata",
    nomJaponais: "平田 洋介",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Masculin",
    dateNaissance: "2 novembre",
    taille: "178 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Personnage secondaire principal",
    rang: "Classe D → Classe C",
    description:
      "Yosuke Hirata est le garçon le plus populaire de la Classe D — beau, sportif, empathique, leader naturel aimé de tous. Sa relation de façade avec Kei Karuizawa est acceptée par lui par gentillesse. Sa propension à vouloir aider tout le monde est à la fois sa plus grande qualité et sa faiblesse stratégique. Dans la 2e année, il traverse une crise identitaire majeure suite aux révélations sur son entourage.",
    pouvoirs: [
      "Charisme naturel et leadership social",
      "Excellence sportive — performant dans toutes les disciplines physiques",
      "Empathie et médiation — désamorce les conflits internes",
      "Intelligence académique au-dessus de la moyenne",
    ],
    voixJaponaise: "Ryōta Ōsaka",
    voixAnglaise: "Dallas Reid",
    relations: [
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Ami sincère" },
      {
        nomPersonnage: "Kei Karuizawa",
        type: "Relation de façade brisée (Year 2)",
      },
    ],
    citations: [
      "Je crois en la capacité de chacun à s'améliorer si on lui donne une chance.",
    ],
    trivia: [
      "Sa rupture avec Karuizawa dans les LN Year 2 est l'un de ses moments les plus humains",
      "Sa crise identitaire en 2e année révèle les limites de l'idéalisme",
      "Son doubleur Dallas Reid est connu pour Hawks dans My Hero Academia",
      "Le personnage dont la bienveillance est la plus sincère — sans calcul aucun",
    ],
    images: clkImages("yosuke hirata", "clk_hira", 5),
    imagePath: `${CLK_BASE}/yosuke hirata/clk_hira1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 10,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #11 Rokusuke Koenji ──
  {
    id: "clk-rokusuke-koenji",
    nom: "Rokusuke Koenji",
    nomJaponais: "高円寺 六助",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Masculin",
    dateNaissance: "3 avril",
    taille: "181 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire — imprévisible",
    rang: "Classe D → Classe C",
    description:
      "Rokusuke Koenji est l'élève le plus imprévisible de la Classe D. Narcissique, excentrique, entièrement centré sur lui-même, il refuse toute directive collective et agit uniquement selon ses propres désirs. Paradoxalement, ses capacités physiques et intellectuelles sont parmi les plus élevées de toute l'école. Ses motivations profondes restent opaques tout au long de la 1re année.",
    pouvoirs: [
      "Capacités physiques exceptionnelles — performances surhumaines dans les épreuves sportives",
      "Intelligence supérieure à la moyenne",
      "Indépendance totale — incontrôlable et imperméable à la pression sociale",
      "Compétences cachées révélées sélectivement selon ses propres critères",
    ],
    voixJaponaise: "Toshiki Iwasawa",
    voixAnglaise: "Christopher Wehkamp",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Fascination à distance (ne tente pas de le contrôler)",
      },
    ],
    citations: [
      "Je n'agis que selon mes propres règles. Ce que pensent les autres ne m'intéresse pas.",
    ],
    trivia: [
      "Son arc de l'Île Déserte : disparaît puis revient avec des résultats spectaculaires",
      "Son style vestimentaire aristocratique est parmi les plus reconnaissables",
      "Ses motivations restent l'un des plus grands mystères narratifs de la franchise",
      "Son doubleur Christopher Wehkamp est connu pour Zarbon dans Dragon Ball Super",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 11,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #12 Airi Sakura ──
  {
    id: "clk-airi-sakura",
    nom: "Airi Sakura",
    nomJaponais: "佐倉 愛里",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans",
    sexe: "Féminin",
    dateNaissance: "15 octobre",
    taille: "153 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Classe D → Classe C",
    description:
      "Airi Sakura est l'une des élèves les plus timides et réservées de la Classe D. Passionnée de photographie, elle publie en secret des photos sous un pseudonyme et possède une communauté de fans. Sa timidité extrême l'empêche souvent de s'affirmer, mais elle développe un intérêt romantique pour Ayanokoji.",
    pouvoirs: [
      "Photographie de niveau professionnel — style artistique reconnu",
      "Observation fine des détails — sens aigu de l'analyse visuelle",
      "Sens de l'écoute — soutien émotionnel pour ses proches",
    ],
    voixJaponaise: "M.A.O (Mao Ichimichi)",
    voixAnglaise: "Leah Clark",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Intérêt romantique non partagé (1re année)",
      },
      { nomPersonnage: "Kei Karuizawa", type: "Amie proche" },
    ],
    citations: [
      "Derrière chaque photo, il y a une vérité que les mots ne peuvent pas exprimer.",
    ],
    trivia: [
      "Elle publie des photos sous pseudonyme — sa double vie est un fil de la saison 1",
      "Sa timidité est régulièrement source de moments comiques touchants",
      "Sa doubrice Leah Clark est connue pour Blair dans Soul Eater",
      "Personnage préféré de nombreux fans pour son authenticité émotionnelle",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 12,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #13 Miyabi Nagumo ──
  {
    id: "clk-miyabi-nagumo",
    nom: "Miyabi Nagumo",
    nomJaponais: "南雲 雅",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "18 ans (3e année)",
    sexe: "Masculin",
    dateNaissance: "31 mai",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste institutionnel (Year 2)",
    rang: "Conseil Étudiant — 3e année",
    description:
      "Miyabi Nagumo est le successeur de Manabu Horikita à la présidence du Conseil Étudiant. Charismatique mais autoritaire, son style de leadership privilégie ses propres intérêts. Son obsession pour Honami Ichinose est l'un des fils narratifs de la 2e année. Il représente l'antagoniste institutionnel — quelqu'un qui respecte les règles formellement tout en les utilisant contre leur esprit.",
    pouvoirs: [
      "Maîtrise des règles institutionnelles — utilise le règlement à son avantage",
      "Charisme et autorité naturelle",
      "Réseau d'influence au sein du CE et de l'administration",
      "Stratégie politique de haut niveau",
    ],
    voixJaponaise: "Souma Saitou",
    voixAnglaise: "Nazeeh Tarsha",
    relations: [
      { nomPersonnage: "Honami Ichinose", type: "Obsession unilatérale" },
      { nomPersonnage: "Manabu Horikita", type: "Prédécesseur (rival implicite)" },
    ],
    citations: [
      "Les règles sont faites pour être utilisées, pas pour être respectées aveuglément.",
    ],
    trivia: [
      "Son obsession pour Ichinose est l'un des éléments les plus perturbants de la 2e année",
      "Représente la dérive du méritocratisme vers l'autoritarisme",
      "Son doubleur Souma Saitou est connu pour Kodaka Hasegawa dans Boku wa Tomodachi ga Sukunai",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 13,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #14 Ken Sudo ──
  {
    id: "clk-ken-sudo",
    nom: "Ken Sudo",
    nomJaponais: "須藤 健",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Masculin",
    dateNaissance: "6 août",
    taille: "185 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Classe D → Classe C",
    description:
      "Ken Sudo est le joueur de basket phare de la Classe D et l'un des personnages les plus impulsifs de la série. Ses notes académiques médiocres l'ont cantonné en Classe D malgré ses capacités athlétiques exceptionnelles. Son arc de la 1re année — une accusation de violence injuste résolue grâce à Ayanokoji — est l'une des premières épreuves collectives majeures de la Classe D.",
    pouvoirs: [
      "Basket de niveau lycée d'élite — parmi les meilleurs joueurs de l'école",
      "Force physique supérieure — combat corps à corps redoutable",
      "Détermination et persévérance — progresse académiquement au fil des épreuves",
    ],
    voixJaponaise: "Eiji Takeuchi",
    voixAnglaise: "Brandon McInnis",
    relations: [
      { nomPersonnage: "Suzune Horikita", type: "Intérêt romantique" },
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Protecteur/mentor informel (résout son procès)",
      },
    ],
    citations: ["Je suis nul en cours, mais sur le terrain, personne ne me dépasse."],
    trivia: [
      "L'épreuve du tournoi de basket est l'une de ses meilleures scènes de la Saison 1",
      "Son impulsivité est source de problèmes répétés — mais aussi de sincérité rare",
      "Son arc académique (amélioration des notes sous pression) est l'un des plus motivants",
    ],
    images: clkImages("ken sudo", "clk_sudo", 5),
    imagePath: `${CLK_BASE}/ken sudo/clk_sudo1.jpeg`,
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 14,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #15 Hiyori Shiina ──
  {
    id: "clk-hiyori-shiina",
    nom: "Hiyori Shiina",
    nomJaponais: "椎名 ひより",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Féminin",
    dateNaissance: "8 novembre",
    taille: "155 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Classe B",
    description:
      "Hiyori Shiina est une élève de la Classe B passionnée de littérature. Sa relation avec Ayanokoji est construite autour de leur amour commun des livres — l'une des rares interactions sincères du protagoniste, dénuée de calcul. Elle représente l'espace de respiration humaine du protagoniste.",
    pouvoirs: [
      "Culture littéraire exceptionnelle — encyclopédique dans son domaine",
      "Sensibilité d'analyse — comprend les sous-textes des situations",
      "Relationnel sincère — apporte une chaleur rare dans l'univers froid de l'école",
    ],
    voixJaponaise: "Rie Takahashi",
    voixAnglaise: "Brittney Karbowski",
    relations: [
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Amitié littéraire sincère" },
    ],
    citations: [
      "Un livre peut révéler la vérité sur une personne mieux que n'importe quelle conversation.",
    ],
    trivia: [
      "Ses échanges de recommandations de lecture avec Ayanokoji sont parmi les plus doux moments",
      "Souvent citée comme l'une des personnalités les plus authentiques de l'école",
      "Sa doubrice Rie Takahashi est connue pour Megumin dans KonoSuba et Emilia dans Re:Zero",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 15,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #16 Tsubasa Nanase ──
  {
    id: "clk-tsubasa-nanase",
    nom: "Tsubasa Nanase",
    nomJaponais: "七瀬 翼",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans",
    sexe: "Féminin",
    dateNaissance: "14 novembre",
    taille: "158 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire Year 2",
    rang: "1re année — Classe D",
    description:
      "Tsubasa Nanase est une élève de 1re année apparaissant dans l'arc Year 2. Elle approche Ayanokoji avec des intentions apparemment amicales lors d'une épreuve sur une île déserte — mais ses motivations cachées, liées à la White Room, en font un personnage à surveiller. Sa douceur apparente contraste avec les secrets qu'elle dissimule.",
    pouvoirs: [
      "Intelligence tactique — simule la naïveté comme arme",
      "Lien à la White Room — contexte de formation similaire à Ayanokoji",
      "Capacités physiques au-dessus de la moyenne",
    ],
    voixJaponaise: "Minako Satō",
    voixAnglaise: "Non confirmée (Saison 4 en cours)",
    relations: [
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Cible d'approche" },
    ],
    citations: [
      "Je voulais juste te connaître... vraiment.",
    ],
    trivia: [
      "Son introduction lors de l'épreuve sur l'île déserte est l'une des plus intrigantes de Year 2",
      "Ses véritables motivations constituent l'un des mystères les mieux tenus de la 2e année",
      "Introduite en LN Year 2, apparaît à l'écran pour la première fois en Saison 4 (2026)",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 16,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #17 Ichika Amasawa ──
  {
    id: "clk-ichika-amasawa",
    nom: "Ichika Amasawa",
    nomJaponais: "天沢一夏",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans",
    sexe: "Féminin",
    dateNaissance: "1er juillet",
    taille: "160 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire Year 2",
    rang: "1re année — Classe A",
    description:
      "Ichika Amasawa est une élève de 1re année de la Classe A et l'un des personnages les plus fascinants de la 2e année. Espiègle, imprévisible, elle est l'un des rares personnages à connaître l'identité réelle d'Ayanokoji — et à l'assumer sans détour. Son origine dans la White Room fait d'elle un miroir troublant du protagoniste.",
    pouvoirs: [
      "Capacités physiques et intellectuelles de niveau White Room",
      "Imprévisibilité calculée — surprise et désinvolture comme armes tactiques",
      "Connaissance de la White Room et de ses occupants",
    ],
    voixJaponaise: "Momoko Seto",
    voixAnglaise: "Non confirmée (Saison 4 en cours)",
    relations: [
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Connaissance / relation complexe (White Room)",
      },
    ],
    citations: [
      "Je suis l'une des rares à savoir vraiment qui tu es. Et ça ne me fait pas peur.",
    ],
    trivia: [
      "L'une des seules personnes à connaître la vérité sur Ayanokoji sans le cacher",
      "Sa désinvolture masque une profondeur stratégique réelle",
      "Introduite en Year 2, apparaît à l'écran pour la première fois en Saison 4 (2026)",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 17,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #18 Takuya Yagami ──
  {
    id: "clk-takuya-yagami",
    nom: "Takuya Yagami",
    nomJaponais: "八神 拓也",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans",
    sexe: "Masculin",
    nationalite: "Japonaise (fictive)",
    statut: "Antagoniste Year 2",
    rang: "1re année — Classe B",
    description:
      "Takuya Yagami est un élève de 1re année de la Classe B et l'antagoniste principal de certains arcs de la 2e année. Apparence amicale — mais façade masquant un caractère bien différent. Lui aussi issu de la White Room, il cherche à prouver sa supériorité sur Ayanokoji. Décrit comme extrêmement habile au combat et doté d'une grande intelligence.",
    pouvoirs: [
      "Combat physique exceptionnel — formation White Room intensifiée",
      "Intelligence stratégique de niveau White Room",
      "Manipulation sociale — masque efficacement sa vraie personnalité",
    ],
    voixJaponaise: "Shinnosuke Tokudome",
    voixAnglaise: "Non confirmée (Saison 4 en cours)",
    relations: [
      { nomPersonnage: "Kiyotaka Ayanokoji", type: "Rival principal" },
    ],
    citations: [
      "La White Room m'a créé pour surpasser tout ce qui existait avant moi — y compris toi.",
    ],
    trivia: [
      "Sa révélation comme antagoniste est l'un des moments les plus intenses de Year 2",
      "Connu pour avoir déclenché une révolte dans la White Room avant de s'en échapper",
      "Introduit en Year 2, apparaît à l'écran en Saison 4 (2026)",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 18,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #19 Kohei Katsuragi ──
  {
    id: "clk-kohei-katsuragi",
    nom: "Kohei Katsuragi",
    nomJaponais: "葛城 康平",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Masculin",
    dateNaissance: "21 novembre",
    taille: "183 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Classe A",
    description:
      "Kohei Katsuragi était le leader de facto de la Classe A avant l'arrivée d'Arisu Sakayanagi. Imposant physiquement, rigoureux intellectuellement, il représente un style de leadership traditionnel basé sur la discipline et les règles. Sa rivalité avec Sakayanagi — qui finit par le renverser via une manœuvre politique habile — est l'une des dynamiques internes les plus intéressantes de la 1re année.",
    pouvoirs: [
      "Leadership traditionnel basé sur la discipline et l'excellence",
      "Physique imposant — crédibilité physique naturelle",
      "Rigueur académique et organisationnelle",
      "Expérience tactique dans les examens collectifs",
    ],
    voixJaponaise: "Satoshi Hino",
    voixAnglaise: "Jarrod Greene",
    relations: [
      { nomPersonnage: "Arisu Sakayanagi", type: "Rivale interne (l'a évincé)" },
    ],
    citations: [
      "La discipline et les règles sont les seules bases fiables d'un succès durable.",
    ],
    trivia: [
      "Sa rivalité interne avec Sakayanagi est une des dynamiques les plus intéressantes de la Classe A",
      "Sa chute illustre que la force brute ne suffit pas face à l'intelligence",
      "Son doubleur Satoshi Hino est connu pour Ain dans Black Clover",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 19,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #20 Mio Ibuki ──
  {
    id: "clk-mio-ibuki",
    nom: "Mio Ibuki",
    nomJaponais: "伊吹 澪",
    animeId: "classroom-of-elite",
    animeName: "Classroom of the Elite",
    auteurId: "shogo-kinugasa",
    auteurNom: "Shōgo Kinugasa",
    studioId: "studio-lerche",
    studioNom: "Studio Lerche",
    age: "16 ans → 17 ans",
    sexe: "Féminin",
    dateNaissance: "1er mai",
    taille: "162 cm",
    nationalite: "Japonaise (fictive)",
    statut: "Secondaire",
    rang: "Classe C → Classe B",
    description:
      "Mio Ibuki est l'un des bras droits de Kakeru Ryuen en Classe C. Combattante redoutable aux arts martiaux, directe et sans concession, l'une des élèves physiquement les plus capables parmi les filles. Après la défaite de Ryuen, son rapport à Ayanokoji évolue. Dans les arcs avancés de la 2e année, elle est un personnage en transition, cherchant à définir ses propres valeurs.",
    pouvoirs: [
      "Arts martiaux de haut niveau — l'une des combattantes les plus efficaces",
      "Résistance physique et mentale exceptionnelles",
      "Loyauté absolue — atout majeur pour son chef",
      "Combat corps à corps — style direct et puissant",
    ],
    voixJaponaise: "Mikako Komatsu",
    voixAnglaise: "Jamie Marchi",
    relations: [
      { nomPersonnage: "Kakeru Ryuen", type: "Chef (1re année)" },
      {
        nomPersonnage: "Kiyotaka Ayanokoji",
        type: "Évolution vers questionnement (2e année)",
      },
    ],
    citations: [
      "Ryuen-kun m'a donné une raison de me battre. Maintenant je dois trouver la mienne.",
    ],
    trivia: [
      "Ses combats sont parmi les plus physiquement intenses de la série",
      "Son arc en 2e année — de l'obéissance aveugle vers l'autonomie — est subtil",
      "Sa doubrice Jamie Marchi est connue pour Panty dans Panty & Stocking",
      "L'une des rares élèves dont les capacités de combat sont montrées de façon convaincante",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    isTrending: false,
    isNew: false,
    popularityRank: 20,
    created_at: FieldValue.serverTimestamp(),
  },
];

// ─────────────────────────────────────────────
// 5. QUIZ (personnages principaux)
// ─────────────────────────────────────────────
const quizzes = [
  // Ayanokoji
  {
    characterId: "clk-kiyotaka-ayanokoji",
    questions: [
      {
        question: "Quel score Ayanokoji a-t-il obtenu à chaque matière de l'examen d'entrée ?",
        options: ["100/100", "75/100", "50/100", "0/100"],
        correctIndex: 2,
      },
      {
        question: "Comment s'appelle le programme d'entraînement qui a formé Ayanokoji ?",
        options: ["Dark Room", "White Room", "Shadow Academy", "Elite Project"],
        correctIndex: 1,
      },
      {
        question: "Qui est le père d'Ayanokoji ?",
        options: ["Directeur Sakayanagi", "Atsuomi Ayanokoji", "Manabu Horikita", "Miyabi Nagumo"],
        correctIndex: 1,
      },
      {
        question: "Quelle est la relation d'Ayanokoji avec Kei Karuizawa à partir du LN Year 2 ?",
        options: ["Alliée stratégique", "Rivale", "Petite amie", "Ennemie"],
        correctIndex: 2,
      },
      {
        question: "Qui est l'unique rival intellectuel direct d'Ayanokoji parmi les élèves ?",
        options: ["Suzune Horikita", "Honami Ichinose", "Arisu Sakayanagi", "Kakeru Ryuen"],
        correctIndex: 2,
      },
      {
        question: "Dans quelle classe Ayanokoji est-il placé au début de la série ?",
        options: ["Classe A", "Classe B", "Classe C", "Classe D"],
        correctIndex: 3,
      },
    ],
  },

  // Suzune Horikita
  {
    characterId: "clk-suzune-horikita",
    questions: [
      {
        question: "Quel est l'objectif principal de Suzune Horikita en arrivant à l'école ?",
        options: [
          "Devenir la meilleure athlète",
          "Atteindre la Classe A pour prouver sa valeur à son frère",
          "Trouver des amis",
          "Obtenir la bourse maximale",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel art martial Suzune pratique-t-elle depuis l'enfance ?",
        options: ["Judo", "Karaté", "Kendo", "Jujitsu"],
        correctIndex: 1,
      },
      {
        question: "Quel poste Suzune obtient-elle en 2e année ?",
        options: [
          "Déléguée de classe uniquement",
          "Vice-présidente du CE",
          "Présidente du Conseil Étudiant",
          "Capitaine de l'équipe sportive",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel est le surnom non-officiel de Suzune dans le fanbase ?",
        options: [
          "La Reine de Glace",
          "La Princesse de Glace",
          "L'Ange Froid",
          "La Guerrière Solitaire",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui est le frère aîné de Suzune ?",
        options: ["Miyabi Nagumo", "Kohei Katsuragi", "Manabu Horikita", "Kiyotaka Ayanokoji"],
        correctIndex: 2,
      },
    ],
  },

  // Arisu Sakayanagi
  {
    characterId: "clk-arisu-sakayanagi",
    questions: [
      {
        question: "Pourquoi Arisu Sakayanagi se déplace-t-elle avec une canne ?",
        options: [
          "Suite à une blessure sportive",
          "Malformation cardiaque congénitale",
          "Blessure en combat",
          "Simple accessoire de style",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui est le père d'Arisu Sakayanagi ?",
        options: [
          "Miyabi Nagumo",
          "Le fondateur de l'école",
          "Le Directeur de la Kodo Ikusei",
          "Manabu Horikita",
        ],
        correctIndex: 2,
      },
      {
        question: "Dans quelle classe se trouve Arisu Sakayanagi ?",
        options: ["Classe B", "Classe C", "Classe D", "Classe A"],
        correctIndex: 3,
      },
      {
        question: "Quel élève Sakayanagi remplace-t-elle à la tête de la Classe A ?",
        options: ["Kakeru Ryuen", "Miyabi Nagumo", "Kohei Katsuragi", "Yosuke Hirata"],
        correctIndex: 2,
      },
      {
        question: "Parmi les personnages suivants, lequel est le premier à suspecter la vraie nature d'Ayanokoji ?",
        options: ["Suzune Horikita", "Honami Ichinose", "Arisu Sakayanagi", "Sae Chabashira"],
        correctIndex: 2,
      },
    ],
  },

  // Kakeru Ryuen
  {
    characterId: "clk-kakeru-ryuen",
    questions: [
      {
        question: "Comment Ryuen dirige-t-il la Classe C ?",
        options: [
          "Par la diplomatie et le consensus",
          "Par la force brute et la peur",
          "Par les points de classe uniquement",
          "Par la manipulation psychologique subtile",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel est le bras droit féminin de Ryuen ?",
        options: ["Kei Karuizawa", "Honami Ichinose", "Mio Ibuki", "Airi Sakura"],
        correctIndex: 2,
      },
      {
        question: "Qu'est-ce que Ryuen tente d'identifier obsessionnellement dans la Classe D ?",
        options: [
          "La source de financement cachée",
          "Le cerveau de la Classe D",
          "L'identité du président de classe",
          "Les failles du règlement",
        ],
        correctIndex: 1,
      },
      {
        question: "Vers quelle classe Ryuen évolue-t-il en 2e année ?",
        options: ["Classe A", "Classe B", "Reste en Classe C", "Classe D"],
        correctIndex: 1,
      },
    ],
  },
];

// ─────────────────────────────────────────────
// IMPORT PRINCIPAL
// ─────────────────────────────────────────────
async function importCLK() {
  console.log("🏫 Démarrage de l'import Classroom of the Elite...\n");

  // 1. Animé
  await db.collection("animes").doc(animeData.id).set(animeData, { merge: true });
  console.log(`✅ Animé : ${animeData.titre}`);

  // 2. Créateur
  await db.collection("creators").doc(creatorData.id).set(creatorData, { merge: true });
  console.log(`✅ Créateur : ${creatorData.nom}`);

  // 3. Studio
  await db.collection("studios").doc(studioData.id).set(studioData, { merge: true });
  console.log(`✅ Studio : ${studioData.nom}`);

  // 4. Personnages
  console.log(`\n📋 Import de ${characters.length} personnages...`);
  const batch = db.batch();
  for (const character of characters) {
    const ref = db.collection("characters").doc(character.id);
    batch.set(ref, character, { merge: true });
    console.log(`  → ${character.nom} (${character.id})`);
  }
  await batch.commit();
  console.log(`✅ ${characters.length} personnages importés`);

  // 5. Quiz
  console.log(`\n📝 Import de ${quizzes.length} quiz...`);
  const quizBatch = db.batch();
  for (const quiz of quizzes) {
    const ref = db.collection("quizzes").doc(quiz.characterId);
    quizBatch.set(ref, quiz, { merge: true });
    console.log(`  → Quiz : ${quiz.characterId} (${quiz.questions.length} questions)`);
  }
  await quizBatch.commit();
  console.log(`✅ ${quizzes.length} quiz importés`);

  console.log("\n🎉 Import CLK terminé avec succès !");
  console.log("📊 Résumé :");
  console.log("   1 animé | 1 créateur | 1 studio");
  console.log(`   ${characters.length} personnages | ${quizzes.length} quiz`);
  process.exit(0);
}

importCLK().catch((err) => {
  console.error("❌ Erreur import :", err);
  process.exit(1);
});
