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
        color: Colors.white70,
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
        color: Colors.white,
      ),
    );
  }

  /// タグ表示用ウィジェット
  Widget _buildTagsText() {
    return Text(
      '#${article.tags.join(' #')}',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white70,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// ハートアイコンといいね数表示用ウィジェット
  Widget _buildLikeInfo() {
    return Row(
      children: [
        const Icon(Icons.favorite, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          article.likesCount.toString(),
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  /// 投稿者情報表示用ウィジェット
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(article.user.profileImageUrl),
        ),
        const SizedBox(height: 4),
        Text(
          article.user.id,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
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
            color: Color(0xFF55C500), // 背景色
            borderRadius: BorderRadius.circular(20), // 角丸
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateText(),
              const SizedBox(height: 8),
              _buildTitleText(),
              const SizedBox(height: 8),
              _buildTagsText(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLikeInfo(),
                  _buildUserInfo(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
