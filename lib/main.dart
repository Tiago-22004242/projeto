 import 'package:flutter/material.dart';
import 'package:projeto/dashboardScreen.dart';
import 'package:projeto/listagemScreen.dart';
import 'package:projeto/registo.dart';
import 'package:projeto/registoScreen.dart';

void main() => runApp(iQueChumbei());

class iQueChumbei extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Registo> listaRegistos = [];
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MainScreen(
          screens: [
            DashBoardScreen(listaRegistos: listaRegistos,),
            listagemAvaliacaoScreen(listaRegistos: listaRegistos),
            registoAvaliacaoScreen(listaRegistos: listaRegistos)
          ],
          bottoms: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "DashBoard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Lista",
            ),

            /// Search
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: "Registo",
            ),
          ]
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> bottoms;
  const MainScreen({super.key, required this.screens, required this.bottoms});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.screens[_currentPage],
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.deepOrange,
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            currentIndex: _currentPage,
            unselectedItemColor: Colors.black,
            unselectedFontSize:10,
            onTap: (i) => setState(() => _currentPage = i),
            items: widget.bottoms
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

