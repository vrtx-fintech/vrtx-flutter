import 'package:flutter/material.dart';
import 'package:vrtx_flutter/vrtx_flutter.dart';
import 'package:vrtx_flutter_example/local_config.dart';

void main() => runApp(const ExampleApp());

/// Root widget for the Vrtx Flutter example app.
class ExampleApp extends StatelessWidget {
  /// Creates an [ExampleApp].
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vrtx-flutter Example',
      home: HomeScreen(),
    );
  }
}

/// Landing screen demonstrating the Vrtx Flutter SDK.
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEnglish = true;

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

  Future<void> _launchVrtx() async {
    try {
      await Vrtx.setup(
        clientId: vrtxClientId,
        clientSecret: vrtxClientSecret,
        environment: _environment,
        language: _language,
        mode: Mode.light,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 18,
                            offset: Offset(0, 6),
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
                        color: const Color(0xFFEAF5EF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3C9B66),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            _environmentLabel,
                            style: TextStyle(
                              color: const Color(0xFF287348),
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
                    color: const Color(0xFF111111),
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
                    color: const Color(0xFF7B8087),
                    fontFamily: _fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE9EBEF)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 24,
                        offset: Offset(0, 10),
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
                              color: const Color(0xFF111111),
                              fontFamily: _fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            _configurationHint,
                            style: TextStyle(
                              color: const Color(0xFF9CA1A8),
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
                    onPressed: _launchVrtx,
                    icon: Icon(
                      _isEnglish
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_back_rounded,
                      size: 19,
                    ),
                    label: Text(_buttonLabel),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF111111),
                      foregroundColor: Colors.white,
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
                    color: const Color(0xFF9CA1A8),
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
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF34383E),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: fontFamily),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: const Color(0xFF17191C),
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFFA6ABB2),
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Icon(
              Icons.tag_rounded,
              size: 19,
              color: Color(0xFF8B929A),
            ),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE6E9ED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE6E9ED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF17191C),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: fontFamily),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF17191C) : const Color(0xFF8B929A),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ControlLabel(label: label, fontFamily: labelFontFamily),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE6E9ED)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<_FontOption>(
              value: value,
              isExpanded: true,
              isDense: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 21,
                color: Color(0xFF59616A),
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
              selectedItemBuilder: (context) {
                return options.map((option) {
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF17191C),
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
                      color: const Color(0xFF17191C),
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
