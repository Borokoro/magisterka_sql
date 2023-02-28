import 'dart:async';
import 'package:magisterka_sql/mySQL/mySQL.dart';
import 'package:flutter/material.dart';
import 'package:magisterka_sql/functions/records.dart';
import 'package:magisterka_sql/functions/timer_function.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int passed = 0;
  bool isTimerRunning=false;
  final MySQL mySQL=MySQL();
  late TimerFunction timerFunction;
  void _update(int updatedTime) {
    print(updatedTime);
    setState(() {
      passed = updatedTime;
    });
  }

  @override
  void initState() {
    mySQL.establishConnection();
    timerFunction=TimerFunction(valueChanged: _update);
    print('done 1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  passed.toString(),
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'ms',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async{
                  timerFunction.startTimer();
                  await Records(mySql: mySQL).addRecords();//Records(mySql: mySQL).addRecords();
                  timerFunction.cancelTimer();
                },
                child: const Text('Start')),
          ],
        ),
      ),
    );
  }
}
