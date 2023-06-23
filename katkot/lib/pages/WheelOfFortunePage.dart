import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WheelOfFortunePage extends StatefulWidget {
  @override
  _WheelOfFortunePageState createState() => _WheelOfFortunePageState();
}

class _WheelOfFortunePageState extends State<WheelOfFortunePage> {
  late Timer _timer;
  var _angle = 0.0;
  var _prize = '';
  var _pressed = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('_prizes');
  List<String> prizes = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loadedFromPrefs = prefs.getBool('loaded_from_firestore');
    DateTime? lastFetchTime = prefs.getString('last_fetch_time') != null
        ? DateTime.parse(prefs.getString('last_fetch_time')!)
        : null;

    if (loadedFromPrefs != null && loadedFromPrefs && lastFetchTime != null) {
      bool shouldFetchData =
          DateTime.now().difference(lastFetchTime).inHours >= 12;
      bool isMidnight = DateTime.now().hour == 0;
      if (shouldFetchData || isMidnight) {
        await fetchDataFromFirebase();
        prefs.setString('last_fetch_time', DateTime.now().toString());
      } else {
        setState(() {
          prizes = prefs.getStringList('prizes') ?? [];
          loaded = true;
        });
      }
    } else {
      await fetchDataFromFirebase();
      prefs.setBool('loaded_from_firestore', true);
      prefs.setString('last_fetch_time', DateTime.now().toString());
    }
  }

  Future<void> fetchDataFromFirebase() async {
    await FirebaseFirestore.instance.collection('_prizes').get().then((value) {
      List<String> fetchedPrizes =
          value.docs.map((doc) => doc['message'].toString()).toList();
      List<String> uniquePrizes = [];
      Random random = Random();
      while (uniquePrizes.length < 5 &&
          uniquePrizes.length < fetchedPrizes.length) {
        int randomIndex = random.nextInt(fetchedPrizes.length);
        String prize = fetchedPrizes[randomIndex];
        if (!uniquePrizes.contains(prize)) {
          uniquePrizes.add(prize);
        }
      }
      setState(() {
        prizes = uniquePrizes;
        loaded = true;
      });
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('prizes', prizes);
      });
    }).catchError((error) {
      debugPrint("error >>> ${error.toString()}");
    });
  }

  List<DataModel> data = [];

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _rotateWheel() {
    if (!_pressed && loaded) {
      _pressed = true;
      _angle = 0;
      _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          _angle = _angle + 1.0 + Random().nextDouble() * 1.0;
        });
        if (_angle >= pi * 5) {
          _timer.cancel();
          _pressed = false;
          setState(() {
            if (prizes.isNotEmpty) {
              _prize = prizes[Random().nextInt(prizes.length)];
              prizes.remove(_prize);
            }
          });
          print('Selected prize: $_prize');
          showDialog(
            context: context,
            builder: (_) => WheelOfFortuneDialog(
              prize: _prize,
              color: Color.fromARGB(255, 249, 209, 222),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤😍شوف رسالتك يا كتكوت  '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  color: Color.fromARGB(183, 57, 214, 193),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'يا كتكوت'
                  '\n'
                  'ليك كل 12 ساعة 5 رسائل',
                  style: TextStyle(
                    color: Color.fromARGB(255, 247, 245, 245),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Transform.rotate(
              angle: _angle,
              child: Image.asset('images/wheel.png'),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: _rotateWheel,
              child: const Text(
                'جرب يا كتكوت',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 75, 112, 182),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WheelOfFortuneCard extends StatelessWidget {
  final String prize;
  final Color color;
  const WheelOfFortuneCard({required this.prize, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Text(
        prize,
        textAlign: TextAlign.end,
        style: const TextStyle(
          color: Color.fromARGB(255, 28, 25, 25),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class WheelOfFortuneDialog extends StatelessWidget {
  final String prize;
  final Color color;
  const WheelOfFortuneDialog({required this.prize, required this.color});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Center(
        child: const Text(
          'يا كتكوت',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: WheelOfFortuneCard(prize: prize, color: color),
      actions: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '❤🥺شكراً يا كتكوت',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
