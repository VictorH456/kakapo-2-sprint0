import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessário para o FilteringTextInputFormatter
import 'package:aplicativo/generated/l10n.dart';

class AlarmesPage extends StatefulWidget {
  @override
  _AlarmesPageState createState() => _AlarmesPageState();
}

class _AlarmesPageState extends State<AlarmesPage> {
  List<Map<String, String>> alarmes = [];
  Set<String> diasSelecionados =
      {}; // Usando Set para armazenar os dias selecionados
  String?
      compartimentoSelecionado; // Variável para armazenar o compartimento selecionado
  final TextEditingController horarioController =
      TextEditingController(); // Controlador para armazenar o horário inserido

  void _adicionarAlarme() {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).addAlarm),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: S.of(context).name),
                ),
                DropdownButtonFormField<String>(
                  value: compartimentoSelecionado,
                  icon: Image.asset(
                    'assets/images/compartimento.png', // Caminho para a imagem do ícone
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
                  controller: horarioController,
                  decoration: InputDecoration(
                    labelText: S.of(context).time,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Aceita apenas números
                    LengthLimitingTextInputFormatter(
                        2), // Limita a entrada a 2 caracteres
                  ],
                ),
                TextField(
                  controller: descricaoController,
                  decoration:
                      InputDecoration(labelText: S.of(context).description),
                ),
                SizedBox(height: 10),
                // Seleção de múltiplos dias da semana com Checkboxes
                Column(
                  children: [
                    _buildDayCheckbox(S.of(context).monday, 'Monday'),
                    _buildDayCheckbox(S.of(context).tuesday, 'Tuesday'),
                    _buildDayCheckbox(S.of(context).wednesday, 'Wednesday'),
                    _buildDayCheckbox(S.of(context).thursday, 'Thursday'),
                    _buildDayCheckbox(S.of(context).friday, 'Friday'),
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
                    'horario': horarioController.text,
                    'dias': diasSelecionados
                        .join(', '), // Convertendo a lista em string
                    'descricao': descricaoController.text,
                  });
                  diasSelecionados
                      .clear(); // Limpar a seleção de dias após adicionar
                  compartimentoSelecionado =
                      null; // Limpar a seleção de compartimento
                  horarioController.clear(); // Limpar a seleção de horário
                });
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).save),
            ),
            TextButton(
              onPressed: () {
                diasSelecionados
                    .clear(); // Limpar a seleção de dias ao cancelar
                compartimentoSelecionado =
                    null; // Limpar a seleção de compartimento
                horarioController.clear(); // Limpar a seleção de horário
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  void _verDetalhesAlarme(Map<String, String> alarme, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alarme['nome']!),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${S.of(context).time}: ${alarme['horario']}'),
                Text(
                    '${S.of(context).compartment}: ${alarme['compartimento']}'),
                Text('${S.of(context).days}: ${alarme['dias']}'),
                SizedBox(height: 10),
                Text('${S.of(context).description}:'),
                Text(alarme['descricao']!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).close),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  alarmes.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Cor do texto do botão
              ),
              child: Text(S.of(context).delete),
            ),
          ],
        );
      },
    );
  }

  // Função que cria o checkbox para cada dia da semana
  Widget _buildDayCheckbox(String label, String day) {
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
              'Horário: ${alarme['horario']}, Dias: ${alarme['dias']}',
            ),
            trailing: Text(alarme['compartimento']!),
            onTap: () =>
                _verDetalhesAlarme(alarme, index), // Abre os detalhes ao clicar
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarAlarme,
        child: Image.asset(
            'assets/images/mais.png'), // Certifique-se de ter essa imagem no caminho correto
      ),
    );
  }
}
