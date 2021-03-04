import 'package:que/db/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:que/db/users.dart';
import 'package:provider/provider.dart';

enum Status{unintialized,authenticated,authenticating,unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth  _auth;
  FirebaseUser  _user;
  UserServices _userServices= UserServices();
  Status _status= Status.unintialized;
  Status get status=> _status;
  FirebaseUser get user=> _user;

  UserProvider.initialize():_auth= FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool>signIn(
    String email, String password)async{
     try{
       _status= Status.authenticating;
       notifyListeners();
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       return true;
     }catch(e){
       _status= Status.unauthenticated;
       notifyListeners();
       print(e.toString());
       return false;

     }
    }

     Future<bool>signUp(String username,
    String email, String password)async{
     try{
       _status= Status.authenticating;
       notifyListeners();
       FirebaseUser user= (await _auth.createUserWithEmailAndPassword(
           email: email, 
           password: password)).user;
           print(user.uid.toString());
          
           if(user.uid!=null)
          {
              
                _userServices.createUser(
                  {
                    "name":username,
                    "email":email,
                    "userId":user.uid,
                  }
                );
        
                return true;

     }}catch(e){
       _status= Status.unauthenticated;
       notifyListeners();
       print(e.toString());
       return false;
     }
    }

    Future signOut()async{
      _auth.signOut();
      _status= Status.unauthenticated;
      notifyListeners();
      return Future.delayed(Duration.zero);
    }

  
  


  void _onStateChanged(FirebaseUser user){

    if(user== null){
      _status=Status.unauthenticated;

    }else{
      _user=user;
      _status=Status.authenticated;
    }
    notifyListeners();

  }


}