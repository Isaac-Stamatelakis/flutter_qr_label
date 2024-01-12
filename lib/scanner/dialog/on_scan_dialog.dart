import 'package:flutter/material.dart';
import 'package:qr_label/global/global_helper.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';


class OnScanDialog extends StatefulWidget {
  final List<IScanPage> pages;
  const OnScanDialog({super.key, required this.pages});
  @override
  State<StatefulWidget> createState() => _OnScanDialogState();
}

class _OnScanDialogState extends State<OnScanDialog> {
  final PageController _pageController = PageController();
  late int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content:Container(
        height: MediaQuery.of(context).size.height*3/4,
        width: GlobalHelper.getPreferredWidth(context),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Column(
          children: [
            AppBar(
              backgroundColor: Colors.pink,
              title: const Text(
                "Scan Results",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back, 
                  color: Colors.white
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            Flexible(child: PageView.builder(
              onPageChanged: (BuildContext) {
                setState(() {
                  _currentPage = _pageController.page!.round();
                });
              },
              controller: _pageController,
              itemCount: widget.pages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: widget.pages[index]
                );
                },
              ),
            ),

          ],
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: _buildDotIndictators(),
          )
        
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndictators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.pink : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}