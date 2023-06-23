import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_chaiy.dart';

class CharityPage extends StatefulWidget {
  const CharityPage({Key? key}) : super(key: key);

  @override
  _CharityPageState createState() => _CharityPageState();
}

class _CharityPageState extends State<CharityPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('_advertis');
  List<DataChaiy> data = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    if (!loaded) {
      await FirebaseFirestore.instance
          .collection('_advertis')
          .get()
          .then((value) {
        for (var element in value.docs) {
          data.add(DataChaiy.fromJson(element.data()));
          debugPrint("length of dat list ${data.length}");
          debugPrint("data${data[0].message.toString()}");
        }
      }).catchError((error) {
        debugPrint("error >>> ${error.toString()}");
      });
      loaded = true;
    }
  }

  void _shareAdvertisement(String advertisementTitle) {
    final _advertis = data.firstWhere((ad) => ad.title == advertisementTitle);
    final text = '${_advertis.message} - Phone: ${_advertis.phone}';
    final subject = _advertis.title;
    Share.share(text, subject: subject);
  }

  void _contactCompany(String companyPhone) async {
    final url = 'tel:$companyPhone';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to launch dialer'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اكسب صدقه مع صناع الحياة'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('خطأ في الاتصال بقاعدة البيانات');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          data = snapshot.data!.docs
              .map((document) =>
                  DataChaiy.fromJson(document.data() as Map<String, dynamic>?))
              .toList();

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final _advertis = data[index];
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          _advertis.title,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        _advertis.message,
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () =>
                                _shareAdvertisement(_advertis.title),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              final text =
                                  '${_advertis.title} \n ${_advertis.message} \n رقم الواتس اب للتواصل ${_advertis.phone}';
                              Clipboard.setData(ClipboardData(text: text));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('تم النسخ'),
                              ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () => _contactCompany(_advertis.phone),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
