import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/auth/register_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String phone = '';
  String password = '';
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final TextStyle _infoStyle = const TextStyle(
      fontWeight: FontWeight.w600, color: Color(0xFF808080), fontSize: 16);

  final TextStyle _forgotPassStyle = const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.blue);

  final TextStyle _signInStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

  final TextStyle _registerStyle =
      const TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/auth/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .6,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(child: _buildPhoneTextField(context)),
                      Column(
                        children: [
                          _buildPasswordTextField(context),
                          const SizedBox(height: 5),
                          _buildForgotPass(context),
                        ],
                      ),
                      _buildSignInButton(context, authViewModel,
                          phoneController, passwordController),
                      const SizedBox(height: 25),
                      _buildOthersSignIn(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // authViewModel.loading ? const LoadingView() : Container(),
      ],
    ));
  }

  Widget _buildPhoneTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(context.tr('phone_number'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF808080),
                      fontSize: 16))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.searchBorderColor.withOpacity(.3))),
            child: TextFormField(
              decoration: InputDecoration.collapsed(
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(.4)),
                  hintText: context.tr('enter_phone_number')),
              keyboardType: TextInputType.number,
              controller: phoneController,
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 5),
            child: Text(context.tr('password'),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF808080),
                    fontSize: 16))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.searchBorderColor.withOpacity(.3))),
          child: TextFormField(
            decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(color: Colors.grey.withOpacity(.4)),
                hintText: context.tr('enter_password')),
            controller: passwordController,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Row _buildForgotPass(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Text(
            '${context.tr('forgot_password')}?',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blue),
          ),
        )
      ],
    );
  }

  Widget _buildSignInButton(
      BuildContext context,
      AuthViewModel authViewModel,
      TextEditingController phoneController,
      TextEditingController passwordController) {
    return GestureDetector(
      onTap: authViewModel.loading
          ? null
          : () async {
              if (phone.isEmpty || password.isEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(context.tr('phone_or_password_is_empty')),
                    content:
                        Text(context.tr('please_fill_your_phone_or_password')),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'))
                    ],
                  ),
                );
              } else {
                FocusManager.instance.primaryFocus?.unfocus();
                Map<String, String> loginData = {
                  'phone': phone,
                  'password': password,
                };
                await authViewModel.login(
                  loginData,
                  context,
                  phoneController,
                  passwordController,
                );
              }
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
        alignment: Alignment.center,
        height: 45,
        child: authViewModel.loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                context.tr('sign_in').toUpperCase()),
      ),
    );
  }

  Center _buildOthersSignIn(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Text(
          //   context.tr('or_sign_in_with'),
          //   style: _infoStyle,
          // ),
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         image: NetworkImage(
          //             'https://banner2.cleanpng.com/20180521/ers/kisspng-google-logo-5b02bbe1d5c6e0.2384399715269058258756.jpg')),
          //     shape: BoxShape.circle,
          //   ),
          //   width: 31,
          //   height: 31,
          // ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr('donot_have_an_account'),
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterView(),
                    ),
                  );
                },
                child: Text(
                  context.tr('register_now'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: AppColors.blue),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
