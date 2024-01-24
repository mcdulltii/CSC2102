import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/ui/pages/chat/chat_page.dart';
import 'package:mobile/ui/pages/history/history_page.dart';
import 'package:mobile/ui/pages/home/home_page.dart';
import 'package:mobile/ui/pages/profile/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../theme/theme.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [const HomePage(), const ChatPage(), const ProfilePage()];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home_outlined),
          title: ("Home"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.greyColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
          title: ("Chat"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.greyColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.square_stack_3d_down_right_fill),
          title: ("Profile"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.greyColor,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          false, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          false, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style2, // Choose the nav bar style with this property.
    );
  }
}
