import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void toggleTheme() {
    themeNotifier.value =
        themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;
    final maxWidth = 900.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // ================= APPBAR (MATCHES CHATSCREEN) =================
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
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
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= USER CARD (LESS HEIGHT) =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14, // <-- less height
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade600,
                        Colors.deepPurple.shade400,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Text(
                          currentUser?.email
                                  ?.substring(0, 1)
                                  .toUpperCase() ??
                              'U',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Logged in as",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentUser?.email ?? "User",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28), // <-- spacing after card

                /// ================= CHAT SECTION =================
                _sectionTitle("Chats"),
                _settingsTile(
                  icon: Icons.chat_bubble_outline,
                  title: "Your Chats",
                  subtitle: "View all conversations",
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                _settingsTile(
                  icon: Icons.search,
                  title: "Search Chats",
                  subtitle: "Find messages quickly",
                  onTap: () {},
                ),

                const SizedBox(height: 28),

                /// ================= APPEARANCE =================
                _sectionTitle("Appearance"),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) {
                    return _settingsTile(
                      icon: mode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      title: mode == ThemeMode.light
                          ? "Light Mode"
                          : "Dark Mode",
                      subtitle: "Switch app theme",
                      onTap: toggleTheme,
                    );
                  },
                ),

                const SizedBox(height: 28),

                /// ================= APP INFO (NEW) =================
                _sectionTitle("About"),
                _settingsTile(
                  icon: Icons.info_outline,
                  title: "App Version",
                  subtitle: "v1.0.0",
                  onTap: () {},
                ),
                _settingsTile(
                  icon: Icons.security_outlined,
                  title: "Privacy Policy",
                  subtitle: "Read our privacy policy",
                  onTap: () {},
                ),

                const SizedBox(height: 28),

                /// ================= LOGOUT =================
                _sectionTitle("Account"),
                _settingsTile(
                  icon: Icons.logout,
                  title: "Logout",
                  subtitle: "Sign out from your account",
                  onTap: logout,
                  isDanger: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= REUSABLE TITLE =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  /// ================= REUSABLE TILE =================
  Widget _settingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Icon(
          icon,
          color: isDanger ? Colors.red : Colors.deepPurple,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDanger ? Colors.red : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 13),
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
