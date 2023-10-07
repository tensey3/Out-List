import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MemoriaApp());
}

class MemoriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memoria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> cardNumbers = [1, 2, 3, 4, 1, 2, 3, 4]; // カードの数値
  List<bool> cardFlips = List.filled(8, false); // カードのめくられた状態
  int firstCardIndex = -1; // 最初に選択したカードのインデックス
  int secondCardIndex = -1; // 2番目に選択したカードのインデックス
  bool isChecking = false; // カードを比較中かどうか

  @override
  void initState() {
    super.initState();
    cardNumbers.shuffle(); // カードの数値をランダムにシャッフル
  }

  void _flipCard(int index) {
    if (isChecking || cardFlips[index]) {
      return; // カードを比較中または既にめくられたカードは無視
    }

    setState(() {
      cardFlips[index] = true; // カードをめくる
    });

    if (firstCardIndex == -1) {
      firstCardIndex = index;
    } else {
      secondCardIndex = index;
      isChecking = true;
      Timer(Duration(seconds: 1), _checkCards); // 1秒後にカードを比較
    }
  }

  void _checkCards() {
    if (cardNumbers[firstCardIndex] == cardNumbers[secondCardIndex]) {
      // カードが一致した場合
      setState(() {
        cardFlips[firstCardIndex] = false;
        cardFlips[secondCardIndex] = false;
      });
    } else {
      // カードが一致しない場合、カードを戻す
      setState(() {
        cardFlips[firstCardIndex] = false;
        cardFlips[secondCardIndex] = false;
      });
    }

    firstCardIndex = -1;
    secondCardIndex = -1;
    isChecking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memoria Game'),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2列にする
          ),
          itemCount: cardNumbers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _flipCard(index);
              },
              child: Card(
                color: cardFlips[index] ? Colors.white : Colors.blue,
                child: Center(
                  child: cardFlips[index]
                      ? Text(
                    cardNumbers[index].toString(),
                    style: TextStyle(fontSize: 24),
                  )
                      : Text('?', style: TextStyle(fontSize: 24)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
