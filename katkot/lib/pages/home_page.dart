import 'package:url_launcher/url_launcher.dart';

import '../utils/exports.dart';
import 'Appform.dart';
import 'NotePage.dart';
import 'TaskPage.dart';
import 'WheelOfFortunePage.dart';
import 'charity.dart';
import 'fasbok.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController =
      TextEditingController(); //for TextField
  final ScrollController _scrollController =
      ScrollController(); //for ListView.builder
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String greeting = (now.hour < 12) ? 'صباح الخير' : 'مساء الخير';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$greeting يا كتكوت\n و المقصود بالخير هنا و جودك ',
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'images/katkot.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
                color: Colors.white,
                colorBlendMode: BlendMode.dstIn,
              ),
              const SizedBox(height: 16),
              const Text(
                '❤❤🥺 عساك بخير يا كتكوت ',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  child: const Text('شكرا يا كتكوت'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
  }

  //Sends prompt request to ChatGPT
  void sendPrompt() {
    if (_textEditingController.text.isNotEmpty) {
      //calling mainApi with prompt text and scroll controller
      context.read<MessageProvider>().sendPrompt(
          _textEditingController.text.trim(), _scrollController, context);
      _textEditingController.clear(); //clear text field
    }
    FocusScope.of(context).unfocus(); //dismiss keyboard on submission
  }

  //method to access toggle recording
  void recordSpeech() => context
      .read<SpeechProvider>()
      .toggleRecording(_scrollController, context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context), //this appBar is in widgets folder
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Image.asset(
                'images/kat.png',
                width: 100,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text(
                '❤😘فضفض هنا يا كتكوت',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                '❤😜اعمل المهام يا كتكوت',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                '❤😍شوف رسالتك يا كتكوت',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WheelOfFortunePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                '❤🥺اكسب صدقه يا كتكوت',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharityPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                '❤😁صفحتنا يا كتكوت ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => fasbok()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                '❤😊عن التطبيق يا كتكوت',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Appform(infoText: 'KatKot - كتكوت'),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'سياسة الخصوصية',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                const url =
                    'https://sites.google.com/view/katkot/privacy-policy';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          //Chat Container
          Expanded(child: Consumer<MessageProvider>(
            builder: (context, provider, child) {
              //messages is empty then it shows only the Logo
              if (provider.messages.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: Theme.of(context).primaryColor == primaryColor
                      ? Image.asset(lightLogo, scale: 25, width: 200)
                      : Image.asset(darkLogo, scale: 25, width: 200),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final data = provider.messages[index];
                    //message tile for user and assistant with animations
                    if (data.role == "user") {
                      //user
                      return Align(
                        alignment: Alignment
                            .topRight, //aligns user message tile to right
                        child: SlideInRight(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: senderBorder,
                            ),
                            child: Text(
                              data.content,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ), //user prompt message
                          ),
                        ),
                      );
                    } else {
                      //assistant
                      return Align(
                        alignment: Alignment
                            .topLeft, //aligns assistant message tile to left
                        child: SlideInLeft(
                          duration: const Duration(milliseconds: 300),
                          child: GestureDetector(
                            onLongPress: () => copyText(data.content,
                                context), //copy message to clip board on long press
                            child: Container(
                              height: data.isImage
                                  ? 250
                                  : null, //if data.isImage then it the height and width is fixed to 250
                              width: data.isImage
                                  ? 250
                                  : null, //if not then the both are null, so it resizes according to its child
                              padding: data.isImage
                                  ? const EdgeInsets.all(0)
                                  : const EdgeInsets.all(15),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: receiverBorder,
                              ),

                              //if data.isImage is true then it shows cachedNetworkImage to show image. if false then shows text message
                              child: data.isImage
                                  ? GestureDetector(
                                      onTap: () =>
                                          viewImage(context, data.content),
                                      child: CachedNetworkImage(
                                        imageUrl: data.content,
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 250,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child:
                                                    CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          color: Colors.white,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ))
                                  : data.content == "...."
                                      ? //if the data.content is "...." then it shows animated text until the actual message is updated
                                      //wavy animation
                                      AnimatedTextKit(
                                          totalRepeatCount: 5,
                                          animatedTexts: [
                                            WavyAnimatedText(data.content,
                                                textStyle: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyMedium,
                                                speed: const Duration(
                                                    milliseconds: 300)),
                                          ],
                                          isRepeatingAnimation: true,
                                        )
                                      :
                                      //main message
                                      SelectableText(
                                          data.content,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyMedium,
                                        ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          )),

          //Text Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                        hintText: '❤🥺اكتب رسالتك يا قلب كتكوت',
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                    onPressed: () => recordSpeech(),
                    icon: const Icon(Icons.mic)),
                IconButton(
                    onPressed: () => sendPrompt(),
                    icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
