import 'package:intl/intl.dart';

class Registo {
  String _disciplina = "";
  String _avaliacao = "";
  String _data = "";
  int _dificuldade = 0;
  String _observacoes = "";

  Registo(this._disciplina, this._avaliacao, this._data, this._dificuldade,
      this._observacoes);
  @override
  String apresentacao() {
    return 'Data : $_data \nDificuldade: $_dificuldade';
  }
  @override
  String toString() {
    String date = DateFormat.Hm().format(DateTime.parse(data));
    return '$_avaliacao de $disciplina ás $date';
  }

  String get disciplina => _disciplina;
  String get data => _data;
  String get avaliacao => _avaliacao;
  String get observacoes => _observacoes;
  int get dificuldade => _dificuldade;
}