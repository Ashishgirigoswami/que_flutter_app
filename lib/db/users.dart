import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserServices{
  
  final _database = FirebaseDatabase.instance.reference();
  String ref= "users";


  createUser(Map value){
    String id = value["userId"];
    _database.reference().child("$ref/$id").set(
      value
    ).catchError((e)=>{print(e.toString())});
  }
}
