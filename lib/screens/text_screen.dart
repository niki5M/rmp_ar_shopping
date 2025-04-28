import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';

import '../providers/image_provider.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {

  late AppImageProvider imageProvider;
  LindiController controller = LindiController(icons: []);
  bool showEditor = false;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/edit');
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                Uint8List? bytes = await controller.saveAsUint8List();
                imageProvider.changeImage(bytes!);
                if (!mounted) {
                  return;
                }
                Navigator.of(context).pushReplacementNamed('/edit');
              },
              icon: Icon(Icons.check, size: 30, color: Colors.white),
            )
          ],
        ),
        body: GestureDetector(
          onDoubleTap: (){
            setState(() {
              showEditor = true;
            });
          },
          child: Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, AppImageProvider value, Widget? child) {
                if (value.currentImage != null) {
                  return LindiStickerWidget(
                    controller: controller,
                    child: Image.memory(value.currentImage!),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 100,
          color: Colors.black,
          child: TextButton(onPressed: (){
            setState(() {
              showEditor = true;
            });
          }, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 40,),
              Text("Add Text", style: TextStyle(color: Colors.white, fontSize: 25),)
            ],
          )),
        ),
      ),
        if(showEditor)
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.75),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextEditor(
                fonts: ['',''],
                textStyle: const TextStyle(
                  color: Colors.white
                ),
                minFontSize: 10,
                maxFontSize: 70,
                // textAlingment: textAlign,
                onEditCompleted: (style, align, text) {
                  setState(() {
                    showEditor = false;
                    if(text.isNotEmpty){
                      controller.add(
                          Text(
                            text,
                            textAlign: align,
                            style: style,
                          )
                      );
                    }
                  });


                  // setState(() {
                  //   _text = text;
                  //   _textStyle = style;
                  //   _textAlign = align;
                  // });
                },
              ),
            ),
          ),
        )
    ]
    );
  }
}
