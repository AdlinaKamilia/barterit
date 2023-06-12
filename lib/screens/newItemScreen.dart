import 'dart:convert';
import 'dart:io';
import 'package:barterit/screens/itemListingScreen.dart';
import 'package:barterit/screens/usersItem.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user.dart';
import '../myConfig.dart';
import 'package:http/http.dart' as http;

class NewItemScreen extends StatefulWidget {
  final User user;
  const NewItemScreen({super.key, required this.user});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  List<File> newImages = [];
  // ignore: unused_field
  int _index = 0;
  var imgNo = 1;
  File? _image;
  final _formKey = GlobalKey<FormState>();
  late double screenH, screenW;
  final TextEditingController _itemNameC = TextEditingController();
  final TextEditingController _itemDescC = TextEditingController();
  final TextEditingController _itemPriceC = TextEditingController();
  final TextEditingController _itemQtyC = TextEditingController();
  final TextEditingController _localC = TextEditingController();
  final TextEditingController _stateC = TextEditingController();

  String selectType = "Home Appliances";
  List<String> categoryList = [
    "Home Appliances",
    "Car Accesories",
    "Electronic Components",
    "Books",
    "Others"
  ];

  late Position _currPosition;
  String currAddress = "", currState = "", prlat = "", prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
    newImages.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: Column(
        children: [
          imgNo == 0
              ? GestureDetector(
                  onTap: () {
                    _selectFromCamera();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Card(
                        child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? const AssetImage("assets/images/camera.jpg")
                              : FileImage(_image!) as ImageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 250,
                    child: PageView.builder(
                        itemCount: 3,
                        controller: PageController(viewportFraction: 0.9),
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return image1();
                          } else if (index == 1) {
                            return image2();
                          } else {
                            return image3();
                          }
                        }),
                  ),
                ),
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                  height: 60,
                                  child: DropdownButton(
                                    value: selectType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectType = newValue!;
                                      });
                                    },
                                    items: categoryList.map((selectType) {
                                      return DropdownMenuItem(
                                          value: selectType,
                                          child: Text(selectType));
                                    }).toList(),
                                  )),
                            ],
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "Item Name must be longer than 5"
                                : null,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (v) {},
                            controller: _itemNameC,
                            decoration: const InputDecoration(
                                labelText: 'Item Name',
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.abc_outlined,
                                  size: 40,
                                ),
                                iconColor: Colors.blue,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "Item description must be longer than 10"
                                    : null,
                            keyboardType: TextInputType.text,
                            maxLines: 4,
                            onFieldSubmitted: (v) {},
                            controller: _itemDescC,
                            decoration: const InputDecoration(
                                labelText: 'Item Description',
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.description_outlined,
                                  size: 30,
                                ),
                                iconColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Item price needs a value"
                                        : null,
                                    onFieldSubmitted: (v) {},
                                    controller: _itemPriceC,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Item Price',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.money,
                                          size: 30,
                                        ),
                                        iconColor: Colors.blue,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.green),
                                        ))),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Quantity should be more than 0"
                                        : null,
                                    controller: _itemQtyC,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Item Quantity',
                                        labelStyle: TextStyle(),
                                        icon: Icon(
                                          Icons.numbers,
                                          size: 30,
                                        ),
                                        iconColor: Colors.green,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.blue),
                                        ))),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  controller: _localC,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      labelText: 'Locality',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.map),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                      ))),
                            ),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  controller: _stateC,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      labelText: 'State',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.place),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                      ))),
                            ),
                          ]),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showInsertDialog();
                              },
                              child: const Text("Insert Item")),
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }

  void _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  cropImage() async {
    CroppedFile? cropFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).colorScheme.secondary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (cropFile != null) {
      File imageFile = File(cropFile.path);
      _image = imageFile;
      //int? sizeInBytes = img?.lengthSync();
      //double sizeInMb = sizeInBytes! / (1024 * 1024);
      newImages.add(_image!);
      setState(() {});
    }
  }

  void showInsertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please check any of your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please choose or take any pictures")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Do you want to insert new item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertNewItem();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertNewItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("In Process of Adding New Item"),
          content: LinearProgressIndicator(),
        );
      },
    );
    String itemN = _itemNameC.text;
    String itemDesc = _itemDescC.text;
    String itemPrice = _itemPriceC.text;
    String itemQty = _itemQtyC.text;
    List<String> base64Images = [];
    for (File? image in newImages) {
      if (image != null) {
        String base64Image = base64Encode(image.readAsBytesSync());
        base64Images.add(base64Image);
      }
    }
    http.post(Uri.parse("${MyConfig().server}/barterit/php/insert_item.php"),
        body: {
          "userId": widget.user.id.toString(),
          "itemName": itemN,
          "itemDescription": itemDesc,
          "itemPrice": itemPrice,
          "itemQuantity": itemQty,
          "itemType": selectType,
          "state": _stateC.text,
          "loc": _localC.text,
          "lat": prlat,
          "long": prlong,
          "images": jsonEncode(
              base64Images), // Pass the base64 encoded images to the backend
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => UserItemScreen(
                        user: widget.user,
                      )));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location service are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission are permanently denied.");
    }
    _currPosition = await Geolocator.getCurrentPosition();
    _getAddress(_currPosition);
  }

  Future<void> _getAddress(Position currentPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    setState(() {
      _localC.text = placemarks[0].locality.toString();
      _stateC.text = placemarks[0].administrativeArea.toString();
      prlat = _currPosition.latitude.toString();
      prlong = _currPosition.longitude.toString();
    });
  }

  Widget image1() {
    return Transform.scale(
        scale: 1,
        child: GestureDetector(
          onTap: () {
            _selectFromCamera();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Card(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: newImages.isNotEmpty
                      ? FileImage(newImages[0]) as ImageProvider
                      : const AssetImage("assets/images/camera.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
            )),
          ),
        ));
  }

  Widget image2() {
    return Transform.scale(
        scale: 1,
        child: GestureDetector(
          onTap: () {
            _selectFromCamera();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Card(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: newImages.length > 1
                      ? FileImage(newImages[1]) as ImageProvider
                      : const AssetImage("assets/images/camera.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
            )),
          ),
        ));
  }

  Widget image3() {
    return Transform.scale(
        scale: 1,
        child: Flexible(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                _selectFromCamera();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Card(
                    child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: newImages.length > 2
                          ? FileImage(newImages[2]) as ImageProvider
                          : const AssetImage("assets/images/camera.jpg"),
                      fit: BoxFit.contain,
                    ),
                  ),
                )),
              ),
            )));
  }
}
//sambung pick 3 image, then pass data to database then buat edit delete, see details, 