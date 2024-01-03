import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/decoration.dart';
import 'package:etravel_mobile/models/account.dart';
import 'package:etravel_mobile/models/nationality.dart';
import 'package:etravel_mobile/repository/auth_repository.dart';
import 'package:etravel_mobile/repository/language_repository.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/common/common_app_bar.dart';
import 'package:etravel_mobile/view/widgets/loading_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../const/const.dart';
import '../widgets/form_dropdown_input_builder.dart';
import '../widgets/form_text_input_builder.dart';
import '../widgets/form_title_text.dart';

class EditProfileView extends StatefulWidget {
  final Account profile;
  const EditProfileView({required this.profile, super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> _initialValues = {};

  bool _isInit = true;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String _genderDropdownValue = kGender[0];
  String _nationalityDropdownValue = '';

  List<Nationality> _nationalities = [];

  @override
  void initState() {
    _initialValues = widget.profile.toJson();
    _genderDropdownValue = widget.profile.gender ?? kGender[0];
    _nationalityDropdownValue = widget.profile.nationalCode ?? 'en-us';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      LanguageRepository().getNationalities().then((response) {
        final data = (response as List?)
                ?.map((item) => Nationality.fromJson(item))
                .toList() ??
            [];
        setState(() {
          _nationalities = data;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _onSubmit(BuildContext ctx) async {
    bool valid = _form.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    loggerInfo.i(json.encode(_initialValues));

    final data = await AuthRepository().updateProfile(_initialValues);
    final updatedAccount = Account.fromJson(data['account']);
    final savedAccount = Account.fromJson(widget.profile.toJson());

    savedAccount.firstName = updatedAccount.firstName;
    savedAccount.lastName = updatedAccount.lastName;
    savedAccount.gender = updatedAccount.gender;
    savedAccount.nationality = updatedAccount.nationality;
    savedAccount.nationalCode = updatedAccount.nationalCode;
    savedAccount.address = updatedAccount.address;
    savedAccount.image = updatedAccount.image;
    await LocalStorageService().saveAccountInfo(savedAccount);
    if (ctx.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _onFormFieldSave(String fieldName, String fieldValue) {
    _initialValues[fieldName] = fieldValue;
  }

  void _onChangeImage() {
    ImagePicker()
        .pickImage(
      source: ImageSource.camera,
    )
        .then((file) {
      if (file == null) {
        return Future.value(null);
      }
      return file.readAsBytes();
    }).then((bytes) {
      if (bytes == null || bytes.isEmpty) {
        return Future.value(null);
      }
      final userId = _initialValues['id'];
      final ref = FirebaseStorage.instance.ref('User');
      final userImageRef = ref.child('$userId');
      setState(() {
        _isUploadingImage = true;
      });
      return userImageRef.putData(bytes).then((snapshot) {
        setState(() {
          _isUploadingImage = false;
        });
        return Future.value(snapshot);
      });
    }).then((task) {
      final taskResult = task;
      if (taskResult == null) {
        return Future.value('');
      }
      return taskResult.ref.getDownloadURL();
    }).then((imageUrl) {
      if (imageUrl.isEmpty) {
        return;
      }
      _initialValues['image'] = imageUrl;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          height: 45,
          child: ElevatedButton(
            style: kCircularButtonStyle,
            onPressed: () => _onSubmit(context),
            child: Text(
              toBeginningOfSentenceCase(context.tr('confirm'))!,
            ),
          ),
        ),
        appBar: CommonAppBar(
          title: Text(
            context.tr('edit_profile'),
            style: const TextStyle(color: Colors.black),
          ),
          appBar: AppBar(),
          backgroundColor: Colors.white,
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: _isUploadingImage
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 38.0,
                                  backgroundImage: NetworkImage(
                                      _initialValues['image'] ?? kDefaultImage),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 12.0,
                                      child: GestureDetector(
                                        onTap: _onChangeImage,
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 20.0,
                                          color: Color(0xFF404040),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  ...buildFormTextInputField(
                    title: context.tr('first_name'),
                    name: 'firstName',
                    required: true,
                    initialValue: _initialValues['firstName'],
                    onSaved: (value) => _onFormFieldSave('firstName', value),
                  ),
                  ...buildFormTextInputField(
                    title: context.tr('last_name'),
                    name: 'lastName',
                    required: true,
                    initialValue: _initialValues['lastName'],
                    onSaved: (value) => _onFormFieldSave('lastName', value),
                  ),
                  ...buildFormTextInputField(
                    title: context.tr('email'),
                    required: true,
                    name: 'email',
                    enabled: false,
                    initialValue: _initialValues['email'],
                    onSaved: (value) => _onFormFieldSave('email', value),
                  ),
                  ...buildFormTextInputField(
                    title: context.tr('phone_number'),
                    required: true,
                    name: 'phone',
                    enabled: false,
                    initialValue: _initialValues['phone'],
                    onSaved: (value) => _onFormFieldSave('phone', value),
                  ),
                  ...buildFormDropdownInput<String>(
                    title: context.tr('gender'),
                    required: true,
                    value: _genderDropdownValue,
                    items: kGender,
                    onChanged: (value) {
                      setState(() {
                        _genderDropdownValue = value;
                      });
                    },
                    onSaved: (value) => _onFormFieldSave('gender', value),
                  ),
                  ..._buildFormNationalityInputField(
                    title: context.tr('nationality'),
                    nationalities: _nationalities,
                    value: _nationalityDropdownValue,
                    required: true,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        _nationalityDropdownValue = newValue;
                      }
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _onFormFieldSave('nationalCode', newValue);
                      }
                    },
                  ),
                  ...buildFormTextInputField(
                    title: context.tr('address'),
                    name: 'address',
                    required: true,
                    initialValue: _initialValues['address'] ?? '',
                    onSaved: (value) => _onFormFieldSave('address', value),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
      if (_isLoading)
        const LoadingIndicator(
          isBackground: true,
        ),
    ]);
  }
}

List<Widget> _buildFormNationalityInputField({
  required String title,
  required List<Nationality> nationalities,
  required String value,
  bool required = false,
  required void Function(String?) onChanged,
  required void Function(String?) onSaved,
}) {
  return [
    FormTitleText(
      title: title,
    ),
    const SizedBox(
      height: 5,
    ),
    DropdownButtonFormField2(
      items: nationalities.map((item) {
        return DropdownMenuItem(
          value: item.nationalCode,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.icon),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(item.nationalName),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      value: value,
      onSaved: onSaved,
      decoration: kInputDecoration,
    ),
    const SizedBox(
      height: 10,
    ),
  ];
}
