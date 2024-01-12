import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/global/pagination.dart';
import 'package:qr_label/qrcode/dataqrcode_list.dart';
import 'package:qr_label/qrcode/db_qrcode.dart';
import 'package:qr_label/qrcode/qrcode.dart';
import 'package:qr_label/scanner/dialog/on_scan_dialog.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

class CollectionPageLoader extends SizedWidgetLoader {
  final String? userID;

  const CollectionPageLoader({super.key, required this.userID}) : super(size: const Size(200,200));
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
  const _CollectionPage({required super.user}) : super(emptyText: "So empty... Better get to scanning!", textFieldLabel: "Search Categories");
  @override
  State<StatefulWidget> createState() => _CollectionPageState();
  

}

class _CollectionPageState extends APaginationState<DataQRCode> {
  

  @override
  LimitSearchDatabaseQuery getQuery() {
    return UserQRCodeQueryLimitSearch(userID: widget.user.dbID!, search: search, amount: widget.displayedAmount);
  }
  
  @override
  Widget getList() {
    return _CollectionQRList(user: widget.user, list: displayed);
  }
}

class _CollectionQRList extends AbstractDataQRCodeList<User> {
  const _CollectionQRList({required super.user, required super.list});

  @override
  State<StatefulWidget> createState() => _CollectionQRListState();

}

class _CollectionQRListState extends AbstractDataQRCodeListState<User> {
  @override
  onLongPress(DataQRCode element, BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return ConfirmationDialog<DataQRCode>(displayText: "Are you sure you want to delete this code?", onConfirmCallback: _onDeleteConfirmed, element: element);
      }
    );
  }

  Future<void> _onDeleteConfirmed(DataQRCode code, BuildContext context) async {
    await QRCodeDBManager<DataQRCode>().delete(code);
    setState(() {
      widget.list!.remove(code);
    });
  }

  @override
  onPress(DataQRCode element, BuildContext context) async {
    setState(() {
      widget.list!.remove(element);
      widget.list!.insert(0, element);
    });
    OwnedScanPage page = OwnedScanPage(code: element);
    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return OnScanDialog(pages: [page]);
      }
    );
    await page.actionOnClose();
    setState(() {
      
    });
  }
}