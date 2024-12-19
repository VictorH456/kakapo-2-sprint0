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

  // Função para mudar de aba
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          bodyLarge: TextStyle(color: Colors.black), // Atualizado
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Tema escuro
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Atualizado
        ),
      ),
      themeMode: _themeMode, // Define o tema atual (claro, escuro ou sistema)
      home: Scaffold(
        appBar: AppBar(title: Text('Dark Mode Example')),
        body: _getBodyContent(), // Exibe o conteúdo baseado na aba selecionada
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Índice da aba selecionada
          onTap: _onItemTapped, // Muda a aba quando clicado
          backgroundColor: _themeMode == ThemeMode.dark
              ? Colors.black // fundo escuro para tema escuro
              : Colors.lightBlueAccent, // fundo pastel para tema claro
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/alarmes.png',
                  width: 24, height: 24), // Ícone personalizado
              label: 'Alarmes',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/consultas.png',
                  width: 24, height: 24), // Ícone personalizado
              label: 'Consultas',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/estatisticas.png',
                  width: 24, height: 24), // Ícone personalizado
              label: 'Estatísticas',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/preferencias.png',
                  width: 24, height: 24), // Ícone personalizado
              label: 'Preferências',
            ),
          ],
          selectedItemColor: _themeMode == ThemeMode.dark
              ? Colors.white // Cor dos itens selecionados para tema escuro
              : Colors.black, // Cor dos itens selecionados para tema claro
          unselectedItemColor: _themeMode == ThemeMode.dark
              ? Colors
                  .white70 // Cor dos itens não selecionados para tema escuro
              : Colors
                  .black54, // Cor dos itens não selecionados para tema claro
        ),
      ),
    );
  }

  // Método para retornar o conteúdo da tela baseado na aba selecionada
  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return Center(child: Text('Alarmes'));
      case 1:
        return Center(child: Text('Consultas'));
      case 2:
        return Center(child: Text('Estatísticas'));
      case 3:
        return _preferenciasPage(); // Página de preferências com o botão de alternar tema
      default:
        return Center(child: Text('Alarmes'));
    }
  }

  // Página de preferências com o botão para alternar o tema
  Widget _preferenciasPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Preferências',
            style:
                Theme.of(context).textTheme.headlineMedium, // Título atualizado
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: toggleTheme, // Função que alterna o tema
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor, // Cor do botão
            ),
            child: Text(
              'Alternar Tema', // Texto do botão
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white // Cor do texto para tema escuro
                    : Colors.black, // Cor do texto para tema claro
              ),
            ),
          ),
        ],
      ),
    );
  }
}
