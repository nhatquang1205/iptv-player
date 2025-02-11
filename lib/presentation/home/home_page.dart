import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iptv_player/common/widgets/animated_border_fab.dart';
import 'package:iptv_player/presentation/home/nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; //chỉ số

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Home Page'));
      case 1:
        return const Center(child: Text('Channel Page'));
      case 2:
        return const Center(child: Text('XTream Page'));
      case 3:
        return const Center(child: Text('Setting Page'));
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedBorderFab(),
        resizeToAvoidBottomInset: false,
        body: _buildPageContent());
  }
}
