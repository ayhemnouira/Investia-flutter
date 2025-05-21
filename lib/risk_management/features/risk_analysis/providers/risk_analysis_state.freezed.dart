// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'risk_analysis_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RiskAnalysisState {
// --- Entrées utilisateur ---
  String get symbol =>
      throw _privateConstructorUsedError; // Symbole boursier saisi
  List<String> get selectedDomains =>
      throw _privateConstructorUsedError; // Domaines sélectionnés
  List<String> get selectedIndicators =>
      throw _privateConstructorUsedError; // Indicateurs sélectionnés
// --- État de chargement et erreurs ---
  bool get isLoading =>
      throw _privateConstructorUsedError; // Indicateur de chargement global
  String? get errorMessage =>
      throw _privateConstructorUsedError; // Message d'erreur général
  bool get apiLimitExceeded =>
      throw _privateConstructorUsedError; // Flag spécifique pour l'erreur 429
// --- Données reçues de l'API ---
// Stocke les données JSON brutes (Map) ou des objets de modèle typés
  Map<String, dynamic>? get priceData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get volatilityData =>
      throw _privateConstructorUsedError; // ATR
  Map<String, dynamic>? get rsiData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get smaData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get emaData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get macdData =>
      throw _privateConstructorUsedError; // --- Résultats de l'analyse ---
  bool get analysisPerformed =>
      throw _privateConstructorUsedError; // Indique si une analyse a eu lieu
  String? get riskLevel =>
      throw _privateConstructorUsedError; // 'Élevé', 'Modéré', 'Faible', 'Non disponible'
  List<String> get riskFactors => throw _privateConstructorUsedError;

  /// Create a copy of RiskAnalysisState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiskAnalysisStateCopyWith<RiskAnalysisState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiskAnalysisStateCopyWith<$Res> {
  factory $RiskAnalysisStateCopyWith(
          RiskAnalysisState value, $Res Function(RiskAnalysisState) then) =
      _$RiskAnalysisStateCopyWithImpl<$Res, RiskAnalysisState>;
  @useResult
  $Res call(
      {String symbol,
      List<String> selectedDomains,
      List<String> selectedIndicators,
      bool isLoading,
      String? errorMessage,
      bool apiLimitExceeded,
      Map<String, dynamic>? priceData,
      Map<String, dynamic>? volatilityData,
      Map<String, dynamic>? rsiData,
      Map<String, dynamic>? smaData,
      Map<String, dynamic>? emaData,
      Map<String, dynamic>? macdData,
      bool analysisPerformed,
      String? riskLevel,
      List<String> riskFactors});
}

/// @nodoc
class _$RiskAnalysisStateCopyWithImpl<$Res, $Val extends RiskAnalysisState>
    implements $RiskAnalysisStateCopyWith<$Res> {
  _$RiskAnalysisStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RiskAnalysisState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? selectedDomains = null,
    Object? selectedIndicators = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? apiLimitExceeded = null,
    Object? priceData = freezed,
    Object? volatilityData = freezed,
    Object? rsiData = freezed,
    Object? smaData = freezed,
    Object? emaData = freezed,
    Object? macdData = freezed,
    Object? analysisPerformed = null,
    Object? riskLevel = freezed,
    Object? riskFactors = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDomains: null == selectedDomains
          ? _value.selectedDomains
          : selectedDomains // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedIndicators: null == selectedIndicators
          ? _value.selectedIndicators
          : selectedIndicators // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      apiLimitExceeded: null == apiLimitExceeded
          ? _value.apiLimitExceeded
          : apiLimitExceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      priceData: freezed == priceData
          ? _value.priceData
          : priceData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      volatilityData: freezed == volatilityData
          ? _value.volatilityData
          : volatilityData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rsiData: freezed == rsiData
          ? _value.rsiData
          : rsiData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      smaData: freezed == smaData
          ? _value.smaData
          : smaData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      emaData: freezed == emaData
          ? _value.emaData
          : emaData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      macdData: freezed == macdData
          ? _value.macdData
          : macdData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      analysisPerformed: null == analysisPerformed
          ? _value.analysisPerformed
          : analysisPerformed // ignore: cast_nullable_to_non_nullable
              as bool,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      riskFactors: null == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiskAnalysisStateImplCopyWith<$Res>
    implements $RiskAnalysisStateCopyWith<$Res> {
  factory _$$RiskAnalysisStateImplCopyWith(_$RiskAnalysisStateImpl value,
          $Res Function(_$RiskAnalysisStateImpl) then) =
      __$$RiskAnalysisStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbol,
      List<String> selectedDomains,
      List<String> selectedIndicators,
      bool isLoading,
      String? errorMessage,
      bool apiLimitExceeded,
      Map<String, dynamic>? priceData,
      Map<String, dynamic>? volatilityData,
      Map<String, dynamic>? rsiData,
      Map<String, dynamic>? smaData,
      Map<String, dynamic>? emaData,
      Map<String, dynamic>? macdData,
      bool analysisPerformed,
      String? riskLevel,
      List<String> riskFactors});
}

/// @nodoc
class __$$RiskAnalysisStateImplCopyWithImpl<$Res>
    extends _$RiskAnalysisStateCopyWithImpl<$Res, _$RiskAnalysisStateImpl>
    implements _$$RiskAnalysisStateImplCopyWith<$Res> {
  __$$RiskAnalysisStateImplCopyWithImpl(_$RiskAnalysisStateImpl _value,
      $Res Function(_$RiskAnalysisStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RiskAnalysisState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? selectedDomains = null,
    Object? selectedIndicators = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? apiLimitExceeded = null,
    Object? priceData = freezed,
    Object? volatilityData = freezed,
    Object? rsiData = freezed,
    Object? smaData = freezed,
    Object? emaData = freezed,
    Object? macdData = freezed,
    Object? analysisPerformed = null,
    Object? riskLevel = freezed,
    Object? riskFactors = null,
  }) {
    return _then(_$RiskAnalysisStateImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDomains: null == selectedDomains
          ? _value._selectedDomains
          : selectedDomains // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedIndicators: null == selectedIndicators
          ? _value._selectedIndicators
          : selectedIndicators // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      apiLimitExceeded: null == apiLimitExceeded
          ? _value.apiLimitExceeded
          : apiLimitExceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      priceData: freezed == priceData
          ? _value._priceData
          : priceData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      volatilityData: freezed == volatilityData
          ? _value._volatilityData
          : volatilityData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rsiData: freezed == rsiData
          ? _value._rsiData
          : rsiData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      smaData: freezed == smaData
          ? _value._smaData
          : smaData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      emaData: freezed == emaData
          ? _value._emaData
          : emaData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      macdData: freezed == macdData
          ? _value._macdData
          : macdData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      analysisPerformed: null == analysisPerformed
          ? _value.analysisPerformed
          : analysisPerformed // ignore: cast_nullable_to_non_nullable
              as bool,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      riskFactors: null == riskFactors
          ? _value._riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$RiskAnalysisStateImpl
    with DiagnosticableTreeMixin
    implements _RiskAnalysisState {
  const _$RiskAnalysisStateImpl(
      {this.symbol = 'AAPL',
      final List<String> selectedDomains = const [],
      final List<String> selectedIndicators = const [],
      this.isLoading = false,
      this.errorMessage,
      this.apiLimitExceeded = false,
      final Map<String, dynamic>? priceData,
      final Map<String, dynamic>? volatilityData,
      final Map<String, dynamic>? rsiData,
      final Map<String, dynamic>? smaData,
      final Map<String, dynamic>? emaData,
      final Map<String, dynamic>? macdData,
      this.analysisPerformed = false,
      this.riskLevel,
      final List<String> riskFactors = const []})
      : _selectedDomains = selectedDomains,
        _selectedIndicators = selectedIndicators,
        _priceData = priceData,
        _volatilityData = volatilityData,
        _rsiData = rsiData,
        _smaData = smaData,
        _emaData = emaData,
        _macdData = macdData,
        _riskFactors = riskFactors;

// --- Entrées utilisateur ---
  @override
  @JsonKey()
  final String symbol;
// Symbole boursier saisi
  final List<String> _selectedDomains;
// Symbole boursier saisi
  @override
  @JsonKey()
  List<String> get selectedDomains {
    if (_selectedDomains is EqualUnmodifiableListView) return _selectedDomains;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedDomains);
  }

// Domaines sélectionnés
  final List<String> _selectedIndicators;
// Domaines sélectionnés
  @override
  @JsonKey()
  List<String> get selectedIndicators {
    if (_selectedIndicators is EqualUnmodifiableListView)
      return _selectedIndicators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedIndicators);
  }

// Indicateurs sélectionnés
// --- État de chargement et erreurs ---
  @override
  @JsonKey()
  final bool isLoading;
// Indicateur de chargement global
  @override
  final String? errorMessage;
// Message d'erreur général
  @override
  @JsonKey()
  final bool apiLimitExceeded;
// Flag spécifique pour l'erreur 429
// --- Données reçues de l'API ---
// Stocke les données JSON brutes (Map) ou des objets de modèle typés
  final Map<String, dynamic>? _priceData;
// Flag spécifique pour l'erreur 429
// --- Données reçues de l'API ---
// Stocke les données JSON brutes (Map) ou des objets de modèle typés
  @override
  Map<String, dynamic>? get priceData {
    final value = _priceData;
    if (value == null) return null;
    if (_priceData is EqualUnmodifiableMapView) return _priceData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _volatilityData;
  @override
  Map<String, dynamic>? get volatilityData {
    final value = _volatilityData;
    if (value == null) return null;
    if (_volatilityData is EqualUnmodifiableMapView) return _volatilityData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// ATR
  final Map<String, dynamic>? _rsiData;
// ATR
  @override
  Map<String, dynamic>? get rsiData {
    final value = _rsiData;
    if (value == null) return null;
    if (_rsiData is EqualUnmodifiableMapView) return _rsiData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _smaData;
  @override
  Map<String, dynamic>? get smaData {
    final value = _smaData;
    if (value == null) return null;
    if (_smaData is EqualUnmodifiableMapView) return _smaData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _emaData;
  @override
  Map<String, dynamic>? get emaData {
    final value = _emaData;
    if (value == null) return null;
    if (_emaData is EqualUnmodifiableMapView) return _emaData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _macdData;
  @override
  Map<String, dynamic>? get macdData {
    final value = _macdData;
    if (value == null) return null;
    if (_macdData is EqualUnmodifiableMapView) return _macdData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// --- Résultats de l'analyse ---
  @override
  @JsonKey()
  final bool analysisPerformed;
// Indique si une analyse a eu lieu
  @override
  final String? riskLevel;
// 'Élevé', 'Modéré', 'Faible', 'Non disponible'
  final List<String> _riskFactors;
// 'Élevé', 'Modéré', 'Faible', 'Non disponible'
  @override
  @JsonKey()
  List<String> get riskFactors {
    if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_riskFactors);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RiskAnalysisState(symbol: $symbol, selectedDomains: $selectedDomains, selectedIndicators: $selectedIndicators, isLoading: $isLoading, errorMessage: $errorMessage, apiLimitExceeded: $apiLimitExceeded, priceData: $priceData, volatilityData: $volatilityData, rsiData: $rsiData, smaData: $smaData, emaData: $emaData, macdData: $macdData, analysisPerformed: $analysisPerformed, riskLevel: $riskLevel, riskFactors: $riskFactors)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RiskAnalysisState'))
      ..add(DiagnosticsProperty('symbol', symbol))
      ..add(DiagnosticsProperty('selectedDomains', selectedDomains))
      ..add(DiagnosticsProperty('selectedIndicators', selectedIndicators))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('apiLimitExceeded', apiLimitExceeded))
      ..add(DiagnosticsProperty('priceData', priceData))
      ..add(DiagnosticsProperty('volatilityData', volatilityData))
      ..add(DiagnosticsProperty('rsiData', rsiData))
      ..add(DiagnosticsProperty('smaData', smaData))
      ..add(DiagnosticsProperty('emaData', emaData))
      ..add(DiagnosticsProperty('macdData', macdData))
      ..add(DiagnosticsProperty('analysisPerformed', analysisPerformed))
      ..add(DiagnosticsProperty('riskLevel', riskLevel))
      ..add(DiagnosticsProperty('riskFactors', riskFactors));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskAnalysisStateImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            const DeepCollectionEquality()
                .equals(other._selectedDomains, _selectedDomains) &&
            const DeepCollectionEquality()
                .equals(other._selectedIndicators, _selectedIndicators) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.apiLimitExceeded, apiLimitExceeded) ||
                other.apiLimitExceeded == apiLimitExceeded) &&
            const DeepCollectionEquality()
                .equals(other._priceData, _priceData) &&
            const DeepCollectionEquality()
                .equals(other._volatilityData, _volatilityData) &&
            const DeepCollectionEquality().equals(other._rsiData, _rsiData) &&
            const DeepCollectionEquality().equals(other._smaData, _smaData) &&
            const DeepCollectionEquality().equals(other._emaData, _emaData) &&
            const DeepCollectionEquality().equals(other._macdData, _macdData) &&
            (identical(other.analysisPerformed, analysisPerformed) ||
                other.analysisPerformed == analysisPerformed) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            const DeepCollectionEquality()
                .equals(other._riskFactors, _riskFactors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      const DeepCollectionEquality().hash(_selectedDomains),
      const DeepCollectionEquality().hash(_selectedIndicators),
      isLoading,
      errorMessage,
      apiLimitExceeded,
      const DeepCollectionEquality().hash(_priceData),
      const DeepCollectionEquality().hash(_volatilityData),
      const DeepCollectionEquality().hash(_rsiData),
      const DeepCollectionEquality().hash(_smaData),
      const DeepCollectionEquality().hash(_emaData),
      const DeepCollectionEquality().hash(_macdData),
      analysisPerformed,
      riskLevel,
      const DeepCollectionEquality().hash(_riskFactors));

  /// Create a copy of RiskAnalysisState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiskAnalysisStateImplCopyWith<_$RiskAnalysisStateImpl> get copyWith =>
      __$$RiskAnalysisStateImplCopyWithImpl<_$RiskAnalysisStateImpl>(
          this, _$identity);
}

abstract class _RiskAnalysisState implements RiskAnalysisState {
  const factory _RiskAnalysisState(
      {final String symbol,
      final List<String> selectedDomains,
      final List<String> selectedIndicators,
      final bool isLoading,
      final String? errorMessage,
      final bool apiLimitExceeded,
      final Map<String, dynamic>? priceData,
      final Map<String, dynamic>? volatilityData,
      final Map<String, dynamic>? rsiData,
      final Map<String, dynamic>? smaData,
      final Map<String, dynamic>? emaData,
      final Map<String, dynamic>? macdData,
      final bool analysisPerformed,
      final String? riskLevel,
      final List<String> riskFactors}) = _$RiskAnalysisStateImpl;

// --- Entrées utilisateur ---
  @override
  String get symbol; // Symbole boursier saisi
  @override
  List<String> get selectedDomains; // Domaines sélectionnés
  @override
  List<String> get selectedIndicators; // Indicateurs sélectionnés
// --- État de chargement et erreurs ---
  @override
  bool get isLoading; // Indicateur de chargement global
  @override
  String? get errorMessage; // Message d'erreur général
  @override
  bool get apiLimitExceeded; // Flag spécifique pour l'erreur 429
// --- Données reçues de l'API ---
// Stocke les données JSON brutes (Map) ou des objets de modèle typés
  @override
  Map<String, dynamic>? get priceData;
  @override
  Map<String, dynamic>? get volatilityData; // ATR
  @override
  Map<String, dynamic>? get rsiData;
  @override
  Map<String, dynamic>? get smaData;
  @override
  Map<String, dynamic>? get emaData;
  @override
  Map<String, dynamic>? get macdData; // --- Résultats de l'analyse ---
  @override
  bool get analysisPerformed; // Indique si une analyse a eu lieu
  @override
  String? get riskLevel; // 'Élevé', 'Modéré', 'Faible', 'Non disponible'
  @override
  List<String> get riskFactors;

  /// Create a copy of RiskAnalysisState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiskAnalysisStateImplCopyWith<_$RiskAnalysisStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
