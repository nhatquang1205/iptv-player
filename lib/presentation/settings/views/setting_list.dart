import 'package:flutter/material.dart';
import 'package:iptv_player/presentation/language/language.dart';
import 'package:iptv_player/presentation/settings/views/review_page.dart';

class SettingListPage extends StatelessWidget {
  const SettingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          item(
              icon: Icons.language,
              iconColor: Theme.of(context).primaryColor,
              title: 'Language',
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageWidget()),
                    )
                  }),
          item(
              icon: Icons.star,
              iconColor: Theme.of(context).primaryColor,
              title: 'Rate Us',
              onTap: () => {
                    CustomRatingBottomSheet.showFeedBackBottomSheet(
                        context: context)
                  }),
          item(
            icon: Icons.privacy_tip,
            iconColor: Theme.of(context).primaryColor,
            title: 'Privacy Policy',
            onTap: () => {},
          ),
          item(
            icon: Icons.shield,
            iconColor: Theme.of(context).primaryColor,
            title: 'Terms & Conditions',
            onTap: () => {},
          ),
          item(
            icon: Icons.email,
            iconColor: Theme.of(context).primaryColor,
            title: 'Contact Us',
            onTap: () => {},
          ),
        ],
      ),
    );
  }

  Widget item({
    required Color iconColor,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: iconColor,
      ),
      onTap: onTap,
    );
  }
}
