import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/firebase_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();
  final storeMessage = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Group chat",
            style: TextStyle(fontSize: 29),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () async {
                  service.signOut(context);
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove("email");
                },
                icon: Icon(Icons.logout))
          ],
          // title: Text(loginUser!.email.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 250,
                  ),
                  Column(
                    children: [
                      Text(
                        'Lets chat',
                        style: TextStyle(fontSize: 29),
                      ),
                      Clock(),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  // Spacer(),
                  ShowMessage(),
                  // const Text('Messages'),

                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Row(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.blue, width: 0.3))),
                child: TextField(
                  controller: msg,
                  decoration:
                      const InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Enter Message...'),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (msg.text.isNotEmpty) {
                    storeMessage.collection("Messages").doc().set({
                      "messages": msg.text.trim(),
                      "user": loginUser!.email.toString(),
                      "time": DateTime.now(),
                    });
                    msg.clear();
                  }
                },
                icon: const Icon(Icons.send))
          ],
        ));
  }
}

class ShowMessage extends StatelessWidget {
  const ShowMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Messages")
          .orderBy("time")
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          // reverse: true,
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot x = snapshot.data!.docs[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: loginUser!.email == x['user']
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: loginUser!.email == x['user']
                        ? Colors.green.withOpacity(.1)
                        : Colors.blue.withOpacity(.1),
    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(x['user']),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        x['messages'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],

              // subtitle: Text(x['user']),
            );
          },
        );
      }),
    );
  }
}

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Center(
          child: Text(DateTime.now().toString()),
        );
      },
    );
  }
}
