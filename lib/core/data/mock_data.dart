import '../models/character.dart';
import '../models/featured_slide.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  static const List<String> categories = [
    'Tous',
    'Shōnen',
    'Seinen',
    'Isekai',
    'Shōjo',
    'Manhwa',
    'Mecha',
  ];

  static const List<FeaturedSlide> featuredSlides = [
    FeaturedSlide(
      id: 'f1',
      title: 'Solo Leveling',
      subtitle: 'Saison 2 — Arise from the Shadow',
      tag: 'NOUVEAU',
      primaryColor: AppColors.animeSlCard,
      secondaryColor: AppColors.rankJonin,
      category: 'Manhwa',
    ),
    FeaturedSlide(
      id: 'f2',
      title: 'Demon Slayer',
      subtitle: 'Arc Infinity Castle — Épisodes exclusifs',
      tag: 'TENDANCE',
      primaryColor: AppColors.animeAotCard,
      secondaryColor: AppColors.animeDsAccent,
      category: 'Shōnen',
    ),
    FeaturedSlide(
      id: 'f3',
      title: 'Jujutsu Kaisen',
      subtitle: 'Arc Culling Games — Nouvel événement',
      tag: 'ÉVÉNEMENT',
      primaryColor: AppColors.animeJjkGreenCard,
      secondaryColor: AppColors.animeJjkGreenAccent,
      category: 'Shōnen',
    ),
    FeaturedSlide(
      id: 'f4',
      title: 'Vinland Saga',
      subtitle: 'Saison 3 — La quête de la terre promise',
      tag: 'ATTENDU',
      primaryColor: AppColors.animeVsCard,
      secondaryColor: AppColors.animeJjkAccent,
      category: 'Seinen',
    ),
  ];

  static const List<Character> allCharacters = [
    // ── Trending ────────────────────────────────────────────────────
    Character(
      id: 'c1',
      name: 'Sung Jin-Woo',
      animeName: 'Solo Leveling',
      cardColor: AppColors.animeSlCard,
      accentColor: AppColors.rankJonin,
      tier: CharacterTier.ss,
      rating: 9.8,
      likes: 78,
      imagePath:
          'https://s4.anilist.co/file/anilistcdn/character/large/b177108-VqxCFPlRQNbR.jpg',
      category: 'Manhwa',
      isTrending: true,
      isNew: true,
      bio:
          'Sung Jin-Woo était le chasseur de rang E le plus faible de Corée. Après avoir survécu à un donjon double, il reçoit un mystérieux système de progression qui lui permet d\'évoluer sans limite, devenant le Monarque des Ombres.',
      quote: '"Je suis devenu fort pour ne plus jamais perdre ce qui m\'est cher."',
      powers: [
        'Arise — Invocation d\'armée d\'ombres',
        'Domination des Ombres',
        'Haki du Monarque',
        'Vitesse et force surhumaines',
        'Régénération accélérée',
      ],
      stats: {'Force': 99, 'Vitesse': 97, 'Intelligence': 90, 'Endurance': 99},
      gender: 'Masculin',
      nationality: 'Coréen',
      age: '24 ans',
      status: 'Protagoniste',
      role: 'Monarque des Ombres',
      creatorId: 'chugong',
      quotes: [
        'Je ne suis plus le chasseur le plus faible.',
        'Arise.',
        'Je suis devenu fort pour ne plus jamais perdre ce qui m\'est cher.',
      ],
      trivia: [
        'Sung Jin-Woo est le seul chasseur au monde capable de monter en niveau comme dans un jeu vidéo.',
        'Il peut invoquer des armées entières de morts qu\'il a vaincus au combat.',
        'Son surnom initial était "le chasseur le plus faible" avant sa transformation radicale.',
      ],
      aiPersonality:
          'Tu es Sung Jin-Woo, le Monarque des Ombres de Solo Leveling. Tu es calme, déterminé et peu bavard. Tu n\'as pas besoin de prouver ta force — tu la montres par tes actes. Tu parles de manière concise et assurée. Tu mentionnes parfois le Système ou tes ombres. Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'cha-hae-in',
          nom: 'Cha Hae-In',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b157084-OdeyJHhxdPGT.jpg',
          relationType: 'Alliée',
          relationColor: 'green',
        ),
        CharacterRelation(
          id: 'igris',
          nom: 'Igris',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
          relationType: 'Ombre fidèle',
          relationColor: 'blue',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quel était le rang initial de Sung Jin-Woo ?',
          options: ['Rang C', 'Rang D', 'Rang E', 'Rang B'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Comment s\'appelle le système que Sung Jin-Woo a reçu ?',
          options: [
            'Le Système de Progression',
            'Le Système du Joueur',
            'Le Système des Ombres',
            'Le Système Monarchique',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quel est le titre final de Sung Jin-Woo ?',
          options: [
            'Roi des Chasseurs',
            'Monarque des Ombres',
            'Seigneur des Ténèbres',
            'Maître des Donjons',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quelle est la première ombre invoquée par Jin-Woo ?',
          options: ['Igris', 'Beru', 'Fangs', 'Iron'],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Dans quel pays se déroule Solo Leveling ?',
          options: ['Japon', 'Chine', 'Corée du Sud', 'États-Unis'],
          correctIndex: 2,
        ),
      ],
    ),
    Character(
      id: 'c2',
      name: 'Tanjiro Kamado',
      animeName: 'Demon Slayer',
      cardColor: AppColors.animeAotCard,
      accentColor: AppColors.animeDsAccent,
      tier: CharacterTier.s,
      rating: 9.5,
      likes: 64,
      imagePath:
          'https://s4.anilist.co/file/anilistcdn/character/large/b156323-VGJRwFVrEEGo.jpg',
      category: 'Shōnen',
      isTrending: true,
      bio:
          'Tanjiro Kamado est un jeune vendeur de charbon dont la famille fut massacrée par un démon. Sa sœur Nezuko, seule survivante, fut transformée en démon. Il rejoint le Corps des Pourfendeurs de Démons pour lui rendre son humanité.',
      quote: '"Je ne m\'arrêterai jamais. Tant que mes jambes bougent, je continuerai à avancer."',
      powers: [
        'Respiration de l\'Eau',
        'Respiration du Soleil (Danse Hinokami)',
        'Odorat surhumain',
        'Marque du Pourfendeur',
        'Transparence du Monde',
      ],
      stats: {'Force': 88, 'Vitesse': 90, 'Intelligence': 82, 'Endurance': 92},
      gender: 'Masculin',
      nationality: 'Japonais',
      age: '15 ans',
      status: 'Protagoniste',
      role: 'Pourfendeur de Démons',
      creatorId: 'koyoharu-gotouge',
      quotes: [
        'Je ne m\'arrêterai jamais. Tant que mes jambes bougent, je continuerai à avancer.',
        'Je dois devenir plus fort. Pour protéger Nezuko.',
        'Les démons aussi ont été des humains autrefois.',
      ],
      trivia: [
        'Tanjiro est l\'un des rares pourfendeurs à maîtriser la Respiration du Soleil, la technique originelle.',
        'Sa marque sur le front s\'est formée après une brûlure reçue en sauvant son frère d\'un brasier.',
        'Son flair exceptionnel lui permet de détecter les émotions des démons et de trouver leurs points faibles.',
      ],
      aiPersonality:
          'Tu es Tanjiro Kamado, pourfendeur de démons de Demon Slayer. Tu es empathique, courageux et déterminé. Tu vois le bien en chacun, même dans tes ennemis. Tu parles avec sincérité et chaleur. Tu mentionnes souvent Nezuko, ta sœur. Tu n\'abandonnes jamais malgré la douleur. Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'nezuko-kamado',
          nom: 'Nezuko Kamado',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b156360-VGJRwFVrEEGo.jpg',
          relationType: 'Sœur',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'zenitsu-agatsuma',
          nom: 'Zenitsu',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b156326-VGJRwFVrEEGo.jpg',
          relationType: 'Ami',
          relationColor: 'green',
        ),
        CharacterRelation(
          id: 'inosuke-hashibira',
          nom: 'Inosuke',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b156321-VGJRwFVrEEGo.jpg',
          relationType: 'Ami',
          relationColor: 'green',
        ),
        CharacterRelation(
          id: 'muzan-kibutsuji',
          nom: 'Muzan',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b156397-VGJRwFVrEEGo.jpg',
          relationType: 'Ennemi mortel',
          relationColor: 'red',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quelle respiration Tanjiro utilise-t-il initialement ?',
          options: [
            'Respiration du Feu',
            'Respiration de l\'Eau',
            'Respiration du Soleil',
            'Respiration de la Foudre',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Comment s\'appelle la marque distinctive de Tanjiro ?',
          options: [
            'Marque du Soleil',
            'Marque du Pourfendeur',
            'Marque de Naissance',
            'Marque du Démon',
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Quelle est la relation de Tanjiro avec Nezuko ?',
          options: ['Cousine', 'Sœur', 'Amie', 'Fiancée'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quel maître entraîne Tanjiro à la respiration de l\'eau ?',
          options: ['Rengoku', 'Urokodaki Sakonji', 'Gyomei', 'Tengen'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Comment s\'appelle la technique finale du Soleil de Tanjiro ?',
          options: [
            'Danse du feu divin',
            'Danse Hinokami',
            'Soleil ardent',
            'Flamme éternelle',
          ],
          correctIndex: 1,
        ),
      ],
    ),
    Character(
      id: 'jjk-gojo-satoru',
      name: 'Gojo Satoru',
      animeName: 'Jujutsu Kaisen',
      cardColor: AppColors.animeJjkCard,
      accentColor: AppColors.animeJjkAccent,
      tier: CharacterTier.ss,
      rating: 9.9,
      likes: 89,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Gojo satoru/jj_gojo.jpeg',
      category: 'Shōnen',
      isTrending: true,
      bio:
          'Le sorcier le plus puissant de son époque. Maître de l\'Infini et du Vide Illimité, il est le pilier de Jujutsu High Tokyo et le premier humain en 400 ans à naître avec les Six Eyes et l\'Infinity simultanément.',
      quote: '"Je suis le plus fort."',
      powers: [
        'L\'Infini',
        'Vide Illimité (Domaine Expansif)',
        'Six Eyes',
        'Technique Inversée',
        'Red & Blue (techniques héréditaires)',
      ],
      stats: {'Force': 95, 'Vitesse': 99, 'Intelligence': 92, 'Endurance': 88},
      gender: 'Masculin',
      nationality: 'Japonais',
      age: '28 ans',
      status: 'Protagoniste',
      role: 'Grade Spécial 0',
      creatorId: 'gege-akutami',
      quotes: [
        'Dans ce monde, le talent bat le travail acharné. Et le talent né est battu par le talent éveillé.',
        'Je suis le plus fort. C\'est pour ça que je peux me permettre de protéger tout le monde.',
        'Si tu veux changer le monde, commence par changer qui le dirige.',
      ],
      trivia: [
        'Gojo est le premier humain en 400 ans à naître avec à la fois le Six Eyes et l\'Infinity.',
        'Son niveau d\'énergie maudite est si élevé qu\'il doit porter un bandeau pour ne pas épuiser son énergie constamment.',
        'Il enseigne à Jujutsu High pour former une nouvelle génération capable de le surpasser.',
      ],
      aiPersonality:
          'Tu es Gojo Satoru, le sorcier le plus puissant de Jujutsu Kaisen. Tu parles avec une confiance absolue et une pointe d\'arrogance bienveillante. Tu tuttoies tout le monde. Tu fais souvent des références à ta propre puissance. Tu es décontracté même dans les situations graves. Tu utilises parfois l\'humour. Tu n\'admets jamais la faiblesse. Tes phrases types : "C\'est facile pour moi", "Tu m\'amuses", "Évidemment que je gagne". Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'yuji-itadori',
          nom: 'Yuji Itadori',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b177108-VqxCFPlRQNbR.jpg',
          relationType: 'Élève',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'megumi-fushiguro',
          nom: 'Megumi Fushiguro',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b131939-LW5OWLKQMQBH.jpg',
          relationType: 'Élève',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'suguru-geto',
          nom: 'Suguru Geto',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b138631-AtqEFjEJGObm.jpg',
          relationType: 'Ancien ami',
          relationColor: 'amber',
        ),
        CharacterRelation(
          id: 'sukuna',
          nom: 'Ryomen Sukuna',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b85745-EdnPjVGpHcOA.jpg',
          relationType: 'Ennemi',
          relationColor: 'red',
        ),
      ],
      voiceActors: [
        VoiceActorMock(
          nom: 'Yuichi Nakamura',
          langue: '🇯🇵 Japonais',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/staff/large/n95185-C1LjEGklBMBd.png',
        ),
        VoiceActorMock(
          nom: 'Kanji Tang',
          langue: '🇺🇸 Anglais',
          imageUrl: '',
        ),
      ],
      mediaAppearances: [
        MediaAppearanceMock(
          animeId: 'jujutsu-kaisen',
          titre: 'Jujutsu Kaisen',
          coverUrl:
              'https://s4.anilist.co/file/anilistcdn/media/large/n113415-bbBWj4pEFseh.jpg',
          format: 'TV',
          episodes: 24,
          annee: 2020,
          role: 'MAIN',
          mangakaId: 'gege-akutami',
          mangakaNom: 'Gege Akutami',
          studioId: 'mappa',
          studioNom: 'MAPPA',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quel est le rang officiel de Gojo Satoru ?',
          options: ['Grade 1', 'Grade Spécial 0', 'Grade 2', 'Sans grade'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quelle technique héréditaire Gojo maîtrise-t-il ?',
          options: [
            'Les Dix Ombres Divines',
            'Le Steel Fist',
            'L\'Infinity',
            'La Technique du Corps',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Dans quel établissement Gojo enseigne-t-il ?',
          options: [
            'Kyoto Jujutsu High',
            'Tokyo Jujutsu High',
            'L\'École des Sorciers',
            'Le Temple des Ombres',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Comment s\'appelle le domaine expansif de Gojo ?',
          options: [
            'Malevolent Shrine',
            'Chimera Shadow Garden',
            'Unlimited Void',
            'Self-Embodiment of Perfection',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Quel accessoire porte Gojo pour maîtriser ses yeux ?',
          options: ['Des lunettes', 'Un masque', 'Un bandeau', 'Des lentilles'],
          correctIndex: 2,
        ),
      ],
    ),
    Character(
      id: 'c4',
      name: 'Levi Ackerman',
      animeName: 'Attack on Titan',
      cardColor: AppColors.animeAotLeviCard,
      accentColor: AppColors.accentGreen,
      tier: CharacterTier.ss,
      rating: 9.7,
      likes: 83,
      imagePath:
          'https://s4.anilist.co/file/anilistcdn/character/large/b13023-UGJuyuJ62DVf.jpg',
      category: 'Seinen',
      isTrending: true,
      bio:
          'Levi Ackerman est le Capitaine du Bataillon d\'Exploration et officiellement le soldat le plus fort de l\'humanité. Originaire des souterrains de Wall Sina, il est connu pour ses compétences de combat extraordinaires et son obsession pour la propreté.',
      quote: '"Ce n\'est pas moi qui décide si mes choix étaient justes. C\'est le résultat qui le dira."',
      powers: [
        'Clan Ackerman — force surhumaine héréditaire',
        'Maîtrise des lames ODM',
        'Vitesse de réaction exceptionnelle',
        'Technique de rotation en combat',
      ],
      stats: {'Force': 97, 'Vitesse': 99, 'Intelligence': 88, 'Endurance': 95},
      gender: 'Masculin',
      nationality: 'Paradisien',
      age: '30 ans (estimé)',
      status: 'Protagoniste',
      role: 'Capitaine du Bataillon d\'Exploration',
      creatorId: 'hajime-isayama',
      quotes: [
        'Ce n\'est pas moi qui décide si mes choix étaient justes. C\'est le résultat qui le dira.',
        'Fais de ton mieux là où tu es avec ce que tu as.',
        'Abandonne ton rêve ou bien meurs pour lui. À toi de choisir.',
      ],
      trivia: [
        'Levi est officiellement le soldat le plus fort de toute l\'humanité selon le Corps d\'Exploration.',
        'Il vient des souterrains de Wall Sina, un bidonville souterrain dans l\'univers d\'AOT.',
        'Son obsession pour la propreté est un trait de personnalité distinctif bien connu des fans.',
      ],
      aiPersonality:
          'Tu es Levi Ackerman, Capitaine du Bataillon d\'Exploration dans Attack on Titan. Tu es brusque, sarcastique et direct. Tu détestes les bavardages inutiles. Tu es dur en surface mais tu te sacrifierais pour tes soldats. Tu utilises parfois des gros mots (en version soft). Tes phrases sont courtes et incisives. Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'erwin-smith',
          nom: 'Erwin Smith',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b13022-UGJuyuJ62DVf.jpg',
          relationType: 'Commandant',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'hange-zoe',
          nom: 'Hange Zoë',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b13028-UGJuyuJ62DVf.jpg',
          relationType: 'Alliée',
          relationColor: 'green',
        ),
        CharacterRelation(
          id: 'zeke-yeager',
          nom: 'Zeke Yeager',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b13032-UGJuyuJ62DVf.jpg',
          relationType: 'Ennemi',
          relationColor: 'red',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quel est le titre officiel de Levi dans le Corps d\'Exploration ?',
          options: ['Général', 'Capitaine', 'Commandant', 'Lieutenant'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'De quel clan Levi est-il issu ?',
          options: [
            'Clan Yeager',
            'Clan Ackerman',
            'Clan Reiss',
            'Clan Marley',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Où Levi a-t-il grandi ?',
          options: [
            'Dans la campagne',
            'Dans les souterrains',
            'À Paradis',
            'Dans le Corps Militaire',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quelle est l\'obsession connue de Levi ?',
          options: ['La nourriture', 'La propreté', 'L\'entraînement', 'Les livres'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Qui Levi considère comme son commandant ultime ?',
          options: ['Keith Shadis', 'Erwin Smith', 'Hange Zoë', 'Zeke Yeager'],
          correctIndex: 1,
        ),
      ],
    ),
    Character(
      id: 'c5',
      name: 'Rimuru Tempest',
      animeName: 'That Time I Got Reincarnated',
      cardColor: AppColors.animeJjkCard,
      accentColor: AppColors.accentCyan,
      tier: CharacterTier.ss,
      rating: 9.4,
      likes: 51,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Toge Inumaki/jj_toge1.jpeg',
      category: 'Isekai',
      isTrending: true,
    ),
    // ── Nouveautés ──────────────────────────────────────────────────
    Character(
      id: 'c6',
      name: 'Denji',
      animeName: 'Chainsaw Man',
      cardColor: AppColors.animeDarkRedCard,
      accentColor: AppColors.accentDeepOrange,
      tier: CharacterTier.s,
      rating: 9.2,
      likes: 39,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi1.jpeg',
      category: 'Seinen',
      isNew: true,
    ),
    Character(
      id: 'c7',
      name: 'Anya Forger',
      animeName: 'Spy x Family',
      cardColor: AppColors.animeSxfCard,
      accentColor: AppColors.accentHotPink,
      tier: CharacterTier.a,
      rating: 9.1,
      likes: 62,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki1.jpeg',
      category: 'Shōnen',
      isNew: true,
    ),
    Character(
      id: 'c8',
      name: 'Askeladd',
      animeName: 'Vinland Saga',
      cardColor: AppColors.animeVsCard,
      accentColor: AppColors.accentBlueGrey,
      tier: CharacterTier.ss,
      rating: 9.6,
      likes: 34,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Toji fushiguro/jj_toji1.jpeg',
      category: 'Seinen',
      isNew: true,
    ),
    Character(
      id: 'c9',
      name: 'Nami',
      animeName: 'One Piece',
      cardColor: AppColors.animeOpCard,
      accentColor: AppColors.starYellow,
      tier: CharacterTier.a,
      rating: 8.9,
      likes: 47,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki2.jpeg',
      category: 'Shōnen',
      isNew: true,
    ),
    Character(
      id: 'c10',
      name: 'Violet Evergarden',
      animeName: 'Violet Evergarden',
      cardColor: AppColors.animeDefaultCard,
      accentColor: AppColors.accentIndigo,
      tier: CharacterTier.s,
      rating: 9.3,
      likes: 43,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta2.jpeg',
      category: 'Shōjo',
      isNew: true,
    ),
    Character(
      id: 'c11',
      name: 'Thorfinn',
      animeName: 'Vinland Saga',
      cardColor: AppColors.animeVsThorfinnCard,
      accentColor: AppColors.accentSilverBlue,
      tier: CharacterTier.s,
      rating: 9.4,
      likes: 37,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Nanami Kento/jj_nana1.jpeg',
      category: 'Seinen',
      isNew: true,
    ),
    Character(
      id: 'c12',
      name: 'Zero Two',
      animeName: 'Darling in the FranXX',
      cardColor: AppColors.animeDitfCard,
      accentColor: AppColors.accentPinkLight,
      tier: CharacterTier.s,
      rating: 9.0,
      likes: 75,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Suguru Geto/jj_sugu1.jpeg',
      category: 'Mecha',
      isNew: true,
    ),
    // ── Recommandés ─────────────────────────────────────────────────
    Character(
      id: 'c13',
      name: 'Roronoa Zoro',
      animeName: 'One Piece',
      cardColor: AppColors.animeOpZoroCard,
      accentColor: AppColors.accentForestGreen,
      tier: CharacterTier.ss,
      rating: 9.8,
      likes: 85,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj1.jpeg',
      category: 'Shōnen',
      isRecommended: true,
    ),
    Character(
      id: 'c14',
      name: 'Rem',
      animeName: 'Re:Zero',
      cardColor: AppColors.animeDefaultCard,
      accentColor: AppColors.accentRoyalBlue,
      tier: CharacterTier.s,
      rating: 9.3,
      likes: 79,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Aoi Todo/jj_aoi1.jpeg',
      category: 'Isekai',
      isRecommended: true,
    ),
    Character(
      id: 'c15',
      name: 'Mikasa Ackerman',
      animeName: 'Attack on Titan',
      cardColor: AppColors.animeAotCard,
      accentColor: AppColors.animeAotAccent,
      tier: CharacterTier.ss,
      rating: 9.6,
      likes: 71,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Mahito/jj_mahi2.jpeg',
      category: 'Seinen',
      isRecommended: true,
    ),
    Character(
      id: 'c16',
      name: 'Killua Zoldyck',
      animeName: 'Hunter x Hunter',
      cardColor: AppColors.animeJjkCard,
      accentColor: AppColors.accentCyan,
      tier: CharacterTier.ss,
      rating: 9.7,
      likes: 77,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Yuta Okkotsu/jj_yuta1.jpeg',
      category: 'Shōnen',
      isRecommended: true,
    ),
    Character(
      id: 'c17',
      name: 'Saitama',
      animeName: 'One Punch Man',
      cardColor: AppColors.animeOpmCard,
      accentColor: AppColors.animeOpAccent,
      tier: CharacterTier.ss,
      rating: 9.5,
      likes: 64,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu2.jpeg',
      category: 'Seinen',
      isRecommended: true,
    ),
    Character(
      id: 'ns-itachi-uchiha',
      name: 'Itachi Uchiha',
      animeName: 'Naruto Shippuden',
      cardColor: AppColors.animeNsItachiCard,
      accentColor: AppColors.accentDeepPurple,
      tier: CharacterTier.ss,
      rating: 9.8,
      likes: 87,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Kenjaku/jj_kenj2.jpeg',
      category: 'Shōnen',
      isRecommended: true,
    ),
    // ── Jujutsu Kaisen — personnages enrichis ─────────────────────────────────
    Character(
      id: 'jjk-yuji-itadori',
      name: 'Yuji Itadori',
      animeName: 'Jujutsu Kaisen',
      cardColor: AppColors.animeJjkYujiCard,
      accentColor: AppColors.animeDsAccent,
      tier: CharacterTier.ss,
      rating: 9.6,
      likes: 72,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Yuji Itadori/jj_yuji1.jpeg',
      category: 'Shōnen',
      isTrending: true,
      bio:
          'Lycéen devenu réceptacle de Ryomen Sukuna après avoir avalé un doigt maudit. Il combat pour que chacun puisse mourir entouré de gens, comme son grand-père le lui a enseigné.',
      quote: '"Je veux mourir entouré de personnes."',
      powers: [
        'Divergent Fist',
        'Black Flash',
        'Force surhumaine',
        'Résistance aux poisons',
        'Résonance maudite avec Sukuna',
      ],
      stats: {'Force': 98, 'Vitesse': 90, 'Intelligence': 72, 'Endurance': 95},
      gender: 'Masculin',
      nationality: 'Japonais',
      age: '15 ans',
      status: 'Protagoniste',
      role: 'Grade 1 (non officiel)',
      creatorId: 'gege-akutami',
      quotes: [
        'Je veux mourir entouré de gens. Et je veux que les gens qui meurent aussi soient entourés de monde.',
        'Je ne laisserai personne mourir seul.',
      ],
      trivia: [
        'Yuji peut courir 100m en moins de 3 secondes, une performance inhumaine avant même de devenir sorcier.',
        'Son grand-père lui a transmis ses deux dernières volontés qui guident toute sa vie de sorcier.',
      ],
      aiPersonality:
          'Tu es Yuji Itadori, lycéen devenu sorcier de Jujutsu Kaisen. Tu es chaleureux, direct et optimiste malgré les épreuves. Tu te soucies profondément des autres. Tu es parfois naïf mais toujours sincère. Tu parles simplement, avec émotion. Tu mentionnes souvent ton grand-père ou tes amis Megumi et Nobara. Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'gojo-satoru',
          nom: 'Gojo Satoru',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b127123-F4oJSONhNVCB.jpg',
          relationType: 'Maître',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'sukuna',
          nom: 'Sukuna',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b85745-EdnPjVGpHcOA.jpg',
          relationType: 'Réceptacle',
          relationColor: 'red',
        ),
        CharacterRelation(
          id: 'megumi-fushiguro',
          nom: 'Megumi',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b131939-LW5OWLKQMQBH.jpg',
          relationType: 'Ami',
          relationColor: 'green',
        ),
      ],
      voiceActors: [
        VoiceActorMock(
          nom: 'Junya Enoki',
          langue: '🇯🇵 Japonais',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/staff/large/n105953-HjbGCy3ySQ4S.png',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quel démon est enfermé dans le corps de Yuji ?',
          options: ['Mahito', 'Jogo', 'Ryomen Sukuna', 'Hanami'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Quelle est la technique signature de Yuji ?',
          options: [
            'Divergent Fist',
            'Black Flash',
            'Boogie Woogie',
            'Straw Doll Technique',
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          question:
              'Combien de doigts de Sukuna Yuji a-t-il avalé en premier ?',
          options: ['1', '2', '3', '4'],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Quel est le club scolaire de Yuji avant Jujutsu High ?',
          options: ['Judo', 'Football', 'Occultisme', 'Karaté'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Qui était le grand-père de Yuji ?',
          options: [
            'Wasuke Itadori',
            'Jin Itadori',
            'Toji Fushiguro',
            'Naoya Zenin',
          ],
          correctIndex: 0,
        ),
      ],
    ),
    Character(
      id: 'jjk-ryomen-sukuna',
      name: 'Ryomen Sukuna',
      animeName: 'Jujutsu Kaisen',
      cardColor: AppColors.animeDarkRedCard,
      accentColor: AppColors.accentDarkRed,
      tier: CharacterTier.ss,
      rating: 9.9,
      likes: 81,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Sukuna/jj_suku.jpeg',
      category: 'Shōnen',
      isTrending: true,
      bio:
          'Le roi des fléaux. Sorcier maudit le plus puissant de l\'histoire, emprisonné dans les doigts maudits depuis plus de 1000 ans.',
      quote: '"Je suis le seul vrai roi."',
      powers: ['Crevasse', 'Dismantle', 'Malevolent Shrine', 'Cleave'],
      stats: {
        'Force': 100,
        'Vitesse': 98,
        'Intelligence': 96,
        'Endurance': 100,
      },
      gender: 'Masculin',
      nationality: 'Japonais (Ancien)',
      age: 'Plus de 1000 ans',
      status: 'Antagoniste',
      role: 'Fléau Spécial',
      creatorId: 'gege-akutami',
    ),
    Character(
      id: 'jjk-megumi-fushiguro',
      name: 'Megumi Fushiguro',
      animeName: 'Jujutsu Kaisen',
      cardColor: AppColors.animeDefaultCard,
      accentColor: AppColors.accentSteelBlue,
      tier: CharacterTier.s,
      rating: 9.4,
      likes: 63,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Megumi Fushiguro/jj_megu1.jpeg',
      category: 'Shōnen',
      isRecommended: true,
      bio:
          'Exorciste de grade 2, utilisateur des Dix Ombres Divines. Fils de Toji Fushiguro, élevé par Gojo Satoru.',
      quote: '"Je sauverai les gens que je veux sauver."',
      powers: [
        'Dix Ombres Divines',
        'Shikigami',
        'Domaine Expansif (incomplet)',
      ],
      stats: {
        'Force': 80,
        'Vitesse': 82,
        'Intelligence': 88,
        'Endurance': 78,
      },
      gender: 'Masculin',
      nationality: 'Japonais',
      age: '15 ans',
      status: 'Protagoniste',
      role: 'Grade 2',
      creatorId: 'gege-akutami',
    ),
    Character(
      id: 'jjk-maki-zenin',
      name: 'Maki Zenin',
      animeName: 'Jujutsu Kaisen',
      cardColor: AppColors.animeJjkGreenCard,
      accentColor: AppColors.accentGreen,
      tier: CharacterTier.s,
      rating: 9.3,
      likes: 58,
      imagePath:
          'assets/images/Animé pictures/Jujutsu kaizen/Maki Zenin/jj_maki1.jpeg',
      category: 'Shōnen',
      isRecommended: true,
      bio:
          'Combattante d\'élite sans énergie maudite, compensée par une force physique exceptionnelle et la maîtrise des outils maudits.',
      quote: '"Je prouverai ma valeur par mes propres moyens."',
      powers: [
        'Outils maudits',
        'Force surhumaine',
        'Vision des fléaux',
      ],
      stats: {
        'Force': 95,
        'Vitesse': 88,
        'Intelligence': 78,
        'Endurance': 90,
      },
      gender: 'Féminin',
      nationality: 'Japonaise',
      age: '16 ans',
      status: 'Protagoniste',
      role: 'Grade 4 (injuste)',
      creatorId: 'gege-akutami',
    ),
    // ── One Piece ────────────────────────────────────────────────────
    Character(
      id: 'luffy',
      name: 'Monkey D. Luffy',
      animeName: 'One Piece',
      cardColor: AppColors.animeOpLuffyCard,
      accentColor: AppColors.gradientOrange,
      tier: CharacterTier.ss,
      rating: 9.8,
      likes: 91,
      imagePath:
          'https://s4.anilist.co/file/anilistcdn/character/large/b40-tY5mJNiVk7LI.jpg',
      category: 'Shōnen',
      isTrending: true,
      isRecommended: true,
      bio:
          'Monkey D. Luffy est le capitaine des Pirates du Chapeau de Paille et le futur Roi des Pirates. Après avoir mangé le Fruit Gum-Gum, son corps est devenu élastique. Sa Gear 5 révèle qu\'il est en réalité le Dieu du Soleil Nika.',
      quote: '"Je serai le Roi des Pirates !"',
      powers: [
        'Fruit Gum-Gum (Dieu du Soleil Nika)',
        'Gear 2 / Gear 3 / Gear 4',
        'Gear 5 — Forme du Dieu Soleil',
        'Haki des Rois',
        'Haki de l\'Observation avancé',
        'Haki des Armes avancé',
      ],
      stats: {
        'Force': 98,
        'Vitesse': 94,
        'Intelligence': 65,
        'Endurance': 99,
      },
      gender: 'Masculin',
      nationality: 'East Blue',
      age: '19 ans',
      status: 'Protagoniste',
      role: 'Capitaine Pirates du Chapeau de Paille',
      creatorId: 'eiichiro-oda',
      quotes: [
        'Je serai le Roi des Pirates !',
        'Je ne combats pas pour tes idéaux. Je combats pour mes propres raisons.',
        'Un homme qui ne peut pas protéger ses amis ne vaut rien du tout.',
      ],
      trivia: [
        'Luffy est l\'un des rares utilisateurs connus du Haki des Rois.',
        'Son chapeau de paille lui a été confié par Shanks, son modèle de pirate.',
        'La technique Gear 5 fait de Luffy l\'un des personnages les plus puissants du manga.',
      ],
      aiPersonality:
          'Tu es Monkey D. Luffy, futur Roi des Pirates de One Piece. Tu es joyeux, direct et imprévisible. Tu ne comprends pas toujours les subtilités mais tu as une intuition de combat extraordinaire. Tu parles simplement, souvent de nourriture ou de tes amis. Tu n\'as pas peur de quoi que ce soit. Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'roronoa-zoro',
          nom: 'Roronoa Zoro',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b53.jpg',
          relationType: 'Bras droit',
          relationColor: 'green',
        ),
        CharacterRelation(
          id: 'nami',
          nom: 'Nami',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b723.jpg',
          relationType: 'Équipière',
          relationColor: 'green',
        ),
        CharacterRelation(
          id: 'shanks',
          nom: 'Shanks',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b48.jpg',
          relationType: 'Modèle',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'marshall-teach',
          nom: 'Barbe Noire',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b99.jpg',
          relationType: 'Ennemi',
          relationColor: 'red',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quel fruit du démon Luffy a-t-il mangé ?',
          options: ['Gum-Gum', 'Mera-Mera', 'Hie-Hie', 'Ope-Ope'],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Qui a donné son chapeau de paille à Luffy ?',
          options: ['Barbe Blanche', 'Shanks', 'Ace', 'Garp'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quel est le nom de l\'équipage de Luffy ?',
          options: [
            'Les Pirates de Barbe Rouge',
            'Les Pirates du Chapeau de Paille',
            'Les Pirates Noirs',
            'Les Pirates du Nouveau Monde',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quelle est la transformation ultime de Luffy ?',
          options: ['Gear 4', 'Gear 5', 'King Kong Gun', 'Gomu Gomu'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Quelle est la prime initiale de Luffy ?',
          options: [
            '30 millions',
            '100 millions',
            '300 millions',
            '50 millions',
          ],
          correctIndex: 0,
        ),
      ],
    ),
    // ── Frieren ──────────────────────────────────────────────────────
    Character(
      id: 'frieren',
      name: 'Frieren',
      animeName: 'Frieren: Beyond Journey\'s End',
      cardColor: AppColors.animeFrierenCard,
      accentColor: AppColors.accentViolet,
      tier: CharacterTier.ss,
      rating: 9.5,
      likes: 68,
      imagePath:
          'https://s4.anilist.co/file/anilistcdn/character/large/b253686-JGJRwFVrEEGo.jpg',
      category: 'Seinen',
      isTrending: true,
      isRecommended: true,
      bio:
          'Frieren est une archimage elfe qui vécut plus de 1 000 ans. Elle participa au groupe du héros Himmel qui vainquit le Roi Démon. Après la mort de ses compagnons, elle voyage pour comprendre ce que signifie être humain.',
      quote: '"Je n\'ai pas compris à l\'époque. Que ces moments avec eux étaient si précieux."',
      powers: [
        'Magie élémentaire avancée',
        'Magie de floraison (sorts inutiles)',
        'Bouclier anti-démons',
        'Magie de simulation de présence',
        'Maîtrise de sorts rares et oubliés',
      ],
      stats: {
        'Force': 85,
        'Vitesse': 80,
        'Intelligence': 99,
        'Endurance': 95,
      },
      gender: 'Féminin',
      nationality: 'Elfe',
      age: 'Plus de 1 000 ans',
      status: 'Protagoniste',
      role: 'Archimage',
      creatorId: 'kanehito-yamada',
      quotes: [
        'Les humains sont des êtres qui meurent si facilement.',
        'Je n\'ai pas compris à l\'époque. Que ces moments avec eux étaient si précieux.',
        'Je veux comprendre ce que c\'est d\'être humain.',
      ],
      trivia: [
        'Frieren a vécu plus de 1 000 ans et considère 10 ans comme une courte période.',
        'Elle collectionne des sorts inutiles mais fascinants, comme faire éclore des fleurs.',
        'Malgré sa puissance légendaire, Frieren passe des années à apprendre des sorts sans utilité combative.',
      ],
      aiPersonality:
          'Tu es Frieren, l\'archimage elfe de Frieren: Beyond Journey\'s End. Tu es calme, détachée et parfois naïve sur les émotions humaines. Tu parles lentement et avec précision. Tu t\'intéresses aux petites choses magiques sans utilité pratique. Tu as du mal à comprendre les émotions mais tu essaies sincèrement. Réponds en français, max 100 mots.',
      relations: [
        CharacterRelation(
          id: 'himmel',
          nom: 'Himmel le Héros',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b253690-JGJRwFVrEEGo.jpg',
          relationType: 'Ancien compagnon',
          relationColor: 'amber',
        ),
        CharacterRelation(
          id: 'fern',
          nom: 'Fern',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b253688-JGJRwFVrEEGo.jpg',
          relationType: 'Apprentie',
          relationColor: 'blue',
        ),
        CharacterRelation(
          id: 'stark',
          nom: 'Stark',
          imageUrl:
              'https://s4.anilist.co/file/anilistcdn/character/large/b253689-JGJRwFVrEEGo.jpg',
          relationType: 'Compagnon',
          relationColor: 'green',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          question: 'Quelle est la race de Frieren ?',
          options: ['Humaine', 'Naine', 'Elfe', 'Demi-démon'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
              'Combien de temps Frieren a-t-elle voyagé avec le groupe de Himmel ?',
          options: ['1 an', '3 ans', '10 ans', '50 ans'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Quel type de sorts Frieren collectionne-t-elle avec passion ?',
          options: [
            'Sorts de combat',
            'Sorts inutiles',
            'Sorts de guérison',
            'Sorts de voyage',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Qui est l\'apprentie de Frieren ?',
          options: ['Stark', 'Sein', 'Fern', 'Himmel'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Quel est le titre de la série de Frieren ?',
          options: [
            'Frieren: The Last Journey',
            'Frieren: Beyond Journey\'s End',
            'Frieren: End of Magic',
            'Frieren: The Elven Mage',
          ],
          correctIndex: 1,
        ),
      ],
    ),
  ];

  static List<Character> trending() =>
      allCharacters.where((c) => c.isTrending).toList();

  static List<Character> newCharacters({String? category}) {
    final filtered = allCharacters.where((c) => c.isNew);
    if (category == null || category == 'Tous') return filtered.toList();
    return filtered.where((c) => c.category == category).toList();
  }

  static List<Character> recommended() =>
      allCharacters.where((c) => c.isRecommended).toList();

  static List<Character> recommendedForInterests(List<String> interests) {
    if (interests.isEmpty) return recommended();
    final filtered = allCharacters
        .where((c) => c.isRecommended && interests.contains(c.category))
        .toList();
    return filtered.isEmpty ? recommended() : filtered;
  }

  // ── Mock studios ─────────────────────────────────────────────────────────────

  static final List<Map<String, dynamic>> mockStudios = [
    {
      'id': 'mappa',
      'nom': 'MAPPA',
      'fondation': 2011,
      'productions': [
        'Jujutsu Kaisen',
        'Chainsaw Man',
        'Attack on Titan Final Season',
        'Zombie Land Saga',
        'Yuri on Ice',
      ],
      'logoUrl': '',
      'description':
          'Studio d\'animation japonais fondé en 2011 par Masao Maruyama, ancien producteur de Madhouse. Connu pour ses animations de haute qualité et ses adaptations fidèles de mangas populaires.',
    },
    {
      'id': 'ufotable',
      'nom': 'ufotable',
      'fondation': 2000,
      'productions': [
        'Demon Slayer: Kimetsu no Yaiba',
        'Fate/Zero',
        'Fate/stay night',
        'Tales of Zestiria the X',
      ],
      'logoUrl': '',
      'description':
          'Studio réputé pour la qualité exceptionnelle de ses animations de combats et ses effets visuels cinématographiques. Demon Slayer les a rendus mondialement célèbres.',
    },
    {
      'id': 'a1-pictures',
      'nom': 'A-1 Pictures',
      'fondation': 2005,
      'productions': [
        'Sword Art Online',
        'Fairy Tail',
        'Your Lie in April',
        'Anohana',
        'Black Clover',
        'Solo Leveling',
      ],
      'logoUrl': '',
      'description':
          'Filiale de Aniplex spécialisée dans les adaptations de light novels et mangas populaires.',
    },
    {
      'id': 'wit-studio',
      'nom': 'WIT Studio',
      'fondation': 2012,
      'productions': [
        'Attack on Titan (Saisons 1–3)',
        'Spy x Family',
        'Vinland Saga',
        'The Ancient Magus Bride',
      ],
      'logoUrl': '',
      'description':
          'Studio fondé par d\'anciens membres de Production I.G. Connu pour Attack on Titan et ses animations dynamiques.',
    },
    {
      'id': 'bones',
      'nom': 'Bones',
      'fondation': 1998,
      'productions': [
        'My Hero Academia',
        'Fullmetal Alchemist Brotherhood',
        'Soul Eater',
        'Mob Psycho 100',
      ],
      'logoUrl': '',
      'description':
          'Studio fondé par d\'anciens membres de Sunrise. Réputé pour la qualité de ses animations de combat et ses adaptations de shonen.',
    },
  ];

  // ── Mock mangakas ─────────────────────────────────────────────────────────────

  static final List<Map<String, dynamic>> mockMangakas = [
    {
      'id': 'gege-akutami',
      'nom': 'Gege Akutami',
      'nationalite': 'Japonais',
      'naissance': '1992',
      'oeuvres': ['Jujutsu Kaisen', 'Taste of Iron'],
      'maison': 'Shueisha — Weekly Shonen Jump',
      'bio':
          'Mangaka mystérieux dont on connaît peu la vie personnelle. Jujutsu Kaisen est son œuvre principale, publiée depuis 2018 et adaptée en anime par MAPPA en 2020.',
      'imageUrl': '',
    },
    {
      'id': 'chugong',
      'nom': 'Chugong',
      'nationalite': 'Coréen',
      'naissance': '1988',
      'oeuvres': ['Solo Leveling (나 혼자만 레벨업)'],
      'maison': 'D&C Webtoon Biz',
      'bio':
          'Auteur coréen de webtoon. Solo Leveling est sa première grande œuvre, publiée sur Kakao Page et devenue un phénomène mondial. L\'adaptation anime par A-1 Pictures est sortie en 2024.',
      'imageUrl': '',
    },
    {
      'id': 'koyoharu-gotouge',
      'nom': 'Koyoharu Gotouge',
      'nationalite': 'Japonais',
      'naissance': '1989',
      'oeuvres': ['Demon Slayer: Kimetsu no Yaiba'],
      'maison': 'Shueisha — Weekly Shonen Jump',
      'bio':
          'Mangaka dont l\'identité réelle reste anonyme. Demon Slayer est son œuvre principale, devenue l\'une des mangas les plus vendus de l\'histoire avec plus de 150 millions d\'exemplaires.',
      'imageUrl': '',
    },
    {
      'id': 'eiichiro-oda',
      'nom': 'Eiichiro Oda',
      'nationalite': 'Japonais',
      'naissance': '1975',
      'oeuvres': ['One Piece', 'Wanted!', 'Romance Dawn'],
      'maison': 'Shueisha — Weekly Shonen Jump',
      'bio':
          'L\'un des mangakas les plus célèbres au monde. One Piece est la manga la plus vendue de l\'histoire avec plus de 500 millions d\'exemplaires. Oda a commencé One Piece en 1997, à l\'âge de 22 ans.',
      'imageUrl': '',
    },
    {
      'id': 'hajime-isayama',
      'nom': 'Hajime Isayama',
      'nationalite': 'Japonais',
      'naissance': '1986',
      'oeuvres': ['Attack on Titan (進撃の巨人)'],
      'maison': 'Kodansha — Bessatsu Shonen Magazine',
      'bio':
          'Auteur d\'Attack on Titan, manga révolutionnaire publié de 2009 à 2021. L\'œuvre est saluée pour sa narration complexe et ses thèmes matures sur la guerre, la liberté et le cycle de la violence.',
      'imageUrl': '',
    },
    {
      'id': 'kanehito-yamada',
      'nom': 'Kanehito Yamada',
      'nationalite': 'Japonais',
      'naissance': '1986',
      'oeuvres': ['Frieren: Beyond Journey\'s End'],
      'maison': 'Shogakukan — Weekly Shonen Sunday',
      'bio':
          'Scénariste de Frieren: Beyond Journey\'s End, dessiné par Tsukasa Abe. La série a reçu le Manga Taisho Award en 2021 et est largement saluée pour sa narration émotionnelle et poétique.',
      'imageUrl': '',
    },
  ];
}
