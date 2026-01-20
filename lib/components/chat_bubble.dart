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

  final VoidCallback? onCopy;
  final VoidCallback? onEdit;
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

    // 🔥 FIXED USER COLOR (NO FADE)
    final bubbleColor = isUser
        ? Colors.deepPurple
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                          children: const [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text("Typing...", style: TextStyle(color: Colors.white70)),
                          ],
                        )
                      else if (fileName != null)
                        Row(
                          children: [
                            Icon(
                              fileName!.endsWith('.pdf')
                                  ? Icons.picture_as_pdf
                                  : Icons.description,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
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
                                        fontSize: 11,
                                        color: textColor.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else if (message != null)
                        Text(message!, style: TextStyle(color: textColor)),

                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.7)),
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

                Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: isUser
                      ? [
                          if (onCopy != null)
                            _HoverIcon(icon: Icons.copy_outlined, tooltip: "Copy", onTap: onCopy!),
                          if (onEdit != null)
                            _HoverIcon(icon: Icons.edit_outlined, tooltip: "Edit", onTap: onEdit!),
                        ]
                      : [
                          if (onDislike != null)
                            _HoverIcon(icon: Icons.thumb_down_alt_outlined, tooltip: "Dislike", onTap: onDislike!),
                          if (onCopy != null)
                            _HoverIcon(icon: Icons.copy_outlined, tooltip: "Copy", onTap: onCopy!),
                          if (onShare != null)
                            _HoverIcon(icon: Icons.share_outlined, tooltip: "Share", onTap: onShare!),
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

class _HoverIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _HoverIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: onTap,
      ),
    );
  }
}
