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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content:Container(
        height: MediaQuery.of(context).size.height*1/2,
        width: GlobalHelper.getPreferredWidth(context),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child:  Column(
          children: [
            AppBar(
              backgroundColor: Colors.pink,
              title: const Text(
                "HI",
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
            )
          ],
        )
      ),
    );
  }
}