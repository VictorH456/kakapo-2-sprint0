import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplicativo/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class AlarmesPage extends StatefulWidget {
  @override
  _AlarmesPageState createState() => _AlarmesPageState();
}

class _AlarmesPageState extends State<AlarmesPage> {
  List<Map<String, String>> alarmes = [];
  Set<int> diasSelecionados =
      {}; // Usando Set de inteiros para armazenar os dias da semana
  String? compartimentoSelecionado;
  String selectedHora = '00'; // Hora selecionada
  String selectedMinuto = '00'; // Minuto selecionado
  final TextEditingController intervaloController =
      TextEditingController(); // Controlador para o intervalo

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    tzData.initializeTimeZones(); // Inicializa os fusos horários
    _carregarAlarmes(); // Carregar os alarmes ao iniciar a página

    // Inicializa o plugin de notificações
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _inicializarNotificacoes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarAlarmes(); // Carrega os alarmes sempre que a página for exibida
  }

  void _inicializarNotificacoes() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Certifique-se de ter um ícone de app

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Método para carregar os alarmes do SharedPreferences
  void _carregarAlarmes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmeData = prefs.getString('alarmes');
    if (alarmeData != null) {
      final List<dynamic> alarmeList = json.decode(alarmeData);
      setState(() {
        alarmes =
            alarmeList.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  // Método para salvar os alarmes no SharedPreferences
  void _salvarAlarmes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(alarmes);
    await prefs.setString('alarmes', encodedData);
  }

  void _adicionarAlarme() {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(S.of(context).addAlarm),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: nomeController,
                      decoration:
                          InputDecoration(labelText: S.of(context).name),
                    ),
                    DropdownButtonFormField<String>(
                      value: compartimentoSelecionado,
                      icon: Image.asset(
                        'assets/images/compartimento.png',
                        width: 24,
                        height: 24,
                      ),
                      items: ['1', '2', '3'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          compartimentoSelecionado = newValue;
                        });
                      },
                      decoration:
                          InputDecoration(labelText: S.of(context).compartment),
                    ),
                    TextField(
                      controller: descricaoController,
                      decoration:
                          InputDecoration(labelText: S.of(context).description),
                    ),
                    SizedBox(height: 10),
                    // Seletor de Hora
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.of(context).hours),
                        DropdownButton<String>(
                          value: selectedHora,
                          icon: SizedBox
                              .shrink(), // Define o ícone como invisível
                          items: List.generate(100, (index) {
                            return DropdownMenuItem<String>(
                              value: index.toString().padLeft(2, '0'),
                              child: Text(index.toString().padLeft(2, '0')),
                            );
                          }).toList(),
                          onChanged: (String? newHora) {
                            setState(() {
                              selectedHora = newHora ?? selectedHora;
                            });
                          },
                        ),
                      ],
                    ),
                    // Seletor de Minutos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.of(context).minutes),
                        DropdownButton<String>(
                          value: selectedMinuto,
                          icon: SizedBox
                              .shrink(), // Define o ícone como invisível
                          items: List.generate(60, (index) {
                            return DropdownMenuItem<String>(
                              value: index.toString().padLeft(2, '0'),
                              child: Text(index.toString().padLeft(2, '0')),
                            );
                          }).toList(),
                          onChanged: (String? newMinuto) {
                            setState(() {
                              selectedMinuto = newMinuto ?? selectedMinuto;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Seletor de dias da semana (checkboxes)
                    Column(
                      children: [
                        _buildDayCheckbox(S.of(context).monday, 1),
                        _buildDayCheckbox(S.of(context).tuesday, 2),
                        _buildDayCheckbox(S.of(context).wednesday, 3),
                        _buildDayCheckbox(S.of(context).thursday, 4),
                        _buildDayCheckbox(S.of(context).friday, 5),
                        _buildDayCheckbox(S.of(context).saturday, 6),
                        _buildDayCheckbox(S.of(context).sunday, 7),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      alarmes.add({
                        'nome': nomeController.text,
                        'compartimento': compartimentoSelecionado ?? '',
                        'horario': '$selectedHora:$selectedMinuto',
                        'dias': diasSelecionados.join(', '),
                        'descricao': descricaoController.text,
                      });
                      _salvarAlarmes();
                      _carregarAlarmes(); // Atualiza a lista de alarmes após a adição
                      diasSelecionados.clear();
                      compartimentoSelecionado = null;
                      nomeController.clear();
                      descricaoController.clear();
                      selectedHora = '00'; // Resetando a hora
                      selectedMinuto = '00'; // Resetando o minuto
                    });
                    Navigator.of(context).pop(); // Fechar a página após salvar
                  },
                  child: Text(S.of(context).save),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      diasSelecionados.clear();
                      compartimentoSelecionado = null;
                      nomeController.clear();
                      descricaoController.clear();
                      selectedHora = '00';
                      selectedMinuto = '00';
                    });
                    Navigator.of(context)
                        .pop(); // Fechar a página caso cancelar
                  },
                  child: Text(S.of(context).cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _agendarNotificacao() {
    final now = DateTime.now();
    final intervaloHorasMinutos = intervaloController.text.split('H');
    final horas = int.parse(intervaloHorasMinutos[0]);
    final minutos = int.parse(intervaloHorasMinutos[1].replaceAll('M', ''));

    final local = tz.getLocation('America/Sao_Paulo');

    // Para cada dia selecionado, agendamos a notificação
    diasSelecionados.forEach((dia) {
      DateTime primeiraNotificacao =
          _proximaNotificacaoParaDia(dia, now, horas, minutos);

      // Agendar a notificação recorrente
      _agendarNotificacaoRecorrente(primeiraNotificacao, local, horas, minutos);
    });
  }

  DateTime _proximaNotificacaoParaDia(
      int dia, DateTime now, int horas, int minutos) {
    int daysUntilNextNotification = (dia - now.weekday) % 7;
    if (daysUntilNextNotification < 0) {
      daysUntilNextNotification += 7;
    }

    DateTime nextNotification = now.add(Duration(
        days: daysUntilNextNotification, hours: horas, minutes: minutos));

    // Se a hora já passou, agenda a próxima notificação no próximo ciclo
    if (nextNotification.isBefore(now)) {
      nextNotification =
          nextNotification.add(Duration(days: 7)); // Proxima semana
    }

    return nextNotification;
  }

  void _agendarNotificacaoRecorrente(
      DateTime primeiraNotificacao, tz.Location local, int horas, int minutos) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      S.of(context).alarms,
      S.of(context).timeToNotify,
      tz.TZDateTime.from(primeiraNotificacao, local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarmes',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );

    // Agenda a próxima notificação após o intervalo
    flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      S.of(context).alarms,
      S.of(context).timeToNotify,
      tz.TZDateTime.from(
          primeiraNotificacao.add(Duration(hours: horas, minutes: minutos)),
          local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarmes',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  // Função que cria o checkbox para cada dia da semana
  Widget _buildDayCheckbox(String label, int day) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return CheckboxListTile(
          title: Text(label),
          value:
              diasSelecionados.contains(day), // Verifica se o dia está na lista
          onChanged: (bool? selected) {
            setState(() {
              if (selected != null) {
                if (selected) {
                  // Se o checkbox for marcado, adiciona o dia à lista
                  diasSelecionados.add(day);
                } else {
                  // Se o checkbox for desmarcado, remove o dia da lista
                  diasSelecionados.remove(day);
                }
              }
            });
          },
        );
      },
    );
  }

  String _mapDiaParaNome(int dia) {
    switch (dia) {
      case 1:
        return S.of(context).monday; // Segunda-feira
      case 2:
        return S.of(context).tuesday; // Terça-feira
      case 3:
        return S.of(context).wednesday; // Quarta-feira
      case 4:
        return S.of(context).thursday; // Quinta-feira
      case 5:
        return S.of(context).friday; // Sexta-feira
      case 6:
        return S.of(context).saturday; // Sábado
      case 7:
        return S.of(context).sunday; // Domingo
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).alarms),
      ),
      body: ListView.builder(
        itemCount: alarmes.length,
        itemBuilder: (context, index) {
          final alarme = alarmes[index];
          return ListTile(
            title: Text(alarme['nome']!),
            subtitle: Text(
              '${S.of(context).time}: ${alarme['horario']}, ${S.of(context).days}: ${_getDiaComNome(alarme['dias'] ?? '')}',
            ),
            trailing: Text(
                '${S.of(context).compartment}: ${alarme['compartimento']}'),
            onTap: () =>
                _verDetalhesAlarme(alarme, index), // Abre os detalhes ao clicar
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarAlarme,
        child: Image.asset('assets/images/mais.png', width: 30, height: 30),
      ),
    );
  }

  String _getDiaComNome(String dias) {
    final diasList = dias.split(', ');
    return diasList.map((dia) => _mapDiaParaNome(int.parse(dia))).join(', ');
  }

  void _verDetalhesAlarme(Map<String, String> alarme, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alarme['nome']!),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).description + ': ' + alarme['descricao']!),
              Text(S.of(context).compartment + ': ' + alarme['compartimento']!),
              Text(S.of(context).time + ': ' + alarme['horario']!),
              Text(S.of(context).days + ': ' + _getDiaComNome(alarme['dias']!)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  alarmes.removeAt(index);
                  _salvarAlarmes(); // Atualiza a lista após a remoção
                });
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).delete),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).close),
            ),
          ],
        );
      },
    );
  }
}
