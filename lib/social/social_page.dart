import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_label/global/global_helper.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/social/edit_profile_dialog.dart';
import 'package:qr_label/social/pagination_social.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

class SocialPageLoader extends SizedWidgetLoader {
  final String userID;
  const SocialPageLoader({super.key, required this.userID}) : super(size: const Size(200,200));

  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _SocialPage(user: snapshot.data);
  }

  @override
  Future getFuture() {
    return UserRetriever(id: userID).fromDatabase();
  }

}

class _SocialPage extends StatefulWidget {
  final User user;

  const _SocialPage({required this.user});
  @override
  State<StatefulWidget> createState() => _SocialPageState();

}

class _SocialPageState extends State<_SocialPage> {
  final List<Color> rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child:Column( 
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: GlobalHelper.getPreferredWidth(context),
              child: 
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            colors: rainbowColors
                          )
                        ),
                        child: const Text(
                          "Your Friend Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      QrImageView(
                        backgroundColor: Colors.white,
                        data : widget.user.dbID!,
                        version: QrVersions.auto,
                        size: 150,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                    children: [
                     SquareGradientButton(
                        onPress: _showEditDialog,
                        text: "Edit Profile", 
                        colors: [Colors.purple,Colors.indigo], 
                        height: 215
                        ),
                    ],
                    )
                  )
                  
                ],
              ),
            ),
            Flexible(child: FriendPagination(user: widget.user))
            ],
          )
        )
      ],
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return EditProfileDialog(user: widget.user);
      }
    );
    await UserDBManager().update(widget.user);
  }
}

