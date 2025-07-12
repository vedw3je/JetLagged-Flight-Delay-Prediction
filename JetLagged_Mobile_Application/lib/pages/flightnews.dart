// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FlightNews extends StatefulWidget {
  @override
  _FlightNewsState createState() => _FlightNewsState();
}

class _FlightNewsState extends State<FlightNews> {
  bool isLoading = true;
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  // Fetch news from News API
  Future<void> fetchNews() async {
    const apiUrl =
        'https://newsapi.org/v2/everything?sortBy=popularity&apiKey=e9b1feb51fee40aca752c091354c056d&q="airline"or"airport"';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          articles = (data['articles'] as List)
              .map((article) => Article.fromJson(article))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 241, 255),
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Flight News',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: const Color.fromARGB(255, 0, 33, 60),
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: article.urlToImage != null
                          ? SizedBox(
                              width: 80,
                              child: Image.network(article.urlToImage!,
                                  width: 80, fit: BoxFit.cover),
                            )
                          : null,
                      title: Text(article.title ?? 'No Title'),
                      subtitle: Text('By ${article.author ?? 'Unknown'}'),
                      onTap: () async {
                        await _launchURL(article.url!);
                      }),
                );
              },
            ),
    );
  }
}

class Article {
  final String? author;
  final String? title;
  final String? urlToImage;
  final String? url;

  Article({this.author, this.title, this.urlToImage, this.url});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'],
      title: json['title'],
      urlToImage: json['urlToImage'],
      url: json['url'],
    );
  }
}
