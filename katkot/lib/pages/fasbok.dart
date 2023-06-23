import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class fasbok extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحات كتكوت'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () async {
                const url = 'https://www.facebook.com/bot.KatKot/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "فيس بوك",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            //-------------------------------------
          ],
        ),
      ),
    );
  }
}
