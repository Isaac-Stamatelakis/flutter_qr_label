import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/global/pagination.dart';
import 'package:qr_label/social/friend_list.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

class FriendPagination extends APagination<User> {
  const FriendPagination({super.key, required super.user}) : super(
    textFieldLabel: "Search Friends", 
    emptyText: "No friends to show :(\n Scan someones friend code and have them scan your friend code to add them as a friend!"
  );

  @override
  State<StatefulWidget> createState() => _FriendPaginationState();

}

class _FriendPaginationState extends APaginationState<User> {
  @override
  Widget getList() {
    return FriendList(list: displayed, height: 60, user: widget.user);
  }

  @override
  LimitSearchDatabaseQuery getQuery() {
    return UserFriendSearchQuery(user: widget.user, amount: widget.displayedAmount, search: search);
  }

}