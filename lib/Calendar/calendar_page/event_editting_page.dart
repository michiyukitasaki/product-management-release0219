
import 'package:eshop5nofirebase/Calendar/calendar_model/event.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../provider/event_provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event
}):super(key: key);



  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}
class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  final titleController = TextEditingController();

  @override
  void initState(){
    super.initState();

    if (widget.event == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }else{
      final event = widget.event!;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose(){
    titleController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green,Colors.cyanAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end:  const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      title: Text(
        '編集',
        style: TextStyle(
            fontSize: 50, color: Colors.white, fontFamily: 'Signatra'),
      ),
      centerTitle: true,
      leading: CloseButton(),
      actions: buildEditingActions(),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTitle(),
            SizedBox(height: 12,),
            buildDateTimePickers(),
          ],
        ),
      ),
    ),
  );

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent
      ),
        icon: Icon(Icons.done),
        label: Text('保存'),
      onPressed: saveForm,
    )
  ];

  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'タイトルを追加'
    ),
    onFieldSubmitted: (_)=>saveForm(),
    controller: titleController,
    validator: (title) =>
    title != null && title.isEmpty ? 'タイトルを入力して下さい':null,
  );

  Widget buildDateTimePickers() => Column(
    children: [
      buildForm(),
      buildTo()
    ],
  );

  Widget buildForm() => buildHeader(
    header:'開始時間',
    child: Row(
      children: [
        Expanded(child: buildDropdownField(
          text: DateFormat('M月d日').format(fromDate)    ,
          onClicked:()=> pickFromDateTime(pickDate:true)
        )),
        Expanded(child: buildDropdownField(
            text: DateFormat('HH時MM分').format(fromDate)  ,
            onClicked:()=> pickFromDateTime(pickDate:false)
        ))

      ],
    ),
  );

  Widget buildTo() => buildHeader(
    header:'終了時間',
    child: Row(
      children: [
        Expanded(child: buildDropdownField(
            text: DateFormat('M月d日').format(fromDate)    ,
            onClicked:()=> pickFromDateTime(pickDate:true)
        )),
        Expanded(child: buildDropdownField(
            text: DateFormat('HH時MM分').format(fromDate)  ,
            onClicked:()=> pickFromDateTime(pickDate:false)
        ))

      ],
    ),
  );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate,pickDate:pickDate);
    if(date == null) return;
    setState(() => fromDate = date );

    if (date.isAfter(toDate)){
      toDate = DateTime(date.year, date.month,date.day, toDate.hour, toDate.minute);
    }

  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,pickDate:pickDate);
    if(date == null) return;
    setState(() => toDate = date );
    }




  Future<DateTime?> pickDateTime(
      DateTime initialDate,{
        required bool pickDate,
        DateTime? firstDate,
        }) async {
        if(pickDate){
          final date = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: firstDate ?? DateTime(2018),
              lastDate: DateTime(2050));
          if(date==null) return null;
          final time =
              Duration(hours: initialDate.hour, minutes: initialDate.minute);

          return date.add(time);
        } else{
          final timeOfDay = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(initialDate));
          if(timeOfDay == null)return null;

          final date = DateTime(
              initialDate.year,
              initialDate.month,
              initialDate.day);
          final time = Duration(
              hours: timeOfDay.hour,
              minutes: timeOfDay.minute
          );
          return date.add(time);
        }
       }


  Widget buildDropdownField({
  required String text,
    required VoidCallback onClicked,
}) => ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({
  required String header,
    required Widget child,
}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,style: TextStyle(fontWeight: FontWeight.bold),),
          child
        ],
      );

  Future saveForm()async{
    final isValid = _formKey.currentState!.validate();

    if(isValid){
      final event = Event(
          title: titleController.text,
          description: 'Description',
          from: fromDate,
          to: toDate,
          isAllDay:false,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context,listen: false);

      if(isEditing){
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      }else {
        provider.addEvent(event);
        Navigator.of(context).pop();
      }
    }
  }
}
