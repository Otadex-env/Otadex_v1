import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/firestore_character_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../home/presentation/widgets/character_grid_card.dart';

class CharacterListScreen extends StatefulWidget {
  final String title;

  const CharacterListScreen({super.key, required this.title});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _service = FirestoreCharacterService();
  final _scrollController = ScrollController();

  final _characters = <dynamic>[];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _initialLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    final (newChars, lastDoc) = await _service.getCharactersPaginated(
      lastDocument: _lastDocument,
    );

    if (!mounted) return;
    setState(() {
      _characters.addAll(newChars);
      _lastDocument = lastDoc;
      _hasMore = lastDoc != null;
      _isLoading = false;
      _initialLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: theme.textPrimary, size: 20),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.rajdhani(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    if (_initialLoaded)
                      Text(
                        '${_characters.length}${_hasMore ? '+' : ''} personnages',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: theme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (!_initialLoaded)
                      const SliverPadding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
                        sliver: SliverToBoxAdapter(
                          child: SkeletonGrid(columns: 3, rows: 4),
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final char = _characters[i];
                              return CharacterGridCard(
                                character: char,
                                onTap: () => context.push(
                                  '/character/${char.id}',
                                  extra: char,
                                ),
                              )
                                  .animate(delay: (30 * (i % 20)).ms)
                                  .fadeIn(duration: 200.ms)
                                  .slideY(
                                      begin: 0.06,
                                      end: 0,
                                      duration: 200.ms);
                            },
                            childCount: _characters.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.72,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: _isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation(
                                          AppColors.primary),
                                    ),
                                  ),
                                )
                              : !_hasMore
                                  ? Center(
                                      child: Text(
                                        'Tous les personnages chargés',
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 12,
                                          color: AppColors.textDisabled,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
