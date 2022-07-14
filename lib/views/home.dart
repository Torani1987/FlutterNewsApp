import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/views/detail.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  List _posts = [];
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sacred News', style: TextStyle(color: Colors.black87)),
        ),
        body: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  color: Colors.grey[200],
                  height: 100,
                  width: 100,
                  child: _posts[index]['urlToImage'] != null
                      ? Image.network(
                          _posts[index]['urlToImage'],
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Center(),
                ),
                title: Text(
                  '${_posts[index]['title']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${_posts[index]['description']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => Detail(
                        url: _posts[index]['url'],
                        title: _posts[index]['title'],
                        content: _posts[index]['content'],
                        publishedAt: _posts[index]['publishedAt'],
                        author: _posts[index]['author'],
                        urlToImage: _posts[index]['urlToImage'],
                      ),
                    ),
                  );
                },
              );
            }));
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=id&apiKey=b9ef3df1048645ceab10cb5e8494634e'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _posts = data['articles'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
