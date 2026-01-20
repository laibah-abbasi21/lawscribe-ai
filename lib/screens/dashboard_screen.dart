import 'package:flutter/material.dart';
import '../components/scribe_logo.dart';
import '../components/dashboard_stat_card.dart';
import '../components/_header_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width > 700) crossAxisCount = 2;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ================= HEADER =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          elevation: 0,
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

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: "Back to Login",
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),

          title: const ScribeLogo(height: 42),

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
                          icon: Icons.chat_bubble_outline,
                          label: "Chat",
                          onTap: () => Navigator.pushNamed(context, '/chat'),
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

                // 🖥 DESKTOP/TABLET: show buttons
                return Row(
                  children: [
                    HeaderButton(
                      icon: Icons.chat_bubble_outline,
                      label: "Chat",
                      onTap: () => Navigator.pushNamed(context, '/chat'),
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
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DASHBOARD",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 28),

            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.8,
              ),
              children: [
                DashboardStatCard(
                  title: "Total Documents",
                  value: "23",
                  icon: Icons.description_outlined,
                  color: Colors.deepPurple,
                ),
                DashboardStatCard(
                  title: "Chats Today",
                  value: "12",
                  icon: Icons.chat_outlined,
                  color: Colors.blue,
                ),
                DashboardStatCard(
                  title: "AI Responses",
                  value: "86",
                  icon: Icons.smart_toy_outlined,
                  color: Colors.green,
                ),
                DashboardStatCard(
                  title: "Pending Reviews",
                  value: "3",
                  icon: Icons.pending_actions_outlined,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              "Weekly Usage",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "📊 Usage Graph Placeholder",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ================= Hover Menu Button (Responsive) =================
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
