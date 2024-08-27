import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/widgets/article_container.dart';
import 'package:qiita_search/widgets/common_navigation_bar.dart';

/// 記事の最新方法を表示する画面
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchArticles(); // 初期状態で記事を取得
  }

  // Qiita APIを使用して記事を取得するメソッド
  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    final uri = Uri.https('qiita.com', '/api/v2/items', {
      'per_page': '10',
      'page': _currentPage.toString(),
    });

    final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

    final res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(res.body);
      setState(() {
        articles.addAll(body.map((json) => Article.fromJson(json)).toList());
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 次のページを読み込むメソッド
  void _loadMore() {
    setState(() {
      _currentPage += 1; // ページを1つ進める
    });
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _isLoading && articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length + 1,
              itemBuilder: (context, index) {
                if (index == articles.length) {
                  // 最後のアイテムで次のページをロード
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loadMore,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Load More'),
                      ),
                    ),
                  );
                } else {
                  return ArticleContainer(article: articles[index]);
                }
              },
            ),
      bottomNavigationBar: CommonNavigationBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/search');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
