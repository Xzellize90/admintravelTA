import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travel_admin/data/model/response/favorit_model.dart';
import 'package:travel_admin/provider/auth_provider.dart';
import 'package:travel_admin/provider/favorit_provider.dart';
import 'package:travel_admin/utill/styles.dart';
import 'package:travel_admin/view/screens/login_screen_email.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  FavoritModel data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<FavoritProvider>(
          builder: (context, favoritProvider, child) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Admin",
                    style: rockSaltBold.copyWith(
                      fontSize: 32.sp,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout()
                          .then((value) {
                        print('logout >> $value');
                        if (value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreenEmail(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 30),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Sign Out',
                        style: rockSaltMedium.copyWith(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
