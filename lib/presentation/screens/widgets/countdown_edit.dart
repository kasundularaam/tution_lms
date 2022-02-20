import 'package:flutter/material.dart';

import '../../../data/models/countdown_model.dart';

class CountdownEdit extends StatefulWidget {
  final Countdown? countdown;
  const CountdownEdit({
    Key? key,
    this.countdown,
  }) : super(key: key);

  @override
  _CountdownEditState createState() => _CountdownEditState();
}

class _CountdownEditState extends State<CountdownEdit> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Countdown Edit"),
    );
  }
}
