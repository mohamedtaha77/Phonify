import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../auth/sign_in_screen.dart';
import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Locale _selectedLocale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.profile),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/images/avatar.png'),
            ),
            const SizedBox(height: 16),
            Text(
              authProvider.user?.name ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              authProvider.user?.email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                const Text(
                  'Select Language:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                DropdownButton<Locale>(
                  value: _selectedLocale,
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                  ],
                  onChanged: (Locale? locale) {
                    if (locale != null) {
                      setState(() {
                        _selectedLocale = locale;
                      });
                      FlutterShoppingApp.setLocale(context, locale);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                authProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: Text(localization.logout),
            ),
          ],
        ),
      ),
    );
  }
}
