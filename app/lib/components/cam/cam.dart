import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:birdup/routes.dart';

class Cam extends StatelessWidget {

  const Cam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 2.0,
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://drw.selfip.com/latest.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              onTap: () {
                context.router.push(const CamRoute());
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: const Text(
                  "LIVE",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
