import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/widgets/article_container.dart';

/**
 * アプリの初期ページとなるクラス
 */
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/**
 * SearchScreenの状態を管理するクラス
 */
class _SearchScreenState extends State<SearchScreen> {
  // 検索結果を格納する変数
  List<Article> articles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // アプリバー(ヘッダー部分)
      appBar: AppBar(
        title: const Text('Qiita Search'),
      ),

      // メインコンテンツ
      body: Column(
        children: [
          // 検索ボックス
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: '検索ワードを入力してください',
              ),
              // 検索処理
              onSubmitted: (String value) async {
                final results = await searchQiita(value); // Qiita APIで検索
                setState(() => articles = results); // 結果取得
              },
            ),
          ),

          // 検索結果
          Expanded(
            child: ListView(
              children: articles
                  .map((article) => ArticleContainer(article: article))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Qiita APIを使用して記事を検索するメソッド
  Future<List<Article>> searchQiita(String keyword) async {
    // 1. http通信に必要なデータを準備をする
    //   - URL、クエリパラメータの設定
    final uri = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '15',
    });
    //   - アクセストークンの取得
    final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

    // 2. Qiita APIにリクエストを送る
    final http.Response res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    // 3. 戻り値をArticleクラスの配列に変換
    // 4. 変換したArticleクラスの配列を返す(returnする)
    if (res.statusCode == 200) {
      // レスポンスをモデルクラスへ変換
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((dynamic json) => Article.fromJson(json)).toList();
    } else {
      // ステータスコードが200でない場合は空のリストを返す
      return [];
    }
  }
}
