import 'package:flutter/material.dart';
import 'package:vrtx_flutter/vrtx_flutter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
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

class HomeScreen extends StatefulWidget {
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

  Language get _language => _isEnglish ? Language.english : Language.arabic;

  String get _fontFamily =>
      _isEnglish ? _selectedEnglishFont.family : _selectedArabicFont.family;

  Future<void> _launchVrtx() async {
    try {
      await Vrtx.setup(
        clientId: 'YOUR_CLIENT_ID',
        clientSecret: 'YOUR_CLIENT_SECRET',
        environment: Environment.sandbox,
        language: _language,
        mode: Mode.light,
        fontFamily: _fontFamily,
      );

      debugPrint('Vrtx launched successfully');
    } on VrtxError catch (e) {
      debugPrint('Vrtx error [${e.status}]: ${e.message}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('[${e.status}] ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 106,
                      height: 106,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Image.asset('assets/icon.png'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to\nvrtx Pay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: _selectedEnglishFont.family,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A smarter wallet for everyday payments',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF8B8B8B),
                        fontFamily: _selectedEnglishFont.family,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    _LanguageRow(
                      isEnglish: _isEnglish,
                      onChanged: (value) {
                        setState(() => _isEnglish = value);
                      },
                    ),
                    _FontDropdownRow(
                      label: 'English Font',
                      value: _selectedEnglishFont,
                      options: _englishFonts,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedEnglishFont = value);
                      },
                    ),
                    _FontDropdownRow(
                      label: 'Arabic Font',
                      value: _selectedArabicFont,
                      options: _arabicFonts,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedArabicFont = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 9),
              child: SizedBox(
                width: double.infinity,
                height: 38,
                child: FilledButton(
                  onPressed: _launchVrtx,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.isEnglish,
    required this.onChanged,
  });

  final bool isEnglish;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Language',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'EN',
            style: TextStyle(
              color: isEnglish ? Colors.black : const Color(0xFFC7C7C7),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 38,
            height: 24,
            child: Switch(
              value: !isEnglish,
              onChanged: (value) => onChanged(!value),
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFDDDDDD),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFDDDDDD),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'AR',
            style: TextStyle(
              color: isEnglish ? const Color(0xFFC7C7C7) : Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
    required this.onChanged,
  });

  final String label;
  final _FontOption value;
  final List<_FontOption> options;
  final ValueChanged<_FontOption?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: Color(0xFFE6E6E6)),
        SizedBox(
          height: 43,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 178,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<_FontOption>(
                    value: value,
                    isExpanded: true,
                    isDense: true,
                    icon: const Icon(
                      Icons.unfold_more,
                      size: 19,
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    alignment: AlignmentDirectional.centerEnd,
                    selectedItemBuilder: (context) {
                      return options.map((option) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            option.label,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: option.family,
                              fontSize: 12,
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
                            color: Colors.black,
                            fontFamily: option.family,
                            fontSize: 12,
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
          ),
        ),
      ],
    );
  }
}
