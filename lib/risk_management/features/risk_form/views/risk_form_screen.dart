import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/risk.dart';
import '../../../core/services/risk_service.dart' as core_services;
import '../providers/risk_form_providers.dart';
import '../../../navigation/app_router.dart';
import '../../risk_list/providers/risk_list_providers.dart';

class RiskFormScreen extends ConsumerStatefulWidget {
  final int? riskId;
  const RiskFormScreen({super.key, this.riskId});

  @override
  ConsumerState<RiskFormScreen> createState() => _RiskFormScreenState();
}

class _RiskFormScreenState extends ConsumerState<RiskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _ownerController;
  late TextEditingController _mitigationController;
  String? _selectedCategory;
  int? _selectedImpact;
  int? _selectedProbability;
  bool get _isEditMode => widget.riskId != null;
  String get _pageTitle => _isEditMode
      ? 'Modifier le Risque #${widget.riskId}'
      : 'Ajouter un Risque';
  bool _isSubmitting = false;
  bool _initialDataLoaded = false;

  final List<String> _categories = const [
    'Financier',
    'Opérationnel',
    'Stratégique',
    'Conformité',
    'Cybersécurité',
    'Ressources Humaines',
    'Autre'
  ];
  final List<int> _impactLevels = const [1, 2, 3, 4, 5];
  final List<int> _probabilityLevels = const [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _ownerController = TextEditingController();
    _mitigationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ownerController.dispose();
    _mitigationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSubmitting = true;
      });
      final riskData = Risk(
          id: widget.riskId,
          name: _nameController.text,
          description: _descriptionController.text,
          category: _selectedCategory!,
          impact: _selectedImpact!,
          probability: _selectedProbability!,
          owner:
              _ownerController.text.isNotEmpty ? _ownerController.text : null,
          mitigationPlan: _mitigationController.text.isNotEmpty
              ? _mitigationController.text
              : null);
      print("RiskFormScreen: Soumission du formulaire avec: $riskData");
      try {
        final riskService = ref.read(core_services.riskServiceProvider);
        if (_isEditMode) {
          print("RiskFormScreen: Appel updateRisk...");
          await riskService.updateRisk(widget.riskId!, riskData);
        } else {
          print("RiskFormScreen: Appel addRisk...");
          await riskService.addRisk(riskData);
        }
        print("RiskFormScreen: Opération réussie.");
        ref.invalidate(riskListProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Risque ${_isEditMode ? 'mis à jour' : 'ajouté'} avec succès!')));
          context.pop();
        }
      } catch (e) {
        print("RiskFormScreen: Erreur lors de la soumission: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erreur lors de l\'enregistrement: $e'),
              backgroundColor: Theme.of(context).colorScheme.error));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    } else {
      print("RiskFormScreen: Formulaire invalide.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initialDataAsync = ref.watch(riskFormProvider(widget.riskId));

    if (_isEditMode &&
        initialDataAsync is AsyncData<Risk?> &&
        !_initialDataLoaded) {
      final initialRisk = initialDataAsync.value;
      if (initialRisk != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _nameController.text = initialRisk.name;
              _descriptionController.text = initialRisk.description;
              _ownerController.text = initialRisk.owner ?? '';
              _mitigationController.text = initialRisk.mitigationPlan ?? '';
              _selectedCategory = initialRisk.category;
              _selectedImpact = initialRisk.impact;
              _selectedProbability = initialRisk.probability;
              _initialDataLoaded = true;
            });
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: theme
            .colorScheme.primaryContainer, // Couleur d'arrière-plan de l'AppBar
        foregroundColor: theme
            .colorScheme.onPrimaryContainer, // Couleur du texte de l'AppBar
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // Augmentation du padding global
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (_isEditMode &&
                    (initialDataAsync.isLoading || initialDataAsync.hasError))
                  initialDataAsync.when(
                    data: (_) => const SizedBox.shrink(),
                    loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(child: CircularProgressIndicator())),
                    error: (err, stack) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                            child: Text(
                          "Erreur chargement données initiales:\n$err",
                          style: TextStyle(color: theme.colorScheme.error),
                          textAlign: TextAlign.center,
                        ))),
                  )
                else
                  _buildFormContent(context, theme),
                const SizedBox(height: 40),
                _isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(_isEditMode
                                ? Icons.save_rounded
                                : Icons.add_task_rounded),
                            label: Text(
                                _isEditMode
                                    ? 'Enregistrer les modifications'
                                    : 'Ajouter le risque',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              shadowColor:
                                  theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side:
                                  BorderSide(color: theme.colorScheme.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor:
                                  theme.colorScheme.onSurfaceVariant,
                            ),
                            child: const Text('Annuler',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Identification du Risque",
            style: theme.textTheme.titleLarge
                ?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 12),
        _buildTextFormField(
          controller: _nameController,
          labelText: 'Nom du risque *',
          hintText: 'Ex: Perte de données client',
          prefixIcon: const Icon(Icons.label_important_outline),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Nom requis.';
            if (value.length < 3) return 'Min 3 caractères.';
            return null;
          },
        ),
        const SizedBox(height: 18),
        _buildTextFormField(
          controller: _descriptionController,
          labelText: 'Description *',
          hintText: 'Décrivez le risque en détail...',
          prefixIcon: const Icon(Icons.description_outlined),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Description requise.';
            if (value.length > 1000) return 'Max 1000 caractères.';
            return null;
          },
        ),
        const SizedBox(height: 18),
        _buildDropdownFormField<String>(
          value: _selectedCategory,
          labelText: 'Catégorie *',
          prefixIcon: const Icon(Icons.category_outlined),
          items: _categories
              .map((String category) => DropdownMenuItem<String>(
                  value: category, child: Text(category)))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          validator: (value) => value == null ? 'Catégorie requise.' : null,
        ),
        const SizedBox(height: 24),
        Text("Évaluation",
            style: theme.textTheme.titleLarge
                ?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDropdownFormField<int>(
                value: _selectedImpact,
                labelText: 'Impact *',
                prefixIcon: const Icon(Icons.show_chart_rounded),
                items: _impactLevels
                    .map((int level) => DropdownMenuItem<int>(
                        value: level,
                        child: Text('$level - ${_getImpactLabel(level)}')))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedImpact = newValue;
                  });
                },
                validator: (value) => value == null ? 'Impact requis.' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownFormField<int>(
                value: _selectedProbability,
                labelText: 'Probabilité *',
                prefixIcon: const Icon(Icons.percent_rounded),
                items: _probabilityLevels
                    .map((int level) => DropdownMenuItem<int>(
                        value: level,
                        child: Text('$level - ${_getProbabilityLabel(level)}')))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProbability = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Probabilité requise.' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text("Informations Supplémentaires",
            style: theme.textTheme.titleLarge
                ?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 12),
        _buildTextFormField(
          controller: _ownerController,
          labelText: 'Propriétaire (Optionnel)',
          hintText: 'Ex: Département IT',
          prefixIcon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 18),
        _buildTextFormField(
          controller: _mitigationController,
          labelText: 'Plan de mitigation (Optionnel)',
          hintText: 'Actions envisagées...',
          prefixIcon: const Icon(Icons.healing_outlined),
          maxLines: 3,
          validator: (value) {
            if (value != null && value.length > 1000)
              return 'Max 1000 caractères.';
            return null;
          },
        ),
      ],
    );
  }

  // --- Widgets de formulaire réutilisables avec style ---
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.outline)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.primary)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.error)),
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdownFormField<T>({
    required T? value,
    required String labelText,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
    Widget? prefixIcon,
    String? Function(T?)? validator,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.outline)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.primary)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.error)),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  String _getImpactLabel(int level) {
    switch (level) {
      case 1:
        return 'Très faible';
      case 2:
        return 'Faible';
      case 3:
        return 'Modéré';
      case 4:
        return 'Élevé';
      case 5:
        return 'Très élevé';
      default:
        return '';
    }
  }

  String _getProbabilityLabel(int level) {
    switch (level) {
      case 1:
        return 'Très faible';
      case 2:
        return 'Faible';
      case 3:
        return 'Modérée';
      case 4:
        return 'Élevée';
      case 5:
        return 'Très élevée';
      default:
        return '';
    }
  }
}
