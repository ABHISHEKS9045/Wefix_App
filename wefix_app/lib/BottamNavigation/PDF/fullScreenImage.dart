import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final url;
  FullScreenImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.network(
              url,
              fit: BoxFit.fill,
            ),),
        InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(margin: const EdgeInsets.only(top: 15, right: 15), alignment: Alignment.topRight, child: const Icon(Icons.cancel_outlined, color: Colors.white, size: 30),),),
      ],
    ));
  }
}
