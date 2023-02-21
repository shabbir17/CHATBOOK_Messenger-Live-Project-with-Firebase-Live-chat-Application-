import 'package:chatbook/login_page.dart';
import 'package:chatbook/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{
   static final FlutterLocalNotificationsPlugin _notificationsPlugin= FlutterLocalNotificationsPlugin();

   static initialize(BuildContext context){
     final initializationSettings = InitializationSettings(android: AndroidInitializationSettings
       ("@mipmap/ic_launcher"));
     _notificationsPlugin.initialize(initializationSettings,
     onDidReceiveNotificationResponse: (payload)async{
       if (payload == "regPage") {
         Navigator.push(context, MaterialPageRoute(builder: (context) {
           return RegistrationPage();
         }));
       } else if (payload == "loginPage") {
         Navigator.push(context, MaterialPageRoute(builder: (context) {
           return LoginPage();
         }));
       }else{
         print(payload);
       }
     }
     );

   }



   static void display(RemoteMessage message){

     final id= DateTime.now().millisecondsSinceEpoch~/1000;
     NotificationDetails notificationDetails= NotificationDetails(
         android:AndroidNotificationDetails("com.example.chatbook","notification_channel",
         importance: Importance.max,
           priority: Priority.high
         ) );
     _notificationsPlugin.show(id, message.notification!.title,
         message.notification!.body, notificationDetails,
         payload: message.data["pondit-message"]);
   }

}

