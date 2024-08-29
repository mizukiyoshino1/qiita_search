import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qiita_search/models/user.dart';
import 'package:qiita_search/screens/article_screen.dart';
import 'package:qiita_search/models/article.dart';

/// 記事を表示するタイルウィジェット
class ArticleTile extends StatelessWidget {
  final DocumentSnapshot article;

  /// コンストラクタで記事のDocumentSnapshotを受け取る
  ArticleTile({required this.article});

  /// 記事詳細画面への遷移処理
  void _navigateToArticle(BuildContext context) {
    // DocumentSnapshotをArticleモデルに変換
    final Article articleData = Article(
      id: article.id,
      title: article['title'],
      url: article['url'],
      createdAt: (article['createdAt'] as Timestamp).toDate(),
      tags: List<String>.from(article['tags']),
      likesCount: article['likesCount'],
      user: User(
        // ArticleUserではなくUserを使用
        id: article['user']['id'],
        profileImageUrl: article['user']['profileImageUrl'],
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleScreen(article: articleData),
      ),
    );
  }

  /// 記事を削除する処理
  Future<void> _deleteArticle() async {
    await article.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    // Firestoreのデータをそれぞれの変数に格納
    final articleTitle = article['title'];
    final articleUrl = article['url'];
    final articleCreatedAt = (article['createdAt'] as Timestamp).toDate();
    final articleTags = article['tags'];
    final articleLikesCount = article['likesCount'];
    final articleUserId = article['user']['id'];
    final articleUserProfileImage = article['user']['profileImageUrl'];

    // 記事タイルの外観と構成を定義
    return Dismissible(
      key: Key(article.id),
      direction: DismissDirection.endToStart, // 右から左へのスワイプで削除
      onDismissed: (direction) {
        _deleteArticle(); // スワイプ時に記事を削除
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$articleTitle deleted')),
        );
      },
      background: Container(
        color: Colors.red, // 削除アクションの背景色
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: const Icon(
          Icons.delete, // 削除アイコン
          color: Colors.white,
        ),
      ),
      child: GestureDetector(
        onTap: () => _navigateToArticle(context), // タップ時に詳細画面に遷移
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // カード風のデザインにする
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
              // ユーザー情報（プロフィール画像とユーザーID、作成日）の表示
              _buildUserInfo(
                  articleUserId, articleUserProfileImage, articleCreatedAt),
              const SizedBox(height: 8),
              // 記事タイトルの表示
              _buildTitleText(articleTitle),
              const SizedBox(height: 8),
              // 記事のタグの表示
              _buildTagsText(articleTags),
              const SizedBox(height: 16),
              // いいね数の表示
              _buildLikeInfo(articleLikesCount),
            ],
          ),
        ),
      ),
    );
  }

  /// ユーザー情報を表示するウィジェット
  Widget _buildUserInfo(
      String userId, String profileImageUrl, DateTime createdAt) {
    return Row(
      children: [
        // プロフィール画像を表示
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ユーザーIDを表示
            Text(
              userId,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            // 記事の作成日を表示
            Text(
              DateFormat('yyyy/MM/dd').format(createdAt),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 記事タイトルを表示するウィジェット
  Widget _buildTitleText(String title) {
    return Text(
      title,
      maxLines: 2, // タイトルが長すぎる場合に2行で切り詰める
      overflow: TextOverflow.ellipsis, // タイトルが長い場合に省略記号を表示
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// 記事のタグを表示するウィジェット
  Widget _buildTagsText(List<dynamic> tags) {
    return Text(
      '#${tags.join(' #')}', // タグを'#'で区切って表示
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// いいね数を表示するウィジェット
  Widget _buildLikeInfo(int likesCount) {
    return Row(
      children: [
        const Icon(Icons.favorite, color: Colors.black54, size: 16),
        const SizedBox(width: 4),
        Text(
          likesCount.toString(), // いいね数を表示
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
