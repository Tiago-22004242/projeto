import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/registo.dart';
import 'package:share/share.dart';

String extractMessage(String message) {
  return 'Mensagem compartilhada: $message';
}
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("Teste ao construtor Registo",() {
    final Registo registo = Registo("FundamentosProgramação", "Frequência","2023-03-08 15:30",3,"");
    String apresentacao = "Data : 2023-03-08 15:30 \nDificuldade: 3";
    expect(apresentacao,registo.apresentacao());
    String fraseToString = "Frequência de FundamentosProgramação ás 15:30";
    expect(registo.toString(), fraseToString);
    String disciplina = "FundamentosProgramação";
    expect(disciplina, registo.disciplina);
    String tipo = "Frequência";
    expect(tipo, registo.avaliacao);
    String data = "2023-03-08 15:30";
    expect(data, registo.data);
    int dificuldade = 3;
    expect(dificuldade, registo.dificuldade);
    String observacoes = "";
    expect(observacoes, registo.observacoes);
  });

  test('Test Share.share', () async {
    final message = 'Hello, world!';
    final completer = Completer<void>();
    Share.share(message).then((value) => completer.complete()); // Espere a função ser concluída
    await completer.future; // Aguarde o completer ser concluído
    final sharedMessage = message; // Salve a mensagem em uma variável
    expect(sharedMessage, message); // Verifique se a mensagem é igual à mensagem original
  });
}