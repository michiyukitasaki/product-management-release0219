import 'package:eshop5nofirebase/Calendar/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../calendar_model/event_data_source.dart';
import '../calendar_page/event_viewing_page.dart';

class TasksWidget extends StatefulWidget {

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty){
      return Center(
        child: Text(
          'No Events found!',
          style: TextStyle(color: Colors.black,fontSize: 24),
        ),
      );
    }
    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder:apointmentBuilder,
        selectionDecoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.3)
        ),
        todayHighlightColor: Colors.greenAccent,
        onTap: (details){
        if(details.appointments ==null)return;
        final event = details.appointments!.first;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventViewingPage(event:event)
        ));
        },
    );
  }
}

Widget apointmentBuilder(
  BuildContext context,
 CalendarAppointmentDetails details,
){
  final event = details.appointments.first;
  return Container(
    width: details.bounds.width,
    height: details.bounds.height,
    decoration: BoxDecoration(
      color: event.backgroundColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12)
    ),
    child: Center(
      child: Text(
        event.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}