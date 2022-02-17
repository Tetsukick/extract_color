import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  List<Color> colors = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (image != null)  Image.file(File(image!.path), height: 300,),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                    Color color = colors[index];
                    return Container(
                      color: color,
                      height: 30,
                      width: 30,
                      // padding: EdgeInsets.all(8.0),
                      // child: Text('${color.value}'),
                    );
                  },
                  itemCount: colors.length,
                ),
              ),
              Expanded(child: Container())
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void getImage() async {
    final _image = await _picker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      setState(() {
        image = _image;
      });
      getColorCodeFromImage(_image);
    }
  }

  void getColorCodeFromImage(XFile image) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(FileImage(File(image.path)));
    paletteGenerator.colors.forEach((element) {
      print(element);
    });
    setState(() {
      colors = paletteGenerator.colors.toList();
    });
  }
}
