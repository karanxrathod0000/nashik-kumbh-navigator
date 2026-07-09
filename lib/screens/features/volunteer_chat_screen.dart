import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/common/verified_badge.dart';

class VolunteerChatScreen extends ConsumerStatefulWidget {
  const VolunteerChatScreen({super.key});

  @override
  ConsumerState<VolunteerChatScreen> createState() => _VolunteerChatScreenState();
}

class _VolunteerChatScreenState extends ConsumerState<VolunteerChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'Volunteer Guide (Anand)', 'text': 'Namaste 🙏 Welcome to Nashik Kumbh Mela Control Room Helpdesk! How can I assist you today?', 'isMe': false, 'time': '10:15 AM'},
    {'sender': 'Me', 'text': 'Hello, where can I find wheelchair access for Ramkund Ghat?', 'isMe': true, 'time': '10:16 AM'},
    {'sender': 'Volunteer Guide (Anand)', 'text': 'Wheelchair ramps are set up at Gate #3 (East Entrance). There is also an electric shuttle buggy service available for elderly citizens at Panchavati Circle parking lot.', 'isMe': false, 'time': '10:17 AM'},
  ];

  void _sendMessage() {
    final userMsg = _msgCtrl.text.trim();
    if (userMsg.isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'Me',
        'text': userMsg,
        'isMe': true,
        'time': 'Just now',
      });
    });
    _msgCtrl.clear();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'Volunteer Guide (Anand)',
            'text': 'Thank you! I have noted your query: "$userMsg". ${_getReply(userMsg)}',
            'isMe': false,
            'time': 'Just now',
          });
        });
      }
    });
  }

  String _getReply(String q) {
    final lower = q.toLowerCase();
    if (lower.contains('lost') || lower.contains('missing')) {
      return "Please check the Lost & Found tab or approach the police booth at Pillar 12.";
    }
    if (lower.contains('food') || lower.contains('water')) {
      return "Free community kitchens (Bhandaras) and RO drinking stations are open 24/7 at Tapovan Camp.";
    }
    return "Our ground support team at Sector 2 will assist you immediately. Stay on the green highlighted routes.";
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const VerifiedAvatar(imageUrl: 'https://i.pravatar.cc/150?u=vol_anand', size: 38, isOnline: true),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(tr.translate('volunteer_chat'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: AppColors.infoSkyBlue, size: 14),
                  ],
                ),
                Text('Online • Official Helpdesk #04', style: AppTypography.caption(isDark).copyWith(fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connecting voice call to Volunteer Guide...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryViolet.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, size: 16, color: AppColors.primaryViolet),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All chats are monitored by Kumbh Mela Authority for pilgrim safety and rapid response.',
                    style: AppTypography.caption(isDark).copyWith(color: AppColors.primaryViolet, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isMe = msg['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primaryViolet : (isDark ? AppColors.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 18),
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe) ...[
                          Text(
                            msg['sender'] as String,
                            style: AppTypography.captionBold(isDark).copyWith(color: AppColors.secondarySaffron, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          msg['text'] as String,
                          style: TextStyle(
                            color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg['time'] as String,
                            style: TextStyle(
                              color: isMe ? Colors.white70 : AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1B1B23) : const Color(0xFFF4F4F6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        controller: _msgCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Ask Volunteer Guide anything...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.secondarySaffron,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
