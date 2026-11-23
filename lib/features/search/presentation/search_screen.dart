import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/image_prefetcher.dart';
import '../../../core/utils/search_match.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/models/anime_entry.dart';
import '../../../core/models/character.dart';
import '../../../core/models/creator_entry.dart';
import '../../../core/providers/anilist_providers.dart';
import '../../../core/providers/otadex_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';
import '../../../core/utils/format_likes.dart';
import '../../../core/widgets/otadex_image.dart';

class RechercheScreen extends ConsumerStatefulWidget {
  const RechercheScreen({super.key});

  @override
  ConsumerState<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends ConsumerState<RechercheScreen>
    with TickerProviderStateMixin {
  List<Character> _localChars = [];
  List<AnimeEntry> _localAnimes = [];
  List<CreatorEntry> _localCreators = [];
  // ── Indice animé de la barre de recherche ────────────────────────────
  Timer? _hintTimer;
  int _hintIndex = 0;

  /// Indices : le texte habituel, puis des noms de personnages à essayer.
  List<String> get _hints {
    final base = AppStrings.of(context).searchHint;
    final names = <String>[];
    for (var i = 0; i < _localChars.length && names.length < 5; i++) {
      final c = _localChars[(i + _coverSeed) % _localChars.length];
      final first = c.name.split(' ').first;
      if (first.length >= 3 && !names.contains(first)) names.add(first);
    }
    return [base, for (final n in names) 'Essaie : $n…'];
  }

  void _startHintTimer() {
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && !_isFocused && _query.isEmpty) {
        setState(() => _hintIndex++);
      }
    });
  }

  // ── Controllers ──────────────────────────────────────────────────────
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  // ── Speech ────────────────────────────────────────────────────────────
  final SpeechToText _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _speechInitializing = false;
  // true après un échec d'initialisation (micro refusé / service absent) :
  // l'icône passe en grisé, mais un nouveau tap retente (nouvelle demande).
  bool _speechFailed = false;
  bool _isListening = false;

  // ── State ─────────────────────────────────────────────────────────────
  String _query = '';
  bool _isFocused = false;
  bool _submitted = false;
  int _selectedFilter = 0;
  String? _selectedSubFilter;
  List<Character> _anilistSearchResults = [];
  List<String> _recentSearches = [];

  // ── Animation controllers ─────────────────────────────────────────────
  late AnimationController _cancelCtrl;
  late Animation<Offset> _cancelSlide;
  late Animation<double> _cancelFade;

  final int _coverSeed = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // ── Static data ───────────────────────────────────────────────────────
  // Pour ajouter une catégorie : 1) AppColors.catXxxC1/C2 dans app_colors.dart
  //   2) Ajouter ici dans _subFilters et _categories
  //   3) Ajouter dans _categoryForAnime() dans firestore_character_service.dart
  static const _categories = [
    _Category('SHŌNEN', 'Shōnen', 'Action · Aventure', '⚡',
        AppColors.catShonenC1, AppColors.catShonenC2),
    _Category('SEINEN', 'Seinen', 'Adulte · Psychologique', '✒️',
        AppColors.catSeinenC1, AppColors.catSeinenC2),
    _Category('SPORT', 'Sport', 'Compétition · Dépassement', '🏀',
        AppColors.catSportC1, AppColors.catSportC2),
  ];

  // ── Computed ──────────────────────────────────────────────────────────
  bool get _showSuggestions => _isFocused && _query.isNotEmpty;
  bool get _showResults =>
      (_submitted || _selectedSubFilter != null) && !_isFocused;

  // ── Suggestions « as-you-type » ──────────────────────────────────────
  // Dès [_minSuggestChars] lettres, on propose des personnages (avec portrait),
  // quelques animés et créateurs, du plus pertinent au moins pertinent. Pensé
  // pour qui ne connaît pas le nom complet : « kil » ressort Killua, « zol »
  // aussi (le début de n'importe quel mot du nom compte).
  static const _minSuggestChars = 2;
  static const _maxCharSuggestions = 6;

  List<_Suggestion> get _suggestions {
    final q = _query.trim();
    if (q.length < _minSuggestChars) return [];

    // Personnages : base locale + résultats AniList déjà arrivés (sans doublon).
    final seen = <String>{};
    final pool = [
      for (final c in [..._localChars, ..._anilistSearchResults])
        if (seen.add(c.id)) c,
    ];
    final scored = <(int, Character)>[];
    for (final c in pool) {
      final best = _charScore(c, q);
      if (best != -1) scored.add((best, c));
    }
    scored.sort((a, b) {
      final byScore = a.$1.compareTo(b.$1);
      return byScore != 0
          ? byScore
          : a.$2.name.toLowerCase().compareTo(b.$2.name.toLowerCase());
    });

    final results = <_Suggestion>[
      for (final (_, c) in scored.take(_maxCharSuggestions))
        _Suggestion(c.name, 'Personnage',
            subtitle: c.animeName, imagePath: c.imagePath, character: c),
    ];

    final animes = _localAnimes
        .where((a) => matchScore(a.name, q) != -1)
        .toList()
      ..sort((a, b) => matchScore(a.name, q).compareTo(matchScore(b.name, q)));
    for (final a in animes.take(2)) {
      results.add(_Suggestion(a.name, 'Animé', subtitle: a.studio, anime: a));
    }

    for (final c
        in _localCreators.where((c) => matchScore(c.name, q) != -1).take(1)) {
      results.add(_Suggestion(c.name, 'Créateur'));
    }
    return results;
  }

  /// Ouvre directement la fiche proposée (au lieu de relancer une recherche).
  void _openSuggestion(_Suggestion s) {
    if (s.character != null) {
      _saveQuery(s.text);
      _focusNode.unfocus();
      ImagePrefetcher.prefetchCharacterImages(context, s.character!);
      context.push('/character/${s.character!.id}');
    } else if (s.anime != null) {
      _saveQuery(s.text);
      _focusNode.unfocus();
      context.push('/anime/${s.anime!.id}');
    } else {
      _selectSuggestion(s.text);
    }
  }

  List<Character> get _filteredCharacters {
    final typeFilter = _selectedFilter == 0 || _selectedFilter == 1;
    if (!typeFilter) return [];

    // When AniList results are available, use them (query >= 2 chars)
    if (_query.length >= 2 && _anilistSearchResults.isNotEmpty) {
      return _anilistSearchResults
          .where((c) =>
              _selectedSubFilter == null || c.category == _selectedSubFilter)
          .toList();
    }

    // Base locale (tout le catalogue une fois chargé), avec tolérance aux
    // fautes : « kiotaka » retrouve « Kiyotaka ». Les correspondances fautives
    // ne s'affichent que s'il n'y a aucune correspondance exacte.
    final q = _query.trim();
    final matched = <(int, Character)>[];
    for (final c in _localChars) {
      if (_selectedSubFilter != null && c.category != _selectedSubFilter) {
        continue;
      }
      if (q.isEmpty) {
        matched.add((0, c));
        continue;
      }
      final s = _charScore(c, q);
      if (s != -1) matched.add((s, c));
    }
    if (q.isEmpty) return matched.map((m) => m.$2).toList();
    final exact = matched.where((m) => m.$1 < 4).toList();
    final kept = exact.isNotEmpty ? exact : matched;
    kept.sort((a, b) => a.$1.compareTo(b.$1));
    return kept.map((m) => m.$2).toList();
  }

  /// Meilleur score d'un personnage pour la saisie : nom, puis alias, puis
  /// titre de l'animé (taper « hunter » ressort les personnages de Hunter x
  /// Hunter). -1 = aucun rapport.
  int _charScore(Character c, String q) {
    var best = matchScore(c.name, q);
    for (final alias in c.aliases) {
      final s = matchScore(alias, q);
      if (s != -1 && (best == -1 || s + 1 < best)) best = s + 1;
    }
    final sa = matchScore(c.animeName, q);
    if (sa != -1 && (best == -1 || sa + 2 < best)) best = sa + 2;
    return best;
  }

  List<AnimeEntry> get _filteredAnimes {
    final q = _query.trim();
    final typeFilter = _selectedFilter == 0 || _selectedFilter == 2;
    final matched = <(int, AnimeEntry)>[];
    for (final a in _localAnimes) {
      if (!typeFilter) break;
      if (_selectedSubFilter != null && a.category != _selectedSubFilter) {
        continue;
      }
      if (q.isEmpty) {
        matched.add((0, a));
        continue;
      }
      var s = matchScore(a.name, q);
      final alt = matchScore(a.originalTitle, q); // titre japonais d'origine
      if (alt != -1 && (s == -1 || alt < s)) s = alt;
      for (final other in [a.category, a.studio]) {
        final so = matchScore(other, q);
        if (so != -1 && so < 4 && (s == -1 || so + 2 < s)) s = so + 2;
      }
      if (s != -1) matched.add((s, a));
    }
    if (q.isEmpty) return matched.map((m) => m.$2).toList();
    final exact = matched.where((m) => m.$1 < 4).toList();
    final kept = exact.isNotEmpty ? exact : matched;
    kept.sort((a, b) => a.$1.compareTo(b.$1));
    return kept.map((m) => m.$2).toList();
  }

  List<CreatorEntry> get _filteredCreators {
    final q = _query.trim();
    if (!(_selectedFilter == 0 || _selectedFilter == 3)) return [];
    final matched = <(int, CreatorEntry)>[];
    for (final c in _localCreators) {
      if (q.isEmpty) {
        matched.add((0, c));
        continue;
      }
      var s = matchScore(c.name, q);
      for (final w in c.works) {
        final sw = matchScore(w, q);
        if (sw != -1 && sw < 4 && (s == -1 || sw + 2 < s)) s = sw + 2;
      }
      if (s != -1) matched.add((s, c));
    }
    if (q.isEmpty) return matched.map((m) => m.$2).toList();
    final exact = matched.where((m) => m.$1 < 4).toList();
    final kept = exact.isNotEmpty ? exact : matched;
    kept.sort((a, b) => a.$1.compareTo(b.$1));
    return kept.map((m) => m.$2).toList();
  }

  /// « Vouliez-vous dire… » : meilleure correction parmi les noms connus, si la
  /// saisie ressemble à une faute de frappe (sinon `null`).
  String? get _didYouMean {
    final q = _query.trim();
    if (q.length < 4) return null;
    return didYouMean([
      ..._localChars.map((c) => c.name),
      ..._localAnimes.map((a) => a.name),
      ..._localCreators.map((c) => c.name),
    ], q);
  }

  // ── Historique SharedPreferences ─────────────────────────────────────
  static const _kHistoryKey = 'search_history';

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _recentSearches = prefs.getStringList(_kHistoryKey) ?? [];
      });
    }
  }

  Future<void> _saveQuery(String query) async {
    if (query.trim().length < 2) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    _recentSearches = _recentSearches.take(5).toList();
    await prefs.setStringList(_kHistoryKey, _recentSearches);
    if (mounted) setState(() {});
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kHistoryKey);
    if (mounted) setState(() => _recentSearches = []);
  }

  Future<void> _removeRecentQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    await prefs.setStringList(_kHistoryKey, _recentSearches);
    if (mounted) setState(() {});
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    // Pas d'init de la reconnaissance vocale ici : elle déclenche la demande de
    // permission micro, qui ne doit survenir qu'au tap sur l'icône micro.
    _loadHistory();
    _startHintTimer();
    // Charger depuis Firestore (priorité) → fallback JSON si vide
    ref.read(allCharactersProvider.future).then((chars) {
      if (mounted) setState(() => _localChars = chars);
    });
    ref.read(allAnimesProvider.future).then((animes) {
      if (mounted) setState(() => _localAnimes = animes);
    });
    ref.read(allCreatorsProvider.future).then((creators) {
      if (mounted) setState(() => _localCreators = creators);
    });

    _cancelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _cancelSlide = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cancelCtrl, curve: Curves.easeOut));
    _cancelFade = CurvedAnimation(parent: _cancelCtrl, curve: Curves.easeOut);

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onQueryChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hintTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onQueryChange);
    _controller.dispose();
    _focusNode.dispose();
    _cancelCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ──────────────────────────────────────────────────────────
  bool _poolRequested = false;

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      // Premier usage de la saisie : on charge tout le catalogue pour la
      // recherche (jusque-là, seuls les 20 premiers personnages sont connus).
      if (!_poolRequested) {
        _poolRequested = true;
        ref.read(searchPoolProvider.future).then((chars) {
          if (mounted && chars.length > _localChars.length) {
            setState(() => _localChars = chars);
          }
        });
      }
      _cancelCtrl.forward();
    } else {
      _cancelCtrl.reverse();
    }
  }

  void _onQueryChange() {
    setState(() {
      _query = _controller.text;
      if (_query.isEmpty) {
        _submitted = false;
        _anilistSearchResults = [];
        ref.read(searchQueryProvider.notifier).state = '';
      }
    });
    if (_query.length >= 2) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        if (mounted) ref.read(searchQueryProvider.notifier).state = _query;
      });
    }
  }

  void _cancel() {
    _controller.clear();
    _focusNode.unfocus();
    _debounce?.cancel();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() {
      _query = '';
      _isFocused = false;
      _submitted = false;
      _selectedSubFilter = null;
      _anilistSearchResults = [];
    });
  }

  void _clearQuery() {
    _controller.clear();
    _debounce?.cancel();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() {
      _query = '';
      _submitted = false;
      _anilistSearchResults = [];
    });
  }

  void _selectSuggestion(String text) {
    _controller.text = text;
    _focusNode.unfocus();
    setState(() {
      _query = text;
      _isFocused = false;
      _submitted = true;
    });
    _saveQuery(text);
  }

  void _submitSearch() {
    if (_query.trim().isEmpty) return;
    _focusNode.unfocus();
    setState(() {
      _submitted = true;
      _isFocused = false;
    });
    _saveQuery(_query);
  }

  void _selectCategory(_Category cat) {
    setState(() {
      if (_selectedSubFilter == cat.label) {
        _selectedSubFilter = null;
        _submitted = false;
      } else {
        _selectedSubFilter = cat.label;
        _submitted = true;
      }
    });
  }

  void _removeRecent(String s) => _removeRecentQuery(s);
  void _clearAll() => _clearHistory();

  // ── Speech ────────────────────────────────────────────────────────────
  /// Initialise la reconnaissance vocale. C'est ICI que Android demande la
  /// permission micro : à appeler uniquement suite à un tap sur l'icône micro.
  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
    );
  }

  Future<void> _toggleListening() async {
    if (_speechInitializing) return;
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    if (!_speechAvailable) {
      _speechInitializing = true;
      try {
        await _initSpeech();
      } catch (_) {
        _speechAvailable = false;
      } finally {
        _speechInitializing = false;
      }
      if (!mounted) return;
      setState(() => _speechFailed = !_speechAvailable);
      if (!_speechAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Recherche vocale indisponible : autorise le micro pour '
              "OTADEX dans les réglages d'Android.",
            ),
          ),
        );
        return;
      }
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        final recognized = result.recognizedWords;
        if (recognized.isNotEmpty) {
          _controller.text = recognized;
          setState(() => _query = recognized);
          if (result.finalResult) {
            _speech.stop();
            setState(() => _isListening = false);
            _submitSearch();
          }
        }
      },
      listenOptions: SpeechListenOptions(
        localeId: 'fr_FR',
        pauseFor: const Duration(seconds: 3),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);

    // Arrivée depuis la barre de l'Accueil : on active la saisie tout de suite.
    ref.listen<int>(searchFocusRequestProvider, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    });

    // Watch AniList results for the debounced query
    final debouncedQuery = ref.watch(searchQueryProvider);
    final anilistAsync = debouncedQuery.length >= 2
        ? ref.watch(searchCharactersProvider(debouncedQuery))
        : const AsyncValue<List<Character>>.data([]);
    // Sync results into local cache (triggers re-render of _filteredCharacters)
    final incoming = anilistAsync.valueOrNull ?? [];
    if (incoming != _anilistSearchResults) _anilistSearchResults = incoming;

    return GestureDetector(
      onTap: () {
        if (_isFocused) _focusNode.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          _buildSearchBar(theme),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: _showSuggestions
                ? const SizedBox.shrink()
                : _buildFilterRow(theme),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _showSuggestions
                  ? _buildSuggestionsPanel(theme)
                  : _showResults
                      ? _buildResultsContent(theme)
                      : _buildHomeContent(theme),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────
  Widget _buildSearchBar(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: theme.backgroundCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFocused ? theme.accentColor : theme.borderSubtle,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: theme.accentColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: GoogleFonts.nunitoSans(
                            color: theme.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            // Le conteneur autour dessine déjà la bordure : on
                            // supprime TOUTES les bordures du thème (activée,
                            // focus, erreur…), sinon on voit une double bordure.
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _submitSearch(),
                        ),
                        if (_query.isEmpty)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 450),
                                  transitionBuilder: (child, anim) =>
                                      FadeTransition(
                                    opacity: anim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.5),
                                        end: Offset.zero,
                                      ).animate(anim),
                                      child: child,
                                    ),
                                  ),
                                  child: Text(
                                    _hints[_hintIndex % _hints.length],
                                    key: ValueKey(_hintIndex % _hints.length),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunitoSans(
                                      color: theme.textSecondary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: _clearQuery,
                      child: Icon(
                        Icons.cancel_rounded,
                        color: theme.textSecondary,
                        size: 18,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _toggleListening,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _isListening
                            ? const Icon(
                                Icons.mic_rounded,
                                key: ValueKey('mic_on'),
                                color: AppColors.error,
                                size: 18,
                              )
                            : Icon(
                                Icons.mic_none_rounded,
                                key: const ValueKey('mic_off'),
                                color: _speechFailed
                                    ? theme.textSecondary
                                    : theme.accentColor,
                                size: 18,
                              ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Annuler — slides in when focused
          SizeTransition(
            sizeFactor: _cancelFade,
            axis: Axis.horizontal,
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: _cancelSlide,
              child: FadeTransition(
                opacity: _cancelFade,
                child: GestureDetector(
                  onTap: _cancel,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      AppStrings.of(context).cancel,
                      style: GoogleFonts.nunitoSans(
                        color: theme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter chips ──────────────────────────────────────────────────────
  // Une seule rangée compacte : les genres (Shōnen, Seinen, Sport) sont déjà
  // proposés par les vignettes « Explorer par catégorie », inutile de les
  // répéter ici.
  Widget _buildFilterRow(RankTheme theme) {
    final s = AppStrings.of(context);
    final mainFilters = [s.all, s.characters, s.animes, s.creators];
    final scale = math.min(MediaQuery.textScalerOf(context).scale(1.0), 1.3);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 34 * scale,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: mainFilters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final active = i == _selectedFilter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: active
                      ? theme.accentColor.withValues(alpha: 0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? theme.accentColor : theme.borderSubtle,
                  ),
                ),
                child: Text(
                  mainFilters[i],
                  style: GoogleFonts.nunitoSans(
                    color: active ? theme.accentColor : theme.textSecondary,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── STATE B — Suggestions ─────────────────────────────────────────────
  Widget _buildSuggestionsPanel(RankTheme theme) {
    return ListView(
      key: const ValueKey('suggestions'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ...List.generate(_suggestions.length, (i) {
          return _buildSuggestionRow(theme, _suggestions[i], i);
        }),
        if (_suggestions.isEmpty && _query.trim().length < _minSuggestChars)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'Continue à écrire : les suggestions arrivent dès $_minSuggestChars lettres.',
              style: GoogleFonts.nunitoSans(
                  color: theme.textSecondary, fontSize: 13),
            ),
          ),
        if (_suggestions.isEmpty && _query.trim().length >= _minSuggestChars)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'Aucune suggestion pour « ${_query.trim()} » : essaie une autre orthographe ou lance la recherche complète.',
              style: GoogleFonts.nunitoSans(
                  color: theme.textSecondary, fontSize: 13, height: 1.4),
            ),
          ),
        if (_query.trim().length >= _minSuggestChars)
          InkWell(
            onTap: _submitSearch,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.manage_search_rounded,
                      color: theme.accentColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Voir tous les résultats pour « ${_query.trim()} »',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        color: theme.accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_recentSearches.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildRecentHeader(theme),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches
                .take(3)
                .map((r) => _buildRecentChip(theme, r))
                .toList(),
          ),
        ],
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSuggestionRow(RankTheme theme, _Suggestion s, int index) {
    final isRecent = s.type == 'recent';
    return TweenAnimationBuilder<double>(
      key: ValueKey('${s.text}_$index'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 150 + index * 60),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - value)),
          child: child,
        ),
      ),
      child: InkWell(
        onTap: () => _openSuggestion(s),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _buildSuggestionLeading(theme, s, isRecent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedText(theme, s.text),
                    if (s.subtitle != null && s.subtitle!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          s.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            color: theme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!isRecent) ...[
                Text(
                  s.type,
                  style: GoogleFonts.nunitoSans(
                    color: theme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.textSecondary,
                  size: 16,
                ),
              ] else
                Icon(
                  Icons.north_west_rounded,
                  color: theme.textSecondary,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Portrait rond pour un personnage ; icône pour animé / créateur / historique.
  Widget _buildSuggestionLeading(
      RankTheme theme, _Suggestion s, bool isRecent) {
    final path = s.imagePath;
    if (path != null && path.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 44,
          height: 44,
          child: OtadexImage(
            imagePath: path,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      );
    }
    final icon = isRecent
        ? Icons.history_rounded
        : s.anime != null
            ? Icons.movie_rounded
            : s.type == 'Créateur'
                ? Icons.draw_rounded
                : Icons.search_rounded;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.accentColor.withValues(alpha: 0.12),
      ),
      child: Icon(icon, color: theme.accentColor, size: 20),
    );
  }

  Widget _buildHighlightedText(RankTheme theme, String text) {
    final q = foldAccents(_query.trim());
    final lower = foldAccents(text);
    // Début de mot correspondant en priorité (« zol » dans « Killua Zoldyck »).
    var idx = q.isEmpty
        ? -1
        : RegExp(r'(^|[\s\-_:·.,])' + RegExp.escape(q))
                .firstMatch(lower)
                ?.end ??
            -1;
    if (idx != -1) idx -= q.length;
    if (idx == -1 && q.isNotEmpty) idx = lower.indexOf(q);
    if (idx == -1 || q.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.nunitoSans(color: theme.textPrimary, fontSize: 15),
      );
    }
    return Text.rich(TextSpan(children: [
      if (idx > 0)
        TextSpan(
          text: text.substring(0, idx),
          style:
              GoogleFonts.nunitoSans(color: theme.textSecondary, fontSize: 15),
        ),
      TextSpan(
        text: text.substring(idx, idx + q.length),
        style: GoogleFonts.nunitoSans(
          color: theme.accentColor,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      if (idx + q.length < text.length)
        TextSpan(
          text: text.substring(idx + q.length),
          style: GoogleFonts.nunitoSans(color: theme.textPrimary, fontSize: 15),
        ),
    ]));
  }

  // ── STATE A — Home content ─────────────────────────────────────────────
  Widget _buildHomeContent(RankTheme theme) {
    const side = EdgeInsets.symmetric(horizontal: 16);
    final trendingTitle = AppStrings.of(context)
        .trendingNow
        .replaceFirst(RegExp(r'^[^\p{L}\p{N}]+', unicode: true), '');
    return ListView(
      key: const ValueKey('home'),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Padding(padding: side, child: _buildRecentHeader(theme)),
          const SizedBox(height: 10),
          Padding(padding: side, child: _buildRecentChipsWrap(theme)),
          const SizedBox(height: 24),
        ],
        Padding(
          padding: side,
          child: _buildSectionTitle(
              theme, AppStrings.of(context).exploreByCategory),
        ),
        const SizedBox(height: 12),
        Padding(padding: side, child: _buildCategoryGrid(theme)),
        const SizedBox(height: 26),
        Padding(padding: side, child: _buildSectionTitle(theme, trendingTitle)),
        const SizedBox(height: 12),
        _buildTrendingList(theme),
        _buildDiscoverCard(theme),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildRecentHeader(RankTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.of(context).recentSearches,
          style: GoogleFonts.rajdhani(
            color: theme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        if (_recentSearches.isNotEmpty)
          GestureDetector(
            onTap: _clearAll,
            child: Text(
              AppStrings.of(context).clearAll,
              style: GoogleFonts.nunitoSans(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentChipsWrap(RankTheme theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _recentSearches.map((s) => _buildRecentChip(theme, s)).toList(),
    );
  }

  Widget _buildRecentChip(RankTheme theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, color: theme.textSecondary, size: 14),
          const SizedBox(width: 6),
          Text(
            "'$label'",
            style:
                GoogleFonts.nunitoSans(color: theme.textPrimary, fontSize: 13),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeRecent(label),
            child:
                Icon(Icons.close_rounded, color: theme.textSecondary, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(RankTheme theme, String title) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.rajdhani(
              color: theme.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: theme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(RankTheme theme, String label) {
    return Text(
      label,
      style: GoogleFonts.rajdhani(
        color: theme.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  /// Image à afficher pour un personnage : assets locaux d'abord.
  String? _charImage(Character c) {
    final local = AppAssets.getByCharacterId(c.id);
    if (local.isNotEmpty) return local.first;
    final p = c.imagePath;
    return (p != null && p.isNotEmpty) ? p : null;
  }

  Widget _buildCategoryGrid(RankTheme theme) {
    final scale = math.min(MediaQuery.textScalerOf(context).scale(1.0), 1.3);
    return SizedBox(
      height: 128 * scale,
      child: Row(
        children: [
          for (var i = 0; i < _categories.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: _buildCategoryCard(theme, _categories[i], i)),
          ],
        ],
      ),
    );
  }

  /// Vignette de catégorie : la photo d'un personnage du genre, qui change à
  /// chaque ouverture de l'application, sous un voile de la couleur du genre.
  Widget _buildCategoryCard(RankTheme theme, _Category cat, int index) {
    final isSelected = _selectedSubFilter == cat.label;
    final candidates = _localChars
        .where((c) => c.category == cat.label && _charImage(c) != null)
        .toList();
    final cover = candidates.isEmpty
        ? null
        : _charImage(candidates[(_coverSeed + index) % candidates.length]);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
        ),
      ),
      child: AnimatedScale(
        scale: isSelected ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cat.color1, cat.color2],
                  ),
                ),
              ),
              if (cover != null)
                OtadexImage(
                  imagePath: cover,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                )
              else
                // Pas encore de portrait de ce genre chargé : grande icône
                // en filigrane plutôt qu'un aplat vide.
                Positioned(
                  top: 10,
                  right: -8,
                  child: Icon(
                    switch (cat.label) {
                      'Seinen' => Icons.edit_rounded,
                      'Sport' => Icons.sports_basketball_rounded,
                      _ => Icons.bolt_rounded,
                    },
                    size: 74,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.30, 1.0],
                    colors: [
                      cat.color2.withValues(alpha: 0.0),
                      cat.color2.withValues(alpha: 0.96),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      cat.sub,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 10,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.check_rounded, size: 14, color: cat.color2),
                  ),
                ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => _selectCategory(cat),
                    splashColor: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tendances : mêmes données que l'accueil (`trendingCharactersProvider`),
  /// pour que les deux écrans ne se contredisent plus. Pendant le chargement
  /// ou en cas d'erreur, on réserve la place sans afficher de fausses valeurs.
  /// Affiches de personnages pleine largeur d'écran (la liste déborde du
  /// padding de la page : voir [_buildHomeContent]).
  Widget _buildTrendingList(RankTheme theme) {
    final trending = ref.watch(trendingCharactersProvider).valueOrNull;
    if (trending == null || trending.isEmpty) {
      return const SizedBox(height: 200);
    }
    final items = trending.take(8).toList();
    final scale = math.min(MediaQuery.textScalerOf(context).scale(1.0), 1.3);
    return SizedBox(
      height: 204 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _buildTrendPoster(theme, items[i], i),
      ),
    );
  }

  void _openCharacter(Character c) {
    ImagePrefetcher.prefetchCharacterImages(context, c);
    context.push('/character/${c.id}');
  }

  /// « À découvrir » : un grand bandeau sur un personnage tiré au hasard à
  /// chaque ouverture (hors des 8 tendances déjà montrées), pour que la page
  /// change d'une visite à l'autre.
  Widget _buildDiscoverCard(RankTheme theme) {
    final trendingIds = (ref.watch(trendingCharactersProvider).valueOrNull ??
            const <Character>[])
        .take(8)
        .map((c) => c.id)
        .toSet();
    final pool = _localChars
        .where((c) => !trendingIds.contains(c.id) && _charImage(c) != null)
        .toList();
    if (pool.isEmpty) return const SizedBox.shrink();
    final c = pool[_coverSeed % pool.length];
    final img = _charImage(c)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(theme, 'À découvrir'),
          const SizedBox(height: 12),
          _PressScale(
            onTap: () => _openCharacter(c),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 150,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [c.cardColor, c.accentColor],
                        ),
                      ),
                    ),
                    OtadexImage(
                      imagePath: img,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.6),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: const [0.0, 0.75],
                          colors: [
                            AppColors.backgroundDeep.withValues(alpha: 0.92),
                            AppColors.backgroundDeep.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      right: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.category.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.rajdhani(
                              color: theme.accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.rajdhani(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.animeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendPoster(RankTheme theme, Character c, int index) {
    final img = _charImage(c);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 380 + math.min(index, 4) * 90),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(24 * (1 - value), 0),
          child: child,
        ),
      ),
      child: _PressScale(
        onTap: () => _openCharacter(c),
        child: SizedBox(
          width: 132,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [c.cardColor, c.accentColor],
                    ),
                  ),
                ),
                if (img != null)
                  OtadexImage(
                    imagePath: img,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.45, 1.0],
                      colors: [
                        AppColors.backgroundDeep.withValues(alpha: 0.0),
                        AppColors.backgroundDeep.withValues(alpha: 0.94),
                      ],
                    ),
                  ),
                ),
                // Rang en grand, façon classement.
                Positioned(
                  top: 2,
                  left: 10,
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.rajdhani(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        c.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c.animeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── STATE C — Results ─────────────────────────────────────────────────
  Widget _buildResultsContent(RankTheme theme) {
    final s = AppStrings.of(context);
    final chars = _filteredCharacters;
    final animes = _filteredAnimes;
    final creators = _filteredCreators;

    final showChars =
        (_selectedFilter == 0 || _selectedFilter == 1) && chars.isNotEmpty;
    final showAnimes =
        (_selectedFilter == 0 || _selectedFilter == 2) && animes.isNotEmpty;
    final showCreators =
        (_selectedFilter == 0 || _selectedFilter == 3) && creators.isNotEmpty;

    if (!showChars && !showAnimes && !showCreators) {
      return _buildEmptyResults(theme);
    }

    return ListView(
      key: const ValueKey('results'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      children: [
        if (_selectedSubFilter != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(Icons.filter_list_rounded,
                    color: theme.accentColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Catégorie : $_selectedSubFilter',
                  style: GoogleFonts.nunitoSans(
                    color: theme.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() {
                    _selectedSubFilter = null;
                    if (_query.isEmpty) _submitted = false;
                  }),
                  child: Icon(Icons.close_rounded,
                      color: theme.textSecondary, size: 16),
                ),
              ],
            ),
          ),
        if (showChars) ...[
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                    offset: Offset(0, 16 * (1 - v)), child: child)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(
                    theme, '${s.characters.toUpperCase()} (${chars.length})'),
                const SizedBox(height: 8),
                ...chars.take(5).map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildCharacterResultCard(theme, c),
                    )),
                if (chars.length > 5)
                  _buildSeeMoreRow(
                      theme, '${chars.length - 5} autres personnages'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
        if (showAnimes) ...[
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                    offset: Offset(0, 16 * (1 - v)), child: child)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(
                    theme, '${s.animes.toUpperCase()} (${animes.length})'),
                const SizedBox(height: 8),
                ...animes.take(4).map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildAnimeResultCard(theme, a),
                    )),
                if (animes.length > 4)
                  _buildSeeMoreRow(theme, '${animes.length - 4} autres animés'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
        if (showCreators) ...[
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                    offset: Offset(0, 16 * (1 - v)), child: child)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(
                    theme, '${s.creators.toUpperCase()} (${creators.length})'),
                const SizedBox(height: 8),
                ...creators.take(3).map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildCreatorResultCard(theme, c),
                    )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
        if (_query.isNotEmpty) ...[
          _buildSectionTitle(theme, s.youMightAlsoLike),
          const SizedBox(height: 12),
          _buildRecommendations(theme),
        ],
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildEmptyResults(RankTheme theme) {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, color: theme.textSecondary, size: 48),
          const SizedBox(height: 12),
          Text(
            'Aucun résultat trouvé',
            style: GoogleFonts.rajdhani(
              color: theme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Essaie un autre terme ou change de filtre',
            style: GoogleFonts.nunitoSans(
              color: theme.textSecondary,
              fontSize: 13,
            ),
          ),
          // « Vouliez-vous dire… » : un tap applique la correction.
          if (_didYouMean case final guess?) ...[
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => _selectSuggestion(guess),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: theme.accentColor.withValues(alpha: 0.4)),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Vouliez-vous dire : ',
                        style: GoogleFonts.nunitoSans(
                            color: theme.textSecondary, fontSize: 13),
                      ),
                      TextSpan(
                        text: guess,
                        style: GoogleFonts.nunitoSans(
                          color: theme.accentColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' ?',
                        style: GoogleFonts.nunitoSans(
                            color: theme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeeMoreRow(RankTheme theme, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline_rounded,
              color: theme.accentColor, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              color: theme.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterResultCard(RankTheme theme, Character c) {
    return GestureDetector(
      onTap: () {
        ImagePrefetcher.prefetchCharacterImages(context, c);
        context.push('/character/${c.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.cardColor, c.accentColor.withValues(alpha: 0.6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: c.imagePath != null
                  ? OtadexImage(
                      imagePath: c.imagePath!,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            color: theme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_rounded,
                              color: Colors.redAccent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            formatLikes(ref
                                    .watch(likeCountProvider(c.id))
                                    .valueOrNull ??
                                0),
                            style: GoogleFonts.nunitoSans(
                              color: theme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildTag(c.tierLabel, c.tierColor.withValues(alpha: 0.9),
                          c.cardColor),
                      _buildTag(c.category, theme.textSecondary,
                          theme.backgroundElevated),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.animeName,
                    style: GoogleFonts.nunitoSans(
                      color: theme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimeResultCard(RankTheme theme, AnimeEntry a) {
    return GestureDetector(
      onTap: () => context.push('/anime/${a.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [a.cardColor, a.accentColor],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  a.name.substring(0, 1),
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      color: theme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${a.category} · ${a.year} · ${a.episodes} épisodes',
                    style: GoogleFonts.nunitoSans(
                      color: theme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    a.studio,
                    style: GoogleFonts.nunitoSans(
                      color: theme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorResultCard(RankTheme theme, CreatorEntry c) {
    final mainWork = c.works.isNotEmpty ? c.works.first : '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              shape: BoxShape.circle,
              border: Border.all(color: theme.borderDefault),
            ),
            child: Center(
              child: Text(
                c.initials,
                style: GoogleFonts.rajdhani(
                  color: theme.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: GoogleFonts.rajdhani(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  mainWork.isNotEmpty ? '${c.role} · $mainWork' : c.role,
                  style: GoogleFonts.nunitoSans(
                    color: theme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (c.tags.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: c.tags
                        .take(3)
                        .map((t) => _buildTag(
                            t, theme.textSecondary, theme.backgroundElevated))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: theme.textSecondary),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunitoSans(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecommendations(RankTheme theme) {
    final chars = _localChars.take(3).toList();
    if (chars.isEmpty) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chars.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final c = chars[i];
            final localImgs = AppAssets.getByCharacterId(c.id);
            final imgPath = localImgs.isNotEmpty
                ? localImgs.first
                : c.images.isNotEmpty
                    ? c.images.first
                    : c.imagePath ?? '';

            return GestureDetector(
              onTap: () {
                ImagePrefetcher.prefetchCharacterImages(context, c);
                context.push('/character/${c.id}');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background (toujours visible)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [c.cardColor, c.accentColor],
                          ),
                        ),
                      ),
                      // Image personnage
                      if (imgPath.isNotEmpty)
                        OtadexImage(imagePath: imgPath, fit: BoxFit.cover),
                      // Scrim bas pour lisibilité du texte
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.backgroundDeep.withValues(alpha: 0.0),
                                AppColors.backgroundDeep
                                    .withValues(alpha: 0.92),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Nom + animé
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              c.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              c.animeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────

class _Category {
  final String id;
  final String label;
  final String sub;
  final String icon;
  final Color color1;
  final Color color2;
  const _Category(
      this.id, this.label, this.sub, this.icon, this.color1, this.color2);
}

class _Suggestion {
  final String text;
  final String type;

  /// Ligne secondaire (animé du personnage, studio…) et portrait éventuel.
  final String? subtitle;
  final String? imagePath;

  /// Cible : si renseignée, un tap ouvre directement la fiche.
  final Character? character;
  final AnimeEntry? anime;

  const _Suggestion(
    this.text,
    this.type, {
    this.subtitle,
    this.imagePath,
    this.character,
    this.anime,
  });
}

/// Réaction au toucher : la carte s'enfonce légèrement tant qu'on l'appuie.
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressScale({required this.child, required this.onTap});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
