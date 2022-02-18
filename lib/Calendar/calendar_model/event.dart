import 'package:flutter/material.dart';

class Event {
  final String titel;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.titel,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay = false,
});
}