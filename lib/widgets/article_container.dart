import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/screens/article_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 検索結果の各記事を表示するコンポーネント
class ArticleContainer extends StatelessWidget {
  final Article article;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ArticleContainer({
    super.key,
    required this.article,
  });

  /// 記事詳細画面への遷移処理
  void _navigateToArticle(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleScreen(article: article),
      ),
    );
  }

  /// お気に入りに保存する処理
  Future<void> _saveToFavorites(BuildContext context) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final folderName = await _promptForFolderName(context);
      if (folderName != null && folderName.isNotEmpty) {
        await _saveArticleToFolder(user.uid, folderName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to $folderName')),
        );
      }
    }
  }

  /// フォルダに記事を保存する処理
  Future<void> _saveArticleToFolder(String userId, String folderName) async {
    final folderRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(folderName);

    await folderRef.set({'folderName': folderName}); // フォルダ情報を保存

    await folderRef.collection('favorites').doc(article.id).set({
      'title': article.title,
      'url': article.url,
      'createdAt': article.createdAt,
      'tags': article.tags,
      'likesCount': article.likesCount,
      'user': {
        'id': article.user.id,
        'profileImageUrl': article.user.profileImageUrl,
      },
    });
  }

  /// フォルダ名をユーザーに尋ねるダイアログを表示
  Future<String?> _promptForFolderName(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? folderName;
        return AlertDialog(
          title: const Text('Save to Folder'),
          titleTextStyle: const TextStyle(color: Colors.black),
          content: TextField(
            onChanged: (value) {
              folderName = value;
            },
            decoration: const InputDecoration(hintText: 'Enter folder name'),
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(folderName);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// 投稿日表示用ウィジェット
  Widget _buildDateText() {
    return Text(
      DateFormat('yyyy/MM/dd').format(article.createdAt),
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 12,
      ),
    );
  }

  /// 記事タイトル表示用ウィジェット
  Widget _buildTitleText() {
    return Text(
      article.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// タグ表示用ウィジェット
  Widget _buildTagsText() {
    return Text(
      '#${article.tags.join(' #')}',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// いいね数表示用ウィジェット
  Widget _buildLikeInfo() {
    return Row(
      children: [
        const Icon(Icons.favorite, color: Colors.black54),
        const SizedBox(width: 4),
        Text(
          article.likesCount.toString(),
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  /// 投稿者情報表示用ウィジェット
  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(article.user.profileImageUrl),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.user.id,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            _buildDateText(), // 日付をユーザー名の下に配置
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(article.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        _saveToFavorites(context);
      },
      background: Container(
        color: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: GestureDetector(
          onTap: () => _navigateToArticle(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white, // 背景色を白に変更
              borderRadius: BorderRadius.circular(10), // 角丸を少し小さく調整
              boxShadow: [
                // ボックスシャドウを追加してカード風にする
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(), // ユーザー情報を上部に配置
                const SizedBox(height: 8),
                _buildTitleText(), // タイトルを中間に配置
                const SizedBox(height: 8),
                _buildTagsText(), // タグをタイトルの下に配置
                const SizedBox(height: 16),
                _buildLikeInfo(), // いいね情報を下部に配置
              ],
            ),
          ),
        ),
      ),
    );
  }
}
