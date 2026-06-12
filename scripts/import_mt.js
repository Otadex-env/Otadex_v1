#!/usr/bin/env node
/**
 * import_mt.js — Import Mushoku Tensei dans Firestore
 *
 * Collections créées / mises à jour :
 *   animes/mushoku-tensei
 *   creators/rifujin-na-magonote
 *   studios/studio-bind
 *   characters/mt-{slug}          (20 personnages)
 *   quizzes/mt-{slug}             (7 personnages principaux, 5+ questions chacun)
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_mt.js
 */

'use strict';

const admin = require('firebase-admin');
const path  = require('path');
const fs    = require('fs');
const sendNotification = require('./send_notification');

const KEY = path.resolve(__dirname, '..', 'serviceAccountKey.json');
if (!fs.existsSync(KEY)) {
  console.error('❌  serviceAccountKey.json introuvable à la racine.');
  process.exit(1);
}

admin.initializeApp({ credential: admin.credential.cert(require(KEY)) });
const db   = admin.firestore();
const { FieldValue } = admin.firestore;

// ── Données ────────────────────────────────────────────────────────────────────

const creatorData = {
  nom:          'Rifujin na Magonote',
  nomJaponais:  '理不尽な孫の手',
  bio:          'Rifujin na Magonote est le pseudonyme d\'un romancier japonais né le 3 avril 1985 dans la préfecture de Gifu. Extrêmement discret sur sa vie privée, il porte systématiquement le casque d\'Orsted lors de ses apparitions publiques. Il commença à publier sur Shōsetsuka ni Narō en novembre 2012 avec Mushoku Tensei, qui atteignit la première place du classement combiné du site en moins d\'un an. La série principale se conclut en 2022 avec le 26e volume.',
  dateNaissance: '3 avril 1985',
  nationalite:  'Japonais',
  occupation:   'Romancier indépendant — web novel et light novel',
  oeuvres:      [
    'Mushoku Tensei (2012–2022)',
    'Orc Eroica (2019–présent)',
    'Manga Mushoku Tensei (adapté par Yuka Fujikawa, 2016–présent)',
  ],
  recompenses:  [
    'N°1 classement combiné Shōsetsuka ni Narō (Oct. 2013 – Fév. 2019)',
    'Anime de la Saison — Hiver 2021 (Crunchyroll & ANN)',
    'Meilleure œuvre isekai 2021 — unanimité presse anime',
  ],
  imageUrl:     '',
  animeIds:     ['mushoku-tensei'],
  created_at:   FieldValue.serverTimestamp(),
};

const studioData = {
  nom:          'Studio Bind',
  fondation:    'Créé spécifiquement pour l\'adaptation de Mushoku Tensei',
  fondateur:    'Non divulgué publiquement',
  description:  'Studio d\'animation japonais basé à Tokyo, fondé dans le but exclusif d\'adapter Mushoku Tensei : Jobless Reincarnation avec la plus haute fidélité au matériau source. Unanimement salué pour la qualité de son animation et la profondeur émotionnelle de ses productions.',
  productions:  [
    'Mushoku Tensei : Jobless Reincarnation — Saison 1 (2021, 23 épisodes)',
    'Mushoku Tensei : Jobless Reincarnation — Saison 2 (2023–2024, 25 épisodes)',
    'Mushoku Tensei : Jobless Reincarnation — Saison 3 (2026, en cours)',
    'Onimai: I\'m Now Your Sister! (2023)',
  ],
  animeIds:     ['mushoku-tensei'],
  created_at:   FieldValue.serverTimestamp(),
};

const animeData = {
  titre:        'Mushoku Tensei : Jobless Reincarnation',
  titreJaponais:'無職転生 〜異世界行ったら本気だす〜',
  synopsis:     'Un NEET japonais de 34 ans meurt renversé par un camion en tentant de sauver de jeunes lycéens. Il se réincarne dans un monde de fantasy médiévale avec l\'intégralité de ses souvenirs, résolu à vivre sans regrets. Né Rudeus Greyrat, il découvre un talent magique exceptionnel et commence une nouvelle vie ambitieuse. Considérée comme l\'œuvre fondatrice du genre isekai moderne, la série suit Rudeus de sa naissance jusqu\'à sa mort paisible à 74 ans.',
  genres:       ['Isekai', 'Fantasy', 'Tranche de vie', 'Aventure', 'Romance'],
  annee:        2021,
  episodes:     { saison1: 23, saison2: 25, saison3: 0 },
  studio:       'Studio Bind',
  studioId:     'studio-bind',
  auteur:       'Rifujin na Magonote',
  auteurId:     'rifujin-na-magonote',
  editeur:      'Kadokawa MF Books (JP) / Seven Seas Entertainment (EN)',
  statut:       'En cours',
  type:         'Isekai',
  created_at:   FieldValue.serverTimestamp(),
};

// ── Personnages ────────────────────────────────────────────────────────────────

const characters = [
  {
    id:            'mt-rudeus-greyrat',
    nom:           'Rudeus Greyrat',
    nomJaponais:   'ルーデウス・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Réincarné — vieillissant de 0 à 74 ans',
    sexe:          'Masculin',
    statut:        'Décédé (mort paisible à 74 ans)',
    rang:          'Mage Niveau Dieu',
    description:   'Rudeus Greyrat est l\'âme d\'un japonais de 34 ans, NEET reclus, réincarné dans un monde de fantasy avec la totalité de ses souvenirs. Surnommé "Rudeus du Bourbier" et "Main Droite du Dieu Dragon", il finit par surpasser en puissance magique brute jusqu\'à Laplace, le légendaire Dieu Démon. Son vrai défi n\'est pas la puissance — c\'est de surmonter ses traumatismes et devenir un être humain complet.',
    pouvoirs:      [
      'Magie Eau — niveau Saint, puis quasi complète en adulte',
      'Magie Terre — Stone Cannon niveau Roi / Empereur',
      'Magie sans incantation (voix ou geste) — apprise dès l\'enfance',
      'Œil Démoniaque de Prescience — quelques secondes dans le futur',
      'Magie nucléaire (arc final) — fusion Feu/Air niveau Dieu',
      'Saint Dragon Battle Aura — technique de combat créée par Orsted',
    ],
    citations:     [
      'Je vis dans ce monde sans regrets.',
      'Le mana brut ne fait pas tout — l\'enseignement, c\'est ma vraie force.',
    ],
    trivia:        [
      'Son niveau de mana brut est décrit par Orsted et Kishirika comme supérieur à celui de Laplace.',
      'A créé de son vivant de nombreux artefacts magiques et une école — surnommé "Dieu de l\'Enseignement" posthumément.',
      'Meurt paisiblement à 74 ans, entouré de ses trois femmes et ses enfants.',
    ],
    relations:     [
      { nomPersonnage: 'Sylphiette Greyrat', type: 'famille' },
      { nomPersonnage: 'Roxy Migurdia',      type: 'famille' },
      { nomPersonnage: 'Eris Boreas Greyrat',type: 'famille' },
      { nomPersonnage: 'Ruijerd Superdia',   type: 'allié' },
      { nomPersonnage: 'Orsted',             type: 'allié' },
    ],
    voixJaponaise: 'Tomokazu Sugita (adulte) / Yumi Uchiyama (enfant)',
    voixAnglaise:  'Ben Phillips (adulte) / Madeleine Morris (enfant)',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 1,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-roxy-migurdia',
    nom:           'Roxy Migurdia',
    nomJaponais:   'ロキシー・ミグルディア',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           '44 ans (apparence d\'adolescente permanente)',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Eau Roi',
    description:   'Roxy Migurdia est le premier mentor de Rudeus et sa deuxième épouse. Membre de la race Migurd — des démons vieillissant physiquement très lentement — elle a l\'apparence d\'une adolescente malgré ses décennies d\'existence. Elle quitta son village natal incapable de percevoir la télépathie naturelle de son peuple, devint aventurière puis enseignante de magie. Son pendentif offert à Rudeus est l\'une des reliques les plus symboliques de la série.',
    pouvoirs:      [
      'Magie Eau — niveau Eau Roi, l\'une des meilleures de sa génération',
      'Magie sans incantation (chuchotée)',
      'Enseignement de la magie — excellente pédagogue',
      'Aventurière de rang avancé — combat polyvalent',
    ],
    citations:     [
      'Même si tu ne peux pas entendre les autres, ton cœur parle pour toi.',
    ],
    trivia:        [
      'Sa race Migurd lui donne une apparence d\'adolescente permanente — source de quiproquos récurrents.',
      'Son pendentif offert à Rudeus à ses 5 ans est l\'un des objets les plus symboliques de la série.',
      'Enseigne à l\'Académie de Ranoa où elle côtoie régulièrement Rudeus adulte.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',      type: 'famille' },
      { nomPersonnage: 'Sylphiette Greyrat',  type: 'famille' },
      { nomPersonnage: 'Elinalise Dragonroad',type: 'famille' },
    ],
    voixJaponaise: 'Ai Kayano',
    voixAnglaise:  'Skyler Davenport',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 2,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-sylphiette-greyrat',
    nom:           'Sylphiette Greyrat',
    nomJaponais:   'シルフィエット・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Contemporaine de Rudeus',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Eau Roi',
    description:   'Sylphiette (surnommée "Sylphie") est l\'amie d\'enfance de Rudeus et sa première épouse. Née d\'un mélange de sang humain, elfique et humain-bête, elle hérite d\'une chevelure argentée exceptionnellement rare qui fut à l\'origine d\'un harcèlement dans son enfance. Déguisée sous le nom de "Fitz" à Ranoa, elle joue un rôle crucial dans l\'ascension de la Princesse Ariel au trône.',
    pouvoirs:      [
      'Magie Eau — niveau Eau Roi, plus avancée que Roxy à niveau équivalent',
      'Magie Vent — techniques offensives complémentaires',
      'Magie sans incantation apprise sous la direction de Rudeus',
      'Combat physique — entraînée par Ruijerd et les gardes d\'Ariel',
    ],
    citations:     [
      'Je t\'ai attendu si longtemps... enfin retrouvé.',
    ],
    trivia:        [
      'Sa chevelure argentée rare est la source d\'un harcèlement d\'enfance qui l\'amena à rencontrer Rudeus.',
      'Déguisée sous le nom de "Fitz" pendant plusieurs années à Ranoa — révélation progressivement dramatique.',
      'Joue un rôle crucial dans l\'ascension politique de la Princesse Ariel au trône d\'Asura.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',      type: 'famille' },
      { nomPersonnage: 'Ariel Anemoi Asura',  type: 'allié' },
      { nomPersonnage: 'Elinalise Dragonroad',type: 'famille' },
    ],
    voixJaponaise: 'Lynn',
    voixAnglaise:  'Brianna Knickerbocker',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 3,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-eris-boreas-greyrat',
    nom:           'Eris Boreas Greyrat',
    nomJaponais:   'エリス・ボレアス・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Légèrement plus jeune que Rudeus',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Mad Sword King — Épée Roi',
    description:   'Eris Boreas Greyrat est l\'héritière de la famille noble Boreas Greyrat, cousine éloignée de Rudeus et sa troisième épouse. Surnommée "Mad Sword King Eris", elle maîtrise plusieurs styles d\'épée et devient l\'une des combattantes les plus redoutables du monde. Son départ brutal et silencieux après leur nuit ensemble est l\'un des moments les plus douloureux pour les fans.',
    pouvoirs:      [
      'Épée Nord — style héréditaire Greyrat, niveau Saint puis Roi',
      'Épée Dieu (God Sword Style) — partiellement apprise auprès de Gal Farion',
      'Épée de Combat — entraînée par Ruijerd et Ghislaine',
      'Force physique et vitesse exceptionnelles — combat pur sans magie',
    ],
    citations:     [
      'Rudeus ! Je ne te pardonne pas de m\'avoir rendue si faible face à toi.',
    ],
    trivia:        [
      'Devient l\'une des guerrières les plus puissantes du monde — classée dans les Sept Grandes Puissances.',
      'Son départ silencieux de la chambre de Rudeus est l\'un des moments les plus discutés de la communauté.',
      'Tempérament volcanique adouci progressivement — l\'un des meilleurs arcs de développement de la série.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',    type: 'famille' },
      { nomPersonnage: 'Ruijerd Superdia',  type: 'mentor' },
      { nomPersonnage: 'Ghislaine Dedoldia',type: 'mentor' },
    ],
    voixJaponaise: 'Ai Kakuma',
    voixAnglaise:  'Erica Mendez',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 4,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-ruijerd-superdia',
    nom:           'Ruijerd Superdia',
    nomJaponais:   'ルイジェルド・スペルディア',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Plusieurs centaines d\'années',
    sexe:          'Masculin',
    statut:        'Vivant',
    rang:          'Guerrier Superd — Légendaire',
    description:   'Ruijerd Superdia est un guerrier de la race Superd, portant une malédiction qui fit massacrer les siens pendant la Guerre de Laplace, les rendant universellement haïs. Il erre depuis des siècles pour retrouver les survivants de son peuple et racheter leur nom. Sa rencontre avec Rudeus — qui ne connaît pas sa réputation — le libère progressivement de son isolement. Sa lance est le dernier souvenir de son fils Luiweld.',
    pouvoirs:      [
      'Maîtrise absolue de la lance — niveau incomparable dans le monde',
      'Vitesse et réflexes dépassant tout humain',
      'Pierre frontale Superd — capacité à ressentir les émotions',
      'Résistance physique colossale — combat depuis des siècles',
    ],
    citations:     [
      'Je protège les enfants. C\'est ma seule loi.',
      'L\'honneur d\'un Superd ne peut être restauré que par un Superd.',
    ],
    trivia:        [
      'Sa lance est légèrement plus courte que la normale — elle était celle de son fils Luiweld, de plus petite stature.',
      'Dans tous les loops d\'Orsted, Ruijerd épousait toujours Norn — destin immuable.',
      'Sa tragédie : être l\'être le plus honorable du monde mais le plus craint à cause d\'une malédiction ancienne.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',     type: 'allié' },
      { nomPersonnage: 'Eris Boreas Greyrat',type: 'allié' },
      { nomPersonnage: 'Norn Greyrat',       type: 'famille' },
    ],
    voixJaponaise: 'Daisuke Namikawa',
    voixAnglaise:  'Kaiji Tang',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 5,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-paul-greyrat',
    nom:           'Paul Greyrat',
    nomJaponais:   'パウロ・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           '37 ans environ (décédé)',
    sexe:          'Masculin',
    statut:        'Décédé (Labyrinthe Téléporté)',
    rang:          'Aventurier S-rank',
    description:   'Paul Greyrat est le père de Rudeus et l\'un des personnages les plus complexes de la série. Né d\'une famille noble d\'Asura, il fuit son milieu pour vivre comme aventurier. À la tête des Fangs of the Black Wolf, il atteint le rang S. Profondément humain dans ses défauts — infidèle, impulsif, mauvais communicant —, il est aussi sincèrement aimant. Sa mort dans le Labyrinthe Téléporté pour sauver Rudeus est l\'un des moments les plus dévastateurs de la série.',
    pouvoirs:      [
      'Maîtrise des trois styles d\'épée : Nord, Eau et Dieu (niveau Roi pour chacun)',
      'Combat d\'aventurier S-rank — polyvalence et expérience incomparables',
    ],
    citations:     [
      'Tu es mon fils. Je suis fier de toi, même si je ne te l\'ai jamais dit assez.',
    ],
    trivia:        [
      'Sa mort de dos, fauché par un monstre alors qu\'il est distrait, est considérée comme l\'une des plus traumatisantes.',
      'A maîtrisé les trois styles d\'épée majeurs à un niveau Roi — exploit rarissime.',
      'Sa lettre posthume à Rudeus est l\'une des scènes les plus touchantes de la série.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',    type: 'famille' },
      { nomPersonnage: 'Zenith Greyrat',    type: 'famille' },
      { nomPersonnage: 'Lilia Greyrat',     type: 'famille' },
    ],
    voixJaponaise: 'Shintaro Asanuma',
    voixAnglaise:  'Brandon McInnis',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 6,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-orsted',
    nom:           'Orsted',
    nomJaponais:   'オルステッド',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Plusieurs siècles — boucles temporelles',
    sexe:          'Masculin',
    statut:        'Vivant',
    rang:          'Dieu Dragon',
    description:   'Orsted est le Dieu Dragon actuel, fils du Dieu Dragon Précédent, piégé dans une boucle temporelle pour combattre Hitogami. Chaque vie, il recommence avec ses souvenirs mais avec une malédiction qui rend tous les humains haineux envers lui. La rencontre avec Rudeus — immunisé — change tout : Rudeus devient sa "Main Droite" dans la guerre contre Hitogami.',
    pouvoirs:      [
      'Puissance parmi les plus élevées du monde',
      'Dragon Battle Aura (Saint Dragon Battle Aura)',
      'Mémoire complète de toutes les boucles temporelles précédentes',
      'Malédiction d\'Orsted : terreur/haine automatiques chez tout humain',
    ],
    citations:     [
      'Chaque loop, je reviens avec mes souvenirs. Chaque loop, j\'échoue. Jusqu\'à toi.',
    ],
    trivia:        [
      'Orsted a traversé des dizaines de boucles temporelles — toutes échouées avant Rudeus.',
      'Sa malédiction provoque terreur automatique chez tous — sauf Rudeus et ses descendants.',
      'Porte son propre casque en public — l\'auteur s\'en est inspiré pour son apparence publique.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat', type: 'allié' },
      { nomPersonnage: 'Hitogami',       type: 'ennemi' },
    ],
    voixJaponaise: 'Takahiro Sakurai',
    voixAnglaise:  'Ray Chase',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 7,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-hitogami',
    nom:           'Hitogami',
    nomJaponais:   'ヒトガミ',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'L\'être le plus ancien du monde',
    sexe:          'Masculin (apparence)',
    statut:        'Antagoniste final',
    rang:          'Dieu Humain',
    description:   'Hitogami (litt. "Dieu Homme") est l\'antagoniste ultime de Mushoku Tensei. Il apparaît initialement comme un guide bienveillant dans les rêves de Rudeus. Sa véritable nature : un manipulateur cherchant à empêcher la naissance des enfants de Rudeus, prophétisés pour le tuer. Il tire sa puissance de la foi des mortels et orchestre sa survie via des "Apôtres" manipulés.',
    pouvoirs:      [
      'Vision de multiples futurs possibles (quasi-omniscience temporelle)',
      'Lecture des esprits',
      'Communication via les rêves',
      'Confiance automatique de tous les humains envers lui',
      'Réseau d\'Apôtres manipulés',
    ],
    citations:     [
      'Je te connais mieux que tu ne te connais toi-même, Rudeus.',
      'Chaque coup que tu joues, je l\'ai déjà prévu.',
    ],
    trivia:        [
      'Son visage — blanc, sans traits mémorables — est volontairement impossible à retenir.',
      'Son plan : manipuler les événements pour que Rudeus n\'ait jamais d\'enfants.',
      'Considéré comme l\'un des antagonistes les plus méthodiquement écrits du genre isekai.',
    ],
    relations:     [
      { nomPersonnage: 'Orsted',          type: 'ennemi' },
      { nomPersonnage: 'Rudeus Greyrat',  type: 'ennemi' },
      { nomPersonnage: 'Badigadi',        type: 'ennemi' },
    ],
    voixJaponaise: 'Jun Fukuyama',
    voixAnglaise:  'Zeno Robinson',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 8,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-ghislaine-dedoldia',
    nom:           'Ghislaine Dedoldia',
    nomJaponais:   'ギレーヌ・デドルディア',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Environ 30 ans',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Épée Roi',
    description:   'Ghislaine Dedoldia est une humaine-bête féline, ancienne aventurière S-rank des Fangs of the Black Wolf. Physiquement imposante, elle combine une puissance physique brute et une maîtrise du style Épée de Dieu. Elle enseigne l\'épée à Eris et la langue Bête à Rudeus. Profondément loyale mais peu loquace. Rudeus lui apprend à lire et écrire en échange de ses cours.',
    pouvoirs:      [
      'Épée de Dieu (God Sword Style) — niveau Roi Épée',
      'Force et vitesse physiques dépassant la plupart des humains',
      'Combat instinctif naturel',
    ],
    citations:     [
      'Les mots sont inutiles quand l\'épée parle.',
    ],
    trivia:        [
      'L\'une des rares personnes capables de former Eris au niveau Roi.',
      'Analphabète au début de la série, apprend à lire grâce à Rudeus.',
    ],
    relations:     [
      { nomPersonnage: 'Eris Boreas Greyrat', type: 'élève' },
      { nomPersonnage: 'Paul Greyrat',        type: 'allié' },
      { nomPersonnage: 'Rudeus Greyrat',      type: 'allié' },
    ],
    voixJaponaise: 'Yoko Hikasa',
    voixAnglaise:  'Caitlin Glass',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 9,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-perugius-dola',
    nom:           'Perugius Dola',
    nomJaponais:   'ペルギウス・ドーラ',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Plusieurs centaines d\'années',
    sexe:          'Masculin',
    statut:        'Vivant',
    rang:          'Roi Dragon Cuirassé — Sept Grandes Puissances',
    description:   'Perugius Dola est le Roi Dragon Cuirassé, l\'une des Sept Grandes Puissances et maître de la forteresse céleste flottante. Orgueilleux et condescendant, il juge les êtres sur leur valeur. Il contribua à l\'exil de Laplace il y a des siècles. Il confère au fils de Rudeus (Sieghart) le second nom "Saladin" — marque d\'une faveur extrêmement rare.',
    pouvoirs:      [
      'Armored Dragon King Hand Sword — peut trancher un roi démon immortel',
      'Douze Familiers Invocables — chacun surpuissant dans son domaine',
      'Seigneur de la Forteresse Volante',
    ],
    citations:     [
      'Je ne donne mon respect qu\'à ceux qui en sont dignes. Et tu es l\'un d\'eux.',
    ],
    trivia:        [
      'Sa forteresse volante est l\'une des merveilles architecturales du monde fictif.',
      'Donner un second nom est un honneur rarissime — il le fait pour Sieghart, fils de Rudeus.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat', type: 'allié' },
    ],
    voixJaponaise: 'Shigeru Chiba',
    voixAnglaise:  'Kirk Thornton',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 10,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-zenith-greyrat',
    nom:           'Zenith Greyrat',
    nomJaponais:   'ゼニス・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           '17 ans à la naissance de Rudeus',
    sexe:          'Féminin',
    statut:        'Semi-consciente (état altéré)',
    rang:          'Ancienne aventurière S-rank',
    description:   'Zenith Greyrat (née Latreia) est la mère de Rudeus et l\'épouse de Paul. Ancienne prêtresse de Millis et aventurière S-rank. Douce et protectrice, elle est le pilier moral de la famille. Après l\'Incident de Téléportation, elle est retrouvée piégée dans un cristal de mana. Sauvée physiquement, elle reste dans un état de semi-conscience permanent — dénouement ambigu particulièrement douloureux.',
    pouvoirs:      [
      'Magie de soin (Healing) — niveau Saint',
      'Combat d\'aventurière S-rank (dans son passé)',
    ],
    citations:     [
      'Rudeus... mon enfant...',
    ],
    trivia:        [
      'Son état post-sauvetage — physiquement présente mais mentalement absente — est l\'une des conclusions les plus douloureuses.',
      'A appris à cuisiner de Geese — transmis ensuite à toute la famille.',
    ],
    relations:     [
      { nomPersonnage: 'Paul Greyrat',   type: 'famille' },
      { nomPersonnage: 'Rudeus Greyrat', type: 'famille' },
      { nomPersonnage: 'Norn Greyrat',   type: 'famille' },
    ],
    voixJaponaise: 'Mami Koyama',
    voixAnglaise:  'Monica Rial',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 11,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-norn-greyrat',
    nom:           'Norn Greyrat',
    nomJaponais:   'ノルン・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Née 7 ans après Rudeus',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Étudiante — Niveau académique',
    description:   'Norn Greyrat est la fille légitime de Paul et Zenith, sœur cadette de Rudeus. Elle entretient initialement une relation difficile avec son frère. Leur réconciliation progressive, via une confrontation directe où Rudeus lui expose toute la vérité, est l\'un des arcs relationnels les plus touchants. Elle épouse finalement Ruijerd Superdia — destinée révélée comme quasi-immuable à travers toutes les boucles d\'Orsted.',
    pouvoirs:      [
      'Magie de base — niveau académique',
      'Combat basique',
    ],
    citations:     [
      'Onii-chan... tu m\'as enfin dit la vérité.',
    ],
    trivia:        [
      'Son mariage avec Ruijerd était apparent dans toutes les boucles temporelles d\'Orsted — destin fixe.',
      'Sa réconciliation avec Rudeus après confrontation directe est l\'un des arcs émotionnels les plus salués.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',  type: 'famille' },
      { nomPersonnage: 'Ruijerd Superdia',type: 'famille' },
      { nomPersonnage: 'Aisha Greyrat',   type: 'famille' },
    ],
    voixJaponaise: 'Non précisé',
    voixAnglaise:  'Non précisé',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 12,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-aisha-greyrat',
    nom:           'Aisha Greyrat',
    nomJaponais:   'アイシャ・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Née la même année que Norn',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Gestionnaire — Niveau domestique',
    description:   'Aisha Greyrat est la fille de Paul et Lilia. Demi-sœur de Rudeus, elle développe une admiration quasi-fanatique envers lui ("Onii-sama"). Extrêmement intelligente et débrouillarde, elle prend en charge la gestion administrative de la maison familiale de Rudeus à Sharia avec une efficacité remarquable. Elle épousera Ars Greyrat (fils de Rudeus et Eris).',
    pouvoirs:      [
      'Intelligence et organisation exceptionnelles',
      'Gestion administrative et domestique',
      'Magie de base et combat léger',
    ],
    citations:     [
      'Onii-sama est le plus grand du monde !',
    ],
    trivia:        [
      'Gère avec une efficacité redoutable la maison de Sharia — surnommée "majordome" par les fans.',
      'Son admiration obsessionnelle pour Rudeus est une des sources de comédie récurrente.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat', type: 'famille' },
      { nomPersonnage: 'Norn Greyrat',   type: 'famille' },
      { nomPersonnage: 'Lilia Greyrat',  type: 'famille' },
    ],
    voixJaponaise: 'Non précisé',
    voixAnglaise:  'Non précisé',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 13,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-elinalise-dragonroad',
    nom:           'Elinalise Dragonroad',
    nomJaponais:   'エリナリーゼ・ドラゴンロード',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Plusieurs décennies malgré une apparence juvénile',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Aventurière — Ancienne S-rank',
    description:   'Elinalise Dragonroad est une elfe affectée d\'une malédiction qui la contraint à une promiscuité régulière. Ancienne membre des Fangs of the Black Wolf et grand-mère biologique de Sylphiette. Elle finira par épouser Cliff Grimoire, qui accepte sa malédiction — histoire d\'amour parmi les plus originales de la série.',
    pouvoirs:      [
      'Magie d\'elfes — niveau avancé',
      'Combat d\'aventurière expérimentée',
    ],
    citations:     [
      'Les malédictions ne définissent pas qui tu es.',
    ],
    trivia:        [
      'Son mariage avec Cliff — qui accepte sa malédiction inconditionnellement — est l\'une des romances les plus appréciées.',
      'La révélation qu\'elle est la grand-mère de Sylphie est l\'un des twists familiaux les plus surprenants.',
    ],
    relations:     [
      { nomPersonnage: 'Sylphiette Greyrat', type: 'famille' },
      { nomPersonnage: 'Cliff Grimoire',     type: 'famille' },
      { nomPersonnage: 'Paul Greyrat',       type: 'allié' },
    ],
    voixJaponaise: 'Rie Tanaka',
    voixAnglaise:  'Mela Lee',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 14,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-cliff-grimoire',
    nom:           'Cliff Grimoire',
    nomJaponais:   'クリフ・グリモワール',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Contemporain de Rudeus à l\'Académie',
    sexe:          'Masculin',
    statut:        'Vivant',
    rang:          'Prêtre de Millis',
    description:   'Cliff Grimoire est le petit-fils du Pape de Millis et étudiant à l\'Académie de Ranoa. Arrogant initialement, il évolue sous l\'influence de Rudeus. Sa relation avec Elinalise — qu\'il aime malgré sa malédiction — constitue l\'un des arcs romantiques les plus originaux. Il contribue aux recherches magiques de Rudeus et Zanoba.',
    pouvoirs:      [
      'Magie Millis (spécialité religieuse) — niveau élevé',
      'Rituel de purification et de guérison',
      'Recherche magique avancée',
    ],
    citations:     [
      'Je t\'aime, Elinalise. Ta malédiction n\'y changera rien.',
    ],
    trivia:        [
      'Propose à Elinalise malgré sa malédiction — l\'un des moments romantiques les plus sincères.',
      'Contribue aux recherches magiques avec Rudeus et Zanoba sur les artefacts anti-malédiction.',
    ],
    relations:     [
      { nomPersonnage: 'Elinalise Dragonroad', type: 'famille' },
      { nomPersonnage: 'Rudeus Greyrat',       type: 'ami' },
      { nomPersonnage: 'Zanoba Shirone',        type: 'ami' },
    ],
    voixJaponaise: 'Yuichiro Umehara',
    voixAnglaise:  'Griffin Puatu',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 15,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-zanoba-shirone',
    nom:           'Zanoba Shirone',
    nomJaponais:   'ザノバ・シローネ',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Plus âgé que Rudeus',
    sexe:          'Masculin',
    statut:        'Vivant',
    rang:          'Disciple de Rudeus — Ancien Prince',
    description:   'Zanoba Shirone est l\'ancien troisième prince du Royaume de Shirone. Possédant une force physique divine incontrôlable, il tua accidentellement sa petite sœur et fut contraint de quitter son pays. Disciple fanatique de Rudeus, il est fasciné par ses figurines et artefacts. Loyal jusqu\'à la dévotion, il devient subordonné d\'Orsted contre Hitogami.',
    pouvoirs:      [
      'Force physique divine (God Strength) — incontrôlable dans sa jeunesse',
      'Création d\'artefacts magiques',
      'Combat physique pur — dévastateur en corps-à-corps',
    ],
    citations:     [
      'Maître Rudeus ! Cette figurine est un chef-d\'œuvre absolu !',
    ],
    trivia:        [
      'Sa passion pour les figurines et artefacts de Rudeus est source d\'un comique récurrent.',
      'Le décès accidentel de sa sœur par excès de force est le trauma fondateur de son personnage.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',    type: 'élève' },
      { nomPersonnage: 'Cliff Grimoire',    type: 'ami' },
      { nomPersonnage: 'Nanahoshi Shizuka', type: 'ami' },
    ],
    voixJaponaise: 'Makoto Furukawa',
    voixAnglaise:  'Daman Mills',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 16,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-nanahoshi-shizuka',
    nom:           'Nanahoshi Shizuka',
    nomJaponais:   '七星 静',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Lycéenne (~17-18 ans)',
    sexe:          'Féminin',
    statut:        'Vivante (invoquée)',
    rang:          'Invoquée — Spécialiste Invocation',
    description:   'Nanahoshi Shizuka est une lycéenne japonaise téléportée accidentellement dans le monde de Mushoku Tensei lors de l\'Incident de Téléportation. Contrairement à Rudeus, elle a été transportée telle quelle. Elle consacre son temps à trouver un moyen de retourner dans son monde. Elle souffre d\'une mystérieuse maladie liée au mana (Drine disease).',
    pouvoirs:      [
      'Invocation (Summoning Magic) — spécialité développée à Ranoa',
      'Connaissance scientifique de la Terre applicable à la magie',
      'Intelligence analytique élevée',
    ],
    citations:     [
      'Je rentrerai chez moi. Peu importe le temps que ça prendra.',
    ],
    trivia:        [
      'Seule autre personne d\'origine japonaise dans le monde — lien particulier avec Rudeus malgré leur tension.',
      'Invoque une pastèque sans pépins depuis la Terre — preuve que ses sorts fonctionnent, scène mémorable.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat',  type: 'allié' },
      { nomPersonnage: 'Zanoba Shirone',  type: 'allié' },
      { nomPersonnage: 'Cliff Grimoire',  type: 'allié' },
    ],
    voixJaponaise: 'Non précisé',
    voixAnglaise:  'Non précisé',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 17,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-ariel-anemoi-asura',
    nom:           'Ariel Anemoi Asura',
    nomJaponais:   'アリエル・アネモイ・アスラ',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Contemporaine de Sylphie',
    sexe:          'Féminin',
    statut:        'Vivante — Future Reine d\'Asura',
    rang:          'Princesse d\'Asura',
    description:   'Ariel Anemoi Asura est la deuxième princesse du Royaume d\'Asura. Ambitieuse, charismatique et politiquement redoutable, elle recrute Sylphiette comme garde du corps. Sa lutte pour le trône d\'Asura contre des factions hostiles constitue l\'un des fils politiques majeurs. Elle finira par accéder au trône grâce au soutien de Rudeus.',
    pouvoirs:      [
      'Intelligence politique et diplomatique exceptionnelle',
      'Leadership charismatique',
      'Magie royale Asura',
    ],
    citations:     [
      'Sylphie, je t\'ai choisie. Et tu ne m\'as jamais déçue.',
    ],
    trivia:        [
      'Son accession au trône d\'Asura est l\'un des objectifs stratégiques de la coalition d\'Orsted contre Hitogami.',
      'Sa relation avec Sylphie — protectrice/protégée mutuellement — est l\'une des plus complexes.',
    ],
    relations:     [
      { nomPersonnage: 'Sylphiette Greyrat', type: 'allié' },
      { nomPersonnage: 'Rudeus Greyrat',     type: 'allié' },
    ],
    voixJaponaise: 'Mikako Komatsu',
    voixAnglaise:  'Tara Sands',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 18,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-lilia-greyrat',
    nom:           'Lilia Greyrat',
    nomJaponais:   'リーリャ・グレイラット',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Contemporaine de Paul et Zenith',
    sexe:          'Féminin',
    statut:        'Vivante',
    rang:          'Ancienne servante — 2e épouse de Paul',
    description:   'Lilia est l\'ancienne servante de la famille Greyrat devenue la deuxième épouse de Paul après leur liaison. Dévouée, discrète et profondément attachée à la famille, elle élève Aisha avec un amour sincère. Elle survit à l\'Incident de Téléportation et reste avec les sœurs de Rudeus, pilier silencieux de la famille.',
    pouvoirs:      [
      'Compétences de servante et de gestion domestique',
      'Magie de base légère',
    ],
    citations:     [
      'Je servirai cette famille jusqu\'à mon dernier souffle.',
    ],
    trivia:        [
      'Sa loyauté envers Zenith malgré la liaison avec Paul est l\'une des dynamiques les plus nuancées.',
    ],
    relations:     [
      { nomPersonnage: 'Paul Greyrat',   type: 'famille' },
      { nomPersonnage: 'Aisha Greyrat',  type: 'famille' },
      { nomPersonnage: 'Zenith Greyrat', type: 'allié' },
    ],
    voixJaponaise: 'Akane Fujita',
    voixAnglaise:  'Jad Saxton',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 19,
    created_at:    FieldValue.serverTimestamp(),
  },
  {
    id:            'mt-badigadi',
    nom:           'Badigadi',
    nomJaponais:   'バーディガーディ',
    animeId:       'mushoku-tensei',
    animeName:     'Mushoku Tensei : Jobless Reincarnation',
    auteurId:      'rifujin-na-magonote',
    auteurNom:     'Rifujin na Magonote',
    studioId:      'studio-bind',
    studioNom:     'Studio Bind',
    age:           'Plusieurs centaines ou milliers d\'années',
    sexe:          'Masculin',
    statut:        'Vivant — Immortel',
    rang:          'Roi Démon Immortel — Sept Grandes Puissances',
    description:   'Badigadi est l\'un des Rois Démons les plus puissants du monde, immortel et doté de six bras, classé parmi les Sept Grandes Puissances. Jovial, belliqueux et amateur de bons combats, il est manipulé par Hitogami avant de devenir un allié. Son immortalité le rend quasi invincible aux attaques conventionnelles. Malgré son apparence terrifiante, il est l\'un des personnages les plus drôles du cast.',
    pouvoirs:      [
      'Immortalité — régénération de tout membre perdu',
      'Six bras — attaques multiples simultanées',
      'Puissance de frappe colossale',
      'Résistance absolue aux attaques ordinaires',
    ],
    citations:     [
      'Un bon combat vaut mille victoires faciles !',
      'Tu as les Stone Cannon d\'un Roi ou d\'un Empereur, petit mage.',
    ],
    trivia:        [
      'Sa jovialité absolue même en combat mortel en fait l\'un des personnages comiques les plus aimés.',
      'Déclare que les Stone Cannon de Rudeus ont le niveau Roi/Empereur — précieux indicateur de puissance.',
    ],
    relations:     [
      { nomPersonnage: 'Rudeus Greyrat', type: 'allié' },
      { nomPersonnage: 'Hitogami',       type: 'ennemi' },
    ],
    voixJaponaise: 'Tomokazu Sugita',
    voixAnglaise:  'Non précisé',
    images:        [],
    imagePath:     '',
    likesCount:    0,
    collectCount:  0,
    popularityRank: 20,
    created_at:    FieldValue.serverTimestamp(),
  },
];

// ── Quiz — 7 personnages principaux ───────────────────────────────────────────

const quizzes = [
  {
    characterId: 'mt-rudeus-greyrat',
    questions: [
      {
        question:     'Quel était le métier / style de vie de Rudeus dans sa vie précédente ?',
        options:      ['Salaryman surmené', 'NEET reclus', 'Étudiant', 'Artiste de rue'],
        correctIndex: 1,
      },
      {
        question:     'Quel surnom Rudeus a-t-il reçu de la part du monde pour ses exploits en magie de terre ?',
        options:      ['Le Sage des Profondeurs', 'Main Droite du Dieu Dragon', 'Rudeus du Bourbier', 'Le Sorcier Céleste'],
        correctIndex: 2,
      },
      {
        question:     'Qui a offert à Rudeus l\'Œil Démoniaque de Prescience ?',
        options:      ['Orsted', 'Hitogami', 'Kishirika Kishirisu', 'Perugius Dola'],
        correctIndex: 2,
      },
      {
        question:     'Combien d\'épouses Rudeus a-t-il à la fin de la série ?',
        options:      ['1', '2', '3', '4'],
        correctIndex: 2,
      },
      {
        question:     'Quelle est la technique de combat corps-à-corps que Rudeus apprend d\'Orsted ?',
        options:      ['Dragon Aura Blast', 'Saint Dragon Battle Aura', 'God Sword Style', 'Earth Crash Fist'],
        correctIndex: 1,
      },
      {
        question:     'À quel âge Rudeus meurt-il paisiblement dans cette nouvelle vie ?',
        options:      ['54 ans', '64 ans', '74 ans', '84 ans'],
        correctIndex: 2,
      },
    ],
  },
  {
    characterId: 'mt-roxy-migurdia',
    questions: [
      {
        question:     'Quelle est la race de Roxy Migurdia ?',
        options:      ['Elfe', 'Migurd', 'Humaine-Bête', 'Humaine'],
        correctIndex: 1,
      },
      {
        question:     'Pourquoi Roxy a-t-elle quitté son village natal ?',
        options:      ['Pour chercher aventure', 'Pour étudier la magie', 'Incapable de percevoir la télépathie de sa race', 'Chassée par son clan'],
        correctIndex: 2,
      },
      {
        question:     'Quel objet Roxy offre-t-elle à Rudeus qui devient une relique précieuse ?',
        options:      ['Un livre de magie', 'Un pendentif', 'Une baguette magique', 'Un cristal de mana'],
        correctIndex: 1,
      },
      {
        question:     'Quel est le niveau de magie Eau atteint par Roxy ?',
        options:      ['Eau Saint', 'Eau Roi', 'Eau Dieu', 'Eau Empereur'],
        correctIndex: 1,
      },
      {
        question:     'Où Roxy enseigne-t-elle la magie une fois adulte ?',
        options:      ['L\'Académie Royale d\'Asura', 'L\'Académie de Magie de Ranoa', 'Le Temple de Millis', 'Le Château d\'Orsted'],
        correctIndex: 1,
      },
    ],
  },
  {
    characterId: 'mt-sylphiette-greyrat',
    questions: [
      {
        question:     'Quelle est la particularité physique rare de Sylphiette qui causa son harcèlement ?',
        options:      ['Des oreilles elfiques visibles', 'Une chevelure argentée', 'Des yeux violets', 'Une marque de naissance'],
        correctIndex: 1,
      },
      {
        question:     'Sous quel pseudonyme Sylphiette se déguise-t-elle à l\'Académie de Ranoa ?',
        options:      ['Aria', 'Sylvie', 'Fitz', 'Selena'],
        correctIndex: 2,
      },
      {
        question:     'Quel rang de magie Eau Sylphiette atteint-elle ?',
        options:      ['Eau Saint', 'Eau Roi', 'Eau Dieu', 'Eau Maître'],
        correctIndex: 1,
      },
      {
        question:     'Quelle est la relation entre Sylphiette et Elinalise Dragonroad ?',
        options:      ['Mère et fille', 'Tante et nièce', 'Grand-mère et petite-fille', 'Sœurs'],
        correctIndex: 2,
      },
      {
        question:     'Dans quelle entité politique Sylphiette joue-t-elle un rôle majeur ?',
        options:      ['Le Royaume de Shirone', 'L\'Empire d\'Asura', 'Le Continent Démoniaque', 'L\'Académie de Ranoa'],
        correctIndex: 1,
      },
    ],
  },
  {
    characterId: 'mt-eris-boreas-greyrat',
    questions: [
      {
        question:     'Quel est le surnom de combat d\'Eris ?',
        options:      ['Red Sword Eris', 'Mad Sword King Eris', 'Iron Blade Eris', 'Storm Queen Eris'],
        correctIndex: 1,
      },
      {
        question:     'Qui est l\'un des formateurs principaux d\'Eris à l\'épée ?',
        options:      ['Rudeus Greyrat', 'Orsted', 'Ghislaine Dedoldia', 'Paul Greyrat'],
        correctIndex: 2,
      },
      {
        question:     'Quel rang d\'épée Eris atteint-elle au cours du récit ?',
        options:      ['Épée Saint', 'Épée Roi', 'Épée Dieu', 'Épée Maître'],
        correctIndex: 1,
      },
      {
        question:     'Quelle décision d\'Eris est considérée comme l\'une des plus douloureuses pour les fans ?',
        options:      ['Elle refuse d\'épouser Rudeus', 'Elle part silencieusement après leur nuit ensemble', 'Elle trahit Rudeus pour Hitogami', 'Elle abandonne son entraînement à l\'épée'],
        correctIndex: 1,
      },
      {
        question:     'Quel lien de famille unit Eris et Rudeus au départ ?',
        options:      ['Demi-frère et demi-sœur', 'Cousins éloignés', 'Oncle et nièce', 'Aucun lien'],
        correctIndex: 1,
      },
    ],
  },
  {
    characterId: 'mt-ruijerd-superdia',
    questions: [
      {
        question:     'Quelle est la race de Ruijerd Superdia ?',
        options:      ['Demi-Elfe', 'Humain-Bête', 'Superd', 'Dragon'],
        correctIndex: 2,
      },
      {
        question:     'Pourquoi la race Superd est-elle universellement haïe ?',
        options:      ['Ils ont trahi les humains', 'Ils furent maudits et massacrèrent amis et ennemis pendant la Guerre de Laplace', 'Ils ont volé les terres humaines', 'Ils servent Hitogami'],
        correctIndex: 1,
      },
      {
        question:     'Quel est le bien le plus précieux de Ruijerd ?',
        options:      ['Son armure enchantée', 'Sa lance — dernier souvenir de son fils Luiweld', 'Sa gemme frontale', 'Son journal de voyage'],
        correctIndex: 1,
      },
      {
        question:     'Quel est le nom du groupe formé par Rudeus, Eris et Ruijerd ?',
        options:      ['Fangs of the Black Wolf', 'Dead End', 'Black Shield', 'Mana Breakers'],
        correctIndex: 1,
      },
      {
        question:     'Qui Ruijerd épouse-t-il à la fin du récit ?',
        options:      ['Aisha Greyrat', 'Nanahoshi Shizuka', 'Norn Greyrat', 'Ghislaine Dedoldia'],
        correctIndex: 2,
      },
    ],
  },
  {
    characterId: 'mt-orsted',
    questions: [
      {
        question:     'Qu\'est-ce que la malédiction d\'Orsted inflige à ceux qui le rencontrent ?',
        options:      ['Ils perdent leur magie', 'Terreur et haine automatiques envers lui', 'Ils tombent malades', 'Ils deviennent ses serviteurs'],
        correctIndex: 1,
      },
      {
        question:     'Pourquoi Orsted recommence-t-il sa vie en boucle ?',
        options:      ['Pour accumuler de la puissance', 'Piégé par son père pour combattre Hitogami', 'Pour trouver ses épouses', 'À cause d\'un artefact maudit'],
        correctIndex: 1,
      },
      {
        question:     'Quel titre Orsted donne-t-il à Rudeus dans leur alliance ?',
        options:      ['Bouclier du Dieu Dragon', 'Main Droite du Dieu Dragon', 'Bras Gauche du Dieu Dragon', 'Œil du Dieu Dragon'],
        correctIndex: 1,
      },
      {
        question:     'Qui est l\'ennemi juré d\'Orsted ?',
        options:      ['Laplace', 'Perugius Dola', 'Hitogami', 'Badigadi'],
        correctIndex: 2,
      },
      {
        question:     'Pourquoi Rudeus est-il immunisé à la malédiction d\'Orsted ?',
        options:      ['Il a un niveau de mana supérieur', 'Sa magie Eau le protège', 'Il est étranger à ce monde (réincarné)', 'Il possède l\'Œil de Prescience'],
        correctIndex: 2,
      },
    ],
  },
  {
    characterId: 'mt-hitogami',
    questions: [
      {
        question:     'Comment Hitogami apparaît-il initialement à Rudeus ?',
        options:      ['Comme un ennemi déclaré', 'Comme un guide bienveillant dans ses rêves', 'Comme un voyageur mystérieux', 'Comme un esprit ancestral'],
        correctIndex: 1,
      },
      {
        question:     'Quelle est la raison principale pour laquelle Hitogami veut empêcher les enfants de Rudeus ?',
        options:      ['Il veut détruire la magie dans le monde', 'Ils sont prophétisés pour le tuer', 'Il veut régner sur le monde', 'Il hait les réincarnés'],
        correctIndex: 1,
      },
      {
        question:     'Quelle est la capacité distinctive de Hitogami vis-à-vis des humains ordinaires ?',
        options:      ['Il les contrôle mentalement', 'Tous les humains lui font automatiquement confiance', 'Il peut lire leurs pensées uniquement', 'Il les rend immortels'],
        correctIndex: 1,
      },
      {
        question:     'Comment Hitogami tire-t-il sa puissance ?',
        options:      ['Des cristaux de mana', 'De la foi des mortels en lui', 'Du sang des dragons', 'Des boucles temporelles'],
        correctIndex: 1,
      },
      {
        question:     'Comment appelle-t-on les individus que Hitogami manipule pour ses objectifs ?',
        options:      ['Serviteurs', 'Apôtres', 'Hérauts', 'Avatars'],
        correctIndex: 1,
      },
    ],
  },
];

// ── Import principal ───────────────────────────────────────────────────────────

async function main() {
  console.log('\n━━━ OTADEX — Import Mushoku Tensei ━━━\n');

  // 1. Créateur
  await db.collection('creators').doc('rifujin-na-magonote').set(creatorData, { merge: true });
  console.log('✅  Créateur Rifujin na Magonote importé');

  // 2. Studio
  await db.collection('studios').doc('studio-bind').set(studioData, { merge: true });
  console.log('✅  Studio Studio Bind importé');

  // 3. Animé
  await db.collection('animes').doc('mushoku-tensei').set(animeData, { merge: true });
  console.log('✅  Animé Mushoku Tensei importé');

  // 4. Personnages (batch par 20)
  const BATCH_SIZE = 20;
  for (let i = 0; i < characters.length; i += BATCH_SIZE) {
    const batch = db.batch();
    const slice = characters.slice(i, i + BATCH_SIZE);
    for (const c of slice) {
      const { id, ...data } = c;
      batch.set(db.collection('characters').doc(id), data, { merge: true });
      console.log(`  → ${c.nom} (${id})`);
    }
    await batch.commit();
  }
  console.log(`✅  ${characters.length} personnages importés`);

  // 5. Quiz (batch)
  const quizBatch = db.batch();
  for (const q of quizzes) {
    quizBatch.set(db.collection('quizzes').doc(q.characterId), {
      characterId: q.characterId,
      questions:   q.questions,
      created_at:  FieldValue.serverTimestamp(),
    }, { merge: true });
  }
  await quizBatch.commit();
  console.log(`✅  ${quizzes.length} quiz importés`);

  // 6. Notification OneSignal
  await sendNotification({
    title: '✨ Mushoku Tensei débarque sur OTADEX !',
    body: 'Rudeus, Eris, Roxy et Sylphiette sont disponibles. Explore leurs fiches !',
    route: '/anime/mushoku-tensei',
    type: 'new_characters',
  });

  console.log('\n🎉  Import Mushoku Tensei terminé !');
  console.log('\nLance manuellement si node snap est bloqué :');
  console.log("  env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \\");
  console.log("    /home/tilstack/.cache/ms-playwright-go/1.50.1/node \\");
  console.log("    scripts/import_mt.js");

  process.exit(0);
}

main().catch(e => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
