 import 'package:chatbook/chatbook_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController? emailController;
  TextEditingController? passController;
  bool? showSpinner;
  FirebaseAuth? firebaseAuth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController= TextEditingController();
    passController= TextEditingController();
    showSpinner=false;
    firebaseAuth = FirebaseAuth.instance;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: "logo_tag",
                child: SizedBox(
                  height: 200,
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
                TextField(
                controller: emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter userName',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
                TextField(

                controller: passController,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Material(
                  elevation: 0.5,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(32),
                  child: MaterialButton(
                    onPressed: () async {
                      if(emailController!.text.isEmpty){
                        Alert(context:context,
                            type:AlertType.error,
                            title: "email",
                            desc: "Please Enter you email address").show();
                      }else  if(passController!.text.length<6){
                        Alert(context:context,
                            type:AlertType.error,
                            title: "password",
                            desc: "password must be more than 6 character").show();
                      }else{
                        setState(() {
                          showSpinner=true;
                        });

                        try{
                          UserCredential userCred= await firebaseAuth!.signInWithEmailAndPassword(
                              email: emailController!.text,
                              password: passController!.text);
                          if(userCred.user!.email==emailController!.text){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return ChatBookPage();
                                }));
                          }else{
                            setState(() {
                              showSpinner=false;
                            });
                            Alert(context:context,
                                type:AlertType.error,
                                title: "Failed LogIn",
                                desc: " ").show();
                          }
                        }catch(error){
                          setState(() {
                            showSpinner=false;
                          });
                          Alert(context:context,
                              type:AlertType.error,
                              title: "Failed LogIn",
                              desc: error.toString()).show();
                        }

                      }


                    },
                    minWidth: 200,
                    height: 42,
                    child: const Text("LogIn"),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
