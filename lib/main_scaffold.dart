import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/main.dart';
import 'package:qr_label/scanner/scan_sorter.dart';
import 'package:qr_label/scanner/scanner_page.dart';

class MainScaffold extends StatefulWidget {
  final String? userID;
  final MainPage initalPage;
  final String title;
  final Widget? content;
  const MainScaffold({super.key, required this.content, required this.title, required this.userID, required this.initalPage});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late MainPage currentPage = widget.initalPage;
  late String displayedTitle = widget.title;
  late Widget displayedContent;
  @override
  void initState() {
    currentPage = widget.initalPage;
    displayedTitle = widget.title;
    if (widget.content == null) {
      _buildFragments();
    } else {
      displayedContent = widget.content!;
    }
    super.initState();
  }

  void _buildFragments() {  
    switch (currentPage) {
      case MainPage.Collection:
        return _setContent(Text("HI",),"Collection");
      case MainPage.Scanner:
        return _setContent(QRScannerLoader(userID: widget.userID!),"Scanner");
      case MainPage.Social:
        return _setContent(Container(),"Social");
    }
  }

  void _setContent(Widget content, String title) {
    setState(() {
      displayedContent = content;
      displayedTitle = title; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          displayedTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.home, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context): null;
              },
            ),
        ],
        backgroundColor: Colors.pink,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        items: _MainPageFactory.getNavigatorBarItems(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: MainPage.values.indexOf(currentPage),
        onTap: (index) {
          setState(() {
            if (MainPage.values[index] == currentPage) {
              return;
            }
            currentPage = MainPage.values[index];
            _buildFragments();
          });
        }
      ),
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,  
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87,Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
          _LightPatchCollection(),
          displayedContent,
        ],
      ),
    );
  }
}

enum MainPage {
  Collection,
  Scanner,
  Social
}

class _MainPageFactory {

  static const Color iconColor = Colors.white;
  static BottomNavigationBarItem getNavigatorBarWidget(MainPage page) {
    switch (page) {
      case MainPage.Collection:
        return const BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code,
            color: iconColor,
          ), 
          label: "Collection", 
        );
      case MainPage.Scanner:
        return const BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code_scanner,
            color: iconColor,
          ), 
          label: 'Scanner', 
        );
      case MainPage.Social:
        return const BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: iconColor
          ), 
          label: 'Social',
        );
    }
  }
  static List<BottomNavigationBarItem> getNavigatorBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (MainPage page in MainPage.values) {
      items.add(getNavigatorBarWidget(page));
    }
    return items;
  }
}

class _LightPatch extends StatelessWidget {
  final Size size;
  const _LightPatch({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.5, // Adjust the radius as needed
          colors: [
            Colors.green.shade200.withOpacity(0.2), // Inner color (fully opaque)
            Colors.green.shade200.withOpacity(0.0), // Outer color (fully transparent)
          ],
        ),
      ),
    );
  }
}

class _LightPatchCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int seperation = 250;
    Size screenSize = MediaQuery.of(context).size;
    int rows = (screenSize.width/seperation).floor()+1;
    int columns = (screenSize.height/seperation).floor()+1;
    double rowOffset = (screenSize.width-rows*seperation);
    double colOffset = (screenSize.height-columns*seperation);
    return Stack(
      children: List.generate(
          rows*columns,
          (index) => Positioned(
            top: (index/rows).floor() * seperation + colOffset+100+randomInRange(0, 100),
            left: (index % rows) * seperation + rowOffset+randomInRange(0, 100),
            child: const _LightPatch(size: Size(200,200)),
          ),
        ),
    );
  }
  int randomInRange(int min, int max) => min + Random().nextInt(max - min);
}