import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:eshop5nofirebase/google_sheets/user.dart';
import 'package:eshop5nofirebase/google_sheets/user_form_widget.dart';
import 'package:eshop5nofirebase/google_sheets/user_sheets_api.dart';
import 'package:flutter/material.dart';

import '../navigate_users_widget.dart';
import 'item_form_widget.dart';
// import 'create_sheets_page.dart';
// import 'navigate_users_widget.dart';

class SheetToFirestorePage extends StatefulWidget {


  @override
  State<SheetToFirestorePage> createState() => _SheetToFirestorePageState();
}

class _SheetToFirestorePageState extends State<SheetToFirestorePage> {
  List<User> users = [];
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  Future getUsers({int? index})async{
    final users = await UserSheetsApi.getAll();

    setState(() {
      this.users = users;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoogleShetts'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ItemFormWidget(
              user:users.isEmpty ? null : users[index],
              onSavedUser: (user) async {
                await UserSheetsApi.update(user.id!, user.toJson());
                // UserSheetsApi.updateCell(
                //     id: 4,
                //     key: 'email',
                //     value: 'MICHIYUKI@gmail.com');
              },
            ),
            const SizedBox(height: 16,),
            if(users.isNotEmpty) buildUserControls(),
          ],
        ),
      ),
    );

  }
  

  Widget buildUserControls() => Column(
    children: [
      ButtonWidget(
          text: 'Delete',
          onClicked: deleteUser),
      NavigateUsersWidget(
        text: '${index + 1}/${users.length}Users',
        onClickedNext:(){
          final nextIndex = index >= users.length -1 ? 0 :index + 1;
          setState(() => index = nextIndex);
        },
        onClickedPrevious:(){
          final previousIndex = index <=0 ? users.length -1 :index - 1;
          setState(() => index = previousIndex);
        },
      ),
    ],
  );

  Future deleteUser() async {
    final user = users[index];
    await UserSheetsApi.deleteById(user.id!);
    final newIndex = index > 0 ? index - 1: 0;
    await getUsers(index:newIndex);
  }

}






class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key,required this.text,required this.onClicked}):super(key:key);
  final String text;
  final VoidCallback onClicked;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          shape: StadiumBorder(),),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white
            ),
          ),
        ));
  }
}
