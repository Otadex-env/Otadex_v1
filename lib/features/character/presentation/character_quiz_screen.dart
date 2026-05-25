import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/character.dart';
import '../../../core/providers/anilist_providers.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../core/widgets/subscription_modal.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class CharacterQuizScreen extends ConsumerStatefulWidget {
  final String charId;
  final String charName;
  final List<QuizQuestion>? quizQuestions;

  const CharacterQuizScreen({
    super.key,
    required this.charId,
    required this.charName,
    this.quizQuestions,
  });

  @override
  ConsumerState<CharacterQuizScreen> createState() =>
      _CharacterQuizScreenState();
}

class _CharacterQuizScreenState extends ConsumerState<CharacterQuizScreen> {
  // ── Quiz state ─────────────────────────────────────────────────────
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _validated = false;
  int _score = 0;
  bool _quizFinished = false;
  bool _loadingQuestions = false;
  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    final provided = widget.quizQuestions;
    if (provided != null && provided.isNotEmpty) {
      _questions = provided;
    } else {
      _questions = [];
      _loadingQuestions = true;
      Future.microtask(_loadFirestoreQuestions);
    }
  }

  Future<void> _loadFirestoreQuestions() async {
    try {
      final fsQuestions =
          await ref.read(firestoreQuizProvider(widget.charId).future);
      if (!mounted) return;
      setState(() {
        _questions =
            fsQuestions.isNotEmpty ? fsQuestions : _buildGenericQuestions();
        _loadingQuestions = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _questions = _buildGenericQuestions();
        _loadingQuestions = false;
      });
    }
  }

  // ── Questions génériques (fallback) ────────────────────────────────

  List<QuizQuestion> _buildGenericQuestions() {
    final name = widget.charName;
    return [
      QuizQuestion(
        question: 'Quel est le niveau de puissance de $name ?',
        options: ['Très faible', 'Moyen', 'Extrêmement puissant', 'Inconnu'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'Dans quel type d\'univers évolue $name ?',
        options: [
          'Science-fiction',
          'Fantasy/Magie',
          'Sport',
          'Tranche de vie'
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: 'Quelle caractéristique définit le mieux $name ?',
        options: [
          'Courage et détermination',
          'Intelligence froide',
          'Force brute',
          'Vitesse pure',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: 'Quel est le rôle de $name dans son histoire ?',
        options: [
          'Antagoniste principal',
          'Personnage secondaire',
          'Protagoniste ou héros',
          'Mentor uniquement',
        ],
        correctIndex: 2,
      ),
      QuizQuestion(
        question: 'Qu\'est-ce qui motive principalement $name ?',
        options: [
          'La vengeance',
          'Protéger ses proches',
          'La richesse',
          'La célébrité',
        ],
        correctIndex: 1,
      ),
    ];
  }

  // ── Actions ────────────────────────────────────────────────────────

  void _validate() {
    if (_selectedAnswer == null) return;
    setState(() {
      _validated = true;
      if (_selectedAnswer == _questions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _validated = false;
      _selectedAnswer = null;
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
      } else {
        _quizFinished = true;
        _updateFirestoreScore();
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestion = 0;
      _selectedAnswer = null;
      _validated = false;
      _score = 0;
      _quizFinished = false;
    });
  }

  Future<void> _updateFirestoreScore() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'score_fan': FieldValue.increment(_score * 5),
        'quiz_completed': FieldValue.arrayUnion([widget.charId]),
      });
    } catch (_) {}
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    // Gate: Genin cannot access this screen
    if (profile.rank == 'genin') {
      return _buildGeninGate(context);
    }

    if (_loadingQuestions) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: SkeletonScreen(),
      );
    }

    if (_quizFinished) {
      return _buildResultScreen(context);
    }

    return _buildQuizScreen(context);
  }

  // ── Genin gate ─────────────────────────────────────────────────────

  Widget _buildGeninGate(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button — top left
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Centred content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'Quiz Jonin+',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Passe Jonin pour accéder aux quiz IA.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _JoninButton(
                      onPressed: () => showSubscriptionModal(
                        context,
                        SubscriptionPlan.jonin,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Quiz screen ────────────────────────────────────────────────────

  Widget _buildQuizScreen(BuildContext context) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Quiz — ${widget.charName}',
                        style: GoogleFonts.dmSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    color: AppColors.accent,
                    backgroundColor: AppColors.backgroundElevated,
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Question ${_currentQuestion + 1}/${_questions.length}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Question card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundElevated,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Question ${_currentQuestion + 1}/${_questions.length}',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.question,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Answer options ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(question.options.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AnswerButton(
                        label: question.options[i],
                        index: i,
                        selectedAnswer: _selectedAnswer,
                        correctIndex: question.correctIndex,
                        validated: _validated,
                        onTap: _validated
                            ? null
                            : () => setState(() => _selectedAnswer = i),
                      ),
                    );
                  }),
                ),
              ),

              // ── Feedback ──
              if (_validated)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _buildFeedback(question),
                ),

              // ── Action button ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: _buildActionButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(QuizQuestion question) {
    final isCorrect = _selectedAnswer == question.correctIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.statGreen.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isCorrect
            ? '✓ Bonne réponse ! +5 pts Fan Score'
            : '✗ La bonne réponse était : ${question.options[question.correctIndex]}',
        style: GoogleFonts.nunitoSans(
          fontSize: isCorrect ? 14 : 13,
          color: isCorrect ? AppColors.statGreen : AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (!_validated && _selectedAnswer != null) {
      return SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: _validate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Valider',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (_validated) {
      return SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: _nextQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Suivant →',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Placeholder to keep layout stable when no button is visible
    return const SizedBox(height: 48);
  }

  // ── Result screen ──────────────────────────────────────────────────

  Widget _buildResultScreen(BuildContext context) {
    final int total = _questions.length;
    final Color scoreColor;
    final String badge;

    if (_score == total) {
      scoreColor = AppColors.accent;
      badge = 'Quiz Master 🧠';
    } else if (_score >= (total * 0.6).ceil()) {
      scoreColor = AppColors.statGreen;
      badge = 'Bon fan ⭐';
    } else {
      scoreColor = AppColors.textSecondary;
      badge = 'Continue d\'apprendre 📚';
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Score
                Text(
                  '$_score/$total',
                  style: GoogleFonts.rajdhani(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Badge
                Text(
                  badge,
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  '$_score bonne${_score > 1 ? 's' : ''} réponse${_score > 1 ? 's' : ''} sur $total',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _resetQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.backgroundElevated,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Rejouer',
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => context.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Retour',
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

/// Answer option button with colour-coded feedback states.
class _AnswerButton extends StatelessWidget {
  final String label;
  final int index;
  final int? selectedAnswer;
  final int correctIndex;
  final bool validated;
  final VoidCallback? onTap;

  const _AnswerButton({
    required this.label,
    required this.index,
    required this.selectedAnswer,
    required this.correctIndex,
    required this.validated,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedAnswer == index;
    final isCorrect = index == correctIndex;

    Color bgColor;
    Border? border;

    if (validated) {
      if (isCorrect) {
        bgColor = AppColors.statGreen.withValues(alpha: 0.25);
        border = Border.all(color: AppColors.statGreen);
      } else if (isSelected) {
        bgColor = AppColors.error.withValues(alpha: 0.25);
        border = Border.all(color: AppColors.error);
      } else {
        bgColor = AppColors.backgroundElevated;
        border = null;
      }
    } else {
      if (isSelected) {
        bgColor = AppColors.accent.withValues(alpha: 0.15);
        border = Border.all(color: AppColors.accent);
      } else {
        bgColor = AppColors.backgroundElevated;
        border = null;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Gradient CTA button for the Jonin gate screen.
class _JoninButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _JoninButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, AppColors.accentBright],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Devenir Jonin',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
