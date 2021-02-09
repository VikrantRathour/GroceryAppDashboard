import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app_dashboard/models/cloud_storage_result.dart';
import 'package:grocery_app_dashboard/services/cloud_storage_service.dart';
import 'package:grocery_app_dashboard/services/database.dart';
import 'package:grocery_app_dashboard/shared/image_selector.dart';
import 'package:grocery_app_dashboard/shared/loading.dart';

class AddProductView extends StatefulWidget {
  final String storeId;

  const AddProductView({Key key, this.storeId}) : super(key: key);
  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
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
  int price;
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
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Product'),
        ),
        body: isLoading
            ? Loading()
            : Column(
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
                        val.isEmpty ? 'Please enter product name' : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                    decoration: InputDecoration(hintText: 'Product Name'),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (val) => (val.isEmpty ||
                            int.tryParse(val) <= 0 ||
                            int.tryParse(val) == null)
                        ? 'Please enter valid price'
                        : null,
                    onChanged: (val) {
                      setState(() => price = int.tryParse(val));
                    },
                    decoration: InputDecoration(hintText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
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
                    await DatabaseService().addNewProductToStore(
                        widget.storeId, name, price, imageUrl, imageFileName);
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
                'Add Product',
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
