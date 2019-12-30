import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_litle_crud/Database/DBHelper.dart';
import 'package:sql_litle_crud/Model/Contact.dart';

Future<List<Contact>> getContactsFromDb() async {
  var dbHelper = DBHelper();
  Future<List<Contact>> contacts = dbHelper.getContacts();
  return contacts;
}

class MyContactList extends StatefulWidget {
  State<StatefulWidget> createState() => new MyContactListState();
}

class MyContactListState extends State<MyContactList> {

  final controller_name = new TextEditingController();
  final controller_phone = new TextEditingController();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Contact List'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
          future: getContactsFromDb(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return new Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0),
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ),
                                  Text(
                                    snapshot.data[index].phone,
                                    style: TextStyle(
                                        color: Colors.grey[500]),
                                  )
                                ],
                              )
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: Icon(
                              Icons.update,
                              color: Colors.red,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    }
                );
              }
            }

            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }


}