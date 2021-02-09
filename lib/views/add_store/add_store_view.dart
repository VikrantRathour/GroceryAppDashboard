import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app_dashboard/models/category.dart';
import 'package:grocery_app_dashboard/models/cloud_storage_result.dart';
import 'package:grocery_app_dashboard/models/location_model.dart';
import 'package:grocery_app_dashboard/services/cloud_storage_service.dart';
import 'package:grocery_app_dashboard/services/database.dart';
import 'package:grocery_app_dashboard/shared/image_selector.dart';
import 'package:grocery_app_dashboard/shared/loading.dart';

class AddStoreView extends StatefulWidget {
  @override
  _AddStoreViewState createState() => _AddStoreViewState();
}

class _AddStoreViewState extends State<AddStoreView> {
  final _formKey = GlobalKey<FormState>();
  final ImageSelector _imageSelector = ImageSelector();
  final CloudStorageSerice _cloudStorageSerice = CloudStorageSerice();

  File _selectedImage;
  File get selectedImage => _selectedImage;

  Future selectImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      setState(() {
        _selectedImage = tempImage;
      });
    }
  }

  String name;
  String location = 'Sector 94';
  int distanceFromUser = 0;
  String category = 'Fruits and Vegetables';
  String imageFileName;
  String imageUrl;
  bool isLoading = false;

  Future addImage() async {
    CloudStorageResult storageResult =
        await _cloudStorageSerice.uploadImage(imageToUpload: _selectedImage);

    setState(() {
      imageFileName = storageResult.imageFileName;
      imageUrl = storageResult.imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    // void _showAddCategoryPanel() {
    //   showModalBottomSheet(
    //       context: context,
    //       builder: (context) {
    //         return AddCategoryBottomSheet();
    //       });
    // }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Store'),
        ),
        body: isLoading
            ? Loading()
            : ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () => selectImage(),
                    child: Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: selectedImage == null
                          ? Text(
                              'Tap to add image',
                              style: TextStyle(color: Colors.grey[400]),
                            )
                          : Image.file(selectedImage),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Please enter store name' : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                    decoration: InputDecoration(hintText: 'Store Name'),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: StreamBuilder<List<LocationModel>>(
                      stream: DatabaseService().getLocations(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading');
                        } else {
                          List<DropdownMenuItem> categoryItems = [];
                          for (LocationModel cat in snapshot.data) {
                            categoryItems.add(DropdownMenuItem(
                              child: Text('${cat.name}'),
                              value: cat.name,
                            ));
                          }
                          return DropdownButtonFormField(
                              items: categoryItems,
                              value: 'Sector 94',
                              onChanged: (val) {
                                setState(() => location = val);
                              });
                        }
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 15.0,
                  // ),
                  // TextFormField(
                  //   validator: (val) => (val.isEmpty ||
                  //           int.tryParse(val) <= 0 ||
                  //           int.tryParse(val) == null)
                  //       ? 'Please enter valid distance'
                  //       : null,
                  //   onChanged: (val) {
                  //     setState(() => distanceFromUser = int.tryParse(val));
                  //   },
                  //   decoration: InputDecoration(hintText: 'Distance from user'),
                  //   keyboardType: TextInputType.number,
                  // ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: StreamBuilder<List<Category>>(
                      stream: DatabaseService().getCategoriesList(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading');
                        } else {
                          List<DropdownMenuItem> categoryItems = [];
                          for (Category cat in snapshot.data) {
                            categoryItems.add(DropdownMenuItem(
                              child: Text('${cat.name}'),
                              value: cat.name,
                            ));
                          }
                          return DropdownButtonFormField(
                              items: categoryItems,
                              value: 'Fruits and Vegetables',
                              onChanged: (val) {
                                setState(() => category = val);
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: () async {
              if (_formKey.currentState.validate() && _selectedImage != null) {
                try {
                  setState(() => isLoading = true);
                  await addImage();
                  if (imageUrl != null) {
                    await DatabaseService().addNewStore(name, location,
                        distanceFromUser, category, imageUrl, imageFileName);
                    Navigator.of(context).pop();
                  } else {
                    setState(() => isLoading = false);
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
            child: Container(
              child: Center(
                  child: Text(
                'Add Store',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              )),
              height: 60.0,
            ),
          ),
        ),
      ),
    );
  }
}
