import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String storeId;
  final String name;
  final String location;
  final int distanceFromUser;
  final String image;

  Store(
      {this.storeId,
      this.name,
      this.location,
      this.distanceFromUser,
      this.image});

  factory Store.fromMap(DocumentSnapshot snapshot) {
    final data = snapshot.data();

    return Store(
        storeId: snapshot.id,
        name: data['name'],
        location: data['location'],
        distanceFromUser: data['distanceFromUser'],
        image: data['image']);
  }
}
