// lib/main.dart
import 'package:flutter/material.dart';
import 'package:investia/providers/wallet_provider.dart';
import 'package:investia/providers/watchlist_provider.dart';
import 'package:investia/providers/withdrawal_provider.dart';
import 'package:provider/provider.dart' as provider_pkg;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // Importer GoRouter pour le type

// --- PROVIDERS (package:provider) ---
import 'package:investia/providers/auth_provider.dart';
import 'package:investia/providers/news_provider.dart';
import 'package:investia/providers/market_data_provider.dart';
import 'package:investia/providers/order_provider.dart';

// --- MODÈLES HIVE ---
import 'package:investia/models/news_article.dart';
import 'package:investia/models/asset.dart';

// --- GO ROUTER CONFIGURATION ---
// Importe la DÉFINITION du provider, pas l'instance.
import 'package:investia/risk_management/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env");
    print(
        ".env file loaded successfully: ${dotenv.env['API_BASE_URL'] != null ? 'API_BASE_URL found' : 'API_BASE_URL NOT found'}");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  await Hive.initFlutter();
  try {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NewsArticleAdapter());
      print("NewsArticleAdapter registered.");
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AssetAdapter());
      print("AssetAdapter registered.");
    }
  } catch (e) {
    print("Erreur lors de l'enregistrement des adapters Hive: $e");
  }

  final authProvider = AuthProvider();
  await authProvider.initialize(); // Initialiser AVANT de créer GoRouter

  runApp(
    ProviderScope(
      // On override le goRouterProvider pour lui injecter authProvider
      overrides: [
        goRouterProvider.overrideWithValue(createGoRouter(authProvider)),
      ],
      child: MyApp(authProviderInstance: authProvider),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final AuthProvider authProviderInstance;

  const MyApp({super.key, required this.authProviderInstance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Maintenant, ref.watch(goRouterProvider) fonctionnera car il est overridé
    // avec une instance qui a déjà AuthProvider.
    final GoRouter router = ref.watch(goRouterProvider);

    return provider_pkg.MultiProvider(
      providers: [
        provider_pkg.ChangeNotifierProvider.value(value: authProviderInstance),
        provider_pkg.ChangeNotifierProvider(create: (_) => NewsProvider()),
        provider_pkg.ChangeNotifierProvider(
            create: (_) => MarketDataProvider()),
        provider_pkg.ChangeNotifierProvider(create: (_) => OrderProvider()),
        provider_pkg.ChangeNotifierProvider(create: (_) => WalletProvider()),
        provider_pkg.ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        provider_pkg.ChangeNotifierProvider(
            create: (_) => WithdrawalProvider()),
      ],
      child: MaterialApp.router(
        title: 'InvestIA Unified',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.indigo.shade700,
              foregroundColor: Colors.white,
              elevation: 2,
              titleTextStyle: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                borderRadius: BorderRadius.circular(10)),
            labelStyle: GoogleFonts.poppins(),
            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.indigo.shade700,
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w500),
            unselectedLabelStyle: GoogleFonts.poppins(),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.indigo.withOpacity(0.1),
            labelStyle: GoogleFonts.poppins(color: Colors.indigo.shade700),
            selectedColor: Colors.indigo.shade600,
            secondaryLabelStyle: GoogleFonts.poppins(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
