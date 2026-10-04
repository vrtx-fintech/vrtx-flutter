import 'package:flutter/material.dart';
import 'package:vrtx_flutter/vrtx_flutter.dart';
import 'package:vrtx_flutter_example/local_config.dart';

/// Single source of truth for the example app and the native Vrtx UI.
///
/// The returned object is passed unchanged to [Vrtx.setup].
VrtxThemeOptions greenThemeFor(Mode mode) {
  final isDark = mode == Mode.dark;
  String color(String light, String dark) => isDark ? dark : light;

  return VrtxThemeOptions(
    brandName: 'vrtx Pay',
    colors: VrtxColors(
      allBrands: VrtxAllBrandColors(
        primary: color('#16804F', '#62C891'),
        buttonLabel: color('#FFFFFF', '#071B13'),
      ),
      labels: VrtxLabelColors(
        primary: color('#12352A', '#F0FAF4'),
        secondary: color('#5A7168', '#B7D3C3'),
        tertiary: color('#82988E', '#94B8A4'),
        quaternary: color('#AFC0B8', '#729985'),
      ),
      fills: VrtxFillColors(
        primary: color('#E4F4EC', '#1C4A34'),
        secondary: color('#D4EDDF', '#265E42'),
        tertiary: color('#BEDFCE', '#337752'),
        quaternary: color('#A6D1BB', '#439463'),
        vibrant: VrtxVibrantFillColors(
          secondary: color('#62D49A', '#62C891'),
        ),
      ),
      backgrounds: VrtxBackgroundColors(
        primary: color('#F4FBF7', '#071B13'),
        secondary: color('#F8FCF9', '#102B20'),
      ),
      backgroundsGradient: VrtxBackgroundGradientColors(
        wb01: color('#E4F4EC', '#102B20'),
        wb02: color('#DDF3E7', '#153A2A'),
      ),
      accents: VrtxAccentColors(
        red: '#D9534F',
        green: color('#16804F', '#62C891'),
        greenBg: color('#DDF3E7', '#194A3A'),
      ),
    ),
    spacing: const VrtxSpacing(
      x0: 0,
      xxs: 2,
      xs: 4,
      sm: 8,
      md: 12,
      ml: 16,
      lg: 20,
    ),
    radius: const VrtxRadius(
      s: 6,
      sm: 8,
      md: 12,
      lg: 20,
      full: 999,
      huge: 64,
    ),
  );
}

Color _color(String? value, Color fallback) {
  if (value == null) return fallback;
  final hex = value.replaceFirst('#', '');
  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  final parsed = int.tryParse(normalized, radix: 16);
  return parsed == null ? fallback : Color(parsed);
}

ThemeData _materialThemeFrom(VrtxThemeOptions options, Mode mode) {
  final isDark = mode == Mode.dark;
  final brightness = isDark ? Brightness.dark : Brightness.light;
  final colors = options.colors;
  final primary = _color(
    colors?.allBrands?.primary,
    Color(isDark ? 0xFF62C891 : 0xFF16804F),
  );
  final onPrimary = _color(
    colors?.allBrands?.buttonLabel,
    Color(isDark ? 0xFF071B13 : 0xFFFFFFFF),
  );
  final surface = _color(
    colors?.backgrounds?.primary,
    Color(isDark ? 0xFF071B13 : 0xFFF4FBF7),
  );
  final surfaceElevated = _color(
    colors?.backgrounds?.secondary,
    Color(isDark ? 0xFF102B20 : 0xFFF8FCF9),
  );
  final onSurface = _color(
    colors?.labels?.primary,
    Color(isDark ? 0xFFF0FAF4 : 0xFF12352A),
  );
  final onSurfaceVariant = _color(
    colors?.labels?.secondary,
    Color(isDark ? 0xFFB7D3C3 : 0xFF5A7168),
  );
  final outline = _color(
    colors?.fills?.tertiary,
    Color(isDark ? 0xFF337752 : 0xFFBEDFCE),
  );

  return ThemeData(
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: onPrimary,
          primaryContainer: _color(
            colors?.fills?.primary,
            Color(isDark ? 0xFF1C4A34 : 0xFFE4F4EC),
          ),
          onPrimaryContainer: onSurface,
          surface: surface,
          surfaceContainerLowest: surfaceElevated,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          outline: outline,
          outlineVariant: _color(
            colors?.fills?.secondary,
            Color(isDark ? 0xFF265E42 : 0xFFD4EDDF),
          ),
        ),
    scaffoldBackgroundColor: surface,
  );
}

void main() => runApp(const ExampleApp());

/// Root widget for the Vrtx Flutter example app.
class ExampleApp extends StatefulWidget {
  /// Creates an [ExampleApp].
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  Mode _mode = Mode.light;

  @override
  Widget build(BuildContext context) {
    final theme = greenThemeFor(_mode);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vrtx-flutter Example',
      theme: _materialThemeFrom(theme, _mode),
      home: HomeScreen(
        mode: _mode,
        theme: theme,
        onModeChanged: (mode) => setState(() => _mode = mode),
      ),
    );
  }
}

/// Landing screen demonstrating the Vrtx Flutter SDK.
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({
    required this.mode,
    required this.theme,
    required this.onModeChanged,
    super.key,
  });

  /// Current SDK appearance mode.
  final Mode mode;

  /// Theme options sent to the native SDK.
  final VrtxThemeOptions theme;

  /// Updates the appearance mode for the app and the SDK.
  final ValueChanged<Mode> onModeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEnglish = true;
  bool _isLoading = false;

  static const List<_FontOption> _englishFonts = [
    _FontOption('Inter', 'Inter'),
    _FontOption('Geom', 'Geom'),
    _FontOption('Jura', 'Jura'),
    _FontOption('Noto Sans', 'Noto Sans'),
    _FontOption('JejuGothic', 'JejuGothic'),
    _FontOption('Jockey One', 'Jockey One'),
  ];

  static const List<_FontOption> _arabicFonts = [
    _FontOption('IBM Plex Sans Arabic', 'IBM Plex Sans Arabic'),
    _FontOption('Noto Kufi Arabic', 'Noto Kufi Arabic'),
    _FontOption('Noto Naskh Arabic', 'Noto Naskh Arabic'),
    _FontOption('Arslan Wessam B', 'Arslan Wessam B'),
  ];

  _FontOption _selectedEnglishFont = _englishFonts.first;
  _FontOption _selectedArabicFont = _arabicFonts.first;
  final _externalReferenceController = TextEditingController();

  @override
  void dispose() {
    _externalReferenceController.dispose();
    super.dispose();
  }

  Language get _language => _isEnglish ? Language.english : Language.arabic;

  Environment get _environment => vrtxEnvironment == 'production'
      ? Environment.production
      : Environment.sandbox;

  _FontOption get _selectedFont =>
      _isEnglish ? _selectedEnglishFont : _selectedArabicFont;

  List<_FontOption> get _fontOptions =>
      _isEnglish ? _englishFonts : _arabicFonts;

  String get _fontFamily => _selectedFont.family;

  String get _title =>
      _isEnglish ? 'Welcome to\nvrtx Pay' : 'مرحباً بك في\nڤرتكس باي';

  String get _subtitle => _isEnglish
      ? 'A smarter wallet for everyday payments'
      : 'محفظة أذكى للمدفوعات اليومية';

  String get _languageLabel => _isEnglish ? 'Language' : 'اللغة';

  String get _modeLabel => _isEnglish ? 'Appearance' : 'المظهر';

  String get _lightModeLabel => _isEnglish ? 'Light' : 'فاتح';

  String get _darkModeLabel => _isEnglish ? 'Dark' : 'داكن';

  String get _fontLabel => _isEnglish ? 'English Font' : 'الخط العربي';

  String get _externalReferenceLabel =>
      _isEnglish ? 'External Reference' : 'المرجع الخارجي';

  String get _externalReferenceHint => _isEnglish ? 'Optional' : 'اختياري';

  String get _environmentLabel => vrtxEnvironment.toUpperCase();

  String get _configurationLabel =>
      _isEnglish ? 'SDK Configuration' : 'إعدادات SDK';

  String get _configurationHint =>
      _isEnglish ? 'Customize your session' : 'خصص جلستك';

  String get _footerLabel => _isEnglish
      ? 'Sandbox environment • Secure SDK demo'
      : 'بيئة تجريبية • عرض آمن لـ SDK';

  String get _buttonLabel => _isEnglish ? 'Get Started' : 'ابدأ الآن';

  String get _loadingLabel => _isEnglish ? 'Loading...' : 'جار التحميل...';

  Future<void> _launchVrtx() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await Vrtx.setup(
        clientId: vrtxClientId,
        clientSecret: vrtxClientSecret,
        environment: _environment,
        language: _language,
        mode: widget.mode,
        theme: widget.theme,
        externalReference: _externalReferenceController.text.trim().isEmpty
            ? null
            : _externalReferenceController.text.trim(),
        fontFamily: _fontFamily,
      );

      debugPrint('Vrtx launched successfully');
    } on VrtxError catch (e) {
      debugPrint('Vrtx error [${e.status}]: ${e.message}');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('[${e.status}] ${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: _isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Image.asset('assets/icon.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            _environmentLabel,
                            style: TextStyle(
                              color: colors.primary,
                              fontFamily: _fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontFamily: _fontFamily,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontFamily: _fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _configurationLabel,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontFamily: _fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            _configurationHint,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _ExternalReferenceRow(
                        label: _externalReferenceLabel,
                        hint: _externalReferenceHint,
                        controller: _externalReferenceController,
                        fontFamily: _fontFamily,
                      ),
                      const SizedBox(height: 18),
                      _LanguageRow(
                        label: _languageLabel,
                        isEnglish: _isEnglish,
                        fontFamily: _fontFamily,
                        onChanged: (value) {
                          setState(() => _isEnglish = value);
                        },
                      ),
                      const SizedBox(height: 18),
                      _ModeRow(
                        label: _modeLabel,
                        mode: widget.mode,
                        lightLabel: _lightModeLabel,
                        darkLabel: _darkModeLabel,
                        fontFamily: _fontFamily,
                        onChanged: widget.onModeChanged,
                      ),
                      const SizedBox(height: 18),
                      _FontDropdownRow(
                        label: _fontLabel,
                        value: _selectedFont,
                        options: _fontOptions,
                        labelFontFamily: _fontFamily,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            if (_isEnglish) {
                              _selectedEnglishFont = value;
                            } else {
                              _selectedArabicFont = value;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _launchVrtx,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _isEnglish
                                ? Icons.arrow_forward_rounded
                                : Icons.arrow_back_rounded,
                            size: 19,
                          ),
                    label: Text(_isLoading ? _loadingLabel : _buttonLabel),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primary,
                      disabledBackgroundColor: colors.onSurfaceVariant,
                      foregroundColor: colors.onPrimary,
                      disabledForegroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      elevation: 0,
                      textStyle: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _footerLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlLabel extends StatelessWidget {
  const _ControlLabel({required this.label, required this.fontFamily});

  final String label;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      label,
      style: TextStyle(
        color: colors.onSurface,
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ExternalReferenceRow extends StatelessWidget {
  const _ExternalReferenceRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.fontFamily,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: fontFamily),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: colors.onSurface,
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colors.onSurfaceVariant,
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.tag_rounded,
              size: 19,
              color: colors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colors.primary,
                width: 1.4,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.isEnglish,
    required this.fontFamily,
    required this.onChanged,
  });

  final String label;
  final bool isEnglish;
  final String fontFamily;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: fontFamily),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _LanguageChoice(
                  label: 'English',
                  selected: isEnglish,
                  fontFamily: fontFamily,
                  onTap: () => onChanged(true),
                ),
              ),
              Expanded(
                child: _LanguageChoice(
                  label: 'العربية',
                  selected: !isEnglish,
                  fontFamily: fontFamily,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({
    required this.label,
    required this.mode,
    required this.lightLabel,
    required this.darkLabel,
    required this.fontFamily,
    required this.onChanged,
  });

  final String label;
  final Mode mode;
  final String lightLabel;
  final String darkLabel;
  final String fontFamily;
  final ValueChanged<Mode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: fontFamily),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ModeChoice(
                  label: lightLabel,
                  selected: mode == Mode.light,
                  fontFamily: fontFamily,
                  onTap: () => onChanged(Mode.light),
                ),
              ),
              Expanded(
                child: _ModeChoice(
                  label: darkLabel,
                  selected: mode == Mode.dark,
                  fontFamily: fontFamily,
                  onTap: () => onChanged(Mode.dark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeChoice extends StatelessWidget {
  const _ModeChoice({
    required this.label,
    required this.selected,
    required this.fontFamily,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final String fontFamily;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? colors.onSurface : colors.onSurfaceVariant,
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice({
    required this.label,
    required this.selected,
    required this.fontFamily,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final String fontFamily;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? colors.onSurface : colors.onSurfaceVariant,
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FontOption {
  const _FontOption(this.label, this.family);

  final String label;
  final String family;
}

class _FontDropdownRow extends StatelessWidget {
  const _FontDropdownRow({
    required this.label,
    required this.value,
    required this.options,
    required this.labelFontFamily,
    required this.onChanged,
  });

  final String label;
  final _FontOption value;
  final List<_FontOption> options;
  final String labelFontFamily;
  final ValueChanged<_FontOption?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: labelFontFamily),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<_FontOption>(
              value: value,
              isExpanded: true,
              isDense: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 21,
                color: colors.onSurfaceVariant,
              ),
              dropdownColor: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              selectedItemBuilder: (context) {
                return options.map((option) {
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontFamily: option.family,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList();
              },
              items: options.map((option) {
                return DropdownMenuItem<_FontOption>(
                  value: option,
                  child: Text(
                    option.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontFamily: option.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
