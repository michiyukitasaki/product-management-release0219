import 'package:eshop5nofirebase/Calendar/calendar_widget/tasks_widget.dart';
import 'package:eshop5nofirebase/Calendar/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../calendar_model/event_data_source.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.greenAccent,
      onLongPress: (details){
        final provider = Provider.of<EventProvider>(context,listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
            context: context,
            builder: (context)=> TasksWidget());
      },
    );
  }
}

