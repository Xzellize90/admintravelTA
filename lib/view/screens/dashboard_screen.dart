import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_admin/utill/styles.dart';
import 'package:travel_admin/view/screens/home_screen.dart';
import 'package:travel_admin/view/screens/profile.dart';
import 'package:travel_admin/view/screens/add_wisata_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 1;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;
    _pageController = PageController(
      initialPage: widget.pageIndex,
      keepPage: false,
    );

    // index menu
    _screens = [
      AddWisataScreen(),
      HomeScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        extendBody: true,
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
        bottomNavigationBar: SizedBox(
          // height: MediaQuery.of(context).size.height * 10 / 100,
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.blue[800].withOpacity(0.6),
            selectedItemColor: Colors.orange,
            selectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
            unselectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
            selectedLabelStyle: rockSaltMedium.copyWith(
                fontSize: 24, color: Colors.black),
            unselectedLabelStyle: rockSaltMedium.copyWith(fontSize: 24),
            showUnselectedLabels: true,
            currentIndex: _pageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              _barItem('Add', 0),
              _barItem('List', 1),
              _barItem('Profle', 2),
            ],
            onTap: (int index) {
              _setPage(index);
            },
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(Icons.home_sharp),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _pageIndex = pageIndex;
    });
  }
}
