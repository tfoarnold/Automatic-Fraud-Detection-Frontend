import 'package:automatic_fraud_detection/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigation vers les paramètres
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SettingsScreen()),
              // );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Section Photo de profil et informations
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // Section Comptes bancaires
            _buildAccountSection(),
            const SizedBox(height: 20),

            // Section Paramètres
            _buildSettingsSection(),
            const SizedBox(height: 20),

            // Section Sécurité
            _buildSecuritySection(),
            const SizedBox(height: 30),

            // Bouton de déconnexion
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Générer l'initiale du nom pour l'avatar
        String initial = 'U'; // U pour Utilisateur par défaut
        String fullName = authProvider.userName;
        String displayPhone = authProvider.userPhone;

        if (fullName.isNotEmpty) {
          initial = fullName[0].toUpperCase();
        }

        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: fullName.isNotEmpty
                  ? Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  : const Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 15),
            Text(
              fullName.isNotEmpty ? fullName : 'Utilisateur',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              displayPhone.isNotEmpty ? displayPhone : 'Numéro non renseigné',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Éditer le profil
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(color: Colors.blue[800]!),
              ),
              child: Text(
                'Éditer le profil',
                style: TextStyle(color: Colors.blue[800]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mes Comptes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildAccountItem('Compte Principal', '•••• 1214', '\$16,567.00'),
            _buildAccountItem('Compte Épargne', '•••• 5678', '\$5,430.50'),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Ajouter un compte
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.blue[800], size: 20),
                  const SizedBox(width: 5),
                  Text(
                    'Ajouter un compte',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(String name, String number, String balance) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.account_balance, color: Colors.blue[800]),
      ),
      title: Text(name),
      subtitle: Text(number),
      trailing: Text(
        balance,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Langue',
            subtitle: 'Français',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: 'Aide & Support',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: 'Sécurité',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.fingerprint,
            title: 'Authentification biométrique',
            trailing: Switch(value: true, onChanged: (val) {}),
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.credit_card,
            title: 'Cartes bancaires',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _showLogoutDialog(context);
        },
        child: const Text('Déconnexion'),
      ),
    );
  }

 void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Empêche de fermer en tapant à côté
    builder: (context) => Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: authProvider.isLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Déconnexion en cours...'),
                  ],
                )
              : const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: authProvider.isLoading
              ? [] // Pas de boutons pendant le chargement
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        // Utilisation de la méthode logout de AuthProvider
                        await authProvider.logout(context);
                        
                        // Fermer le dialog
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                        
                        // Afficher un message de confirmation
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Déconnexion réussie'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        // Gestion des erreurs
                        if (context.mounted) {
                          Navigator.pop(context); // Fermer le dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur lors de la déconnexion: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Déconnexion',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        );
      },
    ),
  );
}
}