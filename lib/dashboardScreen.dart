
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto/registo.dart';
import 'package:table_calendar/table_calendar.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key, required this.listaRegistos}):super (key: key);
  final  List<Registo> listaRegistos;
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}
class _DashBoardScreenState extends State<DashBoardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  void initState() {
    _selectedDay = DateTime.now();
    super.initState();
  }
  void ordernar(List<Registo> lista) {
    lista.sort((a,b) => a.data.compareTo(b.data));
  }
  @override
  Widget build(BuildContext context) {
    final sreenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("iQueChumbei"),
        ),
        body: SingleChildScrollView(
          child: Column ( children: [
            Text("Nível médio de dificuldade das avaliações dos próximos 7 dias"),
            Text(dificuldade7dias(widget.listaRegistos)),
            Text("Nível médio de dificuldade das avaliações entre os 7 dias e os 14 dias"),
            Text(dificuldade14dias(widget.listaRegistos)),
            SizedBox(height: 30),
            Text("Calendário Semanal"),
              Container(child:
              TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(formatButtonVisible: false,
                    titleTextStyle: TextStyle(color: Colors.white),
                    titleCentered: true,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                    )
                ),
                availableGestures: AvailableGestures.all,
                focusedDay: _focusedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 7)),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.
                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: Colors.deepOrange),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  )
                ),
                eventLoader: (day) => registosDesseDia(widget.listaRegistos, day),
              )),
            Column(
              children: [
                SizedBox(height: 30,),
                Text("Eventos"),
                for ( int i = 0 ; i < registosDesseDia(widget.listaRegistos, _selectedDay!).length ; i++)
                  if (i != registosDesseDia(widget.listaRegistos, _selectedDay!).length -1 )...[
                    Card(child: ListTile( title:Text(registosDesseDia(widget.listaRegistos, _selectedDay!)[i].toString()),subtitle:Text(registosDesseDia(widget.listaRegistos, _selectedDay!)[i].apresentacao()))),SizedBox(height: 10,),
                  ] else...[
                    Card(child: ListTile(title:Text(registosDesseDia(widget.listaRegistos, _selectedDay!)[i].toString()),subtitle:Text(registosDesseDia(widget.listaRegistos, _selectedDay!)[i].apresentacao())))
              ],
              ]
            ),
          ],
        )
      )
      ),
    );
  }
  String dificuldade7dias(List<Registo> listaRegistos) {
    List<int> listaDificuldades = [];
    double media = 0;
    if (listaRegistos.isNotEmpty) {
    for(int i = 0 ; i < listaRegistos.length; i++) {
      Registo registo = listaRegistos[i];
      DateTime dataAtual = DateTime.parse(registo.data);
      DateTime dataMomento = DateTime.now();
      DateTime data7dias = DateTime.now().add(const Duration(days: 7));
      if (dataAtual.isAfter(dataMomento) && dataAtual.isBefore(data7dias)) {
        listaDificuldades.add(listaRegistos[i].dificuldade);
      }
    }
    if (listaDificuldades.isNotEmpty) {
      media = listaDificuldades.average;
    }
    }
   return media.toStringAsFixed(2);
  }

  String dificuldade14dias(List<Registo> listaRegistos) {
    List<int> listaDificuldades = [];
    double media = 0;
    if (listaRegistos.isNotEmpty) {
      for(int i = 0 ; i < listaRegistos.length; i++) {
        Registo registo = listaRegistos[i];
        DateTime dataAtual = DateTime.parse(registo.data);
        DateTime data7dias = DateTime.now().add(const Duration(days: 7));
        DateTime data14dias = DateTime.now().add(const Duration(days: 14));
        if (dataAtual.isAfter(data7dias) && dataAtual.isBefore(data14dias)) {
          listaDificuldades.add(listaRegistos[i].dificuldade);
        }
      }
      if (listaDificuldades.isNotEmpty) {
        media = listaDificuldades.average;
      }
    }
    return media.toStringAsFixed(2);
  }
  List<Registo> registosDesseDia(List<Registo> listaRegistos , DateTime data) {
    ordernar(listaRegistos);
    List<Registo> listaDesseDia= [];
    if (listaRegistos.isNotEmpty) {
      for(int i = 0 ; i < listaRegistos.length; i++) {
        Registo registo = listaRegistos[i];
        DateTime dataAtual = DateTime.parse(registo.data);
        if ((dataAtual.day == data.day && dataAtual.month == data.month && dataAtual.year == data.year) && dataAtual.isAfter(data)){
          listaDesseDia.add(registo);
        }
      }
    }
    return listaDesseDia;
  }
}