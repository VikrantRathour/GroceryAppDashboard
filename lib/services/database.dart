import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app_dashboard/models/category.dart';
import 'package:grocery_app_dashboard/models/location_model.dart';
import 'package:grocery_app_dashboard/models/product.dart';
import 'package:grocery_app_dashboard/models/store.dart';

class DatabaseService {
  final CollectionReference storesCollection =
      FirebaseFirestore.instance.collection('stores');

  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');

  Future addNewStore(String storeName, String location, int distanceFromUser,
      String category, String imageUrl, String imageFileName) async {
    await storesCollection.add({
      'name': storeName,
      'location': location,
      'distanceFromUser': distanceFromUser,
      'category': category,
      'image': imageUrl,
      'imageFileName': imageFileName,
      'createdOn': DateTime.now()
    });
  }

  Stream<List<Store>> getStoresList() {
    return storesCollection
        .orderBy('createdOn', descending: true)
        .snapshots()
        .map((list) => list.docs.map((doc) => Store.fromMap(doc)).toList());
  }

  Future addNewProductToStore(String storeId, String productName, int price,
      String imageUrl, String imageFileName) async {
    await storesCollection.doc(storeId).collection('products').add({
      'name': productName,
      'price': price,
      'image': imageUrl,
      'imageFileName': imageFileName
    });
  }

  Future removeStore(String storeId) async {
    await storesCollection.doc(storeId).delete();
  }

  Future removeProductFromStore(String storeId, String productId) async {
    await storesCollection
        .doc(storeId)
        .collection('products')
        .doc(productId)
        .delete();
  }

  Stream<List<Product>> getProductsList(String storeId) {
    return storesCollection
        .doc(storeId)
        .collection('products')
        .snapshots()
        .map((list) => list.docs.map((doc) => Product.fromMap(doc)).toList());
  }

  // Future addNewCategory(String categoryName) async {
  //   await categoriesCollection.add({'name': categoryName});
  // }

  Stream<List<Category>> getCategoriesList() {
    return categoriesCollection
        .snapshots()
        .map((list) => list.docs.map((doc) => Category.fromMap(doc)).toList());
  }

  Stream<List<LocationModel>> getLocations() {
    return locationsCollection.snapshots().map(
        (list) => list.docs.map((doc) => LocationModel.fromMap(doc)).toList());
  }
}
