import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _olney = Uri.parse("http://wxtofly.net/i.htm");

class WindgramPage extends StatelessWidget {
  const WindgramPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Soarcast',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _FeedbackDialog(),
                  );
                },
              ),
            ],
            backgroundColor: Colors.black,
            bottom: const TabBar(indicatorColor: Colors.red, tabs: [
              Tab(
                text: "Windgrams",
              ),
              Tab(
                text: "Meteograms",
              ),
            ]),
          ),
          body: TabBarView(children: [
            _GramView(),
            _GramView(),
          ]),
          backgroundColor: Colors.black,
        ),
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

class _GramView extends StatelessWidget {
  late final List<_Gram> _grams;

  _GramView() {
    // Force hourly cache by adding an hourly identifier to the url
    var now = DateTime.now();
    var id = "${now.year}-${now.month}-${now.day}-${now.hour}";
    _grams = [
      _Gram(
        label: 'I',
        url: 'http://wxtofly.net/Tiger_windgram.png?id=$id',
      ),
      _Gram(
        label: 'II',
        url: 'http://wxtofly.net/TigerHikeLookout_windgram.png?id=$id',
      ),
      _Gram(
        label: 'LZ',
        url: 'http://wxtofly.net/TigerLZ_windgram.png?id=$id',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => ListView(
      children: _grams
          .map(
            (g) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _HeroPhotoViewRouteWrapper(
                      title: 'Windgram',
                      subtitle: 'wxtofly.net',
                      imageProvider: NetworkImage(g.url),
                      url: "http://wxtofly.net/i.htm",
                      tag: g.label,
                    ),
                  ),
                );
              },
              child: Container(
                // padding: const EdgeInsets.all(12.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Hero(tag: g.label, child: Image.network(g.url)),
                ),
              ),
            ),
          )
          .toList());
}

class _HeroPhotoViewRouteWrapper extends StatelessWidget {

  final String title;
  final String subtitle;
  late final Uri _uri;
  final ImageProvider imageProvider;
  final String tag;

  _HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    required this.title,
    required this.subtitle,
    required this.tag,
    required String url,
  }) {
    _uri = Uri.parse(url);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: GestureDetector(
            onTap: () async {
              await launchUrl(_olney);
            },
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoView(
            imageProvider: imageProvider,
            heroAttributes: PhotoViewHeroAttributes(tag: tag),
          ),
        ),
      );
}

class _FeedbackDialog extends StatelessWidget {

  final Uri _contact = Uri.parse(Mailto(
    to: ['contact@birdup.cloud'],
    subject: 'Forecast Contact',
  ).toString());

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text("Feedback"),
    content: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: "Have a forecast you want included?\n"),
          TextSpan(
            text: "contact@birdup.cloud",
            style: const TextStyle(
              color: Colors.redAccent,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await launchUrl(_contact);
              },
          ),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          primary: Colors.blueGrey,
        ),
        child: const Text('OK'),
      ),
    ],
  );
}
