import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp_admin/consts/app_constants.dart';
import 'package:fyp_admin/services/app_functions.dart';
import 'package:uuid/uuid.dart';

import '../consts/validator.dart';
import '../models/doc_type.dart';
import '../widgets/subtitle_text.dart';
import '../widgets/title_text.dart';
import 'loading_manager.dart';

class EditAddScreen extends StatefulWidget {
  static const routeName = '/EditAddScreen';

  const EditAddScreen({super.key, this.doctorType});

  final DoctorType? doctorType;

  @override
  State<EditAddScreen> createState() => _EditAddScreenState();
}

class _EditAddScreenState extends State<EditAddScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController;

  String? _categoryValue;
  bool isEditing = false;
  String? docNetworkImage;
  bool _isLoading = false;
  String? docImageUrl;

  @override
  void initState() {
    if (widget.doctorType != null) {
      isEditing = true;
      docNetworkImage = widget.doctorType!.docImage;
      _categoryValue = widget.doctorType!.docCategory;
    }
    _titleController = TextEditingController(
      text: widget.doctorType?.docTitle,);
    _priceController =
        TextEditingController(text: widget.doctorType?.docPrice,);
    _descriptionController =
        TextEditingController(text: widget.doctorType?.docDescription,);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      docNetworkImage = null;
    });
  }

  Future<void> _uploadPicture() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null) {
      AppFunctions.showErrorOrWarningDialog(
          context: context, subtitle: "Choose your image", fct: () {});
      return;
    }
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        final ref = FirebaseStorage.instance.ref().child("doctorImages").child(
            "${_titleController.text}.jpg");
        await ref.putFile(File(_pickedImage!.path));
        docImageUrl = await ref.getDownloadURL();

        final docId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection("doctors")
            .doc(Uuid().v4())
            .set({
          'docId': Uuid().v4(),
          'docName': _titleController.text,
          'docPrice': _priceController.text,
          'docImage': docImageUrl,
          'docCategory': _categoryValue,
          'docDescription': _descriptionController.text,
          'createdAt': Timestamp.now(),
        });
        Fluttertoast.showToast(
          msg: "New Doctor has been added",
          textColor: Colors.white,
        );
        if (!mounted) return;
        AppFunctions.showErrorOrWarningDialog(isError: false,
            context: context,
            subtitle: "Clear Form",
            fct: () {
              clearForm();
            });
      } on FirebaseException catch (error) {
        await AppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          fct: () {},
        );
      } catch (error) {
        await AppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editPicture() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && docNetworkImage == null) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please pick up an image",
        fct: () {},
      );
      return;
    }
    if (isValid) {}
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await AppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return LoadingManager(
      isLoading: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 20,
            child: Material(
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      //backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.phonelink_erase, color: Colors.red),
                    label: const Text("Clear", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      clearForm();
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      // backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.save),
                    label: Text(
                        isEditing ? "Edit" : "Save"),
                    onPressed: () {
                      if (isEditing) {
                        _editPicture();
                      } else {
                        _uploadPicture();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: TitlesTextWidget(
                label: isEditing ? "Edit" : "Enter your details"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
      
                  // Image Picker
                  if(isEditing && docNetworkImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        docNetworkImage!,
                        height: size.height * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ]
                  else
                    if(_pickedImage == null) ...[
                      SizedBox(
                        width: size.width * 0.4 + 10,
                        height: size.width * 0.4,
                        child: DottedBorder(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.green,
                                ),
                                TextButton(
                                  onPressed: () {
                                    localImagePicker();
                                  },
                                  child: Text("Pick your image"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ] else
                      ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_pickedImage!.path),
                            height: size.height * 0.5,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                  if (_pickedImage != null || docNetworkImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: const Text("Pick another image"),
                        ),
                        TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: const Text(
                            "Remove image",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
      
                  const SizedBox(height: 25),
      
                  // Category dropdown widget
                  DropdownButton(
                    items: AppConstants.categoriesDropDownList,
                    value: _categoryValue,
                    hint: const Text("Choose a category"),
                    onChanged: (String? value) {
                      setState(() {
                        _categoryValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey('Title'),
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(hintText: 'Name'),
                            validator: (value) {
                              return Validators.uploadDocTexts(
                                value: value,
                                toBeReturnedString: "Please enter a valid name",
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _priceController,
                                  key: const ValueKey('Price'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Price',
                                    prefix: SubtitleTextWidget(
                                      label: "Rs. ",
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    return Validators.uploadDocTexts(
                                      value: value,
                                      toBeReturnedString: "Price is missing",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('Description'),
                            controller: _descriptionController,
                            minLines: 5,
                            maxLines: 8,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Product description',
                            ),
                            validator: (value) {
                              return Validators.uploadDocTexts(
                                value: value,
                                toBeReturnedString: "Description is missed",
                              );
                            },
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight + 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
