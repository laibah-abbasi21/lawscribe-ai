import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/services.dart';

class MessageInputBar extends StatefulWidget {
  final void Function(String, PlatformFile?, String?) onSend;
  const MessageInputBar({Key? key, required this.onSend}) : super(key: key);

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text, null, null);
    _controller.clear();
    _focusNode.requestFocus();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      widget.onSend('', result.files.first, null);
    }
  }

  KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (event.isShiftPressed) return KeyEventResult.ignored;
      _sendMessage();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (_, emoji) {
                _controller.text += emoji.emoji;
                _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length));
              },
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: isDark ? Colors.grey[850] : Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  splashRadius: 20,
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: Focus(
                    focusNode: _focusNode,
                    onKey: _handleKeyPress,
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87),
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                          hintText: "Message to LawScribe...",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                _CircleIcon(
                  icon: Icons.emoji_emotions_outlined,
                  onTap: () {
                    setState(() => _showEmojiPicker = !_showEmojiPicker);
                    FocusScope.of(context).unfocus();
                  },
                ),
                _CircleIcon(
                  icon: Icons.mic,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Recording not available on web/desktop")));
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextButton.icon(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, size: 18, color: Colors.white),
                    label: const Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(36, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black87),
        splashRadius: 18,
        onPressed: onTap,
      ),
    );
  }
}
