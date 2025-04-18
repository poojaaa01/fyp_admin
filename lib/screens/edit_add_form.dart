import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp_admin/consts/app_constants.dart';
import 'package:fyp_admin/services/app_functions.dart';

import '../consts/validator.dart';
import '../widgets/subtitle_text.dart';
import '../widgets/title_text.dart';

class EditAddScreen extends StatefulWidget {
  static const routeName = '/EditAddScreen';

  const EditAddScreen({super.key});
  @override
  State<EditAddScreen> createState() =>
      _EditAddScreenState();
}

class _EditAddScreenState extends State<EditAddScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController;

  String? _categoryValue;
  @override
  void initState() {
    _titleController = TextEditingController(text: "");
    _priceController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");

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
    });
  }

  Future<void> _uploadPicture() async {
    if (_pickedImage == null) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please pick up an image",
        fct: () {},
      );

      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {}
  }

  Future<void> _editPicture() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null) {
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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 20,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    //backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: const Icon(
                      Icons.phonelink_erase,
                  color: Colors.red,),
                  label: const Text(
                    "Clear",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    // backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save",
                  ),
                  onPressed: () {
                    _uploadPicture();
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const TitlesTextWidget(
            label: "Enter your details",
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                // TODO: Implement the image picker
                // Image Picker

                const SizedBox(
                  height: 25,
                ),

                // Category dropdown widget
                 DropdownButton(
                     items: AppConstants.categoriesDropDownList,
                     value: _categoryValue,
                     hint: const Text("Choose a category"),
                     onChanged: (String? value) {
                      setState(() {
                        _categoryValue = value;
                       });
                     }),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                          decoration: const InputDecoration(
                            hintText: 'Name',
                          ),
                          validator: (value) {
                            return Validators.uploadDocTexts(
                              value: value,
                              toBeReturnedString: "Please enter a valid name",
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                                    )),
                                validator: (value) {
                                  return Validators.uploadDocTexts(
                                    value: value,
                                    toBeReturnedString: "Price is missing",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
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
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
