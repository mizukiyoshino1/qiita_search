import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qiita_search/widgets/article_tile.dart';

/// モダンでデザイン性の高いフォルダタイルウィジェット
class FolderTile extends StatelessWidget {
  final DocumentSnapshot folder; // フォルダのデータを保持するDocumentSnapshot
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FolderTile({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // タイルの角を丸める
      ),
      elevation: 3, // 影を追加して浮き上がったような効果をつける
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // 展開時の区切り線を非表示
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text(
            folder['folderName'], // フォルダ名をタイルのタイトルとして表示
            style: const TextStyle(
              fontWeight: FontWeight.bold, // 太字でフォルダ名を表示
              fontSize: 18, // フォルダ名のフォントサイズを調整
              color: Colors.black87, // 文字色を設定
            ),
          ),
          leading: const Icon(
            Icons.folder, // フォルダアイコンを表示
            color: Colors.blueAccent, // アイコンの色を設定
            size: 30, // アイコンのサイズを設定
          ),
          trailing: const Icon(
            Icons.expand_more, // 展開アイコン
            color: Colors.black54, // アイコンの色を設定
          ),
          children: [
            _buildFavoritesList(context), // フォルダ内のお気に入り記事リストを表示
          ],
        ),
      ),
    );
  }

  /// フォルダ内のお気に入り記事リストを作成するウィジェット
  Widget _buildFavoritesList(BuildContext context) {
    final user = _auth.currentUser;
    return StreamBuilder<QuerySnapshot>(
      // フォルダ内のお気に入り記事をFirestoreから取得
      stream: _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('folders')
          .doc(folder.id)
          .collection('favorites')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final articles = snapshot.data!.docs; // 記事リストを取得
          if (articles.isEmpty) {
            // 記事がない場合はメッセージを表示
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No favorites in this folder',
                style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 内部スクロールを無効化
            itemCount: articles.length, // 記事の数に基づいてリストを作成
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleTile(article: article); // 記事タイルウィジェットを表示
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // エラーが発生した場合
        } else {
          return const Center(child: CircularProgressIndicator()); // データ読み込み中
        }
      },
    );
  }
}
