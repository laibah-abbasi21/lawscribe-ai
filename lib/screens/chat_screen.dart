import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../components/chat_bubble.dart';
import '../components/message_input.dart';
import '../theme_provider.dart';
import '../components/scribe_logo.dart';
import '../components/appbar_hover_icon.dart';
import '../components/hover_icon.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String currentUserName = "Ayaan"; // Replace with logged-in user dynamically
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

    setState(() {
      isTyping = false;
      messages.add({
        'sender': 'ai',
        'type': 'text',
        'text': 'I can assist with contracts, drafts, and legal research.',
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A3FC8),
            Color(0xFF7B4EDB),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
      HoverIcon(
        icon: Icons.settings_outlined,
        tooltip: "Settings",
        onTap: () => Navigator.of(context).pushNamed('/settings'),
      ),
      const SizedBox(width: 8),
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
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
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
                  // -------- User Icons --------
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
                  // -------- AI Icons --------
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
