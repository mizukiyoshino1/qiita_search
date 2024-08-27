import 'package:flutter/material.dart';
import 'package:qiita_search/models/article.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.article.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Page'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
