import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/widgets/article_container.dart';
import 'package:qiita_search/widgets/common_navigation_bar.dart';

/// アプリの初期ページを表示する画面
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> articles = [];

  // 現在選択されているナビゲーションタブのインデックスを保持する変数
  int _selectedIndex = 1; // 初期状態では Searchタブを選択する

  /// Qiita APIを使用して記事を検索するメソッド
  Future<List<Article>> searchQiita(String keyword) async {
    final uri = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '15',
    });

    final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

    final res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((json) => Article.fromJson(json)).toList();
    } else {
      return [];
    }
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
        title: const Text('Qiita Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
            child: TextField(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: const InputDecoration(
                hintText: '検索ワードを入力してください',
              ),
              onSubmitted: (String value) async {
                final results = await searchQiita(value);
                setState(() => articles = results);
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: articles
                  .map((article) => ArticleContainer(article: article))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
