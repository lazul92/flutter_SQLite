import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_litle_crud/Model/Contact.dart';

class DBHelper{

  final String TABLE_NAME = 'contacts';

  static Database db_instance;

  Future<Database> get db async{
    if(db_instance == null){
      db_instance = await initDB();
    }
    return db_instance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dabtabase.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunction);
    return db;
  }


  void onCreateFunction(Database db, int version) async {
    await db.execute('CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT)');
  }

  Future<List<Contact>> getContacts() async {
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_NAME');
    List<Contact> contacts = new List();
    
    for (int i = 0; i<list.length; i++){
      Contact contact = new Contact();
      contact.id = list[i]['id'];
      contact.name = list[i]['name'];
      contact.phone = list[i]['phone'];

      contacts.add(contact);
    }
    return contacts;
  }

  void addNewContact(Contact contact) async{
    var db_connection = await db;
    String query = 'INSERT INTO $TABLE_NAME (name, phone) VALUES (\'${contact.name}\', \'${contact.phone}\')';
    await db_connection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  void updateContact(Contact contact) async{
    var db_conntection = await db;
    String updateQuery = 'UPDATE $TABLE_NAME SET name = \'${contact.name}\', phone = \'${contact.phone}\' WHERE id = ${contact.id}';
    await db_conntection.transaction((transaction) async{
      return await transaction.rawQuery(updateQuery);
    });
  }

  void deleteContact(Contact contact) async{
    var db_connection = await db;
    String deleteQuery = 'DELETE FROM $TABLE_NAME WHERE id = ${contact.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawQuery(deleteQuery);
    });
  }
}