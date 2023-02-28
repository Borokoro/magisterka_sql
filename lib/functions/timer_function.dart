import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimerFunction{
  final ValueChanged<int> valueChanged;
  late Timer timer;
  int time=0;
  static const oneMil=Duration(milliseconds: 1);
  TimerFunction({required this.valueChanged});

  void startTimer() async{
    time=0;
    timer=Timer.periodic(oneMil, (Timer timer) {
      time++;
    });
  }
  void cancelTimer() async{
    valueChanged(time);
    timer.cancel();
  }

}
