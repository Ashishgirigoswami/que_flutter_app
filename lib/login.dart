import 'package:que/home.dart';
import 'package:que/db/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:que/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _formKey= GlobalKey<FormState>();
  final _key= GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GoogleSignIn googleSignIn= new GoogleSignIn();
  UserServices _userServices= UserServices();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SharedPreferences preferences;
  bool loading =false;
  bool isLoggedin= false;
  @override
  void initState(){
    super.initState();
    isSignedIN();
     
  }
  void isSignedIN()async{
    setState(() {
      loading=true;
    });
    FirebaseUser user =await _auth.currentUser().then((user){
        if(user!= null){
          setState(() =>isLoggedin=true);
        }
        else{
          setState(() =>isLoggedin=false);

        }
    });
    preferences=await SharedPreferences.getInstance();
    //isLoggedin = await googleSignIn.isSignedIn();
    if(isLoggedin){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new Homepage()));
    }
    setState(() {
      loading=false;
    });
   

    }

    Future handleSignIn() async{
       print("cheack".toString());

      setState(() {
      loading=true;
    });
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser fireuser = authResult.user;
    print("cheack".toString());
  assert(!fireuser.isAnonymous);
  assert(await fireuser.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(fireuser.uid == currentUser.uid);
   print("cheack".toString());
  print(fireuser.email.toString());
  if(currentUser.uid!= null){
  _userServices.createUser(
                  {
                    "name":fireuser.displayName,
                    "email":fireuser.email,
                    "userId":fireuser.uid,
                    "photoUrl": fireuser.photoUrl
                  }
  );
  
  Fluttertoast.showToast(msg: "Logged was successful");
  setState(() {
    loading=false;
  });
  
  Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context)=> new Homepage()));
  }
  
  else{
    Fluttertoast.showToast(msg: "Login Faild :(");
  
  }
  
  }
  @override
  Widget build(BuildContext context) {
     final user= Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      resizeToAvoidBottomPadding: false,

      body:user.status== Status.authenticating?CircularProgressIndicator(): Stack(

            children: <Widget>[
              Image.asset('images/back.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,),
              Container(
                color:Colors.black.withOpacity(0.5),
                height:double.infinity ,
                width:double.infinity,),
                
              

                Padding(
                  padding:const EdgeInsets.only(top:250.0) ,
                      child: Center(
                      child:Form(
                        key: _formKey,
                        child:
                       Column(children: <Widget>[
  
                         Padding(
                           padding: EdgeInsets.fromLTRB(12.0,8.0,12.0,8.0),
                                                  child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.7),
                            elevation: 0.0,
                            child:Padding(
                              padding: const EdgeInsets.only(left:12.0),
                              child: TextFormField(
                               controller: email,
                               decoration: InputDecoration(
                                    hintText: "Email",
                                    icon: Icon(Icons.alternate_email),
                                    
                                ),
                              validator: (value) {
                                        if (value.isEmpty) {
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value))
                                            return 'Please make sure your email address is valid';
                                          else
                                            return null;
                                        }
                                      },
                                    ),
                            )
                           ),
                         ), 
                         
                         Padding(
                           padding: EdgeInsets.fromLTRB(12.0,8.0,12.0,8.0),
                                                  child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.7),
                            elevation: 0.0,
                            child:Padding(
                              padding: const EdgeInsets.only(left:12.0),
                              child: TextFormField(
                               controller: password,
                               decoration: InputDecoration(
                                    hintText: "Password",
                                    
                                    icon: Icon(Icons.lock_outline),
                                    
                                ),
                              validator: (value) {
                                        if (value.isEmpty) {
                                          return "the password field cannot be empty";
                                        }
                                        else if(value.length<6){
                                          return "the password length should be greater then 6";
                                        }
                                        return null;
                                      },
                                    ),
                            )
                           ),
                         ),
                          Padding(
                           padding: EdgeInsets.fromLTRB(12.0,8.0,12.0,8.0),
                                                  child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blueGrey.withOpacity(0.7),
                            elevation: 0.0,
                            child:MaterialButton(onPressed: ()async{
                              if(_formKey.currentState.validate()){
                                if(!await user.signIn(email.text, password.text)) 
                                  _key.currentState.showSnackBar(SnackBar(content:Text("Sign in failed")));
                              }
                            },
                            minWidth:MediaQuery.of(context).size.width,
                             child: Text('login',textAlign:TextAlign.center,
                             style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold),
                            ),),
                         ),

               
                      ),

                      Padding(
                        padding:EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Text("Sign up",style:TextStyle(color: Colors.red)),
                          onTap: (){
                          },),),

                      Divider(color: Colors.white, ),
                      Text('Other login options',style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold),),

                  Expanded(child: Container()),
                      Padding(
                           padding: EdgeInsets.all(8.0),
                              child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.red .withOpacity(0.9),
                            elevation: 0.0,
                            child:MaterialButton(onPressed: (){
                             handleSignIn();
                             },
                            minWidth:MediaQuery.of(context).size.width,
                             child: Text('google',textAlign:TextAlign.center,
                             style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold),
                            ),),
                         ),


                      ),
                      ],))  ,

                    ),
                  
                ),

              Visibility(visible: loading?? true,
              child: Container(
                alignment: Alignment.center,
                color:Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor:AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                
              ),)
            ],
         
      ),
    );
  }
  
}