import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<void> _markAllRead(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();
    if (snapshot.docs.isEmpty) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: theme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new, color: theme.textPrimary),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: theme.textPrimary,
          ),
        ),
        actions: [
          if (uid != null)
            TextButton(
              onPressed: () => _markAllRead(uid),
              child: Text(
                'Tout lire',
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.accentColor,
                ),
              ),
            ),
        ],
      ),
      body: uid == null
          ? Center(
              child: Text(
                'Connecte-toi pour voir tes notifications.',
                style: GoogleFonts.nunitoSans(color: theme.textSecondary),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('notifications')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.accentColor,
                    ),
                  );
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return _buildEmpty(context, theme);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return _NotifItem(
                      docRef: docs[i].reference,
                      data: data,
                      onTap: (route) {
                        if (route != null && route.isNotEmpty) {
                          context.push(route);
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmpty(BuildContext context, dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.accentColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: theme.accentColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune notification',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tes alertes de compte, collections\net nouveautés OTADEX apparaîtront ici.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                height: 1.5,
                color: theme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final DocumentReference docRef;
  final Map<String, dynamic> data;
  final void Function(String? route) onTap;

  const _NotifItem({
    required this.docRef,
    required this.data,
    required this.onTap,
  });

  String _relativeTime(dynamic ts) {
    if (ts == null || ts is! Timestamp) return '';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inDays > 0) return 'Il y a ${diff.inDays}j';
    if (diff.inHours > 0) return 'Il y a ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'Il y a ${diff.inMinutes}min';
    return "À l'instant";
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final isRead = data['read'] as bool? ?? true;
    final type = data['type'] as String? ?? '';
    final title = data['title'] as String? ?? '';
    final body = data['body'] as String? ?? '';
    final route = data['route'] as String?;
    final timeStr = _relativeTime(data['created_at']);

    IconData icon;
    Color iconColor;
    switch (type) {
      case 'new_characters':
        icon = Icons.new_releases_outlined;
        iconColor = AppColors.success;
      case 'monthly_vote':
        icon = Icons.emoji_events_outlined;
        iconColor = AppColors.starYellow;
      case 'subscription':
        icon = Icons.workspace_premium_outlined;
        iconColor = AppColors.accent;
      default:
        icon = Icons.notifications_outlined;
        iconColor = AppColors.textSecondary;
    }

    return InkWell(
      onTap: () {
        if (!isRead) docRef.update({'read': true});
        onTap(route);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isRead
              ? theme.backgroundCard
              : theme.accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead
                ? theme.borderSubtle
                : theme.accentColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.w700,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                      if (timeStr.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          timeStr,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            color: theme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        color: theme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (!isRead) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
