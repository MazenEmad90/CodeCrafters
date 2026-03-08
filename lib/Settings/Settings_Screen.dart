import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_life_organizer/Login%20&%20Sign%20Up/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = "Loading...";
  String userEmail = "...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('current_user_name') ?? "Guest User";
      userEmail = prefs.getString('current_user_email') ?? "No Email Found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2214), // نفس لون الخلفية في التصميم
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Section
          Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF2EE07D),
                child: Icon(Icons.person, color: Colors.black, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, 
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Edit Profile', 
                        style: TextStyle(color: Color(0xFF2EE07D), fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Divider(color: Colors.white12),

          _sectionTitle('Account'),
          _settingTile('Manage Subscription', 'Pro Plan Active'),
          _settingTile('Email Address', userEmail),

          _sectionTitle('Preferences'),
          _switchTile('Dark Mode', true),
          _settingTile('Notifications', 'On'),

          _sectionTitle('Integrations'),
          _settingTile('Calendar Sync', 'Connected'),

          const SizedBox(height: 40),

          // Log Out Button
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('current_user_name');
              await prefs.remove('current_user_email');
              
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (_) => const LoginUI()), 
                (route) => false
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Log Out', 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(color: Color(0xFF2EE07D), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );

  Widget _settingTile(String title, String subtitle) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
      );

  Widget _switchTile(String title, bool value) => SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeColor: const Color(0xFF2EE07D),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        value: value,
        onChanged: (val) {},
      );
}