import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/social/friend_profile_dialog.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';
import 'package:qr_label/user/user_list.dart';

class FriendList<User> extends AUserList<User> {
  const FriendList({super.key, required super.list, required super.height, required super.user}); 

  @override
  State<StatefulWidget> createState() => _FriendListState();
}

class _FriendListState<T> extends AUserListState<T> {
  @override
  onLongPress(User element, BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return ConfirmationDialog<User>(displayText: "Are you sure you want remove ${element.getFullName()} as a friend?", onConfirmCallback: _onDeleteConfirmed, element: element);
      }
    );
  }

  Future<void> _onDeleteConfirmed(User deletedUser, BuildContext context) async {
    User? user = widget.user as User?;
    user!.friendIDs.remove(deletedUser.dbID);
    await UserDBManager().update(user);
    setState(() {
      widget.list!.remove(deletedUser);
    });
  }

  @override
  onPress(User element, BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return FriendProfileDialog(user: widget.user as User, friend: element);
      }
    );
  }
  
}