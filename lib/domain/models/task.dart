import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:uuid/uuid.dart';

class Task {
  String? id;
  String? docId;
  String title;
  bool done;
  Color? color;
  DateTime? date;

  Task({
    this.docId,
    required this.title,
    required this.done,
    this.id,
    this.date,
    this.color,
  }) {
    id ??= const Uuid().v1();
    docId ??= id;
    // id == null ? id = DateTime now : id = id
    date ??= DateTime.now();
    color ??=
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
