import 'package:flutter/material.dart';

class NavigateUsersWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedPrevious;
  final VoidCallback onClickedNext;

  const NavigateUsersWidget({
    Key? key,
    required this.text,
    required this.onClickedNext,
    required this.onClickedPrevious
  }) : super(key: key);

  @override
  Widget build(BuildContext context)  => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        iconSize: 48,
          onPressed: onClickedPrevious,
          icon: Icon(Icons.navigate_before),
      ),
      Text(
        text,
        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
      ),
      IconButton(
        iconSize: 48,
          onPressed: onClickedNext,
          icon: Icon(Icons.navigate_next))
    ],
  );
}
