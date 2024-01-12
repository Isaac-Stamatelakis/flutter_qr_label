import 'package:flutter/material.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/global/pagination.dart';
import 'package:qr_label/qrcode/dataqrcode_list.dart';
import 'package:qr_label/qrcode/db_qrcode.dart';
import 'package:qr_label/qrcode/qrcode.dart';
import 'package:qr_label/scanner/dialog/on_scan_dialog.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

class FriendCollectionPageLoader extends SizedWidgetLoader {
  final String? userID;

  const FriendCollectionPageLoader({super.key, required this.userID}) : super(size: const Size(200,200));
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _CollectionPage(user: snapshot.data);
  }

  @override
  Future getFuture() async {
    return await UserRetriever(id: userID!).fromDatabase();
  }

}

class _CollectionPage extends APagination<User> {
  const _CollectionPage({required super.user}) : super(emptyText: "Tell your friend to stop being lazy and start scanning!", textFieldLabel: "Search Categories");
  @override
  State<StatefulWidget> createState() => _CollectionPageState();
  

}

class _CollectionPageState extends APaginationState<DataQRCode> {
  @override
  LimitSearchDatabaseQuery getQuery() {
    return FriendQRCodeQueryLimitSearch(userID: widget.user.dbID!, search: search, amount: widget.displayedAmount);
  }
  
  @override
  Widget getList() {
    return _FriendCollectionQRList(user: widget.user, list: displayed);
  }
}

class _FriendCollectionQRList extends AbstractDataQRCodeList<User> {
  const _FriendCollectionQRList({required super.user, required super.list});

  @override
  State<StatefulWidget> createState() => _FriendCollectionQRListState();

}

class _FriendCollectionQRListState extends AbstractDataQRCodeListState<User> {
  @override
  onLongPress(DataQRCode element, BuildContext context) {
    // Do nothing
  }

  @override
  onPress(DataQRCode element, BuildContext context) async {
    if (element.publicEditable) {
      FriendEditQRPage page = FriendEditQRPage(code: element);
      await showDialog(
        context: context, 
        builder: (BuildContext context) {
          return OnScanDialog(pages: [page]);
        }
      );
      await page.actionOnClose();
      setState(() {
        
      });
    } else {
      FriendViewQRPage page = FriendViewQRPage(code: element);
      await showDialog(
        context: context, 
        builder: (BuildContext context) {
          return OnScanDialog(pages: [page]);
        }
      );
    }
    
  }
}