// lib/screens/auth/login_screen.dart
import 'dart:io'; // Pour SocketException
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importer GoRouter
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';
import '../../risk_management/navigation/app_router.dart'; // Pour AppRoutes

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Pour la visibilité du mot de passe

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        final success = await authProvider.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
        // GoRouter gérera la redirection vers '/home' via son refreshListenable
        // et la logique dans `redirect` si le login est réussi.
        // Pas besoin de navigation explicite ici si AuthProvider notifie correctement.
        if (success && mounted) {
          print("Login successful, GoRouter should redirect.");
        } else if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nom d\'utilisateur ou mot de passe incorrect.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }

      } on SocketException {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur réseau - Impossible de joindre le serveur.'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      } on FormatException {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Réponse invalide du serveur.'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur de connexion: ${e.toString().replaceFirst("Exception: ", "")}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Peut écouter isLoading
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface, // Fond cohérent
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox( // Limiter la largeur sur les grands écrans
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 40.0),
                    child: Image.asset('assets/images/aa.jpg', fit: BoxFit.contain),
                  ),

                  Text(
                    'Connexion',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bon retour parmi nous !',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Champ Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nom d\'utilisateur',
                      hintText: 'Entrez votre nom d\'utilisateur',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest, // Fond de champ légèrement différent
                    ),
                    validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Nom d\'utilisateur requis' : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Champ Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre mot de passe',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Mot de passe requis' : null,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitLogin(), // Permet de soumettre avec la touche "Entrée"
                  ),
                  const SizedBox(height: 12),

                  // Option "Mot de passe oublié ?" (à implémenter si besoin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implémenter la logique de mot de passe oublié
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité "Mot de passe oublié" à venir.')),
                        );
                      },
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Bouton Login
                  authProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Se connecter'),
                    onPressed: _submitLogin,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lien vers Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pas encore de compte ?',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {
                          // **CORRECTION DE LA NAVIGATION**
                          // Utiliser GoRouter pour naviguer vers la page d'inscription
                          context.push(AppRoutes.signup);
                          // Ancien code (peut ne pas fonctionner correctement avec GoRouter) :
                          // Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}