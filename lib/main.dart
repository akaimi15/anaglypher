import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:io'; // 追加
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Anaglypher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _image;

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  Future pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (e) {
      _pickImageError = e;
    }
  }

  Widget _previewImage() {
    if (_image != null) {
      if (kIsWeb) {
        // Webの場合はバイトデータで表示
        return FutureBuilder<Uint8List>(
          future: _image!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Image.memory(snapshot.data!);
            } else if (snapshot.hasError) {
              return const Text('画像の読み込みに失敗しました');
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      } else {
        // モバイル/デスクトップの場合はファイルで表示
        return Image.file(File(_image!.path));
      }
    } else if (_pickImageError != null) {
      return Text('Pick image error!: $_pickImageError');
    } else {
      return Text('upload', style: TextStyle(fontSize: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.cyan, Colors.pink])),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("PickImage");
                pickImage();
              },
              child: Container(
                height: screenSize.height * 0.5,
                width: screenSize.width * 0.25,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Center(child: _previewImage()),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.5,
              width: screenSize.width * 0.125,
            ),
            Container(
              height: screenSize.height * 0.5,
              width: screenSize.width * 0.25,
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: const Center(
                child: Text(
                  'generated',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
