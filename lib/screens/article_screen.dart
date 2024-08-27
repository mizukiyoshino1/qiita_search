import 'package:flutter/material.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/widgets/common_navigation_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 記事の詳細を表示する画面
class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    super.key,
    required this.article,
  });

  /// 表示する記事の情報
  final Article article;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final WebViewController _controller;
  // 現在選択されているナビゲーションタブのインデックスを保持する変数
  int _selectedIndex = 1; // 初期状態では Searchタブを選択する

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.article.url));
  }

  /// ナビゲーションバーのタブがタップされた時に呼び出されるメソッド
  void _onItemTapped(int index) {
    setState(() {
      // 選択されたタブのインデックスを更新
      _selectedIndex = index;

      // タブのインデックスに応じて画面遷移を行う
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Page'),
      ),
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: CommonNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
