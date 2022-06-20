import 'dart:ui';

import 'package:Lighthouse/4_Gewinnt/screens/game_screen/widgets/cell.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference myRef;
  RxList<List<int>> _board = RxList<List<int>>();
  List<List<int>> get board => _board.value;
  set board(List<List<int>> value) => _board.value = value;
 Color select = Colors.black;
  RxBool _turnYellow = true.obs;
  bool get turnYellow => _turnYellow.value;

  void _buildBoard() {
    _turnYellow.value = true;
    board = [
      List.filled(6, 0),
      List.filled(6, 0),
      List.filled(6, 0),
      List.filled(6, 0),
      List.filled(6, 0),
      List.filled(6, 0),
      List.filled(6, 0),
    ];
    update();
  }
  _clearIndex() {
    myRef = database.ref("LED");
    for (int i = 0; i < 288; i++) {
      myRef.child(i.toString()).child("R").set("0");
      myRef.child(i.toString()).child("G").set("0");
      myRef.child(i.toString()).child("B").set("0");
    }
  }

  @override
  void onInit() {
    super.onInit();
    _buildBoard();
    koordinaten_Farben_uebertragung();
  }
  koordinaten_Farben_uebertragung() {
    myRef = database.ref("LED");
  }
   //* wandelt x und y zu Index
  column_row_to_index(int x,int y){
    //erste Reihe
    if(x==0 && y==0){
      return 7;
    }
    if(x==0 && y==1){
      return 6;
    }
    if(x==0 && y==2){
      return 5;
    }
    if(x==0 && y==3){
      return 4;
    }
    if(x==0 && y==4){
      return 3;
    }
    if(x==0 && y==5){
      return 2;
    }
    //zweite Reihe
    if(x==1 && y==0){
      return 15;
    }
    if(x==1 && y==1){
      return 14;
    }
    if(x==1 && y==2){
      return 13;
    }
    if(x==1 && y==3){
      return 12;
    }
    if(x==1 && y==4){
      return 11;
    }
    if(x==1 && y==5){
      return 10;
    }

    //dritte Reihe
    if(x==2 && y==0){
      return 23;
    }
    if(x==2 && y==1){
      return 22;
    }
    if(x==2 && y==2){
      return 21;
    }
    if(x==2 && y==3){
      return 20;
    }
    if(x==2 && y==4){
      return 19;
    }
    if(x==2 && y==5){
      return 18;
    }

    //vierte Reihe
    if(x==3 && y==0){
      return 31;
    }
    if(x==3 && y==1){
      return 30;
    }
    if(x==3 && y==2){
      return 29;
    }
    if(x==3 && y==3){
      return 28;
    }
    if(x==3 && y==4){
      return 27;
    }
    if(x==3 && y==5){
      return 26;
    }
    //fünfte Reihe
    if(x==4 && y==0){
      return 39;
    }
    if(x==4 && y==1){
      return 38;
    }
    if(x==4 && y==2){
      return 37;
    }
    if(x==4 && y==3){
      return 36;
    }
    if(x==4 && y==4){
      return 35;
    }
    if(x==4 && y==5){
      return 34;
    }
    //sechste Reihe
    if(x==5 && y==0){
      return 47;
    }
    if(x==5 && y==1){
      return 46;
    }
    if(x==5 && y==2){
      return 45;
    }
    if(x==5 && y==3){
      return 44;
    }
    if(x==5 && y==4){
      return 43;
    }
    if(x==5 && y==5){
      return 42;
    }
    //siebte Reihe
    if(x==6 && y==0){
      return 55;
    }
    if(x==6 && y==1){
      return 54;
    }
    if(x==6 && y==2){
      return 53;
    }
    if(x==6 && y==3){
      return 52;
    }
    if(x==6 && y==4){
      return 51;
    }
    if(x==6 && y==5){
      return 50;
    }

  }

  void game_Loop(int columnNumber) {
    int index;
    //* Save player number depending on player's turn
    final int playerNumber = turnYellow ? 1 : 2;
    //* Select column
    final selectedColumn = board[columnNumber];

    //* Check if selectedColumn has zeros -> empty cells
    if (selectedColumn.contains(0)) {
      //* Check for first appearance of a zero
      final int rowIndex = selectedColumn.indexWhere((cell) => cell == 0);
      //* Replace zero with playerNumber
      selectedColumn[rowIndex] = playerNumber;

      //* Farbe vom Spieler Übertragung
      if(playerNumber == 2){
        select= Color(0xFF0000);
      }else if(playerNumber==1){
        select= Color(0x00FF00);
      }
      print("playercolor(R):${select.red}");
      print("playercolor(G):${select.green}");
      print("playercolor(B):${select.blue}");
      print(playerNumber);
      print("row(y):$rowIndex");
      print("column(x):${board.indexOf(selectedColumn)}");
      print("index:${column_row_to_index(board.indexOf(selectedColumn), rowIndex)}");
      //* Index des Fenster Übertragung
      index =column_row_to_index(board.indexOf(selectedColumn), rowIndex);
      //* RGB Werte Übertragung
      myRef.child(index.toString()).child("R").set(select.red);
      myRef.child(index.toString()).child("G").set(select.green);
      myRef.child(index.toString()).child("B").set(select.blue);
      //* Switch turns
      _turnYellow.value = !_turnYellow.value;
      //* Update UI
      update();

      winner = checkVictory();

      if (winner != 0) {
        declareWinner();
      }

      if (boardIsFull()) {
        Get.defaultDialog(
            title: 'Niemand hat gewonnen',
            content: Cell(
              currentCellMode: cellMode.EMPTY,
            )).then((value) => resetGame());
      }
    } else {
      Get.snackbar('Nicht möglich',
          'Diese Spalte ist schon voll',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  int winner = 0;

  void declareWinner() {
    Get.defaultDialog(
        title: winner == 1 ? 'Grün hat gewonnen' : 'Rot hat gewonnen',
        content: Cell(
          currentCellMode: winner == 1 ? cellMode.GREEN : cellMode.RED,
        )).then((value) => resetGame());
  }

  void resetGame(){
    _buildBoard();
    _clearIndex();
  }

  bool boardIsFull() {
    for (final col in board) {
      for (final val in col) {
        if (val == 0) {
          return false;
        }
      }
    }
    return true;
  }

  int checkHorizontals() {
    int yellowInARow = 0;
    int redInARow = 0;
    List<List<int>> rows = [];

    for (var i = 0; i < 6; i++) {
      final List<int> currentRow = getRowList(i);
      rows.add(currentRow);
    }

    for (final row in rows) {
      for (final cell in row) {
        if (yellowInARow >= 4) {
          return 1;
        } else if (redInARow >= 4) {
          return 2;
        } else {
          if (cell == 1) {
            yellowInARow++;
            redInARow = 0;
          } else if (cell == 2) {
            redInARow++;
            yellowInARow = 0;
          } else {
            yellowInARow = 0;
            redInARow = 0;
          }
        }
      }
    }
    return 0;
  }

  List<int> getRowList(int rowNumber) {
    List<int> rowList = [];
    for (final column in board) {
      rowList.add(column[rowNumber]);
    }
    return rowList;
  }

  int checkVerticals() {
    int yellowInARow = 0;
    int redInARow = 0;

    for (final column in board) {
      for (final cell in column) {
        if (yellowInARow >= 4) {
          return 1;
        } else if (redInARow >= 4) {
          return 2;
        } else {
          if (cell == 1) {
            yellowInARow++;
            redInARow = 0;
          } else if (cell == 2) {
            redInARow++;
            yellowInARow = 0;
          } else {
            yellowInARow = 0;
            redInARow = 0;
          }
        }
      }
    }
    return 0;
  }

  int checkDiagonals() {
    final List<int> diagonalDown1 = [];
    final List<int> diagonalDown2 = [];
    final List<int> diagonalDown3 = [];
    final List<int> diagonalDown4 = [];
    final List<int> diagonalDown5 = [];
    final List<int> diagonalDown6 = [];
    final List<int> diagonalUp1 = [];
    final List<int> diagonalUp2 = [];
    final List<int> diagonalUp3 = [];
    final List<int> diagonalUp4 = [];
    final List<int> diagonalUp5 = [];
    final List<int> diagonalUp6 = [];

    //* Fill list 1
    diagonalDown1.add(getCellValue(0, 3));
    diagonalDown1.add(getCellValue(1, 2));
    diagonalDown1.add(getCellValue(2, 1));
    diagonalDown1.add(getCellValue(3, 0));
    //* Fill list 2
    diagonalDown2.add(getCellValue(0, 4));
    diagonalDown2.add(getCellValue(1, 3));
    diagonalDown2.add(getCellValue(2, 2));
    diagonalDown2.add(getCellValue(3, 1));
    diagonalDown2.add(getCellValue(4, 0));
    //* Fill list 3
    diagonalDown3.add(getCellValue(0, 5));
    diagonalDown3.add(getCellValue(1, 4));
    diagonalDown3.add(getCellValue(2, 3));
    diagonalDown3.add(getCellValue(3, 2));
    diagonalDown3.add(getCellValue(4, 1));
    diagonalDown3.add(getCellValue(5, 0));
    //* Fill list 4
    diagonalDown4.add(getCellValue(1, 5));
    diagonalDown4.add(getCellValue(2, 4));
    diagonalDown4.add(getCellValue(3, 3));
    diagonalDown4.add(getCellValue(4, 2));
    diagonalDown4.add(getCellValue(5, 1));
    diagonalDown4.add(getCellValue(6, 0));
    //* Fill list 5
    diagonalDown5.add(getCellValue(2, 5));
    diagonalDown5.add(getCellValue(3, 4));
    diagonalDown5.add(getCellValue(4, 3));
    diagonalDown5.add(getCellValue(5, 2));
    //* Fill list 6
    diagonalDown6.add(getCellValue(3, 5));
    diagonalDown6.add(getCellValue(4, 4));
    diagonalDown6.add(getCellValue(5, 3));
    diagonalDown6.add(getCellValue(6, 2));
    //* Fill list 1
    diagonalUp1.add(getCellValue(0, 2));
    diagonalUp1.add(getCellValue(1, 2));
    diagonalUp1.add(getCellValue(2, 3));
    diagonalUp1.add(getCellValue(3, 4));
    //* Fill list 2
    diagonalUp2.add(getCellValue(0, 1));
    diagonalUp2.add(getCellValue(1, 2));
    diagonalUp2.add(getCellValue(2, 3));
    diagonalUp2.add(getCellValue(3, 4));
    diagonalUp2.add(getCellValue(4, 5));
    //* Fill list 3
    diagonalUp3.add(getCellValue(0, 0));
    diagonalUp3.add(getCellValue(1, 1));
    diagonalUp3.add(getCellValue(2, 2));
    diagonalUp3.add(getCellValue(3, 3));
    diagonalUp3.add(getCellValue(4, 4));
    diagonalUp3.add(getCellValue(5, 5));
    //* Fill list 4
    diagonalUp4.add(getCellValue(1, 0));
    diagonalUp4.add(getCellValue(2, 1));
    diagonalUp4.add(getCellValue(3, 2));
    diagonalUp4.add(getCellValue(4, 3));
    diagonalUp4.add(getCellValue(5, 4));
    diagonalUp4.add(getCellValue(6, 5));
    //* Fill list 5
    diagonalUp5.add(getCellValue(2, 0));
    diagonalUp5.add(getCellValue(3, 1));
    diagonalUp5.add(getCellValue(4, 2));
    diagonalUp5.add(getCellValue(5, 3));
    diagonalUp5.add(getCellValue(6, 4));
    // //* Fill list 6
    diagonalUp6.add(getCellValue(3, 0));
    diagonalUp6.add(getCellValue(4, 1));
    diagonalUp6.add(getCellValue(5, 2));
    diagonalUp6.add(getCellValue(6, 3));

    //* Diagonals Parent List
    List<List<int>> diagonals = [];
    diagonals.addAll([
      diagonalDown1,
      diagonalDown2,
      diagonalDown3,
      diagonalDown4,
      diagonalDown5,
      diagonalDown6,
      diagonalUp1,
      diagonalUp2,
      diagonalUp3,
      diagonalUp4,
      diagonalUp5,
      diagonalUp6
    ]);

    for (final diagonal in diagonals) {
      final String diagonalStr = diagonal.join();
      if (diagonalStr.contains('1111')) {
        return 1;
      } else if (diagonalStr.contains('2222')) {
        return 2;
      }
    }

    return 0;
  }

  int getCellValue(int columnNumber, int rowNumber) {
    return board[columnNumber][rowNumber];
  }

  int checkVictory() {
    //* Board dimensions
    const int maxx = 7;
    const int maxy = 6;
    List<List<int>> directions = [
      //* Horizontal to right
      [1, 0],
      //* Diagonal downwards
      [1, -1],
      //* Diagonal upwards
      [1, 1],
      //* Vertical upwards
      [0, 1]
    ];
    //* Direction loop
    for (List<int> d in directions) {
      int dx = d[0];
      int dy = d[1];
      //* Horizontal loop
      for (int x = 0; x < maxx; x++) {
        //* Vertical loop
        for (int y = 0; y < maxy; y++) {
          int lastx = (x + (3 * dx));
          int lasty = (y + (3 * dy));
          //* Check if current coordinates are within the board
          if ((((0 <= lastx) && (lastx < maxx)) && (0 <= lasty)) &&
              (lasty < maxy)) {
            //* Gets value of cell, starts always at (0,0)
            int w = board[x][y];
            //* Check for value equality of next three cells
            if ((((w != 0) && (w == board[x + dx][y + dy])) &&
                    (w == board[x + (2 * dx)][y + (2 * dy)])) &&
                (w == board[lastx][lasty])) {
              return w;
            }
          }
        }
      }
    }
    return 0;
  }
}
