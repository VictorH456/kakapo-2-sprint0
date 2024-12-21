import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:aplicativo/pages/home_page.dart';
import 'package:aplicativo/pages/alarmes_page.dart';
import 'package:aplicativo/pages/consultas_page.dart';
import 'package:aplicativo/pages/estatisticas_page.dart';
import 'package:aplicativo/pages/preferencias_page.dart';

//dart run intl_utils:generate
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  int _selectedIndex = 0;
  Locale? _locale;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final languageCode = prefs.getString('languageCode') ?? 'en';

    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _locale = Locale(languageCode);
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  void toggleTheme() {
    final isDark = _themeMode == ThemeMode.dark;
    setState(() {
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
    _saveThemePreference(!isDark);
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
    _saveLanguagePreference(languageCode);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Mode Example',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: null, // Remove o AppBar
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            HomePage(),
            AlarmesPage(),
            ConsultasPage(),
            EstatisticasPage(),
            PreferenciasPage(
              toggleTheme: toggleTheme,
              changeLanguage: _changeLanguage,
            ),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) => BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: _themeMode == ThemeMode.dark
                ? Colors.black
                : Colors.lightBlueAccent,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/home.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).home,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/alarmes.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).alarms,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/consultas.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).consultations,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/estatisticas.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).statistics,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/preferencias.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).preferences,
              ),
            ],
            selectedItemColor:
                _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
            unselectedItemColor:
                _themeMode == ThemeMode.dark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
      ),
    );
  }
}
