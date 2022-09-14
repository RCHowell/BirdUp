import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class WindgramPage extends StatelessWidget {

  const WindgramPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
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
      backgroundColor: Colors.black,
    ),
    backgroundColor: Colors.black,
    body: Center(
      child: PhotoView(
        imageProvider: const NetworkImage('http://wxtofly.net/Tiger_windgram.png',),
      ),
    ),
  );
}