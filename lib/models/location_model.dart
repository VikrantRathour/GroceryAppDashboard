import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  LocationModel({this.name});

  final String name;

  factory LocationModel.fromMap(DocumentSnapshot snapshot) {
    var data = snapshot.data();

    return LocationModel(name: data['name']);
  }
}
