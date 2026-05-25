import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/otadex_image.dart';

// ─── Message model ───────────────────────────────────────────────────────────

class _Message {
  final String text;
  final bool isUser;
  final DateTime time;

  _Message({required this.text, required this.isUser}) : time = DateTime.now();
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class CharacterChatScreen extends ConsumerStatefulWidget {
  final String charId;
  final String charName;
  final String charImageUrl;
  final String charBio;

  const CharacterChatScreen({
    super.key,
    required this.charId,
    required this.charName,
    required this.charImageUrl,
    required this.charBio,
  });

  @override
  ConsumerState<CharacterChatScreen> createState() =>
      _CharacterChatScreenState();
}

class _CharacterChatScreenState extends ConsumerState<CharacterChatScreen>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  final List<_Message> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;

  // ── Typing indicator animation ───────────────────────────────────────────
  late final AnimationController _dotCtrl;

  @override
  void initState() {
    super.initState();
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _messages.add(_Message(text: _openingLine(), isUser: false));
  }

  @override
  void dispose() {
    _dotCtrl.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _openingLine() {
    final lower = widget.charName.toLowerCase();
    if (lower.contains('gojo')) {
      return "Tiens, un fan... Tu as bon goût. Bon, qu'est-ce que tu veux savoir ? 😏";
    }
    if (lower.contains('levi')) {
      return "Tu voulais me parler ? Fais vite, j'ai pas de temps à perdre.";
    }
    return "Bonjour ! Je suis ${widget.charName}. Qu'est-ce que tu veux savoir sur moi ?";
  }

  String _simulateResponse(String message) {
    final lower = widget.charName.toLowerCase();
    final question = message.toLowerCase();
    if (question.contains('bio') ||
        question.contains('histoire') ||
        question.contains('qui es')) {
      final bio = widget.charBio.trim();
      if (bio.isNotEmpty) {
        return bio.length > 220 ? '${bio.substring(0, 220)}...' : bio;
      }
    }
    if (question.contains('pouvoir') ||
        question.contains('force') ||
        question.contains('capacite')) {
      return "Mes capacites dependent de mon univers, mais OTADEX retient surtout mon impact, mes relations et les moments qui ont marque les fans.";
    }
    if (lower.contains('gojo')) {
      return "Hmm, intéressant comme question... Tu as bon goût de t'intéresser à moi. Mais franchement, peu de gens méritent une vraie réponse. Considère-toi chanceux. 😎";
    } else if (lower.contains('goku') || lower.contains('naruto')) {
      return "OUIIIII ! Je vais m'entraîner encore plus fort ! Crois en moi ! 💪";
    } else if (lower.contains('levi')) {
      return "Imbécile. Arrête de poser des questions stupides et concentre-toi.";
    } else {
      return "C'est une question intéressante... Je vais y réfléchir. Dans mon univers, les choses ne sont pas aussi simples qu'elles y paraissent.";
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _inputCtrl.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    final delay = 1500 + Random().nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));

    if (!mounted) return;
    final response = _simulateResponse(text);
    setState(() {
      _isTyping = false;
      _messages.add(_Message(text: response, isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Gate ─────────────────────────────────────────────────────────────────

  Widget _buildKageGate() {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Centered body
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '👑',
                        style: TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Contenu Kage uniquement',
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Cette fonctionnalité est réservée aux membres Kage.',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => context.push('/subscription'),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.statPurple,
                                AppColors.statPurpleDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Obtenir Kage Pass 👑',
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Avatar ───────────────────────────────────────────────────────────────

  Widget _buildAvatar(double size) {
    if (widget.charImageUrl.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: OtadexImage(
            imagePath: widget.charImageUrl,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    // Initiales fallback
    final initials = widget.charName.isNotEmpty
        ? widget.charName
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundElevated,
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.dmSans(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ── Custom header ────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 6, 12, 10),
        decoration: const BoxDecoration(
          color: AppColors.backgroundDeep,
          border: Border(
            bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            // Avatar
            _buildAvatar(36),
            const SizedBox(width: 10),
            // Name + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.charName,
                    style: GoogleFonts.dmSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Personnage IA',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // IA pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.statPurple.withValues(alpha: 0.15),
                border: Border.all(color: AppColors.statPurple, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'IA',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.statPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Message bubble ───────────────────────────────────────────────────────

  Widget _buildBubble(_Message msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Character bubble with avatar
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 16),
          _buildAvatar(32),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                msg.text,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Typing indicator ─────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 16),
          _buildAvatar(32),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: AnimatedBuilder(
              animation: _dotCtrl,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final offset = sin(
                          (_dotCtrl.value * 2 * pi) - (i * pi / 3),
                        ) *
                        4;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Transform.translate(
                        offset: Offset(0, -offset),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Input bar ────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColors.backgroundElevated,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Assistant local OTADEX · Kage exclusif',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.textDisabled,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.borderSubtle,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _inputCtrl,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Dis quelque chose à ${widget.charName}...',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: AppColors.textDisabled,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    if (profile.rank != 'kage') {
      return _buildKageGate();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Column(
        children: [
          // Custom header
          _buildHeader(),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildBubble(_messages[index]);
              },
            ),
          ),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }
}
