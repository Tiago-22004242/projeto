import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto/listagemDetalhesScreen.dart';
import 'package:projeto/registo.dart';
import 'package:projeto/registoEditScreen.dart';
import 'package:projeto/widget/button_widget.dart';

class listagemAvaliacaoScreen extends StatefulWidget {
  const listagemAvaliacaoScreen({Key? key, required this.listaRegistos}):super (key: key);
  final  List<Registo> listaRegistos;
  @override
  State<listagemAvaliacaoScreen> createState() => _listagemAvaliacaoScreenState();
}
class _listagemAvaliacaoScreenState extends State<listagemAvaliacaoScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Listagem de Avaliação")
          ),
          body: ListView.builder(
            itemCount: widget.listaRegistos
                .length,
            itemBuilder: (context, index) {
              ordernar(widget.listaRegistos);
              Registo registo = widget.listaRegistos[index];
              return Dismissible(
                // Specify the direction to swipe and delete
                direction: isValidEditorEliminate(registo)? DismissDirection.endToStart : DismissDirection.none,
                key: UniqueKey(),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    setState(() {
                      if (!isValidEditorEliminate(registo)) {
                        final message = "Só podem ser eliminados registos de avaliações futuras";
                        final snackBar = SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        showAlertDialog(this.context, index);
                      }
                    });
                  }
                },
                background: const ColoredBox(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
                child:
                Card(child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [ListTile(
                  title: Text(registo.disciplina + " : " + registo.avaliacao),
                  subtitle: Text(registo.apresentacao()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => listagemAvaliacaoDetalhesScreen(listaRegistos: widget.listaRegistos, index: index)),
                    );
                  },
                  trailing: Icon(Icons.arrow_right),
                ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildEditarButton(registo, index),
                        SizedBox(width: 8),
                        buildEliminarButton(registo, index),
                      ],
                    )
              ]
                )
                ),
              );
            },
          ),
      ),
    );
  }
  void ordernar(List<Registo> lista) {
    lista.sort((a,b) => a.data.compareTo(b.data));
  }
  bool isValidEditorEliminate (Registo registo){
    return DateTime.parse(registo.data).isAfter(DateTime.now());
  }
  Widget buildEditarButton(Registo avaliacao , int index) => Builder(
    builder: (context) => TextButton(
      child: Icon(Icons.edit),
      onPressed: () {
        if (!isValidEditorEliminate(avaliacao)) {
          final message = "Só podem ser editados registos de avaliações futuras";
          final snackBar = SnackBar(
            content: Text(
              message,
              style: TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => registoEditScreen(listaRegistos: widget.listaRegistos, index: index)),
          );
        }
      },
    ),
  );
  Widget buildEliminarButton( Registo avaliacao, int index) => Builder(
    builder: (context) => TextButton(
      child: Icon(Icons.delete),
      onPressed: () {
        if (!isValidEditorEliminate(avaliacao)) {
          final message = "Só podem ser eliminados registos de avaliações futuras";
          final snackBar = SnackBar(
            content: Text(
              message,
              style: TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          showAlertDialog(this.context, index);
        }
      },
    ),
  );

  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continuar"),
      onPressed:  () {
        widget.listaRegistos.removeAt(index);
        final message = "O registo de avaliação selecionado foi eliminado com sucesso.";
        final snackBar = SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState((){
        });
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Apagar Registo de Avaliação"),
      content: Text("Tem certeza de que deseja apagar o registo de avaliação selecionado?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}