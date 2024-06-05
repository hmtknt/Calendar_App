import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/edit_profile_provider.dart';
import 'package:flutter_events_2023/View/Components/build_buttons.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/widgets/text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool passToggle = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    final sp = context.read<AuthProvider>();
    sp.getDataFromSharedPreferences();
    nameController.text = sp.name.toString();
    phoneController.text = sp.phone.toString();
    emailController.text = sp.email.toString();
    imageUrl = sp.imageUrl.toString();
    aboutController.text = sp.about.toString();
  }

  File? imageFile;
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<AuthProvider>();
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Edite Profile',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 49,
                          backgroundColor: LightColor.primary,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: imageFile == null
                                ? sp.imageUrl!.isEmpty
                                    ? const AssetImage("assets/Images/person.png")
                                    : NetworkImage("${sp.imageUrl}") as ImageProvider
                                : FileImage(imageFile!) as ImageProvider,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 3,
                          child: InkWell(
                            onTap: () {
                              _chooseImage();
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedTextField(
                    controller: nameController,
                    hint: 'Enter Name',
                    color: Colors.transparent,
                    borderColor: Colors.transparent,
                    pIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 20),
                  RoundedTextField(
                    controller: emailController,
                    onlyRead: true,
                    hint: 'Email Address',
                    color: Colors.transparent,
                    borderColor: Colors.transparent,
                    pIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 20),
                  RoundedTextField(
                    controller: phoneController,
                    hint: 'Phone Number',
                    color: Colors.transparent,
                    borderColor: Colors.transparent,
                    pIcon: const Icon(Icons.phone),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RoundedTextField(
                      controller: aboutController,
                      hint: 'About',
                      color: Colors.transparent,
                      borderColor: Colors.transparent,
                      maxLine: 6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Consumer<EditProfileProvider>(builder: (context, EditProfileProvider editeProfile, _) {
                        return buildRegisterButton(() async {
                          editeProfile.setLoading(true);
                          if (imageFile != null) {
                            String? image = await _uploadImageToFirebase(imageFile!);
                            print("This is image url ==== $image");
                            setState(() {
                              imageUrl = image!;
                            });
                          }

                          print("This is image url ==== $imageUrl");
                          await editeProfile.updateProfile(
                              context, sp.uid.toString(), imageUrl, nameController.text, phoneController.text, aboutController.text);
                          sp.checkUserExists().then((value) async {
                            if (value == true) {
                              // user exists
                              await sp
                                  .getUserDataFromFirestore(sp.uid)
                                  .then((value) => sp.saveDataToSharedPreferences().then((value) => sp.setSignIn().then((value) {
                                        editeProfile.setLoading(false);
                                      })));
                            } else {
                              // user does not exist
                              sp.saveDataToFirestore().then((value) => sp.saveDataToSharedPreferences().then((value) => sp.setSignIn().then((value) {
                                    editeProfile.setLoading(false);
                                  })));
                            }
                          });
                        },
                            editeProfile.loading
                                ? const SpinKitThreeBounce(
                                    color: LightColor.white,
                                    size: 30.0,
                                  )
                                : Text("Update", style: GoogleFonts.poppins(color: LightColor.white, fontSize: 16, fontWeight: FontWeight.w600)));
                      })),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    final file = File(imageFile.path.toString());
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);

    try {
      // Specify content type explicitly as image
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await firebaseStorageRef.putFile(file, metadata);

      final downloadURL = await firebaseStorageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image to Firebase: $e");
      return null; // or handle the error as appropriate for your app
    }
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      // Get.to(() => ImageScreen(image: imageFile, id: widget.id));
    }
  }

  _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 115,
            decoration: const BoxDecoration(
                color: LightColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    _getFromGallery();
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(
                    Icons.add_a_photo,
                    color: LightColor.black,
                  ),
                  title: const Text('Gallery',
                      style: TextStyle(
                        color: LightColor.black,
                        fontSize: 15.0,
                      )),
                ),
                ListTile(
                  onTap: () {
                    _getFromCamera();
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(
                    Icons.camera,
                    color: LightColor.black,
                  ),
                  title: const Text('Camera',
                      style: TextStyle(
                        color: LightColor.black,
                        fontSize: 15.0,
                      )),
                ),
              ],
            ),
          );
        });
  }
}
