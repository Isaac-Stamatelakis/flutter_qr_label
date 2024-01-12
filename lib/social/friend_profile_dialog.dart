import 'package:flutter/material.dart';
import 'package:qr_label/collection/collection_page.dart';
import 'package:qr_label/collection/friend_collection_page.dart';
import 'package:qr_label/global/global_helper.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/main_scaffold.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';
import 'package:qr_label/user/user.dart';


class FriendProfileDialog extends StatefulWidget {
  final User friend;
  final User user;
  const FriendProfileDialog({super.key, required this.user, required this.friend});
  @override
  State<StatefulWidget> createState() => _FriendProfileDialogState();
}

class _FriendProfileDialogState extends State<FriendProfileDialog> {
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
                "Friend Profile",
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
              controller: TextEditingController(text: widget.friend.getFullName()),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white
              ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SquareGradientButton(
                onPress: _viewCollection, 
                text: "View Collection", 
                colors: const [Colors.purple, Colors.indigo], 
                height: 80
              )
            )
            
          ],
        )
      ),
    );
  }

  void _viewCollection(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => 
        MainScaffold(
          content: FriendCollectionPageLoader(userID: widget.friend.dbID), 
          title: "${widget.friend.firstName}'s Collection" , 
          userID: widget.user.dbID, 
          initalPage: MainPage.Collection
        )
      )
    );
  }
}