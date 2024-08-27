import 'package:flutter/material.dart';
import 'package:qiita_search/widgets/common_navigation_bar.dart';

/// ユーザープロフィールを表示する画面
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Page'),
      ),
      bottomNavigationBar: CommonNavigationBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/search');
          }
        },
      ),
    );
  }
}
