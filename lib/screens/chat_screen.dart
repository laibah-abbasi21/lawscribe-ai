import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../components/chat_bubble.dart';
import '../components/message_input.dart';
import '../theme_provider.dart';
import '../components/scribe_logo.dart';
import '../components/appbar_hover_icon.dart';
import '../components/hover_icon.dart';

// ✅ Add this:
import '../components/_header_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String currentUserName = "user"; // Replace with logged-in user dynamically
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;

  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'ai',
      'type': 'text',
      'text': 'Hello! I’m LawScribe AI 🤖. How can I help you?',
      'time': '10:00 AM',
    },
  ];

  void sendMessage(String text, PlatformFile? file, String? audioPath) {
    if (text.trim().isEmpty && file == null) return;

    final time = _formatTime(DateTime.now());

    setState(() {
      if (text.trim().isNotEmpty) {
        messages.add({
          'sender': 'user',
          'type': 'text',
          'text': text,
          'time': time,
        });
      }

      if (file != null) {
        messages.add({
          'sender': 'user',
          'type': 'file',
          'fileName': file.name,
          'fileSize': (file.size / 1024).toStringAsFixed(1),
          'time': time,
        });
      }

      isTyping = true;
    });

    _scrollToBottom();
    _simulateAIReply();
  }

  void _simulateAIReply() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final replies = [
      "Thanks for sharing that. Based on general legal principles, contracts must clearly define obligations of all parties.",
      "From a legal standpoint, enforceability depends on consent, consideration, and lawful purpose.",
      "This situation may involve contractual interpretation. I recommend checking termination and liability clauses.",
      "In many jurisdictions, written agreements carry more weight than verbal assurances.",
      "It would be advisable to review this document carefully or consult a licensed legal professional.",
      "Let me explain this in simple terms: the wording of the contract determines your rights and responsibilities.",
    ];

    setState(() {
      isTyping = false;
      messages.add({
        'sender': 'ai',
        'type': 'text',
        'text': replies[DateTime.now().millisecondsSinceEpoch % replies.length],
        'time': _formatTime(DateTime.now()),
      });
    });

    _scrollToBottom();
  }

  String _formatTime(DateTime now) {
    return '${now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 150,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showEditDialog(int index) {
    final controller =
        TextEditingController(text: messages[index]['text'] ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                messages[index]['text'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade100,

      // ================= HEADER =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: AppBar(
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,

          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.deepPurple.shade600,
                  Colors.deepPurple.shade400,
                ],
              ),
            ),
          ),

          leading: HoverIcon(
            icon: Icons.arrow_back,
            tooltip: "Back",
            onTap: () => Navigator.of(context).pop(),
          ),

          title: const Padding(
            padding: EdgeInsets.only(left: 4),
            child: ScribeLogo(height: 40),
          ),

          actions: [
            Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;

                // 📱 MOBILE: show only menu icon
                if (screenWidth < 520) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _HoverMenuButton(
                      icon: Icons.menu,
                      items: [
                        _HoverMenuItem(
                          icon: Icons.dashboard_outlined,
                          label: "Dashboard",
                          onTap: () => Navigator.pushNamed(context, '/dashboard'),
                        ),
                        _HoverMenuItem(
                          icon: Icons.settings_outlined,
                          label: "Settings",
                          onTap: () => Navigator.pushNamed(context, '/settings'),
                        ),
                      ],
                    ),
                  );
                }

                // 🖥 DESKTOP/TABLET: show icon + label
                return Row(
                  children: [
                    HeaderButton(
                      icon: Icons.dashboard_outlined,
                      label: "Dashboard",
                      onTap: () => Navigator.pushNamed(context, '/dashboard'),
                    ),
                    HeaderButton(
                      icon: Icons.settings_outlined,
                      label: "Settings",
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
          ],

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // <-- add space between header and chat
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == messages.length) {
                  return ChatBubble(
                    isUser: false,
                    label: 'AI',
                    message: '',
                    time: '',
                    isTyping: true,
                  );
                }

                final msg = messages[index];

                return ChatBubble(
                  isUser: msg['sender'] == 'user',
                  label: msg['sender'] == 'user'
                      ? currentUserName[0].toUpperCase()
                      : 'AI',
                  message: msg['text'],
                  fileName: msg['fileName'],
                  fileSize: msg['fileSize'],
                  time: msg['time'],
                  delivered: msg['sender'] == 'user',

                  onCopy: () {
                    if (msg['text'] != null) {
                      Clipboard.setData(ClipboardData(text: msg['text']));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message copied!')),
                      );
                    }
                  },

                  onEdit: msg['sender'] == 'user'
                      ? () {
                          _showEditDialog(index);
                        }
                      : null,

                  onDislike: msg['sender'] == 'ai'
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Disliked AI message!')),
                          );
                        }
                      : null,

                  onShare: msg['sender'] == 'ai'
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Shared AI message!')),
                          );
                        }
                      : null,
                );
              },
            ),
          ),
          MessageInputBar(onSend: sendMessage),
        ],
      ),
    );
  }
}

/// ================= Hover Menu Button =================
class _HoverMenuButton extends StatefulWidget {
  final IconData icon;
  final List<_HoverMenuItem> items;

  const _HoverMenuButton({
    required this.icon,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  State<_HoverMenuButton> createState() => _HoverMenuButtonState();
}

class _HoverMenuButtonState extends State<_HoverMenuButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: PopupMenuButton<int>(
        icon: Icon(
          widget.icon,
          color: _hover ? Colors.white : Colors.white70,
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        itemBuilder: (context) {
          return List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            return PopupMenuItem(
              value: index,
              child: _HoverMenuTile(
                icon: item.icon,
                label: item.label,
                onTap: item.onTap,
              ),
            );
          });
        },
      ),
    );
  }
}

class _HoverMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _HoverMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _HoverMenuTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HoverMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_HoverMenuTile> createState() => _HoverMenuTileState();
}

class _HoverMenuTileState extends State<_HoverMenuTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _hover ? Colors.deepPurple.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: Colors.deepPurple),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
