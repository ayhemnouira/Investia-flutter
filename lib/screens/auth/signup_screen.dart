// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importer GoRouter
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';
import '../../risk_management/navigation/app_router.dart'; // Pour AppRoutes

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        final success = await authProvider.register(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // GoRouter gérera la redirection vers '/home' si l'enregistrement est réussi.
        if (success && mounted) {
          print("Signup successful, GoRouter should redirect.");
        } else if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('L\'enregistrement a échoué. Veuillez réessayer.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur d\'enregistrement: ${e.toString().replaceFirst("Exception: ", "")}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>(); // Pour isLoading
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // appBar: AppBar( // Optionnel: si vous voulez un titre explicite ou un bouton retour forcé
      //   title: const Text("Créer un compte"),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: colorScheme.onSurface,
      // ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo (cohérent avec LoginScreen)
                  Container(
                    width: 120,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 30.0), // Un peu moins d'espace qu'au login
                    child: Image.asset('assets/images/aa.jpg', fit: BoxFit.contain),
                  ),

                  Text(
                    'Créer un compte',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rejoignez InvestIA dès aujourd\'hui.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Champ Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nom d\'utilisateur',
                      hintText: 'Choisissez un nom d\'utilisateur',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Nom d\'utilisateur requis' : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Champ Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Adresse e-mail',
                      hintText: 'Entrez votre e-mail',
                      prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'E-mail requis';
                      final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (!emailRegex.hasMatch(value!)) return 'Format d\'e-mail invalide';
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Champ Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Créez un mot de passe sécurisé',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Mot de passe requis';
                      if (value!.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères'; // Exemple de règle
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Champ Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      hintText: 'Retapez votre mot de passe',
                      prefixIcon: Icon(Icons.lock_person_outlined, color: colorScheme.primary), // Icône légèrement différente
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Veuillez confirmer le mot de passe';
                      if (value != _passwordController.text) return 'Les mots de passe ne correspondent pas';
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitSignup(),
                  ),
                  const SizedBox(height: 32),

                  // Bouton Signup
                  authProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Créer le compte'),
                    onPressed: _submitSignup,
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

                  // Lien vers Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Déjà un compte ?',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {
                          // Utiliser GoRouter pour retourner à la page de connexion
                          // context.go('/') ou context.go(AppRoutes.login) si vous voulez remplacer la pile
                          // context.pop() si SignupScreen a été poussé par-dessus LoginScreen
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.login); // Fallback si on ne peut pas pop
                          }
                        },
                        child: Text(
                          'Se connecter',
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