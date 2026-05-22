/**
 * OTADEX — Import NS (Naruto Shippuden) vers Firestore
 * Usage : node scripts/import_ns.js
 * Prérequis : npm install mammoth firebase-admin (à la racine du projet)
 */

const admin = require("firebase-admin");
const path = require("path");

const serviceAccount = require("../serviceAccountkey.json");
console.log("............................................");

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

const animeData = {
  "id": "naruto-shippuden",
  "titre": "Naruto Shippuden",
  "titreJaponais": "ナルト疾風伝",
  "synopsis": "Naruto Uzumaki, désormais adolescent, revient après deux ans et demi d'entraînement avec Jiraiya. Avec l'Équipe 7 et d'autres alliés, il poursuit son rêve de devenir Hokage tout en protégeant le monde des menaces de l'organisation criminelle Akatsuki.",
  "genres": [
    "Shōnen",
    "Action",
    "Aventure",
    "Arts martiaux",
    "Surnaturel"
  ],
  "annee": 2007,
  "episodes": {
    "total": 500,
},
  "studio": "Studio Pierrot",
  "studioId": "studio-pierrot",
  "auteur": "Masashi Kishimoto",
  "auteurId": "masashi-kishimoto",
  "editeur": "Shueisha — Weekly Shōnen Jump",
  "editeurVF": "Kana",
  "copiesVendues": "Plus de 250 millions de copies",
  "statut": "Terminé",
  "coverImage": "",
  "bannerImage": "",
  "type": "manga_adapte",
};

const creatorData = {
  "id": "masashi-kishimoto",
  "nom": "Masashi Kishimoto",
  "nomJaponais": "岸本 斉史",
  "bio": "Masashi Kishimoto est un mangaka japonais principalement connu pour être l'auteur du manga Naruto. Né le 8 novembre 1974, il a développé une passion pour le dessin dès son plus jeune âge. Son œuvre Naruto est devenue l'un des mangas les plus vendus au monde.",
  "dateNaissance": "8 novembre 1974",
  "lieuNaissance": "Préfecture d'Okayama, Japon",
  "nationalite": "Japonais",
  "imageUrl": "",
  "occupation": "Mangaka",
  "oeuvres": [
    {
      "titre": "Karakuri",
      "annee": 1996,
      "type": "One-shot",
},
    {
      "titre": "Naruto",
      "annee": 1999,
      "type": "Manga",
},
    {
      "titre": "Boruto",
      "annee": 2016,
      "type": "Manga (Supervision/Scénario)",
}
  ],
  "recompenses": [
    "Prix Hope Step (1995)",
    "Quill Award - Meilleur Manga Shōnen (2006)"
  ],
  "influences": [
    "Akira Toriyama",
    "Katsuhiro Otomo"
  ],
  "animeIds": [
    "naruto-shippuden"
  ],
};

const studioData = {
  "id": "studio-pierrot",
  "nom": "Studio Pierrot",
  "nomComplet": "株式会社ぴえろ",
  "fondation": 1979,
  "fondateur": "Yūji Nunokawa",
  "siege": "Tokyo, Japon",
  "description": "Studio d'animation japonais réputé pour avoir produit certaines des séries animées les plus populaires et les plus longues de l'histoire, notamment Naruto, Bleach et Black Clover.",
  "productions": [
    "Naruto",
    "Naruto Shippuden",
    "Bleach",
    "Black Clover",
    "Tokyo Ghoul"
  ],
  "animeIds": [
    "naruto-shippuden"
  ],
  "logoUrl": "",
};

const characters = [
  {
    "id": "ns-minato-namikaze",
    "nom": "Minato Namikaze",
    "nomJaponais": "波風ミナト",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "24 ans (mort — flashbacks Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "25 janvier",
    "nationalite": "Japonais fictif — Konoha (Village Caché des Feuilles)",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Minato Namikaze, surnommé le \"Konoha no Kiiroi Senkō\" (L'Éclair Jaune de Konoha), est le Quatrième Hokage du Village Caché des Feuilles, père de Naruto Uzumaki et époux de Kushina Uzumaki. Considéré comme le ninja le plus rapide de l'histoire, il sacrifia sa vie lors de l'Attaque du Démon Renard à Neuf Queues pour sceller la bête dans son fils nouveau-né, espérant que Naruto serait traité en héros. Génie absolu — académie à 10 ans, mission ANBU à 13 ans —, il devint le disciple de Jiraiya et monta rapidement les échelons. Sur le champ de bataille de la 3e Grande Guerre Ninja, sa réputation était telle que Kumo et Iwa lui offrirent d'énormes primes, car il anéantissait des bataillons entiers seul. Premier du sondage mondial NARUTOP99 avec 4,6 millions de votes — le personnage le plus aimé de toute la franchise.",
    "pouvoirs": [
      "Hiraishin no Jutsu (Éclair de Feu Volant) — téléportation instantanée via des sceaux marqués, lui valant son surnom. Vitesse impossible à suivre même pour des ninjas d'élite",
      "Rasengan — technique de la sphère d'énergie tournoyante qu'il a lui-même inventée après 3 ans de développement, enseignée à Naruto et Jiraiya",
      "Fūinjutsu (Sceaux Ninjas) de niveau légendaire — a créé le Sceau des Huit Trigrammes pour emprisonner le Kyūbi",
      "Senjutsu (Mode Ermite) — maîtrise partielle du chakra naturel",
      "Vitesse surhumaine — insaisissable même sans Hiraishin",
      "Intelligence tactique hors pair — a retourné des batailles entières seul durant la 3e Guerre Ninja"
    ],
    "voixJaponaise": "Toshiyuki Morikawa",
    "voixAnglaise": "Tony Oliver",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🏆 N°1 mondial du sondage NARUTOP99 (2023) avec 4,6 millions de votes — récompensé par un one-shot spécial de Kishimoto",
      "⚡ Sa technique Hiraishin était si redoutée que les armées ennemies avaient pour consigne de fuir dès qu'elles le repéraient",
      "📚 Kishimoto a révélé que Minato était difficile à représenter dans les combats en raison de sa vitesse extraordinaire"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Minato Namikaze/ns_mina1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 1},
  {
    "id": "ns-itachi-uchiha",
    "nom": "Itachi Uchiha",
    "nomJaponais": "うちはイタチ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "21 ans (Part 2 / Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "9 juin",
    "nationalite": "Japonais fictif — Konoha / Akatsuki",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Itachi Uchiha est le personnage le plus tragique et complexe de Naruto Shippuden. Génie précoce — admis à l'Académie à 7 ans, Chunin à 10 ans, capitaine ANBU à 13 ans —, il massacra son clan sur ordre des dirigeants de Konoha pour prévenir un coup d'état. Il épargna son frère cadet Sasuke, lui cachant la vérité et endossant le rôle du monstre pour lui donner une raison de vivre et grandir. Membre de l'Akatsuki pour surveiller l'organisation de l'intérieur, il mourut de maladie lors de son duel contre Sasuke sans jamais lui révéler ses motivations. Sa mort dévoila la vérité bouleversante : Itachi avait tout sacrifié par amour pour son village et son frère. Kishimoto a déclaré qu'il est l'un de ses personnages favoris à écrire pour la complexité de sa dualité.",
    "pouvoirs": [
      "Sharingan (3 tomoe) — copie de toute technique visuelle et lecture des intentions adverses",
      "Mangekyō Sharingan — éveillé après la mort de Shisui Uchiha (son mentor)",
      "Tsukuyomi — genjutsu absolu de l'œil de lune : inflige l'équivalent de 72 heures de torture mentale en quelques secondes",
      "Amaterasu — flammes noires inextinguibles brûlant tout, invoquées par l'œil gauche",
      "Susanoo complet armé de l'Épée de Totsuka (emprisonnement éternel) et du Miroir de Yata (défense absolue)",
      "Izanami — genjutsu absolu sans contact visuel, réinitialisant indéfiniment la même séquence",
      "Maîtrise complète du Ninjutsu, Genjutsu et Taijutsu"
    ],
    "voixJaponaise": "Hideo Ishikawa (adulte) / Yuka Terasaki (enfant)",
    "voixAnglaise": "Crispin Freeman",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🌍 N°2 du sondage NARUTOP99 (2023) — 1er dans les 4e et 5e sondages officiels WSJ du vivant de la série",
      "😢 Kishimoto a déclaré regretter de ne pas avoir développé davantage Itachi avant sa mort narrative",
      "🦅 Son partenaire Akatsuki Kisame l'appelait \"le plus gentil des membres de l'Akatsuki\"",
      "🔴 Souffrait d'une maladie (micopsia) qui minait lentement ses yeux et sa santé depuis des années"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Itachi Uchiha/ns_itac1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 2},
  {
    "id": "ns-sakura-haruno",
    "nom": "Sakura Haruno",
    "nomJaponais": "春野サクラ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "15–17 ans (Shippuden)",
    "sexe": "Féminin",
    "dateNaissance": "28 mars",
    "nationalite": "Japonaise fictive — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Sakura Haruno est la troisième membre de l'Équipe 7 et l'élève principale de Tsunade. Dans Naruto Shippuden, elle opère la transformation la plus radicale de la série : d'une élève à intelligence supérieure mais force limitée, elle devient une kunoichi de niveau Jonin supérieur, experte médicale et combattante physique de premier plan. Sa maîtrise parfaite du chakra — reconnue comme la meilleure du groupe des protagonistes — lui permet de concentrer une puissance dévastatrice dans ses frappes physiques. Son classement surprise en 3e position au sondage NARUTOP99 a stupéfié jusqu'à Kishimoto lui-même, qui a reconnu avoir eu du mal à écrire ses personnages féminins et a exprimé ses regrets publiquement.",
    "pouvoirs": [
      "Contrôle parfait du chakra — le plus précis parmi tous les protagonistes principaux",
      "Force physique surhumaine (chakra concentré dans les poings) — soulève des rochers, détruit le terrain",
      "Techniques médicales avancées : guérison instantanée, extraction de chakra ennemi, antidotes complexes",
      "Ōkashō (Cerise des Cent) : frappe dévastatrice libérant le chakra stocké dans le front en une explosion unique",
      "Byakugō no Jutsu (Sceau de Force Centuplée) : réserve de chakra accumulée pendant des années — régénération continue et puissance décuplée",
      "Contre-poison et analyse chimique au niveau expert"
    ],
    "voixJaponaise": "Chie Nakamura",
    "voixAnglaise": "Kate Higgins",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "😲 Classée 3e au sondage NARUTOP99 (2023) — résultat qui a surpris Kishimoto lui-même, qui a exprimé ses regrets de ne pas avoir mieux écrit ses personnages féminins",
      "🩺 Surpasse Tsunade dans plusieurs techniques médicales à la fin de la série selon les databooks",
      "💪 Son poing est considéré comme l'un des plus dévastateurs de toute la franchise"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Sakura Haruno/ns_saku1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 3},
  {
    "id": "ns-naruto-uzumaki",
    "nom": "Naruto Uzumaki",
    "nomJaponais": "うずまきナルト",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "15–17 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "10 octobre",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Naruto Uzumaki est le protagoniste central de la franchise et l'une des icônes les plus reconnaissables du manga mondial. Orphelin de guerre, rejeté par tout son village à cause du Démon Renard à Neuf Queues scellé en lui, il grandit seul avec pour seul rêve de devenir Hokage et d'être reconnu. Dans Shippuden, il revient après deux ans et demi d'entraînement avec Jiraiya, physiquement transformé. Son parcours — de paria solitaire à héros qui unifie les nations ninjas et incarne la paix de Naruto — est l'un des arcs narratifs les plus longs et les plus marquants du shōnen. Fils de Minato Namikaze (4e Hokage) et de Kushina Uzumaki, il réalise son rêve en devenant le 7e Hokage. Son prénom \"Naruto\" signifie \"tourbillon\" en japonais, symbole de Konoha. La scène de la rencontre avec Minato dans le mode Bijū est l'une des plus pleurées de la série.",
    "pouvoirs": [
      "Kage Bunshin no Jutsu — technique signature créant des centaines de clones réels qui peuvent combattre et apprendre simultanément",
      "Rasengan &amp; variantes : Rasenshuriken (vent), Giant Rasengan, Wind Release Rasengan",
      "Mode Ermite (Sage Mode) : chakra naturel amplifié — perception totale de l'environnement sans mouvement",
      "Mode Chakra des Neuf Queues (Kyūbi Chakra Mode) : armure de chakra rouge et puissance colossale",
      "Mode Kurama Complet : fusion totale avec Kurama (Shippuden tardif)",
      "Six Paths Sage Mode (arc final) : fusion avec les pouvoirs du Sage des Six Voies — suprême puissance",
      "Résistance extraordinaire — peut combattre avec des blessures mortelles grâce au chakra de Kurama"
    ],
    "voixJaponaise": "Junko Takeuchi",
    "voixAnglaise": "Maile Flanagan",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🍜 L'amour de Naruto pour le ramen miso est inspiré de la passion de Kishimoto lui-même pour les ramen",
      "🌀 \"Uzumaki\" signifie \"spirale\" en japonais — symbole central de Konoha",
      "📊 6e au sondage NARUTOP99 (2023) — 1er au 6e sondage officiel WSJ (2011)",
      "👶 Kishimoto a décidé de faire rencontrer Naruto ses parents après sa propre expérience de la paternité"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Naruto Uzumaki/ns_naru1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 4},
  {
    "id": "ns-kakashi-hatake",
    "nom": "Kakashi Hatake",
    "nomJaponais": "はたけカカシ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "29–31 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "15 septembre",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Kakashi Hatake, surnommé \"Kakashi le Copieur\" et \"Le Ninja aux Mille Techniques\", est le Jonin chef de l'Équipe 7 et l'un des ninjas les plus respectés de Konoha. Orphelin de guerre — son père Sakumo s'est suicidé sous le poids de la honte sociale après avoir choisi ses coéquipiers plutôt que sa mission —, il devint un enfant prodige. Son Sharingan, hérité de son ami d'enfance Obito Uchiha mourant sur un champ de bataille, lui permet de copier n'importe quelle technique adverse. Derrière sa nonchalance perpétuelle et sa lecture d'Icha Icha Paradise se cachent un guerrier endurci par les pertes et un sensei profondément attaché à ses élèves. Premier des 1er, 2e et 3e sondages officiels WSJ. Il devient le 6e Hokage après la 4e Grande Guerre Ninja. Son visage sous le masque, resté l'un des plus grands mystères de la franchise pendant 15 ans, fut révélé dans un OAV spécial de 2015.",
    "pouvoirs": [
      "Sharingan (Œil hérité d'Obito) — copie de toute technique observable, plus de 1 000 jutsu mémorisés",
      "Raikiri / Chidori — lame de foudre concentrée dans la main, sa technique signature créée par lui-même",
      "Mangekyō Sharingan : Kamui — téléportation et extraction dimensionnelle (post-arc Pein)",
      "Maîtrise des 5 natures de chakra",
      "Techniques de barrières et sceaux avancés",
      "Combat Taijutsu de niveau Jonin d'élite"
    ],
    "voixJaponaise": "Kazuhiko Inoue",
    "voixAnglaise": "Dave Wittenberg / Kyle Hebert",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "👁️ N°5 au NARUTOP99 (2023) — N°1 des sondages officiels WSJ pendant les 3 premières années",
      "📚 Fan de la série de romans adultes \"Icha Icha Paradise\" d'un bout à l'autre de la série",
      "🎭 Son visage sous le masque a été révélé dans un OAV spécial de 2015 — 15 ans après le début de la série",
      "🏛️ Devient le 6e Hokage après la guerre, puis cède le poste à Naruto"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Kakashi Hatake/ns_kaka1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 5},
  {
    "id": "ns-sasuke-uchiha",
    "nom": "Sasuke Uchiha",
    "nomJaponais": "うちはサスケ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "15–17 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "23 juillet",
    "nationalite": "Japonais fictif — Konoha / Errant",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Sasuke Uchiha est le rival et meilleur ami de Naruto et l'un des personnages les plus complexes de la franchise. Seul survivant du massacre de son clan (orchestré par Itachi sur ordre de Konoha), il est animé par une unique obsession : la vengeance. Dans Shippuden, son arc se radicalise — il rejoint Orochimaru pour un entraînement intensif, puis retourne sa haine contre Konoha entière après avoir appris la vérité sur Itachi. Personnage tiraillé entre lumière et obscurité, il constitue l'un des antagonistes/protagonistes les plus fascinants du shōnen. Son arc de rédemption dans les derniers chapitres, concluant avec son duel final contre Naruto à la Vallée de la Fin, est salué comme l'un des meilleurs dénouements de personnage du genre.",
    "pouvoirs": [
      "Sharingan (3 tomoe) → Mangekyō Sharingan → Rinnegan (arc final)",
      "Amaterasu — flammes noires inextinguibles invoquées par l'œil gauche",
      "Susanoo complet — armure spectrale colossale en forme de démon",
      "Kirin — technique de foudre naturelle, l'une des plus destructrices de la série",
      "Chidori / Raikiri et variantes (Chidori Senbon, Chidori Sharp Spear)",
      "Maîtrise du feu (Katon) — techniques héréditaires Uchiha",
      "Cursed Mark niveau 2 — transformation via le sceau d'Orochimaru (arc antérieur)"
    ],
    "voixJaponaise": "Noriaki Sugiyama",
    "voixAnglaise": "Yuri Lowenthal",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "📊 8e au sondage NARUTOP99 (2023) — régulièrement 2e derrière Naruto dans les sondages officiels",
      "🔴 Son arc de rédemption dans les arcs finaux est considéré comme l'un des meilleurs du shōnen",
      "⚔️ Son duel final avec Naruto à la Vallée de la Fin (ch. 698–699) est la conclusion en 2 chapitres de 15 ans de relation fraternelle"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Sasuke Uchiha/ns_sasu1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 6},
  {
    "id": "ns-jiraiya",
    "nom": "Jiraiya",
    "nomJaponais": "自来也",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "54 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "11 novembre",
    "nationalite": "Japonais fictif — Konoha / Ermite voyageur",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Jiraiya, surnommé \"L'Ermite des Crapauds\" (Gama Sennin) et \"Le Grand Sage Jiraiya\", est l'un des Trois Sannins Légendaires et le mentor de Naruto. Auteur de romans adultes sous le pseudonyme \"L'Ermite Gallant\", il cache derrière son exubérance et sa réputation de perversité un ninja d'une puissance et d'une sagesse rares. Ancien maître de Minato Namikaze (4e Hokage), il forma également Nagato, Yahiko et Konan à Amegakure dans leur jeunesse — croyant qu'ils accompliraient la prophétie du \"ninja qui changerait le monde\". Sa mort aux mains de Pain (son ancien élève) lors de leur affrontement à Amegakure est considérée comme l'une des morts les plus marquantes de l'histoire du manga shōnen. Kishimoto a déclaré regretter de l'avoir dû tuer pour les besoins de la narration.",
    "pouvoirs": [
      "Mode Ermite complet (Sage Mode) — fusion du chakra naturel, amplification massive de toutes les capacités",
      "Invocation des Crapauds — dont Gamabunta (boss crapaud géant) et les crapauds de Mont Myōboku",
      "Techniques de cheveux maudits (Needle Jizo) — utilise ses longs cheveux comme armure et arme",
      "Rasengan — technique transmise par Minato, enseignée à Naruto",
      "Fūinjutsu (Sceaux Ninjas) avancé — notamment Goemon et sceaux de scellement",
      "Feu — Huile de Crapaud : crachement d'huile enflammée combinable"
    ],
    "voixJaponaise": "Hōchū Ōtsuka",
    "voixAnglaise": "David Lodge",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "💔 12e au NARUTOP99 (2023) — Sa mort (arc Pain) est régulièrement citée comme la mort la plus marquante de l'histoire du shōnen moderne",
      "📖 Auteur de \"Icha Icha Paradise\" — la série de romans qu'il écrit et que Kakashi lit systématiquement",
      "🐸 Kishimoto a déclaré : \"Jiraiya est le personnage que j'aurais le plus de mal à tuer — mais la narration l'exigeait\""
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Jiraiya/ns_jira1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 7},
  {
    "id": "ns-gaara",
    "nom": "Gaara",
    "nomJaponais": "我愛羅",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "17–18 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "19 janvier",
    "nationalite": "Japonais fictif — Suna (Village Caché du Sable)",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Gaara est le 5e Kazekage du Village Caché du Sable et l'un des arcs de rédemption les plus puissants de Naruto. Jinchūriki du démon Shukaku (Queue-Un), rejeté dès sa naissance — son propre père (4e Kazekage) ordonna son assassinat à plusieurs reprises car son chakra de bête à queue déstabilisait le sceau —, il devint un être assoiffé de sang, ne vivant que pour tuer afin de \"sentir qu'il existe\". Le symbole 愛 (Ai = \"Amour\") tatouéé sur son propre front symbolise sa solitude absolue. Sa rencontre avec Naruto — qui lui montre que la vraie force vient de la protection des autres — le transforme radicalement. Il passe de monstre solitaire à dirigeant respecté qui unit les nations contre Madara.",
    "pouvoirs": [
      "Contrôle absolu du sable — arme, défense, armure, cage à portée quasi illimitée",
      "Bouclier de Sable (réflexe automatique de défense) — quasi-invulnérabilité passive",
      "Desert Coffin + Desert Funeral — immobilisation puis écrasement par compression sablière",
      "Armure de Sable — enveloppe corporelle de protection renforcée",
      "Ultimate Defense (Sable + Chakra Shukaku) — bouclier multi-couche",
      "Post-extraction du Shukaku : Sable Magnétique (Jinton) héritée de son père le 4e Kazekage",
      "Contrôle de son propre chakra de bête à queue et invocation partielle de Shukaku (arc final)"
    ],
    "voixJaponaise": "Akira Ishida",
    "voixAnglaise": "Liam O'Brien",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "❤️ Le symbole \"Ai\" (愛 — Amour) tatoué sur son front a été gravé par lui-même comme marque de sa solitude absolue",
      "🏔️ Son arc de rédemption est cité par Kishimoto comme l'un de ses arcs préférés à avoir écrits",
      "🌍 Toujours dans le Top 10 de tous les sondages officiels depuis la Partie 1"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Gaara/ns_gaar1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 8},
  {
    "id": "ns-hinata-hyuga",
    "nom": "Hinata Hyuga",
    "nomJaponais": "日向ヒナタ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "15–16 ans (Shippuden)",
    "sexe": "Féminin",
    "dateNaissance": "27 décembre",
    "nationalite": "Japonaise fictive — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Hinata Hyuga est l'héritière de la branche principale du clan Hyuga, l'un des plus puissants de Konoha. Timide, introvertie, déclassée par son propre père (Hiashi) qui la jugea trop faible pour l'héritage familial, elle puisa toute sa motivation dans son amour silencieux pour Naruto Uzumaki. Dans Shippuden, elle s'affirme progressivement comme une combattante redoutable, culminant lors de l'arc Pain : elle s'interpose seule entre Naruto et Pain alors que ce dernier le domine, sachant qu'elle ne peut pas gagner. Ce courage absolu est l'un des moments les plus forts de la série. Elle épouse finalement Naruto et devient la mère de Boruto et Himawari.",
    "pouvoirs": [
      "Byakugan — vision à 360° (angle mort minimal de 2°), vision à travers les obstacles, perception du réseau chakra interne",
      "Jyūken (Poing Doux) — frappe directe sur les tenketsu (points chakra), désactivant les flux d'énergie adverses",
      "Rotation Douce — bouclier sphérique de rotation chakra centrifuge",
      "Twin Lion Fists — attaque concentrant le chakra en deux griffes de lion spectral",
      "Gentle Step Twin Lion Fists — version améliorée combinant Byakugan et chakra offensif maximal"
    ],
    "voixJaponaise": "Nana Mizuki",
    "voixAnglaise": "Stephanie Sheh",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "💜 10e au NARUTOP99 (2023) — 3e dans plusieurs zones géographiques (Asie du Sud-Est)",
      "😭 Son intervention pour défendre Naruto contre Pain (épisode 166) est régulièrement dans les tops des moments les plus émouvants de la série",
      "🎤 Sa doubleuse Nana Mizuki est l'une des chanteuses d'anime les plus populaires du Japon"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Hinata Hyuga/ns_hina1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 9},
  {
    "id": "ns-pain",
    "nom": "Pain",
    "nomJaponais": "長門うずまき",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "35 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "19 septembre",
    "nationalite": "Japonais fictif — Amegakure (Village de la Pluie)",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Nagato Uzumaki, alias Pain, est le chef de l'Akatsuki et l'antagoniste principal de l'arc \"Invasion de Konoha\" — l'un des arcs les plus acclamés de la franchise. Descendant du clan Uzumaki porteur des Rinnegan (les yeux les plus puissants du monde ninja), il fut l'élève de Jiraiya avec Yahiko et Konan à Amegakure. Après la mort tragique de Yahiko, Nagato sombra dans la douleur et utilisa le corps de son ami comme \"Pain Deva\" — son dieu visible. Sa philosophie — infliger une douleur si grande qu'elle crée un pacte de paix universel — est un miroir déformé de celle de Naruto selon Kishimoto. Il se rachète finalement en ressuscitant toutes ses victimes de l'invasion de Konoha, puis meurt. L'arc Pain est régulièrement classé parmi les meilleurs arcs de tout le shōnen moderne.",
    "pouvoirs": [
      "Rinnegan — les yeux les plus puissants du monde ninja, maîtrise des Six Voies",
      "Six Corps de Pain — six cadavres aux Rinnegan contrôlés à distance depuis son fauteuil, chacun maîtrisant un pouvoir unique (Deva, Asura, Human, Animal, Hungry Ghost, Hell Path)",
      "Shinra Tensei (Deva Path) — répulsion gravitationnelle absolue ayant détruit Konoha entièrement",
      "Bansho Ten'in — attraction gravitationnelle",
      "Chibaku Tensei — création d'une sphère gravitationnelle géante piégeant tout, y compris Kurama",
      "Ressuscitation des morts (Hell Path) — utilisé pour racheter toutes ses victimes de Konoha"
    ],
    "voixJaponaise": "Ken'yu Horiuchi (Pain) / Junpei Morita (Nagato)",
    "voixAnglaise": "Troy Baker",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "💥 La destruction totale de Konoha (épisodes 163–169) est considérée comme l'un des moments les plus épiques de l'histoire de l'animation japonaise",
      "🕊️ Sa rédemption finale persuadée par Naruto est jugée l'un des meilleurs retournements narratifs de la série",
      "🌧️ Le symbole de la pluie qui ne cesse jamais sur Amegakure est une métaphore de ses larmes permanentes selon Kishimoto"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Pain/ns_pain1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 10},
  {
    "id": "ns-madara-uchiha",
    "nom": "Madara Uchiha",
    "nomJaponais": "うちはマダラ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "Décédé depuis des décennies — ressuscité par Edo Tensei",
    "sexe": "Masculin",
    "dateNaissance": "24 décembre",
    "nationalite": "Japonais fictif — Konoha (co-fondateur)",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Madara Uchiha est le leader légendaire du clan Uchiha et l'antagoniste final de Naruto Shippuden. Co-fondateur de Konoha aux côtés de son rival et ami d'enfance Hashirama Senju, il brisa leur alliance quand les deux ne purent s'accorder sur la vision de la paix. Il ourdit alors le \"Plan de l'Œil de la Lune\" pour projeter un genjutsu universel (Tsukuyomi Infini) sur toute l'humanité, croyant que l'illusion d'un monde parfait était préférable à la réalité de la guerre. Transmettant son plan à Obito après sa mort apparente, il fut ressuscité par Edo Tensei lors de la 4e Guerre Ninja. La révélation que Black Zetsu — qu'il croyait être sa création — était en réalité au service de Kaguya Ōtsutsuki fut le twist le plus dévastateur de la saga.",
    "pouvoirs": [
      "Sharingan → Mangekyō Sharingan → Rinnegan (les deux en simultané)",
      "Susanoo ultime (armure humanöide spectrale complète de taille colossale)",
      "Limbes — corps spectraux invisibles aux Rinnegan ordinaires",
      "Feu (Katon) — techniques héréditaires portées au niveau ultime",
      "Wood Release (Mokuton) hérité des cellules de Hashirama implantées",
      "Chibaku Tensei amélioré — Six Paths Chibaku Tensei",
      "Tsukuyomi Infini (Infinite Tsukuyomi) — illusion planétaire finale",
      "Hôte du Jūbi — fusion avec la Bête à Dix Queues"
    ],
    "voixJaponaise": "Naoya Uchida",
    "voixAnglaise": "Neil Kaplan",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🌕 Son plan du Tsukuyomi Infini est l'arc narratif le plus ambitieux de toute la série",
      "😮 La révélation que Black Zetsu le manipulait lui-même est considérée comme le plus grand twist de Naruto Shippuden",
      "7e au sondage NARUTOP99 (2023)"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Madara Uchiha/ns_mada1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 11},
  {
    "id": "ns-obito-uchiha",
    "nom": "Obito Uchiha",
    "nomJaponais": "うちはオビト",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "31 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "10 février",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Obito Uchiha est l'antagoniste central de Naruto Shippuden, longtemps dissimulé derrière l'alias \"Tobi\" puis \"Madara\". Ancien coéquipier de Kakashi et Rin Nohara sous la direction de Minato, il fut présumé mort lors de la 3e Guerre Ninja après avoir sauvé Kakashi d'un éboulement. Récupéré et manipulé par Madara, il perdit sa foi en l'humanité quand Rin — la fille qu'il aimait — fut tuée par Kakashi (forcé de le faire pour empêcher la libération du Bijū qui était scellé en elle). Persuadé que la réalité ne peut qu'amener la douleur, il adopta le plan de Madara. Son arc de rédemption à la fin de la guerre, où il choisit de mourir pour protéger Naruto, est l'un des retournements de personnage les plus forts de la série.",
    "pouvoirs": [
      "Kamui (Mangekyō Sharingan) — téléportation et intangibilité dans une dimension parallèle",
      "Sharingan → Rinnegan (grâce à l'œil de Nagato)",
      "Six Paths Jutsu (via les Six Corps de Pain contrôlés)",
      "Wood Release (Mokuton) — par implants de cellules de Hashirama sur sa moitié droite",
      "Corps semi-intangible — côté droit composé de cellules de Hashirama",
      "Contrôle de la Bête à Dix Queues (hôte temporaire)"
    ],
    "voixJaponaise": "Wataru Takagi (adulte) / Megumi Han (enfant)",
    "voixAnglaise": "Michael Yurchak",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "😢 La mort de Rin Nohara (tuée par Kakashi forcé par les circonstances) est le traumatisme central qui a brisé Obito",
      "🌸 Avant sa chute, Obito rêvait de devenir Hokage — citation : \"ceux qui abandonnent leurs camarades sont pires que des déchets\"",
      "11e au sondage NARUTOP99 (2023)"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Obito Uchiha/ns_obit1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 12},
  {
    "id": "ns-hashirama-senju",
    "nom": "Hashirama Senju",
    "nomJaponais": "千手柱間",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "Décédé (ressuscité par Edo Tensei)",
    "sexe": "Masculin",
    "dateNaissance": "23 octobre",
    "nationalite": "Japonais fictif — Co-fondateur de Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Hashirama Senju est le 1er Hokage de Konoha et le \"Dieu des Shinobi\". Co-fondateur du village avec Madara Uchiha, son rival et ami d'enfance, il possédait une puissance sans égale grâce à sa Libération du Bois (Mokuton) — une kekkei genkai si rare qu'elle ne se reproduira plus jamais naturellement. Sa vision de paix entre les clans fut la fondation du système des villages ninjas. Madara lui-même reconnut que Hashirama était le seul adversaire qui l'avait jamais dépassé. Sa résurrection par Edo Tensei lors de la 4e Guerre Ninja permet à Naruto et aux spectateurs de découvrir la profondeur de son personnage.",
    "pouvoirs": [
      "Mokuton (Libération du Bois) — kekkei genkai unique permettant de créer et contrôler la végétation en combat",
      "Hashirama Cell — ses cellules sont les plus précieuses du monde ninja, capables d'amplifier les pouvoirs des autres",
      "Maîtrise des Bijū — peut contrôler les Bêtes à Queue sans Rinnegan",
      "Sage Mode des Forêts — variante unique du chakra naturel",
      "Réserves de chakra astronomiques — surpassant toute comparaison de son époque"
    ],
    "voixJaponaise": "Takayuki Sugo",
    "voixAnglaise": "Jamieson Price",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "⚡ Madara a déclaré qu'Hashirama était le seul être qui l'avait jamais surpassé",
      "14e au sondage NARUTOP99 (2023)",
      "🌳 Ses cellules sont utilisées par Kabuto, Madara, Obito et Danzō — preuve de leur valeur extraordinaire"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Hashirama Senju/ns_hash1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 13},
  {
    "id": "ns-shikamaru-nara",
    "nom": "Shikamaru Nara",
    "nomJaponais": "奈良シカマル",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "15–17 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "22 septembre",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Shikamaru Nara est le membre le plus intelligent de la génération de Naruto, avec un QI dépassant 200 selon les databooks. Premier Genin à devenir Chunin parmi le groupe des protagonistes, il est connu pour sa paresse affichée (\"quel fardeau\") qui cache un stratège militaire d'exception. Son duel contre Hidan (membre immortel de l'Akatsuki) après la mort de son maître Asuma est l'un des sommets de la série — il le bat avec un plan d'une intelligence diabolique. Dans Boruto, il devient le conseiller principal et bras droit de Naruto (7e Hokage), puis assume lui-même le rôle de Hokage temporaire lors de la disparition de Naruto.",
    "pouvoirs": [
      "Kagemane no Jutsu (Technique de l'Ombre Captive) — fusionne son ombre avec celle des cibles, les forçant à mimer ses mouvements",
      "Kageyose no Jutsu — extension de portée de l'ombre",
      "Kage Nui (Couture d'Ombre) — technique offensive transpercant les cibles avec des fils d'ombre",
      "Kage Kubishibari — strangulation par ombre",
      "QI de 200+ — stratégie militaire en temps réel, lecture des adversaires à plusieurs coups d'avance"
    ],
    "voixJaponaise": "Showtaro Morikubo",
    "voixAnglaise": "Tom Gibis",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🧠 QI de 200+ selon les databooks officiels — le personnage le plus intelligent de Konoha",
      "🎯 Son combat contre Hidan (immortel) est considéré comme l'un des plus brillants tactiquement de la série",
      "13e au sondage NARUTOP99 (2023)"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Shikamaru Nara/ns_shik1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 14},
  {
    "id": "ns-rock-lee",
    "nom": "Rock Lee",
    "nomJaponais": "ロック・リー",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "14–17 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "27 novembre",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Rock Lee est l'un des personnages les plus attachants et inspirants de Naruto. Incapable d'utiliser le ninjutsu ou le genjutsu en raison de sa constitution naturelle, il compensa ce handicap absolu par un travail acharné jusqu'à devenir un maître du Taijutsu pur. Son combat contre Gaara lors des examens Chunin — où il retire ses lesteurs de 9 kg chacun pour révéler une vitesse impossible à suivre — est l'un des moments les plus iconiques de toute la franchise. Il incarne le thème central de Naruto : le travail acharné peut surmonter le talent. Formé par Might Guy, son maître et père spirituel, il reproduit sa philosophie et son style de combat.",
    "pouvoirs": [
      "Taijutsu Pur de niveau Jonin supérieur — vitesse et force décuplées par entraînement intensif sans aucun jutsu",
      "Poids de Lestage — entraînement avec des poids extrêmement lourds, retrait = vitesse surhumaine explosive",
      "Huit Portes de la Mort — ouverture de 5–6 portes pour une puissance dépassant temporairement les Kage (au risque de sa vie)",
      "Lotus Primaire (Primary Lotus) — enveloppement de l'adversaire et frappe au sol à vitesse maximale",
      "Lotus d'Acier (Front Lotus) — version améliorée combinant vitesse maximale et force brute"
    ],
    "voixJaponaise": "Yoichi Masukawa",
    "voixAnglaise": "Brian Donovan",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "💪 Son combat contre Gaara (examens Chunin) est régulièrement dans le Top 5 des meilleurs combats de l'histoire du shōnen",
      "🚪 L'ouverture des Huit Portes de la Mort par son maître Guy lors de la 4e Guerre Ninja est l'un des moments les plus épiques de la série",
      "18e au sondage NARUTOP99 (2023)"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Rock Lee/ns_rock1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 15},
  {
    "id": "ns-neji-hyuga",
    "nom": "Neji Hyuga",
    "nomJaponais": "日向ネジ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "14–17 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "3 juillet",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Neji Hyuga est le génie du clan Hyuga, né dans la branche secondaire et portant le sceau maudit qui l'empêchait d'atteindre la branche principale. Sa philosophie initiale — \"le destin est immuable et les gens ne changent pas\" — fut brisée par Naruto lors de leur combat aux examens Chunin, où Naruto lui montra qu'on peut briser les chaînes du destin. Sa transformation de cynique amer en protecteur dévoué est l'un des arcs de personnage les plus réussis de la série. Sa mort lors de la 4e Grande Guerre Ninja — se sacrifiant pour protéger Naruto et Hinata — est l'une des plus dévastatrices pour les fans.",
    "pouvoirs": [
      "Byakugan — vision à 360° plus puissante que celle de Hinata, capable de voir les points chakra à grande distance",
      "Jyūken (Poing Doux) — frappe des tenketsu avec précision chirurgicale",
      "Grande Rotation (Kaiten) — rotation parfaite créant un bouclier sphérique de chakra",
      "64 Frappes Défensives — bloque 64 points chakra adverses en succession ultra-rapide",
      "128 Frappes Défensives — version améliorée doublée"
    ],
    "voixJaponaise": "Kōichi Tōchika",
    "voixAnglaise": "Steve Staley",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "💀 Sa mort lors de la 4e Guerre Ninja est parmi les plus dévastantes émotionnellement — il bloque des milliers de bois de Madara pour protéger Naruto et Hinata",
      "🔥 Son combat contre Naruto aux examens Chunin est l'un des plus emblématiques de la Partie 1"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Neji Hyuga/ns_neji1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 16},
  {
    "id": "ns-tsunade",
    "nom": "Tsunade",
    "nomJaponais": "綱手",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "54–55 ans (Shippuden)",
    "sexe": "Féminin",
    "dateNaissance": "2 août",
    "nationalite": "Japonaise fictive — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Tsunade est la 5e Hokage de Konoha et l'une des Trois Sannins Légendaires. Petite-fille du 1er Hokage Hashirama Senju, elle est reconnue comme la meilleure médecin ninja de tous les temps et comme une combattante physique d'une puissance colossale. Traumatisée par la mort de son petit-frère Nawaki et de son amour Dan Kato (tous deux morts à la guerre en portant son précieux collier hérité d'Hashirama), elle développa une aversion profonde pour le sang et s'exile pendant des années. C'est Naruto qui la convainc de reprendre le flambeau de Hokage et de croire à nouveau en la génération suivante.",
    "pouvoirs": [
      "Byakugō no Jutsu (Sceau du Centuple) — accumulation d'énergie chakra pendant des années stockée dans le front, libérée pour régénération continue",
      "Force physique surhumaine — la plus grande force physique brute de tout Konoha",
      "Techniques médicales de rang légendaire — seule à maîtriser la guérison des blessures mortelles",
      "Katsuyu — invocation de l'escargot géant boss permettant soins massifs à distance",
      "Formation de Sakura — a transmis son sceau du Centuple et ses techniques médicales"
    ],
    "voixJaponaise": "Masako Katsuki",
    "voixAnglaise": "Debi Mae West",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🃏 Joueuse invétérée et criblée de dettes — son surnom officieux est \"La Sucease Légendaire\"",
      "🏥 Reconnue comme la meilleure médecin ninja de l'histoire du monde ninja selon les databooks"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Tsunade/ns_tsun1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 17},
  {
    "id": "ns-might-guy",
    "nom": "Might Guy",
    "nomJaponais": "マイト・ガイ",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "30–31 ans (Shippuden)",
    "sexe": "Masculin",
    "dateNaissance": "1er janvier",
    "nationalite": "Japonais fictif — Konoha",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Might Guy est le maître de Rock Lee et l'un des personnages les plus charismatiques et aimés de Naruto. Lui-même incapable d'utiliser le chakra de façon efficace dans sa jeunesse, il s'est hissé au niveau de Jonin d'élite par pur Taijutsu — inspirant Rock Lee à faire de même. Sa rivalité avec Kakashi (600+ combats, score Guy 50 victoires contre 0 pour Kakashi) est l'une des meilleures bromances de l'histoire du shōnen. Son moment ultime arrive lors de la 4e Grande Guerre Ninja contre Madara : il ouvre la 8e Porte de la Mort, atteignant temporairement une puissance surpassant celle de Madara lui-même — au prix de sa vie. Madara lui-même le déclare \"le plus fort que j'aie affronté en tant qu'humain\".",
    "pouvoirs": [
      "Huit Portes de la Mort — maîtrise complète des 8 portes, dont la 8e (mort certaine à court terme)",
      "Asakujaku — attaque à la 7e Porte, coups si rapides qu'ils créent des illusions de flammes",
      "Hirudora (Midi Tiger) — coup de poing à la 7e Porte créant un tigre de vide d'air",
      "Hachimon Tonkō no Jin (Formation de la Mort) — 8e Porte : puissance dépassant temporairement tout",
      "Taijutsu de niveau légendaire — sans ninjutsu ni genjutsu"
    ],
    "voixJaponaise": "Masashi Ebara",
    "voixAnglaise": "Skip Stellrecht",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🔥 Madara Uchiha l'a déclaré \"le plus fort être humain qu'il ait jamais affronté\"",
      "💚 Sa combinaison verte et son sourcil épais sont parmi les designs les plus reconnaissables de toute la franchise",
      "🥊 Son père Duy ouvrit les Huit Portes pour sauver Guy enfant — inspirant toute sa carrière"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Might Guy/ns_migh1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 18},
  {
    "id": "ns-orochimaru",
    "nom": "Orochimaru",
    "nomJaponais": "大蛇丸",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "54–56 ans (Shippuden)",
    "sexe": "Masculin (corps changeant)",
    "dateNaissance": "27 octobre",
    "nationalite": "Japonais fictif — Konoha (déserteur)",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Orochimaru est l'un des Trois Sannins Légendaires et l'antagoniste central de la Partie 1, dont l'influence se poursuit dans Shippuden. Génie scientifique et ninja, il fut désigné comme successeur du 3e Hokage avant que ses expériences sur des humains vivants ne le contraignent à fuir. Sa quête de l'immortalité l'a conduit à développer des techniques de transplantation d'âme dans de nouveaux corps, lui permettant de ne jamais vieillir. Il est le premier à utiliser la Convocation du Mort (Edo Tensei) pour ressusciter les 1er et 2e Hokage. Dans Shippuden, il sert de maître à Sasuke puis disparaît, pour réapparaître dans les arcs tardifs avec une posture plus ambiguë.",
    "pouvoirs": [
      "Transplantation d'âme dans de nouveaux corps — quasi-immortalité",
      "Edo Tensei (Convocation du Mort) — ressuscite les morts avec une puissance maximale",
      "Techniques de serpents géants — invocation du grand serpent Manda",
      "Sceau Maudit (Juin-jutsu) — marque implantée sur les porteurs amplifiant leur chakra (Sasuke, Anko)",
      "Maîtrise de toutes les natures de chakra connues",
      "Résistance presque totale — peut régénérer depuis n'importe quel fragment de corps"
    ],
    "voixJaponaise": "Kujiraoka Hiroshi",
    "voixAnglaise": "Steve Blum",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🐍 Son corps reptilien et sa langue longue sont parmi les designs visuels les plus iconiques de Naruto",
      "⚗️ Créateur du Jutsu d'Immortalité par transplantation d'âme — a expérimenté sur des centaines de ninjas vivants"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Orochimaru/ns_oroc1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 19},
  {
    "id": "ns-konan",
    "nom": "Konan",
    "nomJaponais": "小南",
    "animeId": "naruto-shippuden",
    "animeName": "Naruto Shippuden",
    "auteurId": "masashi-kishimoto",
    "auteurNom": "Masashi Kishimoto",
    "studioId": "studio-pierrot",
    "studioNom": "Studio Pierrot",
    "age": "35 ans (Shippuden)",
    "sexe": "Féminin",
    "dateNaissance": "20 février",
    "nationalite": "Japonaise fictive — Amegakure",
    "statut": "Protagoniste",
    "rang": "Jonin",
    "description": "Konan est la seule femme parmi les membres fondateurs de l'Akatsuki et la partenaire de Nagato. Orpheline de guerre à Amegakure, elle forma avec Yahiko et Nagato le trio originel qui fut pris sous l'aile de Jiraiya. Après la mort de Yahiko et la chute de Nagato dans la douleur, elle demeura à ses côtés par amour et loyauté. Après la mort de Nagato (rachetée par Naruto), elle tente de garder la paix à Amegakure. Son duel contre Tobi (Obito) est l'un des combats les plus spectaculaires visuellement de toute la série — elle transforme 600 milliards de feuilles de papier en bombes pour tenter de le tuer.",
    "pouvoirs": [
      "Technique du Papier — contrôle total du papier comme arme, défense et outil",
      "Ange de Papier (Paper Person of God Technique) — transformation du corps entier en milliards de papillons de papier",
      "600 milliards de bombes de papier — son attaque ultime contre Tobi",
      "Vol via ailes de papier"
    ],
    "voixJaponaise": "Atsuko Tanaka",
    "voixAnglaise": "Dorothy Elias-Fahn",
    "relations": [],
    "citations": [
      "Je ne reviens jamais sur ma parole !"
    ],
    "trivia": [
      "🌸 Ses techniques de papier sont parmi les plus créatives visuellement de toute la franchise",
      "💔 Après la mort de Nagato, elle offrit à Naruto le livre de Jiraiya comme symbole d'espoir pour la paix",
      "Document confidentiel — Mai 2026 | © Masashi Kishimoto / Shūeisha — Studio Pierrot"
    ],
    "images": [
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona1.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona2.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona3.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona4.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona5.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona6.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona7.jpeg",
      "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona8.jpeg"
    ],
    "imagePath": "assets/images/Animé pictures/Naruto Shippuden/Konan/ns_kona1.jpeg",
    "likesCount": 0,
    "collectCount": 0,
    "popularityRank": 20}
];

async function importData() {
  try {
    console.log("🚀 Lancement de l'import : Naruto Shippuden");
    
    // Animé
    console.log("1. Importation de l'animé...");
    await db.collection("animes").doc(animeData.id).set({ ...animeData, created_at: FieldValue.serverTimestamp() }, { merge: true });
    console.log("✅ Animé importé !");

    // Créateur
    console.log("2. Importation du créateur...");
    await db.collection("creators").doc(creatorData.id).set({ ...creatorData, created_at: FieldValue.serverTimestamp() }, { merge: true });
    console.log("✅ Créateur importé !");

    // Studio
    console.log("3. Importation du studio...");
    await db.collection("studios").doc(studioData.id).set({ ...studioData, created_at: FieldValue.serverTimestamp() }, { merge: true });
    console.log("✅ Studio importé !");
    
    // Personnages
    console.log("4. Importation des personnages...");
    let batch = db.batch();
    for (const char of characters) {
      const docRef = db.collection("characters").doc(char.id);
      batch.set(docRef, { ...char, created_at: FieldValue.serverTimestamp() }, { merge: true });
    }
    await batch.commit();
    console.log("✅ Tous les personnages importés avec succès !");
    
    console.log("🎉 Importation terminée avec succès !");
    process.exit(0);
  } catch (error) {
    console.error("❌ Erreur pendant l'importation :", error);
    process.exit(1);
  }
}

importData();
