// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour HapticFeedback
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:investia/providers/auth_provider.dart';
import 'package:investia/risk_management/navigation/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sectionTitleStyle = GoogleFonts.poppins(
      fontSize: 21,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface.withOpacity(0.85),
    );

    final welcomeSubtitleStyle = GoogleFonts.poppins(
      fontSize: 16,
      color: colorScheme.onSurfaceVariant.withOpacity(0.85),
    );

    final List<Widget> dashboardWidgets = _buildDashboardContent(
        context, authProvider, sectionTitleStyle, welcomeSubtitleStyle);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 80.0),
            itemCount: dashboardWidgets.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 450),
                child: SlideAnimation(
                  verticalOffset: 40.0,
                  child: FadeInAnimation(
                    child: dashboardWidgets[index],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDashboardContent(
    BuildContext context,
    AuthProvider authProvider,
    TextStyle sectionTitleStyle,
    TextStyle welcomeSubtitleStyle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, ${authProvider.username ?? 'utilisateur'} !',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Que souhaitez-vous explorer aujourd\'hui ?',
              style: welcomeSubtitleStyle,
            ),
          ],
        ),
      ),

      // --- Module de Gestion des Risques ---
      _buildSectionTitle(
        context,
        title: 'Module de Gestion des Risques',
        icon: Icons.shield_outlined, // CORRIGÉ: Icône existante
        titleStyle: sectionTitleStyle,
      ),
      _AnimatedDashboardCard(
        indexInList: 0,
        child: _DashboardCardContent(
          icon: Icons.analytics_outlined,
          label: "Analyse des Risques Boursiers",
          subtitle: "Évaluez la volatilité et les tendances.",
          onPressed: () => context.push(AppRoutes.riskAnalysis),
        ),
      ),
      _AnimatedDashboardCard(
        indexInList: 1,
        child: _DashboardCardContent(
          icon: Icons.assignment_late_outlined,
          label: "Liste des Risques Projet",
          subtitle: "Suivez et gérez les risques identifiés.",
          onPressed: () => context.go(AppRoutes.riskManagementList),
        ),
      ),
      const SizedBox(height: 28),

      // --- Données et Marchés ---
      _buildSectionTitle(
        context,
        title: 'Données et Marchés',
        icon: Icons.bar_chart_rounded,
        titleStyle: sectionTitleStyle,
      ),
      _AnimatedDashboardCard(
        indexInList: 2,
        child: _DashboardCardContent(
          icon: Icons.newspaper_outlined,
          label: "Actualités Financières",
          subtitle: "Restez informé des dernières nouvelles.",
          onPressed: () => context.go(AppRoutes.news),
        ),
      ),
      _AnimatedDashboardCard(
        indexInList: 3,
        child: _DashboardCardContent(
          icon: Icons.store_outlined,
          label: "Marché des Actifs",
          subtitle: "Explorez les crypto-monnaies et actions.",
          onPressed: () => context.go(AppRoutes.marketList),
        ),
      ),
      const SizedBox(height: 28),

      // --- Services Financiers ---
      _buildSectionTitle(
        context,
        title: 'Services Financiers',
        icon: Icons.monetization_on_outlined,
        titleStyle: sectionTitleStyle,
      ),
      _AnimatedDashboardCard(
        indexInList: 4,
        child: _DashboardCardContent(
          icon: Icons.payment_outlined,
          label: "Services de Paiement",
          subtitle: "Gérez vos abonnements et transactions.",
          onPressed: () => context.push(AppRoutes.paymentServices),
        ),
      ),
      _AnimatedDashboardCard(
        indexInList: 5,
        child: _DashboardCardContent(
          icon: Icons.receipt_long_outlined,
          label: "Gestion des Ordres",
          subtitle: "Consultez et placez vos ordres.",
          onPressed: () => context.go(AppRoutes.orders),
        ),
      ),
      const SizedBox(height: 40),

      Center(
        child: OutlinedButton.icon(
          icon: const Icon(Icons.exit_to_app_rounded, size: 20),
          label: const Text('Déconnexion'),
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.error,
            side: BorderSide(color: colorScheme.error.withOpacity(0.6)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            textStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            HapticFeedback.mediumImpact();
            await authProvider.logout();
          },
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildSectionTitle(BuildContext context,
      {required String title, required IconData icon, TextStyle? titleStyle}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 26),
          const SizedBox(width: 10),
          Text(title,
              style: titleStyle ??
                  theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AnimatedDashboardCard extends StatefulWidget {
  final int indexInList;
  final Widget child;

  const _AnimatedDashboardCard(
      {required this.indexInList, required this.child});

  @override
  State<_AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<_AnimatedDashboardCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double elevation = _isPressed ? 0.5 : (_isHovering ? 8 : 4);
    final Color shadowColor = _isHovering
        ? colorScheme.primary.withOpacity(0.25)
        : colorScheme.shadow.withOpacity(0.1);
    final Duration animationDuration = const Duration(milliseconds: 200);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 7.0),
          decoration: BoxDecoration(
            color: _isHovering
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: elevation * 2.5,
                spreadRadius: 0.5,
                offset: Offset(0, elevation / 1.5),
              ),
            ],
            border: Border.all(
              color: _isHovering
                  ? colorScheme.primary.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          // CORRIGÉ: Transform.scale n'a pas de paramètre 'duration' direct
          // Son animation est contrôlée par l'AnimatedContainer parent ou un AnimatedScale dédié.
          // Pour un effet de pression qui suit la durée de l'AnimatedContainer, on peut le garder simple.
          // Si on veut une animation d'échelle distincte, il faudrait un AnimatedScale.
          // Ici, l'AnimatedContainer s'occupe de l'animation de la déco (y compris l'ombre qui dépend de _isPressed via elevation)
          // L'échelle sera donc animée par l'AnimatedContainer si ses contraintes changent,
          // mais ici c'est le child qui est scalé. Pour que le scale lui-même soit animé,
          // il faudrait que Transform.scale soit dans un widget qui se reconstruit avec une valeur d'échelle changeante
          // ou utiliser AnimatedScale.
          // Pour la simplicité, l'effet de scale sera lié au rebuild causé par _isPressed.
          // Si l'AnimatedContainer ne reconstruit pas assez vite son child pour voir l'effet de scale,
          // l'effet de scale sera quasi instantané, ce qui est souvent ok pour un feedback de pression.
          child: Transform.scale(
            scale: _isPressed ? 0.97 : 1.0,
            // duration: animationDuration, // SUPPRIMÉ
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _DashboardCardContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onPressed;

  const _DashboardCardContent({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(
            16.0), // Doit correspondre à _AnimatedDashboardCard
        splashColor: colorScheme.primary.withOpacity(0.12),
        highlightColor: colorScheme.primary.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.15),
                      colorScheme.primaryContainer.withOpacity(0.25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
