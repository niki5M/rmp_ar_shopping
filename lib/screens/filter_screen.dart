import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:testik2/helper/filters.dart';
import '../model/filter.dart';
import '../providers/image_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentFilter;
  late List<Filter> filters;
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Uint8List? bytes = await screenshotController.capture();
                imageProvider.changeImage(bytes!);
                if (!mounted) {
                  return;
                }

                Navigator.of(context).pushReplacementNamed('/edit');
                print('Экран закрыт успешно.');
            },
            icon: Icon(Icons.check, size: 30, color: Colors.white),
          )
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, AppImageProvider value, Widget? child) {
            if (value.currentImage != null) {
              return Screenshot(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(currentFilter.matrix),
                    child: Image.memory(value.currentImage!),
                  ),
                  controller: screenshotController);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 150,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, AppImageProvider value, Widget? child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (BuildContext context, int index) {
                  Filter filter = filters[index];
                  bool isSelected = filter == currentFilter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentFilter = filter;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.blueAccent, width: 3)
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filter.matrix),
                              child: value.currentImage != null
                                  ? Image.memory(value.currentImage!, fit: BoxFit.cover)
                                  : Container(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'aaa',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.blueAccent : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
