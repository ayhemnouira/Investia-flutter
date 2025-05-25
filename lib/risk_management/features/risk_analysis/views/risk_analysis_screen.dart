import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart

// Importe le notifier, l'état, et les routes
import '../providers/risk_analysis_notifier.dart';
import '../providers/risk_analysis_state.dart';
import '../../../navigation/app_router.dart';

// --- Helper _prepareChartData (inchangé) ---
List<FlSpot>? _prepareChartData(
    Map<String, dynamic>? rawData, String valueKey) {
  // ... (code de _prepareChartData reste le même) ...
  if (rawData == null ||
      rawData['values'] == null ||
      rawData['values'] is! List) {
    return null;
  }
  final valuesList = rawData['values'] as List;
  if (valuesList.isEmpty) {
    return null;
  }
  List<FlSpot> spots = [];
  for (int i = 0; i < valuesList.length; i++) {
    final item = valuesList[i];
    if (item is Map && item.containsKey(valueKey)) {
      final dynamic rawValue = item[valueKey];
      double? yValue;
      if (rawValue is String) {
        yValue = double.tryParse(rawValue);
      } else if (rawValue is num) {
        yValue = rawValue.toDouble();
      }
      if (yValue != null) {
        double xValue = (valuesList.length - 1 - i).toDouble();
        spots.add(FlSpot(xValue, yValue));
      } else {
        print(
            "Avertissement: Impossible de parser la valeur '$rawValue' pour la clé '$valueKey' à l'index $i");
      }
    }
  }
  return spots.isNotEmpty ? spots : null;
}

class RiskAnalysisScreen extends ConsumerWidget {
  const RiskAnalysisScreen({super.key});

  static const Map<String, String> domainOptions = {
    /* ... options ... */
    'technology': 'Technologie',
    'energy': 'Énergie',
    'finance': 'Finance',
    'healthcare': 'Santé',
    'realEstate': 'Immobilier',
  };
  static const Map<String, String> indicatorOptions = {
    /* ... options ... */
    'volatility': 'Volatilité (ATR)',
    'rsi': 'RSI',
    'sma': 'Moyenne Mobile Simple (SMA)',
    'ema': 'Moyenne Mobile Exponentielle (EMA)',
    'macd': 'MACD',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ... (build reste identique jusqu'à l'appel de _buildChartsSection) ...
    final state = ref.watch(riskAnalysisNotifierProvider);
    final notifier = ref.read(riskAnalysisNotifierProvider.notifier);
    print(
        "RiskAnalysisScreen: Build - isLoading: ${state.isLoading}, Symbol: ${state.symbol}");

    final symbolController = TextEditingController(text: state.symbol);
    symbolController.selection = TextSelection.fromPosition(
        TextPosition(offset: symbolController.text.length));

    return Scaffold(
      appBar: AppBar(
          title: const Text('Analyse des Risques Boursiers'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                  controller: symbolController,
                  onChanged: (value) => notifier.setSymbol(value),
                  onSubmitted: (_) => notifier.loadAndAnalyzeData(),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      labelText: 'Symbole boursier (ex: AAPL)',
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          tooltip: 'Analyser',
                          onPressed: state.isLoading
                              ? null
                              : () => notifier.loadAndAnalyzeData()),
                      border: const OutlineInputBorder())),
              const SizedBox(height: 16),
              const Text('Domaines d\'investissement (Info):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: domainOptions.entries
                      .map((entry) => Chip(label: Text(entry.value)))
                      .toList()),
              const SizedBox(height: 16),
              const Text('Indicateurs de risque:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: indicatorOptions.entries.map((entry) {
                    final key = entry.key;
                    final label = entry.value;
                    final bool isSelected =
                        state.selectedIndicators.contains(key);
                    return FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          final currentSelection =
                              List<String>.from(state.selectedIndicators);
                          if (selected) {
                            currentSelection.add(key);
                          } else {
                            currentSelection.remove(key);
                          }
                          notifier.setSelectedIndicators(currentSelection);
                        },
                        selectedColor:
                            Theme.of(context).colorScheme.primaryContainer);
                  }).toList()),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('Analyser les Risques'),
                  onPressed: state.isLoading
                      ? null
                      : () => notifier.loadAndAnalyzeData(),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12))),
              const SizedBox(height: 24),
              if (state.isLoading)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: CircularProgressIndicator())),
              if (state.errorMessage != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(state.errorMessage!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              if (state.analysisPerformed && !state.isLoading) ...[
                const Divider(height: 32, thickness: 1),
                Text('Résultats de l\'Analyse pour ${state.symbol}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                if (state.riskLevel != null)
                  Card(
                      color: _getRiskLevelColor(context, state.riskLevel!),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Niveau de Risque: ${state.riskLevel}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                              textAlign: TextAlign.center))),
                const SizedBox(height: 16),
                if (state.riskFactors.isNotEmpty) ...[
                  Text('Facteurs Identifiés:',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: state.riskFactors
                          .map((factor) => Chip(label: Text(factor)))
                          .toList())
                ],
                const SizedBox(height: 24),
                Text('Graphiques:',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _buildChartsSection(
                    context, state), // Appel à la méthode modifiée
                const SizedBox(height: 24),
                if (state.riskLevel != null &&
                    state.riskLevel != 'Non disponible')
                  ElevatedButton(
                      child: const Text('Voir les Recommandations'),
                      onPressed: () {
                        print('Voir Recommandations pour: ${state.riskLevel}');
                        context.push(AppRoutes.recommendations,
                            extra: state.riskLevel);
                      }),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget pour construire la section des graphiques (inchangé) ---
  Widget _buildChartsSection(BuildContext context, RiskAnalysisState state) {
    final List<Widget> charts = [];
    // final theme = Theme.of(context); // Pas nécessaire ici

    final priceSpots = _prepareChartData(state.priceData, 'close');
    final atrSpots = _prepareChartData(state.volatilityData, 'atr');
    final rsiSpots = _prepareChartData(state.rsiData, 'rsi');
    final smaSpots = _prepareChartData(state.smaData, 'sma');
    final emaSpots = _prepareChartData(state.emaData, 'ema');
    final macdSpots = _prepareChartData(state.macdData, 'macd');
    final macdSignalSpots = _prepareChartData(state.macdData, 'signal');

    if (priceSpots != null) {
      charts.add(_buildSingleChartCard(
          context, 'Prix de l\'action', priceSpots, Colors.blue));
    }
    if (state.selectedIndicators.contains('volatility') && atrSpots != null) {
      charts.add(_buildSingleChartCard(
          context, 'Volatilité (ATR)', atrSpots, Colors.red));
    }
    if (state.selectedIndicators.contains('rsi') && rsiSpots != null) {
      charts.add(_buildSingleChartCard(context, 'RSI', rsiSpots, Colors.purple,
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
                y: 30, color: Colors.orange.withOpacity(0.5), strokeWidth: 1),
            HorizontalLine(
                y: 70, color: Colors.orange.withOpacity(0.5), strokeWidth: 1)
          ])));
    }
    if (state.selectedIndicators.contains('sma') && smaSpots != null) {
      charts
          .add(_buildSingleChartCard(context, 'SMA', smaSpots, Colors.orange));
    }
    if (state.selectedIndicators.contains('ema') && emaSpots != null) {
      charts.add(_buildSingleChartCard(context, 'EMA', emaSpots, Colors.green));
    }
    if (state.selectedIndicators.contains('macd')) {
      charts.add(_buildMacdChartCard(context, macdSpots, macdSignalSpots));
    }

    if (charts.isEmpty && state.analysisPerformed) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
              child: Text(
                  "Aucun indicateur sélectionné ou données de graphique disponibles.")));
    }
    if (charts.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio:
                MediaQuery.of(context).size.width > 600 ? 1.6 : 1.8),
        itemCount: charts.length,
        itemBuilder: (context, index) => charts[index]);
  }

  // =========================================================================
  // === MODIFICATIONS DANS LES HELPERS DE GRAPHIQUES ===
  // =========================================================================

  // --- Helper pour construire une carte contenant un graphique simple (1 ligne) ---
  Widget _buildSingleChartCard(
      BuildContext context, String title, List<FlSpot> spots, Color lineColor,
      {ExtraLinesData? extraLinesData}) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
        fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.7));

    // Trouver les min/max pour l'axe Y (pour un meilleur affichage)
    double minY =
        spots.fold(double.infinity, (prev, e) => e.y < prev ? e.y : prev);
    double maxY = spots.fold(
        double.negativeInfinity, (prev, e) => e.y > prev ? e.y : prev);
    double yRange = maxY - minY;
    // Ajouter une marge pour éviter que la ligne ne touche les bords
    minY -= yRange * 0.1;
    maxY += yRange * 0.1;
    if (minY == maxY) {
      // Eviter division par zéro si toutes les valeurs sont identiques
      minY -= 1;
      maxY += 1;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, right: 16.0, bottom: 8.0, left: 8.0), // Ajuster padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: minY, // Définit le min de l'axe Y
                  maxY: maxY, // Définit le max de l'axe Y
                  // --- Grille ---
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false, // Cache lignes verticales
                    horizontalInterval:
                        (maxY - minY) / 4, // Intervalles grille Y
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        // Style des lignes de la grille
                        color: theme.dividerColor.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  // --- Bordures ---
                  borderData:
                      FlBorderData(show: false), // Cache les bordures externes
                  // --- Titres des Axes ---
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      // Axe Y gauche
                      sideTitles: SideTitles(
                        showTitles: true, // Affiche les titres Y
                        reservedSize: 40, // Espace réservé pour les titres
                        interval: (maxY - minY) / 4, // Intervalles titres Y
                        getTitlesWidget: (value, meta) {
                          // Ne pas afficher min/max extrêmes pour éviter chevauchement
                          if (value == meta.min || value == meta.max)
                            return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(value.toStringAsFixed(1),
                                style: textStyle, textAlign: TextAlign.right),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)), // Cache X haut
                    rightTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)), // Cache Y droite
                    bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Cache X bas pour l'instant
                  ),
                  // --- Données de la Ligne ---
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      color: lineColor,
                      barWidth: 1.8, // Légèrement plus épais
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                          show: false), // Toujours cacher les points
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withOpacity(0.2), // Opacité augmentée
                      ),
                    ),
                  ],
                  // --- Lignes Horizontales Supplémentaires (pour RSI) ---
                  extraLinesData: extraLinesData,
                  // --- Info Bulles ---
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => theme
                            .colorScheme.secondaryContainer
                            .withOpacity(0.9),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots
                              .map((spot) => LineTooltipItem(
                                  spot.y.toStringAsFixed(2),
                                  TextStyle(
                                      color: theme
                                          .colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold)))
                              .toList();
                        }),
                    handleBuiltInTouches: true,
                  ),
                ),
                duration: const Duration(milliseconds: 150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper pour construire la carte du graphique MACD (2 lignes) ---
  Widget _buildMacdChartCard(BuildContext context, List<FlSpot>? macdSpots,
      List<FlSpot>? signalSpots) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
        fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.7));
    final bool hasMacd = macdSpots != null && macdSpots.isNotEmpty;
    final bool hasSignal = signalSpots != null && signalSpots.isNotEmpty;

    if (!hasMacd && !hasSignal) {
      return const Card(
          elevation: 2,
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text("Données MACD non disponibles."))));
    }

    // Trouver les min/max pour les deux lignes combinées
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    if (hasMacd) {
      minY = macdSpots.fold(minY, (prev, e) => e.y < prev ? e.y : prev);
      maxY = macdSpots.fold(maxY, (prev, e) => e.y > prev ? e.y : prev);
    }
    if (hasSignal) {
      minY = signalSpots.fold(minY, (prev, e) => e.y < prev ? e.y : prev);
      maxY = signalSpots.fold(maxY, (prev, e) => e.y > prev ? e.y : prev);
    }
    // Ajouter marge
    double yRange = maxY - minY;
    minY -= yRange * 0.1;
    maxY += yRange * 0.1;
    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, right: 16.0, bottom: 8.0, left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("MACD", style: theme.textTheme.titleSmall),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    // Afficher grille Y
                    show: true, drawVerticalLine: false,
                    horizontalInterval: (maxY - minY) / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.dividerColor.withOpacity(0.1),
                        strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    // Afficher titres Y
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: (maxY - minY) / 4,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.min || value == meta.max)
                                return const SizedBox.shrink();
                              return Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(value.toStringAsFixed(2),
                                      style: textStyle,
                                      textAlign: TextAlign.right));
                            })),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    if (hasMacd)
                      LineChartBarData(
                          spots: macdSpots,
                          isCurved: false,
                          color: Colors.blue,
                          barWidth: 1.5,
                          dotData: const FlDotData(show: false)),
                    if (hasSignal)
                      LineChartBarData(
                          spots: signalSpots,
                          isCurved: false,
                          color: Colors.red,
                          barWidth: 1.5,
                          dotData: const FlDotData(show: false)),
                  ],
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(
                        y: 0,
                        color: Colors.grey.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [2, 2])
                  ]),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => theme
                            .colorScheme.secondaryContainer
                            .withOpacity(0.9),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            String prefix =
                                spot.barIndex == 0 ? "MACD: " : "Signal: ";
                            return LineTooltipItem(
                                '$prefix${spot.y.toStringAsFixed(2)}',
                                TextStyle(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold));
                          }).toList();
                        }),
                    handleBuiltInTouches: true,
                  ),
                ),
                duration: const Duration(milliseconds: 150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper pour la couleur du niveau de risque ---
  Color _getRiskLevelColor(BuildContext context, String riskLevel) {
    /* ... _getRiskLevelColor ... */
    switch (riskLevel.toLowerCase()) {
      case 'élevé':
        return Colors.red.shade300;
      case 'modéré':
        return Colors.orange.shade300;
      case 'faible':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }
} // Fin RiskAnalysisScreen
