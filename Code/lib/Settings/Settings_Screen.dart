import 'package:flutter/material.dart';

/// Settings screen showing profile, account, preferences, integrations and support.
/// StatelessWidget because current implementation holds no mutable state.
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background for the entire screen
      backgroundColor: Color(0xFF0E2214),
      appBar: AppBar(
        // Transparent ARGB color (alpha = 0) — effectively no AppBar background color
        backgroundColor: const Color.fromARGB(0, 201, 162, 162),
        elevation: 10,
        title: Text('Settings',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Profile Section
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                // Local asset used as avatar placeholder
                backgroundImage:
                    AssetImage('assets/onboarding3.jpg'), // صورة رمزية
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display name
                    Text('Alex Thompson',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    // Edit profile action (no implementation yet)
                    TextButton(
                      onPressed:
                          () {}, // TODO: implement edit profile navigation
                      child: Text('Edit Profile'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.greenAccent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        // Shrink tap target to fit the layout
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.white24),

          // Account Section
          _sectionTitle('Account'),
          _settingTile('Manage Subscription', 'Pro Plan Active'),
          _settingTile('Email Address', 'alex.t@productivity.io'),

          // Preferences Section
          _sectionTitle('Preferences'),
          _switchTile('Dark Mode', true), // Example switch (no state)
          _settingTile('Notifications', ''),

          // Integrations Section
          _sectionTitle('Integrations'),
          _settingTile('Calendar Sync', 'Connected'),
          _settingTile('Health App', 'Disconnected'),

          // Support Section
          _sectionTitle('Support'),
          _settingTile('FAQ', ''),
          _settingTile('Help Center', ''),

          SizedBox(height: 30),

          // Logout Button (action not implemented)
          ElevatedButton(
            onPressed: () {}, // TODO: add logout logic
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          SizedBox(height: 12),
          Center(
            child: Text(
              'VERSION 2.4.0 (BUILD 102)',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget for section titles (Account, Preferences, etc.)
  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      );

  /// Reusable ListTile for simple settings rows.
  /// If subtitle is empty, no subtitle is shown.
  Widget _settingTile(String title, String subtitle) => ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle, style: TextStyle(color: Colors.white70))
            : null,
        trailing:
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {}, // TODO: implement navigation or action
      );

  /// Reusable switch tile for boolean preferences.
  /// Currently uses a fixed `value` and no state management.
  Widget _switchTile(String title, bool value) => SwitchListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        value: value,
        onChanged: (_) {}, // TODO: wire to a stateful value or provider
      );
}
