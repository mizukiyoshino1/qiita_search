import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/screens/article_screen.dart';

/// 検索結果の各記事を表示するコンポーネント
class ArticleContainer extends StatelessWidget {
  final Article article;

  const ArticleContainer({
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

  /// ハートアイコンといいね数表示用ウィジェット
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
    return Padding(
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
    );
  }
}
