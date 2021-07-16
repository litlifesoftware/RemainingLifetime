import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/view/screens/lifetime_screen.dart';
import 'package:remaining_lifetime/view/screens/profile_screen.dart';

/// A screen widget to allow navigation between the [LifetimeScreen] and
/// [ProfileScreen].
class HomeScreen extends StatefulWidget {
  final LifetimeController? lifetimeController;

  /// Creates a [HomeScreen] [Widget].

  const HomeScreen({
    Key? key,
    required this.lifetimeController,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  /// States whether to hide the bottom navigation bar (in case the settings
  /// should be displayed instead panel).
  bool hideNavigationBar = false;

  /// The first screen's tab data.
  static const LitBottomNavigationTabData _tabDataScreen1 =
      const LitBottomNavigationTabData(
    index: 0,
    icon: LitIcons.home_alt,
    iconSelected: LitIcons.home,
  );

  /// The second screen's tab data.
  static const LitBottomNavigationTabData _tabDataScreen2 =
      const LitBottomNavigationTabData(
    index: 1,
    icon: LitIcons.person,
    iconSelected: LitIcons.person_solid,
  );

  /// Toggles the [hideNavigationBar] state value.
  void toggleHideNavigationBar() {
    setState(() {
      hideNavigationBar = !hideNavigationBar;
    });
  }

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
    return LitTabView(
      tabItemColorSelected: Color(0xFFFFF4dc),
      hideNavigationBar: hideNavigationBar,
      tabs: [
        LitNavigableTab(
          tabData: _tabDataScreen1,
          screen: LifetimeScreen(
            lifetimeController: widget.lifetimeController,
            toggleHideNavigationBar: toggleHideNavigationBar,
          ),
        ),
        LitNavigableTab(
          tabData: _tabDataScreen2,
          screen: ProfileScreen(
            toggleHideNavigationBar: toggleHideNavigationBar,
          ),
        ),
      ],
    );
  }
}
