import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/settings_screen.dart';
import '../theme_provider.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,

      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

            // 🔹 TOP ROW: Logo + Menu + Divider
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Image.asset(
          'assets/images/scribe_logo.png',
          height: 52, // bigger logo
        ),
        const SizedBox(width: 8),
        const Text(
          '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    ),

    // Transparent vertical line
    Container(
      width: 1,
      height: 40,
      color: Colors.black.withOpacity(0.1), // adjust opacity
      margin: const EdgeInsets.symmetric(horizontal: 12),
    ),

    // Right side menu/toggle buttons
    PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.black),
      onSelected: (value) async {
        if (value == 'logout') {
          await FirebaseAuth.instance.signOut();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (_) => false,
          );
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'logout',
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  ],
),


              const SizedBox(height: 16),

              // 🔹 TITLE
              const Text(
                'LawScribe AI 🤖',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 ICONS WITH CIRCLES
              Row(
                children: [
                  _circleIcon(
                    icon: Icons.wb_sunny_outlined,
                    onTap: () {
                      themeNotifier.value = ThemeMode.light;
                    },
                  ),
                  const SizedBox(width: 12),
                  _circleIcon(
                    icon: Icons.nights_stay_outlined,
                    onTap: () {
                      themeNotifier.value = ThemeMode.dark;
                    },
                  ),
                  const SizedBox(width: 12),
                  _circleIcon(
                    icon: Icons.settings_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 CIRCULAR ICON WIDGET
  static Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(180);
}
