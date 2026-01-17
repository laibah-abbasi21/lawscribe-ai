import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String label;
  final String? message;
  final String? fileName;
  final String? fileSize;
  final String time;
  final bool delivered;
  final bool isTyping;

  // User icons
  final VoidCallback? onCopy;
  final VoidCallback? onEdit;

  // AI icons
  final VoidCallback? onDislike;
  final VoidCallback? onShare;

  const ChatBubble({
    Key? key,
    required this.isUser,
    required this.label,
    this.message,
    this.fileName,
    this.fileSize,
    required this.time,
    this.delivered = false,
    this.isTyping = false,
    this.onCopy,
    this.onEdit,
    this.onDislike,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleColor = isUser
        ? (isDark ? Colors.deepPurple : Colors.deepPurple.shade100)
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade200);

    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white70 : Colors.black87);

    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple,
              child: Text(label, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          isUser ? const Radius.circular(16) : Radius.zero,
                      bottomRight:
                          isUser ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isTyping)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 6,
                              height: 6,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 6),
                            Text('Typing...'),
                          ],
                        )
                      else if (fileName != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '$fileSize KB',
                              style: TextStyle(
                                  color: textColor.withOpacity(0.7)),
                            ),
                          ],
                        )
                      else if (message != null)
                        Text(message!, style: TextStyle(color: textColor)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.6)),
                          ),
                          if (isUser && delivered)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.done_all,
                                  size: 14, color: Colors.white70),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // ================= ACTION ICONS WITH HOVER =================
                Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: isUser
                      ? [
                          if (onCopy != null)
                            _HoverIcon(
                              icon: Icons.copy_outlined,
                              tooltip: "Copy",
                              onTap: onCopy!,
                            ),
                          if (onEdit != null)
                            _HoverIcon(
                              icon: Icons.edit_outlined,
                              tooltip: "Edit",
                              onTap: onEdit!,
                            ),
                        ]
                      : [
                          if (onDislike != null)
                            _HoverIcon(
                              icon: Icons.thumb_down_alt_outlined,
                              tooltip: "Dislike",
                              onTap: onDislike!,
                            ),
                          if (onCopy != null)
                            _HoverIcon(
                              icon: Icons.copy_outlined,
                              tooltip: "Copy",
                              onTap: onCopy!,
                            ),
                          if (onShare != null)
                            _HoverIcon(
                              icon: Icons.share_outlined,
                              tooltip: "Share",
                              onTap: onShare!,
                            ),
                        ],
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple,
              child: Text(label, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }
}

/// ================= HOVER ICON WIDGET =================
class _HoverIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _HoverIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<_HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<_HoverIcon> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: hovering
                ? (isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.black.withOpacity(0.08))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            size: 16,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
