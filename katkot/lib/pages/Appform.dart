import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Appform extends StatefulWidget {
  final String infoText;

  const Appform({Key? key, required this.infoText}) : super(key: key);

  @override
  _AppformState createState() => _AppformState();
}

class _AppformState extends State<Appform> {
//-------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤😊عن التطبيق يا كتكوت'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'هو تطبيق متعدد الاستخدامات يهدف إلى تحسين جودة حياتك اليومية وإدارة وقتك بشكل أفضل \n يتميز التطبيق بالعديد من الميزات الرائعة، بما في ذلك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Arial',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  ' شات بوت للحصول على المساعدة في أي وقت\n'
                  ' مكان لتدوين الملاحظات والمهام اليومية ومتابعتها بسهولة\n'
                  ' عجلة الحظ التي توفر رسائل جميلة وملهمة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Arial',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              launch('https://www.facebook.com/bot.KatKot/');
            },
            child: Text('صفحتنا على الفيس بوك'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              launch('mailto:mahm015584@gmail.com');
            },
            child: Text('تواصل مع المطور'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
