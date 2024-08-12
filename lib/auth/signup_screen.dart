import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../doctor/doctor_home_page.dart';
import '../patient/patient_home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  final _formKey = GlobalKey<FormState>();
  String userType = 'Patient';
  String email = '';
  String password = '';
  String phoneNumber = '';
  String firstName = '';
  String lastName = '';
  String city = 'Guwahati';
  String profileImageUrl = '';
  String category = 'Dentist';
  String qualification = '';
  String yearsOfExperience = '';
  double latitude = 0.0;
  double longitude = 0.0;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final Location _location = Location();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        value: userType,
                        items: ['Patient', 'Doctor'].map((String type) {
                          return DropdownMenuItem(
                              value: type, child: Text(type));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            userType = val as String;
                          });
                        },
                        decoration: InputDecoration(labelText: 'User Type'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) => email = val,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a email address' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        onChanged: (val) => password = val,
                        validator: (val) => val!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => phoneNumber = val,
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a phone number' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'First Name'),
                        keyboardType: TextInputType.text,
                        onChanged: (val) => firstName = val,
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a first name' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Last Name'),
                        keyboardType: TextInputType.text,
                        onChanged: (val) => lastName = val,
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a last name' : null,
                      ),
                      DropdownButtonFormField(
                        value: city,
                        items: [
                          'Guwahati',
                          'Tezpur',
                          'Nagaon',
                          'North Guwahati'
                        ].map((String city) {
                          return DropdownMenuItem(
                              value: city, child: Text(city));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            city = val as String;
                          });
                        },
                        decoration: InputDecoration(labelText: 'City'),
                        validator: (val) =>
                            val == null ? 'Select a city' : null,
                      ),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Upload Profile Image'),
                      ),
                      _imageFile != null
                          ? Image.file(File(_imageFile!.path))
                          : Container(),
                      if (userType == 'Doctor') ...[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Qualification'),
                          onChanged: (val) => qualification = val,
                          validator: (val) => val!.isEmpty
                              ? 'Please enter a qualification'
                              : null,
                        ),
                        DropdownButtonFormField(
                          value: category,
                          items: [
                            'Dentist',
                            'Cardiology',
                            'Oncology',
                            'Surgeon'
                          ].map((String category) {
                            return DropdownMenuItem(
                                value: category, child: Text(category));
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              category = val as String;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Category'),
                          validator: (val) =>
                              val == null ? 'Select a category' : null,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Year of Experience'),
                          onChanged: (val) => yearsOfExperience = val,
                          validator: (val) => val!.isEmpty
                              ? 'Please enter year of experience'
                              : null,
                        ),
                      ],
                      ElevatedButton(
                          onPressed: _getLocation,
                          child: Text('Click to Get Current Location')),
                      if (latitude != 0.0 && longitude != 0.0)
                        Text('Location: ($latitude, $longitude)'),
                      ElevatedButton(
                          onPressed: _register, child: Text('Register')),
                    ],
                  ),
                ),
              )),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _getLocation() async {
    final locationData = await _location.getLocation();
    setState(() {
      latitude = locationData.latitude!;
      longitude = locationData.longitude!;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;

        if (user != null) {
          String userTypePath = userType == 'Doctor' ? 'Doctors' : 'Patients';
          Map<String, dynamic> userData = {
            'uid': user.uid,
            'email': email,
            'phoneNumber': phoneNumber,
            'firstName': firstName,
            'lastName': lastName,
            'city': city,
            'profileImageUrl': profileImageUrl,
            'latitude': latitude,
            'longitude': longitude,
          };

          if (userType == 'Doctor') {
            userData['qualification'] = qualification;
            userData['category'] = category;
            userData['yearsOfExperience'] = yearsOfExperience;
            userData['totalReviews'] = 0;
            userData['averageRating'] = 0.0;
            userData['numberOfReviews'] = 0;
          }

          await _database.child(userTypePath).child(user.uid).set(userData);

          if (_imageFile != null) {
            Reference storageReference = FirebaseStorage.instance
                .ref()
                .child('$userTypePath/${user.uid}/profile.jpg');
            UploadTask uploadTask =
                storageReference.putFile(File(_imageFile!.path));
            TaskSnapshot taskSnapshot = await uploadTask;

            String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            await _database.child(userTypePath).child(user.uid).update({
              'profileImageUrl': downloadUrl,
            });
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  userType == 'Doctor' ? DoctorHomePage() : PatientHomePage(),
            ),
          );
        }
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
