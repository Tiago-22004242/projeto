
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto/registo.dart';
import 'package:projeto/widget/button_widget.dart';
import 'package:share/share.dart';

class listagemAvaliacaoDetalhesScreen extends StatefulWidget {
  const listagemAvaliacaoDetalhesScreen({Key? key, required this.listaRegistos, required this.index}):super (key: key);
  final  List<Registo> listaRegistos;
  final  index;
  @override
  State<listagemAvaliacaoDetalhesScreen> createState() => _listagemAvaliacaoDetalhesScreenState();
}
class _listagemAvaliacaoDetalhesScreenState extends State<listagemAvaliacaoDetalhesScreen> {
  var avaliacao;
  @override
  void initState(){
    avaliacao = widget.listaRegistos[widget.index];
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
          title: Text("Detalhes da Avaliação"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            )
        ),
        body: Column(
          children: [
            Center(child: Text(avaliacao.disciplina)),
            Center(child: Text(avaliacao.avaliacao)),
            Center(child: Text(avaliacao.data)),
            Center(child: Text(avaliacao.dificuldade.toString())),
            Center(child: Text(avaliacao.observacoes)),
            FloatingActionButton(onPressed: () {
              Share.share( "Mensagem do Dealer!!\n"
                  "Vamos ter avaliação de ${avaliacao.disciplina}, em ${avaliacao.data}, com a dificuldade de ${avaliacao.dificuldade} numa escala de 1 a 5."
                  "\nObservações para esta avaliação: ${avaliacao.observacoes}");
            },
            child: Icon(Icons.share),)
          ],
        ),
      ),
    );
  }
}