import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/listagemScreen.dart';
import 'package:projeto/registo.dart';
import 'package:projeto/widget/button_widget.dart';

class registoAvaliacaoScreen extends StatefulWidget {
  const registoAvaliacaoScreen({Key? key, required this.listaRegistos}):super (key: key);
  final  List<Registo> listaRegistos;
  @override
  State<registoAvaliacaoScreen> createState() => _registoAvaliacaoScreenState();
}
class _registoAvaliacaoScreenState extends State<registoAvaliacaoScreen> {
  final formKey = GlobalKey<FormState>();
  final disciplinaController = TextEditingController();
  final tipoController = TextEditingController();
  final numberController = TextEditingController();
  final dataController = TextEditingController();
  final observacoesController = TextEditingController();

  @override
  void dispose() {
   disciplinaController.dispose();
   tipoController.dispose();
   numberController.dispose();
   dataController.dispose();
   observacoesController.dispose();
   super.dispose();
  }
  @override
  void initState() {
    super.initState();
    disciplinaController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Registo de Avaliação"),
          ),
          body: Form(
            key: formKey, //autovalidateMode: AutovalidateMode.onUserInteraction,
            child:
          ListView(
            padding: EdgeInsets.all(32),
            children: [
              Text("Disciplina"),
              buildDisciplina(),
              const SizedBox(height: 24),
              Text("Tipo de Avaliação"),
              buildtipoAvaliacao(),
              const SizedBox(height: 24),
              Text("Data e Hora da Realização"),
              buildDataRealizacao(),
              const SizedBox(height: 24),
              Text("Nível de dificuldade"),
              buildDificuldade(),
              const SizedBox(height: 24,),
              Text("Observações"),
              buildObservacoes(),
              const SizedBox(height: 24,),
              buildSubmit(),
            ],
          )
          )
      ),
    );
  }

  Widget buildDisciplina() =>
      TextFormField(
        controller: disciplinaController,
        decoration: InputDecoration(
          hintText: 'Insira aqui nome da disciplina',
          labelText: 'Disciplina',
          prefixIcon: const Icon(Icons.school),
          suffixIcon: disciplinaController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => disciplinaController.clear(),
          ),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if ( value == null || value.length < 3) {
            return 'Digite uma disciplina válida ou uma abreviatura da mesma';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        // autofocus: true,
      );

  Widget buildtipoAvaliacao() {
    final lista = ['Frequência', 'Mini-Teste', 'Projeto', 'Defesa'];
    String valueDrop = lista[0];
    tipoController.text = valueDrop;
    return DropdownButtonFormField<String>(
      value: valueDrop,
      onChanged: (value) {
        setState(() {
          valueDrop = value.toString();
          tipoController.text = value.toString();
        });
      },
      items: lista.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
        icon: Padding(
              padding: EdgeInsets.only(),
              child: Icon(Icons.arrow_drop_down),
            ),
    );
  }

  Widget buildDataRealizacao() {
    final format = DateFormat('yyyy-MM-dd HH:mm');
    return DateTimeField(
        controller: dataController,
        decoration: InputDecoration (
          hintText: 'Introduza uma data e hora'
        ),
        format: format,
        onShowPicker: (context,currentValue) async {
      final date = await showDatePicker(context: context, initialDate: currentValue ?? DateTime.now(), firstDate:DateTime.now(),lastDate: DateTime(2100));
      if (date != null) {
       // final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
        final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now().add(Duration(hours: 1))),
            builder: (context, childWidget) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    // Using 24-Hour format
                      alwaysUse24HourFormat: true),
                  // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                  child: childWidget!);
            });
        return DateTimeField.combine(date, time);
      } else {
        return currentValue;
      }
    },
      validator: (value) {
          if ( value == null) {
            return "Digite uma data válida";
          }
          if (value.isAfter(DateTime.now())) {
          return null;
          } else {
          return "Digite uma data válida";
        }
      },
    );
  }
  Widget buildDificuldade() => TextFormField(
    controller: numberController,
    decoration: InputDecoration(
      hintText: 'Insira a dificuldade de 1 a 5',
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.number,
    validator: (value) {
      final list = ['1','2','3','4','5'];
      if (value == null || !(list.contains(value))) {
        return "Por favor digite uma dificuldade entre 1 a 5";
      }
    },
  );

  Widget buildObservacoes() => TextField( controller: observacoesController,keyboardType: TextInputType.multiline, maxLines: null, maxLength: 200);

  Widget buildSubmit() => Builder(
    builder: (context) => ButtonWidget(
      text: 'Submit',
      onClicked: () {
        final isValid = formKey.currentState!.validate();
        // FocusScope.of(context).unfocus();
        if (isValid) {
          formKey.currentState!.save();
          widget.listaRegistos.add(Registo(disciplinaController.text, tipoController.text, dataController.text, int.parse(numberController.text), observacoesController.text));
          final message = "A avaliação foi registada com sucesso.";
          final snackBar = SnackBar(
            content: Text(
              message,
              style: TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    ),
  );
}