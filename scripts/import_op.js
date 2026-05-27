/**
 * OTADEX — Import One Piece vers Firestore
 * Lit One_Piece_Personnages_OTADEX_2026.docx et insère les données dans Firebase Firestore.
 * Usage : node scripts/import_one_piece.js
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
  id: "one-piece",
  titre: "One Piece",
  titreJaponais: "ワンピース",
  synopsis:
    "One Piece suit les aventures de Monkey D. Luffy, un jeune pirate dont le corps est devenu élastique après avoir accidentellement mangé le Fruit du Démon Gomu Gomu no Mi — révélé plus tard comme le légendaire Hito Hito no Mi Modèle Nika. Luffy et son équipage — les Pirates du Chapeau de Paille — naviguent vers le Grand Line à la recherche du trésor légendaire 'One Piece' laissé par le défunt Roi des Pirates Gol D. Roger.",
  genres: ["Shōnen", "Action", "Aventure", "Comédie", "Drame", "Fantaisie", "Arts martiaux"],
  annee: 1999,
  episodes: {
    total: "1160+ (mai 2026)",
    format2026: "Saisonnier — 26 épisodes/an — Arc Elbaf en cours",
  },
  studio: "Toei Animation",
  studioId: "toei-animation",
  auteur: "Eiichiro Oda",
  auteurId: "eiichiro-oda",
  editeur: "Shūeisha — Weekly Shōnen Jump (depuis le 22 juillet 1997)",
  editeurVF: "Glénat",
  copiesVendues: "530+ millions dans le monde (record mondial absolu — mai 2026)",
  statut: "En cours",
  diffusion: "Fuji TV — depuis le 20 octobre 1999",
  coverImage: "",
  bannerImage: "",
  type: "manga_adapte",
  remake: "The One Piece par Wit Studio (Netflix) — prévu février 2027",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 2. DONNÉES CRÉATEUR
// ─────────────────────────────────────────────
const creatorData = {
  id: "eiichiro-oda",
  nom: "Eiichiro Oda",
  nomJaponais: "尾田 栄一郎",
  bio: "Eiichiro Oda naît le 1er janvier 1975 à Kumamoto, au Japon. Dès l'âge de 4 ans, il veut devenir mangaka. Passionné par Dragon Ball et Vic le Viking, il remporte à 17 ans le 44e Concours Tezuka avec Wanted!. En 1994, il abandonne l'université pour devenir assistant de plusieurs mangakas du Weekly Shōnen Jump (Watsuki, Tokuhiro). En 1997, One Piece paraît pour la première fois — lançant la série de manga la plus vendue de l'histoire. Marié depuis 2002 à Chiaki Inaba, perfectionniste obsessionnel, il a battu le record Guinness du plus grand nombre d'exemplaires publiés pour une série BD par un seul auteur en 2015.",
  dateNaissance: "1er janvier 1975",
  lieuNaissance: "Kumamoto, préfecture de Kumamoto, Japon",
  nationalite: "Japonais",
  imageUrl: "",
  occupation: "Mangaka",
  oeuvres: [
    { titre: "Wanted!", annee: 1992, type: "One-shot — Prix 44e Concours Tezuka" },
    { titre: "Kami kara mirai no puresento", annee: 1993, type: "One-shot" },
    { titre: "Ikki Yako", annee: 1993, type: "One-shot — Tenkaichi Manga Award" },
    { titre: "Monsters", annee: 1994, type: "One-shot" },
    { titre: "Romance Dawn (V1)", annee: 1996, type: "One-shot prototype de One Piece" },
    { titre: "Romance Dawn (V2)", annee: 1996, type: "One-shot prototype de One Piece" },
    { titre: "One Piece (manga)", annee: 1997, type: "Série — 110+ volumes — 530M+ copies" },
    { titre: "One Piece (anime)", annee: 1999, type: "Série animée — Toei Animation — 1160+ épisodes" },
    { titre: "One Piece Film : Red", annee: 2022, type: "Film cinématographique — supervision scénario" },
    { titre: "One Piece Live Action (Netflix)", annee: 2023, type: "Producteur exécutif — Saison 1 & 2" },
  ],
  recompenses: [
    "Prix 44e Concours Tezuka pour Wanted! (1992)",
    "Tenkaichi Manga Award pour Ikki Yako (1993)",
    "Grand Prix de l'Association des Auteurs de Bande Dessinée Japonais (2012)",
    "Record Guinness : plus grand nombre d'exemplaires publiés pour une série BD par un seul auteur (2015)",
    "Record mondial : 530 millions de volumes vendus — record absolu toutes séries confondues (2022)",
  ],
  influences: [
    "Akira Toriyama (Dragon Ball) — influence fondamentale",
    "Nobuhiro Watsuki (Kenshin le Vagabond) — mentor direct",
    "Osamu Tezuka (Astro Boy) — référence historique",
    "Yoshihiro Togashi (YuYu Hakusho, HxH) — complexité des intrigues",
    "Vic le Viking — fascination pour l'aventure maritime",
  ],
  animeIds: ["one-piece"],
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 3. DONNÉES STUDIO
// ─────────────────────────────────────────────
const studioData = {
  id: "toei-animation",
  nom: "Toei Animation",
  nomComplet: "東映アニメーション株式会社",
  fondation: 1956,
  fondateur: "Hiroshi Ôkawa",
  siege: "Nerima, Tokyo, Japon",
  description:
    "Toei Animation est l'un des plus anciens et plus grands studios d'animation japonais, fondé en 1956 à Tokyo. Producteur historique des plus grandes franchises de l'animation mondiale, il adapte One Piece depuis 1999 sur Fuji TV. À partir de 2026, Toei restructure la diffusion en saisons de 26 épisodes par an pour améliorer la qualité.",
  productions: [
    "One Piece (1999 — en cours — 1160+ épisodes)",
    "Dragon Ball Z / Dragon Ball Super",
    "Sailor Moon",
    "Saint Seiya (Les Chevaliers du Zodiaque)",
    "Digimon Adventure",
    "Slam Dunk",
    "Mazinger Z",
    "Precure (franchise)",
  ],
  animeIds: ["one-piece"],
  logoUrl: "",
  created_at: FieldValue.serverTimestamp(),
};

// ─────────────────────────────────────────────
// 4. DONNÉES PERSONNAGES (15)
// ─────────────────────────────────────────────
const characters = [
  // ── #1 Monkey D. Luffy ──
  {
    id: "op-monkey-d-luffy",
    nom: "Monkey D. Luffy",
    nomJaponais: "モンキー・D・ルフィ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "17 ans (début) — 19 ans après l'ellipse de 2 ans",
    sexe: "Masculin",
    dateNaissance: "5 mai (Kodomo no Hi — Fête des enfants au Japon)",
    nationalite: "Fictif — East Blue, Village de Fuchsia",
    statut: "Protagoniste",
    rang: "Roi des Pirates",
    description:
      "Monkey D. Luffy est le protagoniste principal de One Piece et capitaine des Pirates du Chapeau de Paille. Son ambition est de devenir le Roi des Pirates, titre suprême du monde pirate. À 7 ans, il mange accidentellement le Gomu Gomu no Mi — révélé plus tard comme le Hito Hito no Mi Modèle Nika — rendant son corps élastique comme du caoutchouc. Impulsif, loyal et souvent naïf, il possède une capacité innée à rallier des alliés autour de lui. Sa prime de 3 milliards de Berrys post-Wano en fait l'un des pirates les plus redoutés du monde.",
    pouvoirs: [
      "Hito Hito no Mi Modèle Nika (ex-Gomu Gomu no Mi) — corps élastique, invulnérable aux impacts physiques",
      "Gear Second — accélère la circulation sanguine pour augmenter vitesse et puissance",
      "Gear Third — gonfle ses os pour des attaques dévastatrices à grande portée",
      "Gear Fourth (Boundman / Snakeman / Tankman) — compression du caoutchouc en formes ultra-puissantes",
      "Gear Fifth — transformation ultime : Dieu du Soleil Nika — puissance quasi-illimitée",
      "Haki des Rois (Haôshoku) — soumet les adversaires par la seule volonté",
      "Haki de l'Armement (Busoshoku) — renforce le corps comme une armure",
      "Haki de l'Observation (Kenbunshoku) — perception des auras et anticipation",
    ],
    voixJaponaise: "Mayumi Tanaka",
    voixFrancaise: "Benoît Du Pac",
    prime: "3 000 000 000 Berrys",
    relations: [
      { nomPersonnage: "Shanks le Roux", type: "Mentor" },
      { nomPersonnage: "Roronoa Zoro", type: "Premier compagnon" },
      { nomPersonnage: "Portgas D. Ace", type: "Frère de cœur" },
      { nomPersonnage: "Sabo", type: "Frère de cœur" },
      { nomPersonnage: "Monkey D. Garp", type: "Grand-père" },
      { nomPersonnage: "Trafalgar Law", type: "Allié stratégique" },
      { nomPersonnage: "Boa Hancock", type: "Admiratrice" },
    ],
    citations: [
      "Je vais devenir le Roi des Pirates !",
      "Je ne veux pas conquérir le monde. Je veux juste que mes amis puissent vivre librement.",
    ],
    trivia: [
      "Premier mondial du sondage Shueisha World Top 100 (2026) avec plus de 10 millions de votes",
      "Son fruit est révélé comme le Hito Hito no Mi Modèle Nika lors de l'arc Wano (chapitre 1044)",
      "Sa prime a progressé de 30 000 000 B (début) à 3 000 000 000 B (post-Wano)",
      "Petit-fils du Vice-Amiral Monkey D. Garp et fils de Monkey D. Dragon, chef de l'Armée Révolutionnaire",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 1,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #2 Roronoa Zoro ──
  {
    id: "op-roronoa-zoro",
    nom: "Roronoa Zoro",
    nomJaponais: "ロロノア・ゾロ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "19 ans (début) — 21 ans après l'ellipse",
    sexe: "Masculin",
    dateNaissance: "11 novembre",
    nationalite: "Fictif — Village de Shimotsuki, East Blue",
    statut: "Premier Officier",
    rang: "Premier Officier des Pirates du Chapeau de Paille",
    description:
      "Roronoa Zoro est le premier membre à rejoindre l'équipage du Chapeau de Paille. Ancien chasseur de primes, son unique objectif est de devenir le meilleur épéiste du monde pour honorer la promesse faite à son amie d'enfance Kuina, décédée prématurément. Stoïque, discipliné et extrêmement fier, Zoro est le pilier guerrier de l'équipage. Sa scène à Thriller Bark — absorbant toute la douleur de Luffy sans broncher — est considérée comme l'une des plus emblématiques de la série. Il se perd même sur un navire.",
    pouvoirs: [
      "Santoryu (Style des Trois Épées) — technique unique : deux épées en mains, une en bouche",
      "Ashura — forme à neuf épées créant une illusion de neuf membres",
      "Haki des Rois (Haôshoku) — révélé lors de l'arc Wano",
      "Haki de l'Armement et de l'Observation — niveau extrême",
      "Enma — épée légendaire de Kozuki Oden, capable de drainer le Haki",
      "Oni Giri, Tora Gari, 108 Caliber Phoenix — techniques d'attaques iconiques",
    ],
    voixJaponaise: "Kazuya Nakai",
    voixFrancaise: "Éric Legrand",
    prime: "1 101 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Sanji Vinsmoke", type: "Rival éternel" },
      { nomPersonnage: "Dracule Mihawk", type: "Rival absolu / Entraîneur" },
      { nomPersonnage: "Kuina", type: "Amie d'enfance décédée" },
    ],
    citations: [
      "Rien n'est impossible à quelqu'un qui a une ambition suffisante.",
      "Si je meurs ici, je n'atteindrai jamais mon ambition.",
    ],
    trivia: [
      "2e au sondage mondial Shueisha 2026",
      "Entraîné par Dracule Mihawk pendant les 2 ans d'ellipse",
      "Célèbre pour son sens de l'orientation déplorable — se perd sur n'importe quel navire",
      "A absorbé toute la douleur de Luffy à Thriller Bark — scène culte du manga",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 2,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #3 Sanji Vinsmoke ──
  {
    id: "op-sanji-vinsmoke",
    nom: "Sanji Vinsmoke",
    nomJaponais: "ヴィンスモーク・サンジ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "19 ans (début) — 21 ans après l'ellipse",
    sexe: "Masculin",
    dateNaissance: "2 mars",
    nationalite: "Fictif — Royaume de Germa (né), North Blue",
    statut: "Cuisinier",
    rang: "Cuisinier des Pirates du Chapeau de Paille",
    description:
      "Sanji est le cuisinier de l'équipage du Chapeau de Paille et l'un de ses trois membres les plus puissants avec Luffy et Zoro — formant le 'Monster Trio'. Fils du roi Vinsmoke Judge, il a fui sa famille royale militarisée pour devenir cuisinier, refusant de se battre avec ses mains pour préserver son don culinaire. Formé par le légendaire cuisinier Zeff sur le Baratie. Romantique invétéré, incapable de frapper une femme même ennemie. Après Wano, ses modifications génétiques Vinsmoke s'activent pleinement, le dotant d'un exosquelette et de flammes bleu-blanc.",
    pouvoirs: [
      "Diable Jambe — ses jambes s'enflamment par friction pour des coups dévastateurs",
      "Ifrit Jambe (post-Wano) — flammes bleu-blanc d'intensité supérieure",
      "Sky Walk (Six Pouvoirs) — marche dans les airs",
      "Exosquelette Vinsmoke — armure génétique activée à Wano",
      "Haki de l'Armement et de l'Observation",
      "Cuisine — cuisinier de génie capable d'adapter les repas à chaque physiologie",
    ],
    voixJaponaise: "Hiroaki Hirata",
    voixFrancaise: "Boris Rehlinger",
    prime: "1 032 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Roronoa Zoro", type: "Rival éternel" },
      { nomPersonnage: "Zeff", type: "Mentor culinaire" },
      { nomPersonnage: "Reiju Vinsmoke", type: "Sœur" },
    ],
    citations: [
      "Un cuisinier qui ne peut pas nourrir un ennemi n'est pas digne de ce nom.",
      "Un homme ne doit jamais lever la main sur une femme.",
    ],
    trivia: [
      "3e au sondage mondial Shueisha 2026 — vainqueur continental",
      "Interdit d'utiliser ses mains au combat pour préserver ses capacités de cuisinier",
      "Modifications génétiques Vinsmoke non voulues par lui-même — activées involontairement à Wano",
      "Son nom complet est Vinsmoke Sanji — il préfère être appelé uniquement Sanji",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 3,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #4 Nami ──
  {
    id: "op-nami",
    nom: "Nami",
    nomJaponais: "ナミ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "18 ans (début) — 20 ans après l'ellipse",
    sexe: "Féminin",
    dateNaissance: "3 juillet",
    nationalite: "Fictif — Village de Cocoyashi, East Blue",
    statut: "Navigatrice",
    rang: "Navigatrice des Pirates du Chapeau de Paille",
    description:
      "Nami est la navigatrice des Pirates du Chapeau de Paille, dotée d'un don inné pour la météorologie et la cartographie. Son objectif est de dresser une carte complète de tous les océans du monde. Son enfance est marquée par la domination du pirate Arlong qui a assassiné sa mère adoptive Bell-mère. Pragmatique et matérialiste en surface, elle cache une profonde loyauté envers ses compagnons. Libérée par Luffy, elle est devenue l'une des navigatrices les plus redoutables des mers.",
    pouvoirs: [
      "Clima-Tact — bâton créé par Usopp permettant de contrôler la météo localement",
      "Sorcière de la Météo — manipulation des nuages, tempêtes, éclairs, illusions météorologiques",
      "Zeus — nuage personnel amplifiant ses attaques électriques (anciennement de Big Mom)",
      "Thunderball, Mirage Tempo, Rain Tempo — techniques avancées de combat météorologique",
      "Navigation surnaturelle — talent pour lire courants, vents et prévoir tempêtes",
    ],
    voixJaponaise: "Akemi Okamura",
    voixFrancaise: "Isabelle Volpé",
    prime: "366 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Bell-mère", type: "Mère adoptive décédée" },
      { nomPersonnage: "Nojiko", type: "Sœur adoptive" },
      { nomPersonnage: "Arlong", type: "Ennemi originel" },
    ],
    citations: [
      "Un navire sans carte n'arrive nulle part. Je suis indispensable.",
      "Je ne serai jamais ta complice, même contre mes amis.",
    ],
    trivia: [
      "4e au sondage mondial Shueisha 2026 — top 5 constant",
      "Zeus, anciennement nuage de Big Mom, est devenu son allié permanent après Whole Cake Island",
      "Objectif de vie : cartographier tous les océans du monde",
      "A travaillé pour Arlong pendant des années pour racheter la liberté de son village",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 4,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #5 Trafalgar D. Water Law ──
  {
    id: "op-trafalgar-law",
    nom: "Trafalgar D. Water Law",
    nomJaponais: "トラファルガー・ロー",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "24 ans (début) — 26 ans après l'ellipse",
    sexe: "Masculin",
    dateNaissance: "6 octobre",
    nationalite: "Fictif — Flevance, North Blue",
    statut: "Capitaine allié",
    rang: "Capitaine des Pirates du Cœur — Chirurgien de la Mort",
    description:
      "Trafalgar Law est le capitaine de l'Équipage du Cœur et l'un des membres les plus populaires de la Génération Terrible. Originaire de Flevance, une ville décimée par l'intoxication au plomb blanc, il est l'unique survivant de sa famille. Recueilli par Donquichotte Rossinante (Corazon), il a cultivé une haine farouche contre Doflamingo. Médecin-chirurgien de génie, son alliance avec Luffy à Punk Hazard marque un tournant stratégique majeur.",
    pouvoirs: [
      "Ope Ope no Mi — crée un espace sphérique (Room) omnipotent dans lequel il contrôle tout",
      "Shambles — échange de positions d'objets ou personnes dans le Room",
      "Amputate / Mes — tranche sans blesser, permettant des opérations impossibles",
      "Gamma Knife — attaque interne dévastant les organes sans entaille externe",
      "Immortality Operation — confère l'immortalité au prix de la vie du chirurgien",
      "Haki de l'Armement et de l'Observation",
      "Kikoku — nodachi surdimensionné, son arme principale",
    ],
    voixJaponaise: "Hiroshi Kamiya",
    voixFrancaise: "Damien Ferrette",
    prime: "3 000 000 000 Berrys (ex-aequo avec Luffy après Wano)",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Allié / Ami" },
      { nomPersonnage: "Donquichotte Rossinante / Corazon", type: "Père adoptif décédé" },
      { nomPersonnage: "Donquichotte Doflamingo", type: "Ennemi juré" },
      { nomPersonnage: "Bepo", type: "Second fidèle" },
    ],
    citations: [
      "Je suis un médecin. Je soigne ceux qui en ont besoin.",
      "Je t'ai détesté toute ma vie, Doflamingo. Mais c'est Corazon que je chéris.",
    ],
    trivia: [
      "5e au sondage mondial Shueisha 2026 — générationnel arc Dressrosa/Wano",
      "Sa prime égale celle de Luffy post-Wano — 3 milliards de Berrys",
      "Son vrai prénom complet : Trafalgar D. Water Law — le 'D.' est un mystère central de la série",
      "L'Ope Ope no Mi est surnommé 'le Fruit du Démon Ultime' par le Gouvernement Mondial",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 5,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #6 Portgas D. Ace ──
  {
    id: "op-portgas-d-ace",
    nom: "Portgas D. Ace",
    nomJaponais: "ポートガス・D・エース",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "20 ans (lors de sa mort à Marineford)",
    sexe: "Masculin",
    dateNaissance: "1er janvier",
    nationalite: "Fictif — né à bord d'un navire pirate",
    statut: "Frère de cœur (décédé)",
    rang: "Commandant de la 2e Division des Pirates de Barbe Blanche",
    description:
      "Portgas D. Ace, surnommé 'Ace aux Poings Ardents', est le fils biologique du défunt Roi des Pirates Gol D. Roger et l'un des personnages les plus aimés de la franchise. Élevé par Monkey D. Garp aux côtés de Luffy et Sabo, il est commandant de la Seconde Division des Pirates de Barbe Blanche. Sa mort tragique à Marineford — en protégeant Luffy d'une attaque de l'Amiral Akainu — est considérée comme l'un des moments les plus marquants de l'histoire du manga et déclenche l'ellipse temporelle de deux ans.",
    pouvoirs: [
      "Mera Mera no Mi (Logia Feu) — transformation complète en feu, immunité aux attaques physiques ordinaires",
      "Hiken (Poing de Feu) — technique signature, lance son poing enflammé à distance",
      "Entei (Flamme Céleste) — colonne de feu dévastatrice vers le ciel",
      "Haki de l'Armement — confirmé lors de combats avec Barbe Noire",
      "Force physique colossale même sans fruit du démon",
    ],
    voixJaponaise: "Toshio Furukawa",
    voixFrancaise: "Thibaut Belfodil",
    prime: "550 000 000 Berrys (avant sa mort)",
    statut_vie: "Décédé — tué par l'Amiral Akainu lors de la Guerre au Sommet (Marineford)",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Frère de cœur" },
      { nomPersonnage: "Sabo", type: "Frère de cœur" },
      { nomPersonnage: "Monkey D. Garp", type: "Grand-père adoptif" },
      { nomPersonnage: "Edward Newgate / Barbe Blanche", type: "Capitaine / Père" },
      { nomPersonnage: "Marshall D. Teach / Barbe Noire", type: "Traître" },
    ],
    citations: [
      "Je suis né de la volonté de mon père et de l'amour de ma mère.",
      "Merci d'être nés dans ce monde, Luffy.",
    ],
    trivia: [
      "6e au sondage mondial Shueisha 2026 — top 5 mondial post-mortem",
      "Fils biologique de Gol D. Roger — tenu secret pendant des années",
      "Sa mère Portgas D. Rouge l'a porté 20 mois pour retarder sa naissance et cacher son identité",
      "Le Mera Mera no Mi est hérité par Sabo lors de l'arc Dressrosa",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 6,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #7 Tony Tony Chopper ──
  {
    id: "op-tony-tony-chopper",
    nom: "Tony Tony Chopper",
    nomJaponais: "トニートニー・チョッパー",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "15 ans (début) — 17 ans après l'ellipse",
    sexe: "Masculin",
    dateNaissance: "24 décembre",
    nationalite: "Fictif — Île de Drum, Grand Line",
    statut: "Médecin",
    rang: "Médecin des Pirates du Chapeau de Paille",
    description:
      "Tony Tony Chopper est le médecin de l'équipage du Chapeau de Paille, un renne anthropomorphe né sur l'Île de Drum. Rejeté par son troupeau à cause de son nez bleu, il est recueilli par le Docteur Hiluluk dont il adopte le rêve : créer un remède capable de soigner toutes les maladies du monde. Après la mort de Hiluluk, il est formé par la redoutable Docteur Kureha. Chopper est le membre le plus jeune et le plus émotif de l'équipage. Sa prime de 1 000 Berrys est intentionnellement ridicule — la Marine le prend pour un simple animal de compagnie.",
    pouvoirs: [
      "Hito Hito no Mi (Zoan Humain) — 8 transformations entre forme renne et humaine géante",
      "Rumble Ball — drogue développée par lui-même activant des formes supplémentaires",
      "Monster Point — transformation gigantesque ultra-puissante, contrôlée après l'ellipse",
      "Walk Point, Heavy Point, Brain Point, Guard Point, Arm Point, Horn Point, Jumping Point",
      "Médecine de génie — diagnostics impossibles, créateur de médicaments universels",
      "Communication avec les animaux — comprend toutes les langues animales",
    ],
    voixJaponaise: "Ikue Ohtani",
    voixFrancaise: "Virginie Méry",
    prime: "1 000 Berrys (intentionnellement ridiculisé par la Marine)",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Docteur Hiluluk", type: "Père spirituel décédé" },
      { nomPersonnage: "Docteur Kureha", type: "Maîtresse" },
      { nomPersonnage: "Brook", type: "Compagnon de jeu" },
    ],
    citations: [
      "Je ne suis pas mignon du tout ! Tais-toi !",
      "Je veux créer un médicament capable de soigner toutes les maladies du monde.",
    ],
    trivia: [
      "7e au sondage mondial Shueisha 2026 — le plus kawaii de l'équipage",
      "Sa prime de 1 000 Berrys est la plus basse de l'équipage — la Marine pense qu'il est un animal",
      "Danse bizarrement quand on le complimente pour cacher sa joie",
      "Docteur autodidacte qui a étudié sous Kureha, médecin légendaire de 139 ans",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 7,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #8 Nico Robin ──
  {
    id: "op-nico-robin",
    nom: "Nico Robin",
    nomJaponais: "ニコ・ロビン",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "28 ans (début) — 30 ans après l'ellipse",
    sexe: "Féminin",
    dateNaissance: "6 février",
    nationalite: "Fictif — Île Ohara, West Blue",
    statut: "Archéologue",
    rang: "Archéologue des Pirates du Chapeau de Paille",
    description:
      "Nico Robin est l'archéologue des Pirates du Chapeau de Paille et l'unique personne au monde capable de lire les Ponéglyphes — les pierres gravées qui révèlent l'histoire du Siècle Oublié. Née sur l'île d'Ohara, centre mondial de l'archéologie, elle est orpheline depuis l'âge de 8 ans après le massacre de son île par le Gouvernement Mondial. Classée comme criminelle depuis l'enfance, elle a survécu seule des décennies. Sa scène à Enies Lobby — 'Je veux vivre !' — est l'une des plus émouvantes de la série.",
    pouvoirs: [
      "Hana Hana no Mi — fait pousser des répliques de ses membres sur toute surface à portée",
      "Mil Fleurs (Mille Fleurs) — invoque des centaines de membres pour attaques et défenses",
      "Gigantesco Mano (post-ellipse) — mains géantes aux dimensions démesurées",
      "Demonio Fleur — transformation vers une forme semi-démoniaque à Onigashima",
      "Connaissance des Ponéglyphes — seule vivante à pouvoir les déchiffrer",
      "Haki de l'Armement (confirmé après l'ellipse)",
    ],
    voixJaponaise: "Yuriko Yamaguchi",
    voixFrancaise: "Sylvie Jacob",
    prime: "930 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine / Famille" },
      { nomPersonnage: "Nico Olvia", type: "Mère biologique décédée" },
      { nomPersonnage: "Professeur Clover", type: "Mentor archéologue décédé" },
      { nomPersonnage: "Nami", type: "Compagne de recherches" },
    ],
    citations: [
      "Je veux vivre ! Emmenez-moi en mer !",
      "L'histoire ne disparaît jamais. Elle attend d'être découverte.",
    ],
    trivia: [
      "8e au sondage mondial Shueisha 2026 — arc Enies Lobby iconique",
      "Son île natale Ohara a été entièrement détruite par le Buster Call quand elle avait 8 ans",
      "Objectif ultime : retrouver le Rio Ponéglyphe et révéler la vérité du Siècle Oublié",
      "A rejoint l'équipage officiellement après Enies Lobby — après avoir servi d'espionne de Baroque Works",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 8,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #9 Boa Hancock ──
  {
    id: "op-boa-hancock",
    nom: "Boa Hancock",
    nomJaponais: "ボア・ハンコック",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "29 ans (arc Amazon Lily)",
    sexe: "Féminin",
    dateNaissance: "2 septembre",
    nationalite: "Fictif — Amazon Lily, Grand Line",
    statut: "Alliée / Impératrice",
    rang: "Reine d'Amazon Lily — Impératrice Serpente",
    description:
      "Boa Hancock est la reine du Royaume d'Amazon Lily et l'ancienne membre des Sept Grands Corsaires. Considérée comme la femme la plus belle du monde, elle a un passé douloureux — esclave des Dragons Célestes avec ses sœurs. Sa rencontre avec Luffy transforme cette femme froide et arrogante en une admiratrice inconditionnelle. Sa loyauté envers Luffy la pousse à saboter subtilement la Marine lors de la Guerre de Marineford.",
    pouvoirs: [
      "Mero Mero no Mi — pétrification de toute personne qui la trouve belle",
      "Slave Arrow — centaines de flèches pétrifiantes simultanées",
      "Pistol Kiss / Perfume Femur — attaques combinant pouvoirs et Haki",
      "Haki des Trois Types (armement, observation et Haôshoku)",
      "Arts Martiaux Kuja — maîtrise du peuple d'Amazon Lily",
      "Salomé — serpent royal lui servant de trône et de transport",
    ],
    voixJaponaise: "Kotono Mitsuishi",
    voixFrancaise: "Céline Melloul",
    prime: "1 659 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Intérêt romantique" },
      { nomPersonnage: "Boa Sandersonia", type: "Sœur" },
      { nomPersonnage: "Boa Marigold", type: "Sœur" },
      { nomPersonnage: "Marshall D. Teach / Barbe Noire", type: "Ennemi récent" },
    ],
    citations: [
      "Je suis belle, donc je peux faire ce que je veux.",
      "J'aime Luffy. C'est une maladie dont je ne veux pas guérir.",
    ],
    trivia: [
      "9e au sondage mondial Shueisha 2026 — top 10 constant depuis l'arc Amazon Lily",
      "A sabordé ses responsabilités de Corsaire pour aider Luffy à Marineford",
      "La plus grande de l'équipage avec 191 cm",
      "Ancienne esclave des Dragons Célestes — porte toujours la marque de l'Astéropale",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 9,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #10 Shanks le Roux ──
  {
    id: "op-shanks",
    nom: "Shanks le Roux",
    nomJaponais: "赤髪のシャンクス",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "37 ans (arc Marineford)",
    sexe: "Masculin",
    dateNaissance: "9 mars",
    nationalite: "Fictif — ancien membre de l'Équipage de Gol D. Roger",
    statut: "Quatre Empereurs",
    rang: "Capitaine de l'Équipage du Roux — L'un des Quatre Empereurs",
    description:
      "Shanks est l'un des Quatre Empereurs, les pirates les plus puissants du monde, et l'homme qui a inspiré Monkey D. Luffy à devenir le Roi des Pirates en lui offrant son chapeau de paille légendaire. Ancien membre de l'équipage de Gol D. Roger, il a perdu son bras gauche pour sauver Luffy d'un monstre marin. Contrairement aux autres Empereurs, Shanks prône une philosophie de paix relative. Sa seule présence stoppe des batailles mondiales.",
    pouvoirs: [
      "Haki des Rois (Haôshoku) — de niveau légendaire, a stoppé un Amiral à Marineford",
      "Haki de l'Armement — niveau extrême malgré un seul bras",
      "Griffu — épée à une main, a survécu à un affrontement avec Mihawk",
      "Présence — sa simple apparition dissuade toute escalade militaire mondiale",
    ],
    voixJaponaise: "Shūichi Ikeda",
    voixFrancaise: "Patrick Messe",
    prime: "4 048 900 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Pupille" },
      { nomPersonnage: "Dracule Mihawk", type: "Rival respectueux" },
      { nomPersonnage: "Marshall D. Teach / Barbe Noire", type: "Rival / Opposant" },
      { nomPersonnage: "Ben Beckman", type: "Second" },
    ],
    citations: [
      "Je suis venu pour mettre fin à la guerre.",
      "Un chapeau de paille pour un roi des pirates.",
    ],
    trivia: [
      "10e au sondage mondial Shueisha 2026 — mythe fondateur de la série",
      "L'un des seuls Quatre Empereurs sans fruit du démon",
      "A rencontré Gol D. Roger enfant en tant que mousse sur son navire",
      "Sa prime dépasse 4 milliards de Berrys — parmi les plus élevées du monde",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 10,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #11 Sabo ──
  {
    id: "op-sabo",
    nom: "Sabo",
    nomJaponais: "サボ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "22 ans (réapparition à Dressrosa)",
    sexe: "Masculin",
    dateNaissance: "20 mars",
    nationalite: "Fictif — Royaume de Goa, East Blue",
    statut: "Bras droit de l'Armée Révolutionnaire",
    rang: "Chevalier de la Révolution — N°2 de l'Armée Révolutionnaire",
    description:
      "Sabo est le second de l'Armée Révolutionnaire dirigée par Monkey D. Dragon et le frère de cœur de Luffy et Ace. Né noble au Royaume de Goa, il a fui sa famille par idéalisme. Présumé mort dans son enfance après l'explosion de son navire, il a été secrètement recueilli par Dragon et a perdu la mémoire pendant des années. Il réapparaît lors de l'arc Dressrosa en héritant du fruit du démon d'Ace.",
    pouvoirs: [
      "Mera Mera no Mi (hérité d'Ace) — maîtrise du feu offensif à longue portée",
      "Dragon's Claw (Griffe du Dragon) — technique de corps-à-corps à mains nues",
      "Haki des Trois Types (armement, observation, haôshoku présumé)",
      "Combat au bâton — maîtrise avant même l'obtention du fruit",
      "Stratège militaire — numéro deux de l'Armée Révolutionnaire",
    ],
    voixJaponaise: "Junichi Suwabe (adulte)",
    voixFrancaise: "Damien Ferrette (adulte)",
    prime: "602 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Frère de cœur" },
      { nomPersonnage: "Portgas D. Ace", type: "Frère de cœur (décédé)" },
      { nomPersonnage: "Monkey D. Dragon", type: "Leader / Mentor" },
      { nomPersonnage: "Koala", type: "Compagne révolutionnaire" },
    ],
    citations: [
      "Ace, je porterai ton héritage et ton fruit.",
      "La liberté ne s'obtient pas sans combat.",
    ],
    trivia: [
      "11e au sondage mondial Shueisha 2026 — populaire depuis la révélation de Dressrosa",
      "Révélation que Sabo était vivant fut l'un des chocs les plus importants du manga (chapitre 731)",
      "Le Mera Mera no Mi avait été mis en vente lors du tournoi de l'arc Dressrosa",
      "Fils d'une famille noble du Royaume de Goa — a renoncé à ce privilège par conviction",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 11,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #12 Usopp ──
  {
    id: "op-usopp",
    nom: "Usopp",
    nomJaponais: "ウソップ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "17 ans (début) — 19 ans après l'ellipse",
    sexe: "Masculin",
    dateNaissance: "1er avril",
    nationalite: "Fictif — Village de Syrup, East Blue",
    statut: "Tireur d'élite",
    rang: "Tireur d'Élite des Pirates du Chapeau de Paille — God Usopp",
    description:
      "Usopp est le tireur d'élite des Pirates du Chapeau de Paille, fils du franc-tireur Yasopp de l'équipage de Shanks. Connu pour ses mensonges grandioses et sa couardise affichée, il cache une bravoure réelle qui éclate dans les moments critiques. Son parcours est celui d'un homme ordinaire parmi des monstres. Son alter ego Sogeking est un déguisement transparent que personne ne reconnaît. À Dressrosa, son tir de 8 km sur Sucre est considéré comme le coup le plus légendaire de la série.",
    pouvoirs: [
      "Kuro Kabuto — lance-pierre de précision à longue portée",
      "Pop Greens — graines explosives et piégées créées par lui-même",
      "Tir légendaire de 8 km à Dressrosa sur Sucre",
      "Haki de l'Observation niveau dieu — perception légendaire activée par instinct",
      "Inventeur — crée gadgets et armes, dont le Clima-Tact de Nami",
    ],
    voixJaponaise: "Kappei Yamaguchi",
    voixFrancaise: "Michel Dodane",
    prime: "500 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Yasopp", type: "Père (équipage de Shanks)" },
      { nomPersonnage: "Kaya", type: "Amie d'enfance" },
    ],
    citations: [
      "Je suis le grand capitaine Usopp ! Je suis invincible !",
      "J'ai peur, mais je vais quand même me battre !",
    ],
    trivia: [
      "12e au sondage mondial Shueisha 2026 — God Usopp à Dressrosa",
      "Son alter ego Sogeking / Sniper King est un déguisement que personne ne reconnaît",
      "Père absent Yasopp est franc-tireur de l'équipage de Shanks",
      "Son tir de 8 km sur Sucre à Dressrosa est unanimement considéré comme le coup le plus légendaire de la série",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 12,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #13 Jinbe ──
  {
    id: "op-jinbe",
    nom: "Jinbe",
    nomJaponais: "ジンベエ",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "46 ans (lors de son entrée dans l'équipage)",
    sexe: "Masculin",
    dateNaissance: "2 avril",
    nationalite: "Fictif — Île des Hommes-Poissons",
    statut: "Timonier",
    rang: "Timonier des Pirates du Chapeau de Paille — Chevalier de la Mer",
    description:
      "Jinbe est le timonier des Pirates du Chapeau de Paille, le plus expérimenté et le plus mature de l'équipage. Homme-poisson de l'espèce requin baleine, ancien capitaine corsaire, il a combattu aux côtés de Barbe Blanche lors de la Guerre de Marineford pour protéger Luffy. Disciple du légendaire Fisher Tiger et militant pour l'égalité humains-hommes-poissons, il incarne la sagesse et le stoïcisme. Son entrée officielle dans l'équipage, attendue des années par les fans, est confirmée lors de l'arc Whole Cake Island.",
    pouvoirs: [
      "Gyojin Karate (Arts Martiaux des Hommes-Poissons) — manipulation du flux d'eau, efficace hors de l'eau",
      "Vagabond Drill — rotation à grande vitesse comme une foreuse",
      "Seabed Strangle — prise immobilisante sous l'eau",
      "Water Shot — projette l'eau comme projectile",
      "Navigation et timon légendaires — duo légendaire avec Nami",
      "Haki de l'Armement et de l'Observation — niveau extrêmement élevé",
    ],
    voixJaponaise: "Katsuhisa Hoki",
    voixFrancaise: "Pascal Germain",
    prime: "1 100 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine / Protégé" },
      { nomPersonnage: "Fisher Tiger", type: "Mentor décédé" },
      { nomPersonnage: "Edward Newgate / Barbe Blanche", type: "Ancien partenaire" },
      { nomPersonnage: "Nami", type: "Compagne de navigation" },
    ],
    citations: [
      "Un homme sage connaît ses limites. Un homme sage les repousse quand même.",
      "La haine ne construit rien. Je choisis l'espoir.",
    ],
    trivia: [
      "13e au sondage mondial Shueisha 2026 — le plus récent Mugiwara officiel",
      "A transfusé son sang à Luffy pour le sauver à Marineford — leur lien est unique",
      "301 cm et 438 kg — le membre le plus imposant physiquement de l'équipage",
      "Attendu comme membre officiel depuis l'arc Impel Down — a finalement rejoint après Whole Cake Island",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 13,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #14 Brook ──
  {
    id: "op-brook",
    nom: "Brook",
    nomJaponais: "ブルック",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "88 ans (avant ellipse) — 90 ans après",
    sexe: "Masculin",
    dateNaissance: "3 avril",
    nationalite: "Fictif — West Blue",
    statut: "Musicien",
    rang: "Musicien des Pirates du Chapeau de Paille — Soul King",
    description:
      "Brook est le musicien des Pirates du Chapeau de Paille, un squelette animé depuis 50 ans grâce au Fruit de la Résurrection. Ancien capitaine de l'Équipage de la Rumbar, il a survécu à la mort mais son âme a mis 50 ans à retrouver son corps dans le Triangle de Florian. Mélomane accompli, violoniste et espéiste hors pair, il a bâti une immense carrière sous le nom de Soul King durant l'ellipse. Célèbre pour ses blagues sur ses os et pour demander à voir les sous-vêtements des femmes.",
    pouvoirs: [
      "Yomi Yomi no Mi — résurrection une seule fois après la mort",
      "Soul Solid — infuse le froid de l'au-delà dans son épée, gèle tout ce qu'il tranche",
      "Astral Projection — projette son âme hors du corps pour espionner ou traverser des barrières",
      "Escrime légendaire — vitesse de dégainage quasi-invisible, style Yahazu Giri",
      "Musique mystique — performances agissant sur les émotions et les esprits",
    ],
    voixJaponaise: "Chō",
    voixFrancaise: "Michel Vigné",
    prime: "383 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Laboon", type: "Baleine géante attendant son retour" },
      { nomPersonnage: "Tony Tony Chopper", type: "Compagnon de farces" },
    ],
    citations: [
      "Yohohoho ! Puis-je voir vos sous-vêtements ?",
      "La musique est l'âme. Et moi, je n'ai plus que ça.",
    ],
    trivia: [
      "14e au sondage mondial Shueisha 2026 — seul musicien du top",
      "Son afro est intact malgré sa mort car les cheveux continuent de pousser après la mort",
      "Laboon — la baleine géante à l'entrée du Grand Line — attend son retour depuis 50 ans",
      "A bâti une carrière musicale mondiale sous le nom de Soul King durant les 2 ans d'ellipse",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 14,
    created_at: FieldValue.serverTimestamp(),
  },

  // ── #15 Franky ──
  {
    id: "op-franky",
    nom: "Franky",
    nomJaponais: "フランキー",
    animeId: "one-piece",
    animeName: "One Piece",
    auteurId: "eiichiro-oda",
    auteurNom: "Eiichiro Oda",
    studioId: "toei-animation",
    studioNom: "Toei Animation",
    age: "34 ans (début) — 36 ans après l'ellipse",
    sexe: "Masculin",
    dateNaissance: "9 mars",
    nationalite: "Fictif — South Blue / Water 7",
    statut: "Charpentier",
    rang: "Charpentier des Pirates du Chapeau de Paille — Cyborg SUPER",
    description:
      "Franky est le charpentier des Pirates du Chapeau de Paille, un cyborg aux modifications corporelles spectaculaires effectuées sur lui-même après avoir été grièvement blessé à Water 7. Ancien apprenti du légendaire charpentier Tom — constructeur du navire de Gol D. Roger — il a construit le Thousand Sunny. Excentrique, exhibitionniste (souvent en slip), il se considère lui-même comme 'SUPER'. Sa loyauté absolue envers ses créations guide sa vie.",
    pouvoirs: [
      "Corps cyborg — résistance extrême, force surhumaine, armes intégrées",
      "Franky Cannon — canon intégré dans la poitrine, puissance dévastatrice",
      "Coup de Vent — souffle d'air comprimé dévastateur",
      "Franky Shogun (General Franky) — robot géant construit à Punk Hazard",
      "Armée-Laser (post-ellipse) — rayons laser inspirés de la technologie Vegapunk",
      "Charpenterie légendaire — peut construire ou réparer n'importe quel navire",
    ],
    voixJaponaise: "Kazuki Yao",
    voixFrancaise: "Jérôme Wiggins",
    prime: "394 000 000 Berrys",
    relations: [
      { nomPersonnage: "Monkey D. Luffy", type: "Capitaine" },
      { nomPersonnage: "Tom", type: "Maître / Père spirituel décédé" },
      { nomPersonnage: "Iceburg", type: "Frère adoptif" },
      { nomPersonnage: "Tony Tony Chopper", type: "Admirateur enfantin" },
    ],
    citations: [
      "Je suis Franky et je suis SUPER !",
      "Je construis des navires pour qu'ils transportent les rêves des gens.",
    ],
    trivia: [
      "15e au sondage mondial Shueisha 2026 — cyborg SUPER, a construit le Thousand Sunny",
      "Son vrai nom est Cutty Flam — il refuse qu'on l'appelle ainsi",
      "Se promène souvent en slip car il a dépensé tous ses matériaux sur ses améliorations corporelles",
      "Le Thousand Sunny intègre le bois Adam légendaire — seul à résister aux attaques de niveau Empereurs",
    ],
    images: [],
    imagePath: "",
    likesCount: 0,
    collectCount: 0,
    popularityRank: 15,
    created_at: FieldValue.serverTimestamp(),
  },
];

// ─────────────────────────────────────────────
// 5. QUIZ (7 personnages principaux — 5 questions chacun)
// ─────────────────────────────────────────────
const quizzes = [
  // Luffy
  {
    characterId: "op-monkey-d-luffy",
    questions: [
      {
        question: "Quel est le vrai nom du fruit du démon de Monkey D. Luffy, révélé lors de l'arc Wano ?",
        options: [
          "Gomu Gomu no Mi",
          "Hito Hito no Mi Modèle Nika",
          "Mera Mera no Mi",
          "Ope Ope no Mi",
        ],
        correctIndex: 1,
      },
      {
        question: "Comment s'appelle la transformation ultime de Luffy débloquée à Wano ?",
        options: ["Gear Fourth", "Gear Fifth", "Gear Third", "Gear Second"],
        correctIndex: 1,
      },
      {
        question: "Qui a inspiré Luffy à devenir le Roi des Pirates ?",
        options: ["Gol D. Roger", "Shanks le Roux", "Barbe Blanche", "Garp"],
        correctIndex: 1,
      },
      {
        question: "Quel est le montant de la prime de Luffy après l'arc Wano ?",
        options: [
          "1 500 000 000 Berrys",
          "2 000 000 000 Berrys",
          "3 000 000 000 Berrys",
          "4 000 000 000 Berrys",
        ],
        correctIndex: 2,
      },
      {
        question: "Qui est le père biologique de Monkey D. Luffy ?",
        options: [
          "Monkey D. Garp",
          "Shanks le Roux",
          "Monkey D. Dragon",
          "Gol D. Roger",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Zoro
  {
    characterId: "op-roronoa-zoro",
    questions: [
      {
        question: "Quelle est la technique de combat unique de Roronoa Zoro ?",
        options: [
          "Diable Jambe",
          "Gyojin Karate",
          "Santoryu — Style des Trois Épées",
          "Arts Martiaux Kuja",
        ],
        correctIndex: 2,
      },
      {
        question: "Quelle est l'épée légendaire que Zoro reçoit lors de l'arc Wano ?",
        options: ["Wado Ichimonji", "Sandai Kitetsu", "Enma", "Shusui"],
        correctIndex: 2,
      },
      {
        question: "Quel est le rival absolu de Zoro, son objectif ultime à surpasser ?",
        options: ["Sanji", "Luffy", "Shanks", "Dracule Mihawk"],
        correctIndex: 3,
      },
      {
        question: "Pour qui Zoro veut-il devenir le meilleur épéiste du monde ?",
        options: [
          "Pour Luffy",
          "Pour sa mère",
          "Pour Kuina, son amie d'enfance décédée",
          "Pour lui-même uniquement",
        ],
        correctIndex: 2,
      },
      {
        question: "Lors de quel arc le Haki des Rois de Zoro est-il révélé ?",
        options: ["Dressrosa", "Whole Cake Island", "Wano", "Enies Lobby"],
        correctIndex: 2,
      },
    ],
  },

  // Sanji
  {
    characterId: "op-sanji-vinsmoke",
    questions: [
      {
        question: "Comment s'appelle la technique de Sanji qui enflamme ses jambes par friction ?",
        options: ["Gear Jambe", "Diable Jambe", "Sky Kick", "Flaming Leg"],
        correctIndex: 1,
      },
      {
        question: "Pourquoi Sanji refuse-t-il de frapper une femme, même ennemie ?",
        options: [
          "Il est trop faible pour ça",
          "C'est une règle de son équipage",
          "C'est son code d'honneur personnel inébranlable",
          "La Marine lui a interdit",
        ],
        correctIndex: 2,
      },
      {
        question: "Quel légendaire cuisinier a formé Sanji sur le Baratie ?",
        options: ["Tom", "Zeff", "Oda", "Newgate"],
        correctIndex: 1,
      },
      {
        question: "Comment s'appelle la version améliorée des flammes de Sanji après l'arc Wano ?",
        options: ["Ultra Jambe", "Ifrit Jambe", "Diablo Jambe", "Storm Jambe"],
        correctIndex: 1,
      },
      {
        question: "Quel est le vrai nom de famille de Sanji ?",
        options: ["Baratie", "Roronoa", "Vinsmoke", "Zeff"],
        correctIndex: 2,
      },
    ],
  },

  // Nami
  {
    characterId: "op-nami",
    questions: [
      {
        question: "Quel est l'objectif de vie de Nami ?",
        options: [
          "Devenir la navigatrice la plus riche",
          "Battre tous les pirates",
          "Dresser une carte complète de tous les océans du monde",
          "Retrouver sa famille",
        ],
        correctIndex: 2,
      },
      {
        question: "Comment s'appelle l'arme principale de Nami ?",
        options: ["Thunderbolt", "Clima-Tact", "Zeus Scepter", "Storm Wand"],
        correctIndex: 1,
      },
      {
        question: "Quel pirate a assassiné Bell-mère, la mère adoptive de Nami ?",
        options: ["Doflamingo", "Kaido", "Arlong", "Big Mom"],
        correctIndex: 2,
      },
      {
        question: "D'où vient Zeus, le nuage électrique allié de Nami ?",
        options: [
          "Elle l'a créé avec son Clima-Tact",
          "C'est un cadeau de Luffy",
          "C'était le nuage personnel de Big Mom",
          "Il vient du pays des nuages Skypiea",
        ],
        correctIndex: 2,
      },
      {
        question: "De quel village de l'East Blue Nami est-elle originaire ?",
        options: ["Village de Fuchsia", "Village de Cocoyashi", "Village de Syrup", "Village de Shimotsuki"],
        correctIndex: 1,
      },
    ],
  },

  // Trafalgar Law
  {
    characterId: "op-trafalgar-law",
    questions: [
      {
        question: "Quel pouvoir donne l'Ope Ope no Mi à Trafalgar Law ?",
        options: [
          "Contrôle des flammes",
          "Création d'un espace sphérique (Room) omnipotent",
          "Transformation en métal",
          "Manipulation du temps",
        ],
        correctIndex: 1,
      },
      {
        question: "De quelle ville dévastée par l'intoxication au plomb Law est-il originaire ?",
        options: ["Water 7", "Dressrosa", "Flevance", "Punk Hazard"],
        correctIndex: 2,
      },
      {
        question: "Qui est le mentor et père adoptif de Law, tué par Doflamingo ?",
        options: [
          "Fisher Tiger",
          "Donquichotte Rossinante / Corazon",
          "Barbe Blanche",
          "Garp",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel est le surnom de Trafalgar Law ?",
        options: [
          "Le Chirurgien de la Mort",
          "Le Médecin des Mers",
          "Le Docteur Fantôme",
          "Le Chirurgien de l'Enfer",
        ],
        correctIndex: 0,
      },
      {
        question: "Quelle est la technique ultime de l'Ope Ope no Mi qui rend quelqu'un immortel mais tue son utilisateur ?",
        options: [
          "Gamma Knife",
          "Shambles",
          "Immortality Operation",
          "Room Omega",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Ace
  {
    characterId: "op-portgas-d-ace",
    questions: [
      {
        question: "Quel est le fruit du démon de Portgas D. Ace ?",
        options: [
          "Magu Magu no Mi",
          "Mera Mera no Mi",
          "Goro Goro no Mi",
          "Hiken Hiken no Mi",
        ],
        correctIndex: 1,
      },
      {
        question: "Qui est le père biologique de Portgas D. Ace ?",
        options: [
          "Monkey D. Dragon",
          "Barbe Blanche",
          "Gol D. Roger",
          "Monkey D. Garp",
        ],
        correctIndex: 2,
      },
      {
        question: "Qui a tué Portgas D. Ace lors de la Guerre au Sommet ?",
        options: ["Akainu", "Kizaru", "Barbe Noire", "Aokiji"],
        correctIndex: 0,
      },
      {
        question: "Qui a récupéré le Mera Mera no Mi d'Ace après sa mort ?",
        options: ["Luffy", "Barbe Noire", "Sabo", "Doflamingo"],
        correctIndex: 2,
      },
      {
        question: "Qui a trahi Ace et l'a livré au Gouvernement Mondial ?",
        options: [
          "Barbe Blanche",
          "Shanks",
          "Marshall D. Teach / Barbe Noire",
          "Doflamingo",
        ],
        correctIndex: 2,
      },
    ],
  },

  // Chopper
  {
    characterId: "op-tony-tony-chopper",
    questions: [
      {
        question: "Quel est le fruit du démon de Tony Tony Chopper ?",
        options: [
          "Zoan Renne",
          "Hito Hito no Mi",
          "Neko Neko no Mi",
          "Inu Inu no Mi",
        ],
        correctIndex: 1,
      },
      {
        question: "Quel médecin de l'Île de Drum a inspiré le rêve de Chopper ?",
        options: ["Docteur Kureha", "Docteur Hiluluk", "Docteur Vegapunk", "Docteur Chopper"],
        correctIndex: 1,
      },
      {
        question: "Quelle drogue Chopper a-t-il développée lui-même pour activer des transformations supplémentaires ?",
        options: ["Power Ball", "Rumble Ball", "Transform Pill", "Zoan Booster"],
        correctIndex: 1,
      },
      {
        question: "Quel est le montant ridicule de la prime de Chopper, intentionnellement bas ?",
        options: ["100 Berrys", "500 Berrys", "1 000 Berrys", "50 Berrys"],
        correctIndex: 2,
      },
      {
        question: "Comment Chopper réagit-il quand on le complimente ?",
        options: [
          "Il remercie avec élégance",
          "Il s'énerve et dit 'Je ne suis pas mignon !'",
          "Il danse en cachant sa joie",
          "Il se transforme immédiatement",
        ],
        correctIndex: 2,
      },
    ],
  },
];

// ─────────────────────────────────────────────
// SCRIPT PRINCIPAL
// ─────────────────────────────────────────────
async function importOnePiece() {
  console.log("🌊 Début import One Piece dans Firestore...\n");

  // Vérification optionnelle du docx (mammoth)
  try {
    const mammothLib = require("mammoth");
    const result = await mammothLib.extractRawText({
      path: path.join(__dirname, "../One_Piece_Personnages_OTADEX_2026.docx"),
    });
    const lineCount = result.value.split("\n").filter((l) => l.trim()).length;
    console.log(
      `📄 Document One Piece lu avec mammoth — ${lineCount} lignes extraites`,
    );
  } catch {
    console.log(
      "ℹ️  mammoth non disponible — import depuis les données inline du script",
    );
  }

  // 1. Import Animé
  await db.collection("animes").doc("one-piece").set(animeData, { merge: true });
  console.log("✅ Animé One Piece importé");

  // 2. Import Créateur
  await db.collection("creators").doc("eiichiro-oda").set(creatorData, { merge: true });
  console.log("✅ Créateur Eiichiro Oda importé");

  // 3. Import Studio
  await db.collection("studios").doc("toei-animation").set(studioData, { merge: true });
  console.log("✅ Studio Toei Animation importé");

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
    title: "🌊 One Piece débarque sur OTADEX !",
    body: "15 personnages One Piece viennent d'être ajoutés — Luffy, Zoro, Sanji et plus !",
    route: "/anime/one-piece",
    type: "new_characters",
  });

  console.log("\n🏴‍☠️ Import One Piece terminé avec succès !");
  console.log("📊 Résumé :");
  console.log("   1 animé | 1 créateur | 1 studio");
  console.log(`   ${characters.length} personnages | ${quizzes.length} quiz`);
  process.exit(0);
}

importOnePiece().catch((err) => {
  console.error("❌ Erreur import :", err);
  process.exit(1);
});
