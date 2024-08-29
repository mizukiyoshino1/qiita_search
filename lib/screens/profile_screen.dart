import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qiita_search/widgets/common_navigation_bar.dart';
import 'package:qiita_search/widgets/folder_tile.dart';

/// ユーザーのプロフィール画面を表示するクラス
class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Firestoreからユーザーのフォルダ情報を取得
        stream: _firestore
            .collection('users')
            .doc(user?.uid)
            .collection('folders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final folders = snapshot.data!.docs; // 取得したフォルダリスト
            return ListView.builder(
              itemCount: folders.length, // フォルダの数に基づいてリストを作成
              itemBuilder: (context, index) {
                final folder = folders[index];
                return FolderTile(folder: folder); // フォルダタイルウィジェットを表示
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // エラーが発生した場合
          } else {
            return const Center(child: CircularProgressIndicator()); // データ読み込み中
          }
        },
      ),
      bottomNavigationBar: CommonNavigationBar(
        selectedIndex: 2, // 現在の画面がプロフィール画面であることを示すインデックス
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home'); // ホーム画面に遷移
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/search'); // 検索画面に遷移
          }
        },
      ),
    );
  }
}
