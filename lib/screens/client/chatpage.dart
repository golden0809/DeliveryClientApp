import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  TextEditingController _newMessageController = TextEditingController();
  
  ScrollController _scrollController = ScrollController();

  FirebaseUser user;

  @override
  initState(){
    super.initState();
    FirebaseAuth.instance.currentUser().then((value)async {
      setState(() {
        user = value;
      });
      var userDocument = await Firestore.instance.collection("chats").document(value.uid).get();
      if(!userDocument.exists)Firestore.instance.collection("chats").document(value.uid).collection("userChats");

    }).catchError((er)=> Navigator.of(context).pop());

  }
  
  
  sendMessage()async {
    if(_newMessageController.text.isNotEmpty){
      if(user == null)user = await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection("chats").document(user.uid).collection("userChats").add({
        "timeStamp": FieldValue.serverTimestamp(),
        "message": _newMessageController.text,
        "userId": user?.uid
      }).then((value){
        _newMessageController.value = TextEditingValue(text: "");
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text("contact us".toUpperCase(),style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
          ),
        ),
        title: Image.asset("assets/images/small_logo.png"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.cover)
          ),
        ),
      ),
        body: Container(
          width: width,
          height: height,
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.only(left: 8,right: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: 50,),
                          Text("${DateTime.now().hour} : ${DateTime.now().minute} ${DateTime.now().hour>12? "PM": "AM"}"),
                          IconButton(
                            onPressed: ()=> Navigator.of(context).pop(),
                            icon: Icon(Icons.cancel,color: Colors.black,),
                          )
                        ],
                      ),
                    ),
                    user == null? Center(child: CircularProgressIndicator(),): Container(
                      height: height - (100 + 50 + 100) - MediaQuery.of(context).viewInsets.bottom,
                      child: StreamBuilder(
                        stream: Firestore.instance.collection("chats").document(user.uid).collection('userChats').orderBy('timeStamp').snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data.documents.length < 1){
                              return Center(child: Text("No Chats Yet"),);
                            }
                            else{
                              Timer.run(() {
                                _scrollController.jumpTo(_scrollController.position?.maxScrollExtent);
                              });
                              return ListView.separated(
                                controller: _scrollController,
                                  shrinkWrap: true,
                                  separatorBuilder: (context,ind)=> SizedBox(height: 5,),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context,ind){
                                    return Container(
                                      width: width,
                                      child: Row(
                                        mainAxisAlignment: snapshot.data.documents[ind]["userId"] == user.uid? MainAxisAlignment.end: MainAxisAlignment.start,
                                        children: <Widget>[
                                          snapshot.data.documents[ind]["userId"] != user.uid?CircleAvatar(
                                            child: Text("A"),
                                            backgroundColor: Colors.blueAccent,
                                          ): Container(),
                                          SizedBox(width: 10,),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: snapshot.data.documents[ind]["userId"] == user.uid? CrossAxisAlignment.end: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      gradient: snapshot.data.documents[ind]["userId"] != user.uid? null: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [Colors.blue,Colors.blue.withOpacity(0.9), Colors.greenAccent]),
                                                      color: snapshot.data.documents[ind]["userId"] == user.uid? null: Colors.grey.withOpacity(0.4),
                                                      borderRadius: snapshot.data.documents[ind]["userId"] == user.uid?BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15),topLeft: Radius.circular(15)): BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15))
                                                  ),
                                                  child: Text("${snapshot.data.documents[ind]['message']}",style: TextStyle(color: snapshot.data.documents[ind]["userId"] == user.uid?Colors.white: Colors.black),),
                                                ),
                                                snapshot.data.documents[ind]['timeStamp'] == null? Container(): Text("${timeago.format(DateTime.parse(snapshot.data.documents[ind]['timeStamp']?.toDate().toString()), locale: 'en_short')}")
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          snapshot.data.documents[ind]["userId"] == user.uid?CircleAvatar(
                                            child: Text("U"),
                                          ): Container(),
                                        ],
                                      ),
                                    );
                                  });
                            }
                          }
                          else{
                            return Center(child: CircularProgressIndicator());
                          }

                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: width,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width * .75,
                            child: TextField(
                              controller: _newMessageController,
                              decoration: InputDecoration(
                                  hintText: "Your message"
                              ),
                            ),
                          ),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: InkWell(
                                  onTap: ()=> sendMessage(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Send".toUpperCase()),
                                  )))
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),

        ));
  }
}
