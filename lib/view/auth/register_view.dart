import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/nationality.dart';
import 'package:etravel_mobile/view/auth/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../repository/auth_repository.dart';
import '../../repository/language_repository.dart';
import '../../res/colors/app_color.dart';
import '../../view_model/main_app_viewmodel.dart';
import '../widgets/form_dropdown_input_builder.dart';
import '../widgets/form_text_input_builder.dart';
import 'otp_input_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _genderDropdownValue = kGender[0];
  var _phoneCodeDropdownValue = '';
  bool _isInit = true;
  List<Nationality> _nationalities = [];

  final _initValues = {
    'firstName': '',
    'lastName': '',
    'gender': '',
    'email': '',
    'phone': '',
    'password': '',
    'confirmPassword': '',
    'configLanguageId': 3,
  };

  var _isShowingPassword = true;

  void _onSubmit(BuildContext context) {
    _formKey.currentState?.save();
    try {
      final firebasePhoneNumber =
          _phoneCodeDropdownValue + (_initValues['phone'] as String);
      final dbPhoneNumber = '0${_initValues['phone'] as String}';
      FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(minutes: 2),
        phoneNumber: firebasePhoneNumber,
        verificationCompleted: (credential) {
          FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (exception) {},
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const OTPInputView()))
              .then((value) {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: value.toString(),
            );
            return FirebaseAuth.instance.signInWithCredential(credential);
          }).then((value) {
            // Signout Firebase because finishing validate phone number
            FirebaseAuth.instance.signOut();
            _initValues['phone'] = dbPhoneNumber;
            final mainAppProvider =
                Provider.of<MainAppViewModel>(context, listen: false);
            _initValues['configLanguageId'] = mainAppProvider.id;
            return AuthRepository().registerApi(_initValues);
          }).then((responseData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text(
                  context.tr('register_succeeded'),
                ),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
              (route) => false,
            );
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (ex) {
      print(ex);
    } catch (ex) {
      print(ex);
    }
  }

  void _toggleShowPassword() {
    setState(() {
      _isShowingPassword = !_isShowingPassword;
    });
  }

  void _onSaved(String name, String value) {
    _initValues[name] = value;
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
          _phoneCodeDropdownValue = data[0].phoneCode;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('sign_up_and_start_now'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...buildFormTextInputField(
                          title: context.tr('first_name'),
                          name: 'firstName',
                          onSaved: (value) => _onSaved('firstName', value),
                        ),
                        ...buildFormTextInputField(
                          title: context.tr('last_name'),
                          name: 'lastName',
                          onSaved: (value) => _onSaved('lastName', value),
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
                          onSaved: (value) => _onSaved('gender', value),
                        ),
                        ...buildFormTextInputField(
                          title: context.tr('email'),
                          required: true,
                          name: 'email',
                          onSaved: (value) => _onSaved('email', value),
                        ),
                        FormInputTitle(
                          title: context.tr('phone_number'),
                          required: true,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                children: buildFormDropdownInput<String>(
                                  onChanged: (value) {
                                    setState(() {
                                      _phoneCodeDropdownValue = value;
                                    });
                                  },
                                  onSaved: (value) {
                                    _phoneCodeDropdownValue = value;
                                  },
                                  items: _nationalities
                                      .map((e) => e.phoneCode)
                                      .toList(),
                                  value: _phoneCodeDropdownValue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: buildFormTextInputField(
                                    type: TextInputType.phone,
                                    name: 'phone',
                                    onSaved: (value) =>
                                        _onSaved('phone', value),
                                  ),
                                ))
                          ],
                        ),
                        ...buildFormTextInputField(
                          title: context.tr('password'),
                          name: 'password',
                          onSaved: (value) => _onSaved('password', value),
                          isPassword: true,
                          isShowingPassword: _isShowingPassword,
                          onToggleShowPassword: _toggleShowPassword,
                        ),
                        ...buildFormTextInputField(
                          title: context.tr('confirm_password'),
                          name: 'confirmPassword',
                          onSaved: (value) =>
                              _onSaved('confirmPassword', value),
                          isPassword: true,
                          isShowingPassword: _isShowingPassword,
                          onToggleShowPassword: _toggleShowPassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _onSubmit(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    context.tr('continue'),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('i_have_an_account'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      context.tr('sign_in_now'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
