import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travel_admin/provider/content_provider.dart';
import 'package:travel_admin/utill/styles.dart';
import 'package:travel_admin/view/base/custom_login_field.dart';
import 'package:travel_admin/view/screens/view_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() async {
    // menampilkan data content /pariwisata
    Provider.of<ContentProvider>(context, listen: false)
        .getContentList(false, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      0, 20, 0, MediaQuery.of(context).size.height * 10 / 100),
                  child: Consumer<ContentProvider>(
                    builder: (context, contentProvider, child) {
                      return (contentProvider.isLoading)
                          // preloaded proses menampilkan data
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          :
                          // menampilkan data pariwisata
                          (contentProvider.contentList.isNotEmpty)
                              ? ListView.builder(
                                  itemCount: contentProvider.contentList.length,
                                  padding: EdgeInsets.only(top: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        // melihat detail data wisata
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ViewContent(
                                                  contentModel: contentProvider
                                                      .contentList[index]);
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        color: Colors.orange,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image.network(
                                                contentProvider
                                                    .contentList[index].foto,
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  contentProvider
                                                      .contentList[index].judul,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      rockSaltMedium.copyWith(
                                                    fontSize: 18.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'Data tidak ditemukan',
                                    style: rockSaltRegular.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
