import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────────────
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  // ── State ─────────────────────────────────────────────────────────────
  String _query = '';
  bool _isFocused = false;
  bool _submitted = false;
  int _selectedFilter = 0;
  String? _selectedSubFilter;
  final List<String> _recentSearches = [
    'Naruto',
    'Solo Leveling',
    'Gojo Satoru',
    'Attack on Titan',
    'Demon Slayer',
  ];

  // ── Animation controllers ─────────────────────────────────────────────
  late AnimationController _cancelCtrl;
  late Animation<Offset> _cancelSlide;
  late Animation<double> _cancelFade;

  // ── Mock data ─────────────────────────────────────────────────────────
  static const _mainFilters = ['Tous', 'Personnages', 'Animés', 'Créateurs'];
  static const _subFilters = ['Shonen', 'Shojo', 'Seinen', 'Manhwa'];

  static const _categories = [
    _Category('SHONEN', 'Shonen', 'Action · Aventure', '⚡',
        Color(0xFFE67E22), Color(0xFF5D1A00)),
    _Category('SHOJO', 'Shojo', 'Romance · Émotions', '🌸',
        Color(0xFFE91E8C), Color(0xFF7B0052)),
    _Category('SEINEN', 'Seinen', 'Adulte · Psychologique', '✒️',
        Color(0xFF546E7A), Color(0xFF1A2327)),
    _Category('MANHWA', 'Manhwa', 'Webtoon · Coréen', '📱',
        Color(0xFF26C6DA), Color(0xFF004D56)),
    _Category('DONGHUA', 'Donghua', 'Animation · Chinoise', '🐉',
        Color(0xFFEF5350), Color(0xFF5D0000)),
    _Category('WEBTOON', 'Webtoon', 'Numérique · Vertical', '📖',
        Color(0xFF66BB6A), Color(0xFF1B3A1C)),
  ];

  static const _trending = [
    _TrendItem('#1', 'Sung Jinwoo', 'Solo Leveling', Color(0xFF1A237E)),
    _TrendItem('#2', 'Gojo Satoru', 'Jujutsu Kaisen', Color(0xFF4A148C)),
    _TrendItem('#3', 'Teijiro', 'Demon Slayer', Color(0xFF880E4F)),
    _TrendItem('#4', 'Luffy', 'One Piece', Color(0xFFBF360C)),
    _TrendItem('#5', 'Levi', 'Attack on Titan', Color(0xFF212121)),
    _TrendItem('#6', 'Frieren', 'Frieren BJE', Color(0xFF1A237E)),
  ];

  static const _recommendations = [
    [Color(0xFFFF6B35), Color(0xFF8B1A00)],
    [Color(0xFF9B59B6), Color(0xFF4A0080)],
    [Color(0xFFE91E8C), Color(0xFF7B0052)],
    [Color(0xFF26C6DA), Color(0xFF004D56)],
  ];

  // ── Computed ──────────────────────────────────────────────────────────
  bool get _showSuggestions => _isFocused && _query.isNotEmpty;
  bool get _showResults => _submitted && _query.isNotEmpty && !_isFocused;

  List<_Suggestion> get _suggestions {
    if (_query.isEmpty) return [];
    final cap = _query[0].toUpperCase() + _query.substring(1);
    return [
      _Suggestion('$cap Satoru', 'Personnage', badge: '10R'),
      _Suggestion('$cap Jogo', 'Personnage'),
      _Suggestion('$cap Satoru', 'recent'),
      const _Suggestion('Jujutsu Kaisen', 'Animé'),
    ];
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

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
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onQueryChange);
    _controller.dispose();
    _focusNode.dispose();
    _cancelCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ──────────────────────────────────────────────────────────
  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _cancelCtrl.forward();
    } else {
      _cancelCtrl.reverse();
    }
  }

  void _onQueryChange() {
    setState(() {
      _query = _controller.text;
      if (_query.isEmpty) _submitted = false;
    });
  }

  void _cancel() {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _query = '';
      _isFocused = false;
      _submitted = false;
    });
  }

  void _clearQuery() {
    _controller.clear();
    setState(() {
      _query = '';
      _submitted = false;
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
    if (!_recentSearches.contains(text)) {
      setState(() => _recentSearches.insert(0, text));
    }
  }

  void _submitSearch() {
    if (_query.trim().isEmpty) return;
    _focusNode.unfocus();
    setState(() {
      _submitted = true;
      _isFocused = false;
    });
    if (!_recentSearches.contains(_query)) {
      setState(() => _recentSearches.insert(0, _query));
    }
  }

  void _removeRecent(String s) => setState(() => _recentSearches.remove(s));
  void _clearAll() => setState(() => _recentSearches.clear());

  // ── Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
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
                  Icon(Icons.search_rounded, color: theme.accentColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: GoogleFonts.nunitoSans(
                        color: theme.textPrimary,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Personnage, animé, créateur...',
                        hintStyle: GoogleFonts.nunitoSans(
                          color: theme.textSecondary,
                          fontSize: 15,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _submitSearch(),
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
                    Icon(Icons.mic_rounded, color: theme.accentColor, size: 18),
                ],
              ),
            ),
          ),
          // Annuler — slides in when focused
          SizeTransition(
            sizeFactor: _cancelFade,
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: SlideTransition(
              position: _cancelSlide,
              child: FadeTransition(
                opacity: _cancelFade,
                child: GestureDetector(
                  onTap: _cancel,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Annuler',
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
  Widget _buildFilterRow(RankTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _mainFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = i == _selectedFilter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? theme.accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? theme.accentColor : theme.borderDefault,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (active) ...[
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        _mainFilters[i],
                        style: GoogleFonts.nunitoSans(
                          color: active ? Colors.white : theme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _subFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = _selectedSubFilter == _subFilters[i];
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedSubFilter = active ? null : _subFilters[i];
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: active
                        ? theme.accentColor.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: active ? theme.accentColor : theme.borderSubtle,
                    ),
                  ),
                  child: Text(
                    _subFilters[i],
                    style: GoogleFonts.nunitoSans(
                      color: active ? theme.accentColor : theme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
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
        onTap: () => _selectSuggestion(s.text),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              Icon(
                isRecent ? Icons.history_rounded : Icons.search_rounded,
                color: theme.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildHighlightedText(theme, s.text)),
              if (s.badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    s.badge!,
                    style: GoogleFonts.rajdhani(
                      color: theme.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
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

  Widget _buildHighlightedText(RankTheme theme, String text) {
    final q = _query.toLowerCase();
    final lower = text.toLowerCase();
    final idx = lower.indexOf(q);
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
          style:
              GoogleFonts.nunitoSans(color: theme.textPrimary, fontSize: 15),
        ),
    ]));
  }

  // ── STATE A — Home content ─────────────────────────────────────────────
  Widget _buildHomeContent(RankTheme theme) {
    return ListView(
      key: const ValueKey('home'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          _buildRecentHeader(theme),
          const SizedBox(height: 10),
          _buildRecentChipsWrap(theme),
          const SizedBox(height: 24),
        ],
        _buildSectionTitle(theme, 'Explorer par catégorie'),
        const SizedBox(height: 12),
        _buildCategoryGrid(theme),
        const SizedBox(height: 24),
        _buildSectionTitle(theme, '🔥 Tendances du moment'),
        const SizedBox(height: 12),
        _buildTrendingList(theme),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildRecentHeader(RankTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'RECHERCHES RÉCENTES',
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
              'Effacer tout',
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
            style: GoogleFonts.nunitoSans(
                color: theme.textPrimary, fontSize: 13),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeRecent(label),
            child: Icon(Icons.close_rounded, color: theme.textSecondary, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(RankTheme theme, String title) {
    return Text(
      title,
      style: GoogleFonts.rajdhani(
        color: theme.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCategoryGrid(RankTheme theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 72,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, i) => _buildCategoryCard(theme, _categories[i], i),
    );
  }

  Widget _buildCategoryCard(RankTheme theme, _Category cat, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + index * 50),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedSubFilter =
              _selectedSubFilter == cat.label ? null : cat.label;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cat.color1, cat.color2],
            ),
            borderRadius: BorderRadius.circular(12),
            border: _selectedSubFilter == cat.label
                ? Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5)
                : null,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat.id,
                style: GoogleFonts.rajdhani(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.label,
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      Text(
                        cat.sub,
                        style: GoogleFonts.nunitoSans(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(cat.icon, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingList(RankTheme theme) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _trending.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _buildTrendCard(theme, _trending[i]),
      ),
    );
  }

  Widget _buildTrendCard(RankTheme theme, _TrendItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [item.color, item.color.withValues(alpha: 0.4)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item.rank,
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: GoogleFonts.nunitoSans(
                  color: theme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                item.anime,
                style: GoogleFonts.nunitoSans(
                  color: theme.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── STATE C — Results ─────────────────────────────────────────────────
  Widget _buildResultsContent(RankTheme theme) {
    return ListView(
      key: const ValueKey('results'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      children: [
        _buildResultSection(
          theme, 'PERSONNAGES', 0, _buildCharacterCard(theme)),
        const SizedBox(height: 16),
        _buildResultSection(
          theme, 'ANIMÉS', 1, _buildAnimeCard(theme)),
        const SizedBox(height: 16),
        _buildResultSection(
          theme, 'CRÉATEURS', 2, _buildCreatorCard(theme)),
        const SizedBox(height: 24),
        _buildSectionTitle(theme, 'Tu pourrais aussi aimer'),
        const SizedBox(height: 12),
        _buildRecommendations(theme),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildResultSection(
      RankTheme theme, String title, int delay, Widget card) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(title),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + delay * 100),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (1)',
            style: GoogleFonts.rajdhani(
              color: theme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          card,
        ],
      ),
    );
  }

  Widget _buildCharacterCard(RankTheme theme) {
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
            width: 52,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A237E), Color(0xFF4A0080)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gojo Satoru',
                      style: GoogleFonts.rajdhani(
                        color: theme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: Colors.redAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '38.2k',
                          style: GoogleFonts.nunitoSans(
                            color: theme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildTag('Spécial Grade 0',
                        const Color(0xFF81C784), const Color(0xFF1B5E20)),
                    _buildTag('Protagoniste',
                        const Color(0xFFFFB74D), const Color(0xFF3E2000)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Jujutsu Kaisen · Shonen',
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
    );
  }

  Widget _buildAnimeCard(RankTheme theme) {
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF880E4F)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jujutsu Kaisen',
                  style: GoogleFonts.rajdhani(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Shonen · 2020 · 24 épisodes',
                  style: GoogleFonts.nunitoSans(
                    color: theme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  'A-1 Pictures',
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
    );
  }

  Widget _buildCreatorCard(RankTheme theme) {
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
                'GA',
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
                  'Gege Akutami',
                  style: GoogleFonts.rajdhani(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Mangaka · Jujutsu Kaisen',
                  style: GoogleFonts.nunitoSans(
                    color: theme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: [
                    _buildTag('Shonen',
                        const Color(0xFF90CAF9), const Color(0xFF0D3B6E)),
                    _buildTag('Action',
                        const Color(0xFFFFB74D), const Color(0xFF3E2000)),
                    _buildTag('Manhwa',
                        const Color(0xFF80CBC4), const Color(0xFF004D40)),
                  ],
                ),
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) =>
          Opacity(opacity: value, child: child),
      child: SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _recommendations.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, i) => Container(
            width: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _recommendations[i],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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

class _TrendItem {
  final String rank;
  final String name;
  final String anime;
  final Color color;
  const _TrendItem(this.rank, this.name, this.anime, this.color);
}

class _Suggestion {
  final String text;
  final String type;
  final String? badge;
  const _Suggestion(this.text, this.type, {this.badge});
}
