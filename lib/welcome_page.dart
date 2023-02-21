 import 'package:chatbook/local_notification/local_notification_service.dart';
import 'package:chatbook/login_page.dart';
import 'package:chatbook/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;

  @override
  // ignore: must_call_super
  void initState() {
    // TODO: implement initState
    LocalNotificationService.initialize(context);

    //destroy mode
    FirebaseMessaging.instance.getInitialMessage().then((mNotification) {
      String myMessage = mNotification!.data["pondit-message"];
      print("my destroy message ${myMessage}");

      if (myMessage == "regPage") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationPage();
        }));
      } else if (myMessage == "loginPage") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      }else{
        print(myMessage);
      }
    });

    //background but click the notification
    FirebaseMessaging.onMessageOpenedApp.listen((mNotification) {
      if (mNotification.notification != null) {
        print("backNotif: ${mNotification.notification!.title}");

        String myMessage = mNotification.data["pondit-message"];
        print("my own message: $myMessage ");

        if (myMessage == "regPage") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegistrationPage();
          }));
        } else if (myMessage == "loginPage") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        }
      }
    });

    //in app or foreground
    FirebaseMessaging.onMessage.listen((mNotification) {
      if (mNotification.notification != null) {
        print("backNotif: ${mNotification.notification!.title}");

        String myMessage = mNotification.data["pondit-message"];
        print("my foreground message: $myMessage ");
      }

      LocalNotificationService.display(mNotification);
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    animation = ColorTween(begin: Colors.blueAccent, end: Colors.blue.shade200)
        .animate(animationController!);
    animationController!.forward();
    animationController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value, //Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Hero(
                    tag: "logo_tag",
                    child: SizedBox(
                      height: 60,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  const Text(
                    "ChatBook",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Material(
                  elevation: 0.5,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(32),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginPage();
                      }));
                    },
                    minWidth: 200,
                    height: 42,
                    child: const Text("LogIn"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Material(
                  elevation: 0.5,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(32),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegistrationPage();
                      }));
                    },
                    minWidth: 200,
                    height: 42,
                    child: const Text("Registration"),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
