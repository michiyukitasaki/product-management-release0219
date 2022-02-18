import 'package:eshop5nofirebase/Calendar/event_provider.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calendar_widget.dart';
import 'event_editting_page.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => EventProvider(),
      child: Scaffold(
        appBar: MyAppBar(title: 'スケジュール',bottom: null,),
        drawer: MyDrawer(),
        body: CalendarWidget(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.pink,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EventEditingPage())
          ),
        ),
      ),
    );
  }
}

