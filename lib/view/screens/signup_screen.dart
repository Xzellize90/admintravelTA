import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travel_admin/provider/auth_provider.dart';
import 'package:travel_admin/utill/routes.dart';
import 'package:travel_admin/utill/styles.dart';
import 'package:travel_admin/view/base/custom_login_field.dart';
import 'package:travel_admin/view/base/custom_snackbar.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    Provider.of<AuthProvider>(context, listen: false)
        .clearRegistrationErrorMessage();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return LoadingOverlay(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
                        child: Column(
                          children: [
                            Text(
                              "Travel Admin",
                              style: rockSaltBold.copyWith(
                                fontSize: 32.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomLoginField(
                                controller: _emailController,
                                nextFocus: _passwordFocus,
                                hintText: 'Email',
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: CustomLoginField(
                                  controller: _passwordController,
                                  isPassword: true,
                                  hintText: 'Password',
                                  inputAction: TextInputAction.done,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  String _email = _emailController.text.trim();
                                  String _password =
                                      _passwordController.text.trim();
                                  // pengecekan email kosong
                                  if (_email.isEmpty) {
                                    showCustomSnackBar(
                                        'Email tidak boleh kosong', context);
                                  }
                                  // pengecekan password kosong
                                  else if (_password.isEmpty) {
                                    showCustomSnackBar(
                                        'Password tidak boleh kosong', context);
                                  }
                                  // proses registrasi
                                  else {
                                    await authProvider
                                        .registration(
                                      _emailController.text,
                                      _passwordController.text,
                                      2,
                                    )
                                        .then((value) {
                                      // apabila registrasi sukses maka
                                      // menampilkan halaman login
                                      if (value.isSuccess) {
                                        Navigator.pushReplacementNamed(
                                            context, Routes.LOGIN_SCREEN);
                                      }
                                      // menampilkan pesan kesalahan
                                      // ketika registrasi gagal
                                      else {
                                        showCustomSnackBar(
                                            value.message, context);
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 30),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    'Register',
                                    style: rockSaltMedium.copyWith(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.LOGIN_SCREEN,
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 30),
                                  child: Text(
                                    'Login',
                                    style: rockSaltMedium.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                color: Colors.grey,
                isLoading: authProvider.isLoading,
                progressIndicator: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  strokeWidth: 1.h,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
