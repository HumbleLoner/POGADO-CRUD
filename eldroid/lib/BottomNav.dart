// ignore_for_file: prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, must_be_immutable, no_logic_in_create_state
import 'package:eldroid/AddItemScreen.dart';
import 'package:eldroid/DeleteItemScreen.dart';
import 'package:eldroid/ProfileScreen.dart';
import 'package:eldroid/ViewItem.dart';
import 'package:flutter/material.dart';
import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';

class LandingScreen extends StatefulWidget {
  int index;
  LandingScreen({required this.index, Key? key}) : super(key: key);
  @override
  _LandingScreenState createState() => _LandingScreenState(index);
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex;
  _LandingScreenState(this._selectedIndex);
  String Home = 'Home';
  List<Widget> _widgetOptions = <Widget>[
    AddItemScreen(),
    ItemListScreen(),
    ItemScreen(),
    ProfileScreen(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CircleBottomNavigation(
        barHeight: 50,
        circleSize: 35,
        arcHeight: 40,
        initialSelection: _selectedIndex,
        inactiveIconColor: Colors.grey,
        textColor: Colors.black,
        hasElevationShadows: false,
        tabs: [
          TabData(
            icon: Icons.food_bank,
            title: 'Add Item',
            iconSize: 15,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          TabData(
            icon: Icons.list,
            title: 'View Item',
            iconSize: 15,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          TabData(
            icon: Icons.list,
            title: 'Update Item',
            iconSize: 15,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          TabData(
            icon: Icons.person,
            title: 'Profile',
            iconSize: 15,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ],
        onTabChangedListener: _onItemTap,
      ),
    );
  }
}
