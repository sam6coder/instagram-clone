import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/drawer_item.dart';

import '../screens/profile_screen.dart';
import '../utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  String username = "";
  int _page = 0;
  late PageController pageController;

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    homeScreenItems[3] =
        ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: webBackgroundColor,
      body: Row(
        children: [
          Container(
            color: webBackgroundColor,
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60.0, bottom: 20, left: 30),
                  child: SvgPicture.asset(
                    'assets/images/ic_instagram.svg',
                    color: primaryColor,
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),
                ),
                buildDrawerItem(
                    Icons.home,
                    'Home',
                    context,
                    _page == 0 ? primaryColor : secondaryColor,
                    ()=>navigationTapped(0)),
                buildDrawerItem(
                    Icons.home,
                    'Search',
                    context,
                    _page == 1 ? primaryColor : secondaryColor,
                    ()=>navigationTapped(1)),
                buildDrawerItem(
                    Icons.add_circle,
                    'Create',
                    context,
                    _page == 2 ? primaryColor : secondaryColor,
                    ()=>navigationTapped(2)),
                buildDrawerItem(
                    Icons.person,
                    'Profile',
                    context,
                    _page == 3 ? primaryColor : secondaryColor,
                    ()=>navigationTapped(3)),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            height: double.infinity,
            thickness: 5,
          ),
          Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
            children: homeScreenItems,
            controller: pageController,
            onPageChanged: onPageChanged,
          ))
        ],
      ),
    );
  }
}
