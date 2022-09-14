import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _olney = Uri.parse("http://wxtofly.net/i.htm");

class WindgramPage extends StatelessWidget {
  late final List<_Gram> grams;

  WindgramPage({Key? key}) : super(key: key) {
    // Force daily cache by adding a dummy key to the url
    var now = DateTime.now();
    var day = "${now.year}-${now.month}-${now.day}";
    grams = [
      _Gram(
        label: 'I',
        url: 'http://wxtofly.net/Tiger_windgram.png?day=$day',
      ),
      _Gram(
        label: 'II',
        url: 'http://wxtofly.net/TigerHikeLookout_windgram.png?day=$day',
      ),
      _Gram(
        label: 'LZ',
        url: 'http://wxtofly.net/TigerLZ_windgram.png?day=$day',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        initialIndex: 0,
        length: grams.length,
        child: Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onTap: () async {
                  await launchUrl(_olney);
                },
                child: Column(
                  children: const [
                    Text(
                      'Windgram',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "wxtofly.net",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.black,
              bottom: TabBar(
                indicatorColor: Colors.red,
                tabs: grams
                    .map(
                      (g) => Tab(
                        text: g.label,
                      ),
                    )
                    .toList(),
              ),
            ),
            backgroundColor: Colors.black,
            body: TabBarView(
              children: grams
                  .map(
                    (g) => Center(
                      child: PhotoView(
                        imageProvider: NetworkImage(g.url),
                      ),
                    ),
                  )
                  .toList(),
            )),
      );
}

class _Gram {
  final String label;
  final String url;

  _Gram({
    required this.label,
    required this.url,
  });
}
