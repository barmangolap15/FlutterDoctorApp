import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/doctor.dart';

class DoctorDetailPage extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  final DatabaseReference _requestDatabase = FirebaseDatabase.instance
      .ref('Requests'); //  it will store appointments requests

  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(widget.doctor.profileImageUrl),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                '${widget.doctor.firstName} ${widget.doctor.lastName}',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.doctor.category,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600),
              ),
              Text(
                widget.doctor.city,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _openMap, child: Text('View Location on map')),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(_selectedDate == null
                            ? 'Select Date'
                            : DateFormat('MM/dd/yyyy').format(_selectedDate!))),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text(_selectedTime == null
                            ? 'Select Time'
                            : _selectedTime!.format(context))),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //select Date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // open map
  void _openMap() async {
    final String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.doctor.latitude},${widget.doctor.longitude}';
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not open the map';
    }
  }
}
