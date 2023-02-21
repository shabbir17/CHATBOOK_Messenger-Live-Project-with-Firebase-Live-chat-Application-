import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

User? user;
FirebaseFirestore? firebaseFirestore;

class ChatBookPage extends StatefulWidget {


  const ChatBookPage({Key? key}) : super(key: key);

  @override
  State<ChatBookPage> createState() => _ChatBookPageState();
}

class _ChatBookPageState extends State<ChatBookPage> {
  FirebaseAuth? auth;
  TextEditingController? messageController;
  FirebaseStorage? storage;

  @override
  void initState() {
    // TODO: implement initState
    auth = FirebaseAuth.instance;
    messageController = TextEditingController();
    firebaseFirestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      user = auth!.currentUser;
    } catch (error) {
      print(error);
    }
  }

  void saveMessage(String url) {
    firebaseFirestore!.collection("pondit_messages").add({
      "sender": user!.email,
      "text": messageController!.text,
      "timestamp": DateTime.now().microsecondsSinceEpoch,
      "imageUrl": url

    });
  }

  Future<void> getImageFromCameraOrGallery(ImageSource source )async{
    final ImagePicker picker =ImagePicker();
    final XFile? file =await picker.pickImage(source: source);
    String fileName= 'pondit_${DateTime.now().microsecondsSinceEpoch.toString()}.png';
Reference reference = storage!.ref().child("pondit_photo").child(fileName);
    uploadFileInFirebaseStorage(file!,reference);
  }

  Future<void> uploadFileInFirebaseStorage(XFile file,Reference ref )async{
    File imageFile= File(file.path);
    await  ref.putFile(imageFile);
    downloadUrlFromFirebaseStorage(ref);
  }

  Future<void>downloadUrlFromFirebaseStorage(Reference ref)async{
    String url= await ref.getDownloadURL();
    saveMessage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: (Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              decoration: BoxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    child: IconButton(
                      onPressed: ()async
                      {
                        await getImageFromCameraOrGallery(ImageSource.gallery);
                      },
                      icon: Icon(Icons.image,

                      size: 20,
                      color:Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    child: IconButton(
                      onPressed: ()async
                      {
                        await getImageFromCameraOrGallery(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt,

                          size: 20,
                          color:Colors.blue),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        filled: true,
                        fillColor: Colors.black54,
                        hintText: "Type your message here",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      saveMessage("no-image");
                      messageController!.clear();
                    },
                    child: Text("Send"),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore!
          .collection("pondit_messages")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageBubble> messageWidgetList = [];

          for (QueryDocumentSnapshot querySnapshot in snapshot.data!.docs) {
            String mMessage = querySnapshot.get("text");
            String mSender = querySnapshot.get("sender");
            String mImageUrl = querySnapshot.get("imageUrl");

                MessageBubble messageBubble = MessageBubble(
              isUserMe: mSender == user!.email ? true : false,
              msgSender: mSender,
              msgText: mMessage,
              imageUrl:mImageUrl,

            );
            messageWidgetList.add(messageBubble);
          }
          return Expanded(
              child: ListView(
          reverse: true,
            children: messageWidgetList,
          ));
        } else {
          return Container();
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String? msgText;
  final String? msgSender;
  final bool? isUserMe;
  final String? imageUrl;

  const MessageBubble({this.imageUrl,this.isUserMe, this.msgSender, this.msgText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isUserMe == true
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            msgSender!,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          imageUrl=='no-image'?Material(
            color: isUserMe == true ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
              topLeft:
                  isUserMe == true ? Radius.circular(50) : Radius.circular(0),
              topRight:
                  isUserMe == true ? Radius.circular(0) : Radius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText!,
                style: TextStyle(
                    fontSize: 15,
                    color: isUserMe == true ? Colors.white : Colors.blue),
              ),
            ),
          ):Container(
            height: 200,
            width: 200,
            alignment: Alignment.center
            ,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(imageUrl!,fit: BoxFit.cover,alignment: Alignment.center,),
          ),
        ],
      ),
    );
  }
}
