import 'package:flutter/material.dart';
import 'package:qr_label/global/global_helper.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';
import 'package:qr_label/user/user.dart';


class EditProfileDialog extends StatefulWidget {
  final User user;
  final bool editable = true;
  const EditProfileDialog({super.key, required this.user});
  @override
  State<StatefulWidget> createState() => _EditProfileDialogState();

  static launch() {
    
  }
}

class _EditProfileDialogState extends State<EditProfileDialog> {
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
                "Edit Profile",
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
            const SizedBox(height: 20),
            Flexible(
              child: TextField(
              controller: TextEditingController(text: widget.user.firstName),
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                widget.user.firstName = text;
              },
              style: const TextStyle(
                color: Colors.white
              ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: TextField(
              controller: TextEditingController(text: widget.user.lastName),
              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                widget.user.lastName = text;
              },
              style: const TextStyle(
                color: Colors.white
              ),
              ),
            ),
          ],
        )
      ),
    );
  }
}