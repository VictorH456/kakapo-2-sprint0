import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Padrão: tema do sistema
  int _selectedIndex = 0; // Controla a aba selecionada
  final PageController _pageController =
      PageController(); // Controlador do PageView

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Carregar a preferência de tema salva
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Salvar a preferência de tema
  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Alternar entre Light Mode e Dark Mode
  void toggleTheme() {
    final isDark = _themeMode == ThemeMode.dark;
    setState(() {
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
    _saveThemePreference(!isDark);
  }

  // Função para mudar de aba ao clicar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Mode Example',
      theme: ThemeData(
        brightness: Brightness.light, // Tema claro
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Tema escuro
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(title: Text('Dark Mode Example')),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            Center(child: Text('Home')), // Novo conteúdo para a aba Home
            Center(child: Text('Alarmes')),
            Center(child: Text('Consultas')),
            Center(child: Text('Estatísticas')),
            _preferenciasPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/alarmes.png',
                width: 24,
                height: 24,
              ),
              label: 'Alarmes',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/consultas.png',
                width: 24,
                height: 24,
              ),
              label: 'Consultas',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/estatisticas.png',
                width: 24,
                height: 24,
              ),
              label: 'Estatísticas',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/preferencias.png',
                width: 24,
                height: 24,
              ),
              label: 'Preferências',
            ),
          ],
          selectedItemColor:
              _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
          unselectedItemColor:
              _themeMode == ThemeMode.dark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  // Página de preferências com o botão para alternar o tema
  Widget _preferenciasPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Preferências',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: toggleTheme,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Alternar Tema',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
