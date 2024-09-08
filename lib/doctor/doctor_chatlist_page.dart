import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/chat_screen.dart';
import 'package:practice/doctor/model/patient.dart';

class DoctorChatlistPage extends StatefulWidget {
  const DoctorChatlistPage({super.key});

  @override
  State<DoctorChatlistPage> createState() => _DoctorChatlistPageState();
}

class _DoctorChatlistPageState extends State<DoctorChatlistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase = FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _patientsDatabase = FirebaseDatabase.instance.ref().child('Patients');
  List<Patient> _chatList = [];
  bool _isLoading =  true;
  late String doctorId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doctorId = _auth.currentUser?.uid ?? '';
    _fetchChatList();
  }


  Future<void> _fetchChatList() async {
    if(doctorId.isNotEmpty){
      try{
        final DatabaseEvent event = await _chatListDatabase.child(doctorId).once();
        DataSnapshot snapshot = event.snapshot;
        List<Patient> tempChatList = [];

        if(snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

          for( var userId in values.keys){
            final DatabaseEvent patientEvent = await _patientsDatabase.child(userId).once();
            DataSnapshot patientSnapshot = patientEvent.snapshot;
            if(patientSnapshot.value != null){
              Map<dynamic, dynamic> patientMap = patientSnapshot.value as Map<dynamic, dynamic>;
              tempChatList.add(Patient.fromMap(Map<String, dynamic>.from(patientMap)));
            }
          }
        }
        setState(() {
          _chatList = tempChatList;
          _isLoading = false;
        });

      }catch (error) {
        // error message
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with'),),
      body: _isLoading ? Center(child: CircularProgressIndicator())
          : _chatList.isEmpty
          ? Center(child: Text('No chats available'))
          : ListView.builder(
          itemCount: _chatList.length,
          itemBuilder: (context, index){
            final patient = _chatList[index];
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text('Chat with ${patient.firstName} ${patient.lastName}'),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        doctorId:  doctorId,
                        patientId: patient.uid,
                        patientName: '${patient.firstName} ${patient.lastName}',
                      )
                    )
                  );
                },
              ),
            );
          }),
    );
  }
}
