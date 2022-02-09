import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:timetracker1229/app/home/jobs/edit_job_page.dart';
import 'package:timetracker1229/app/home/jobs/job_list_file.dart';
import 'package:timetracker1229/common_widgets/show_alert_dialog.dart';
import 'package:timetracker1229/common_widgets/show_exception_alert_dialog.dart';
import 'package:timetracker1229/services/auth.dart';
import 'package:timetracker1229/services/database.dart';

import '../model/job.dart';

class JobsPage extends StatelessWidget {
  // final AuthBase auth;
  // const HomePage({Key? key, required this.auth}) : super(key: key);


  Future<void> _signout(BuildContext context)async{
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
  final didRequestSignOut = await showAlertDialog(
    context,
    title:'Logout',
    content: 'Are you sure that you what to logout?',
    cancelActionText: 'Cancel',
    defaultActiontext: 'Logout',
  );
  if (didRequestSignOut == true){
    _signout(context);
  }
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // onPressed: () => EditJobPage.show(context)
        onPressed: () =>EditJobPage.show(context),
      ),
    );
  }
}

Widget _buildContents (BuildContext context){
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Job?>>(
    stream: database.jobsStream(),
      builder: (context,snapshot){
      if (snapshot.hasData){
        final jobs = snapshot.data;
        final children = jobs!
            .map((job) => JobListTile(
          job: job,
          onTap: () =>EditJobPage.show(context, job: job),)).toList();
        return ListView(children: children);
        // return Container();
        // return AddJobPage();
      }
      if(snapshot.hasError){
        return Center(child:Text('Some error occurred'));
      }
      return Center(child: CircularProgressIndicator());
      });
}

