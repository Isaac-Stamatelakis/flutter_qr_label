import 'package:flutter/material.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/qrcode/db_qrcode.dart';
import 'package:qr_label/qrcode/qrcode.dart';
import 'package:qr_label/scanner/dialog/keyvalue.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

/// A page displayed on qrscan dialog
abstract class IScanPage<T extends QRCode> extends StatefulWidget{
  final T? code;
  const IScanPage({super.key, required this.code});

}
/// A Page which is mutable, has actions when closed
abstract class MutablePage {
  Future<void> actionOnClose();
}

/// Page which allows user to view and edit their existing qrcodes
class OwnedScanPage<T extends DataQRCode> extends IScanPage implements MutablePage{
  const OwnedScanPage({super.key, required super.code});

  @override
  Future<void> actionOnClose() async {
    (code as DataQRCode).lastAccessed = DateTime.now();
    await QRCodeDBManager<DataQRCode>().update(code as DataQRCode);
  }
  
  @override
  State<StatefulWidget> createState() => _OwnedScanPageState();

}

class _OwnedScanPageState extends State<OwnedScanPage> {
  late bool editMode = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              editMode ?  _EditPublicButtons(code: widget.code as DataQRCode) : Container(),
              const SizedBox(height: 20),
              buildList()
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: FloatingActionButton(
            heroTag: 'editButton',
            backgroundColor: Colors.blue,
            onPressed: (){
              setState(() {
                editMode = !editMode;
              });
            },
            child:  const Icon(
              Icons.edit,
              color: Colors.white
            )
          )
        ),
        buildAddButton()
      ],
    );
  }
  Widget buildList() {
    return editMode ? KeyValueEditList(data: (widget.code as DataQRCode).data) : KeyValueViewList(data: (widget.code as DataQRCode).data);
  }
  Widget buildAddButton() {
    return editMode ?
     Positioned(
          bottom: 80,
          left: 0,
          child: FloatingActionButton(
            heroTag: 'addButton',
            backgroundColor: Colors.blue,
            onPressed: (){
              setState(() {
                (widget.code as DataQRCode?)!.data.add(KeyValuePair(key: "", value: ""));
              });
            },
            child:  const Icon(
              Icons.add,
              color: Colors.white
            )
          )
      ) 
    : Container();
  }

}

/// Page for a new QRCode
class NewQRCodePage<T extends DataQRCode> extends IScanPage implements MutablePage{
  NewQRCodePage({super.key, required super.code});
  final uploadSingleList = [true]; // weird bypass for not putting late objects
  @override
  Future<void> actionOnClose() async {
    if (uploadSingleList[0]) {
      DataQRCode dataQRCode = code as DataQRCode;
      await QRCodeDBManager<DataQRCode>().upload(dataQRCode);
    }
  }
  
  @override
  State<StatefulWidget> createState() => _NewQRCodeDataPageState();
}

class _NewQRCodeDataPageState extends State<NewQRCodePage> {
  late double seperation = 80;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _EditPublicButtons(code: widget.code as DataQRCode),
                const SizedBox(height: 20),
                SquareGradientButton(
                  onPress: (BuildContext context) {
                    setState(() {
                      widget.uploadSingleList[0] = !widget.uploadSingleList[0];
                    });
                  },
                  text: "Upload",
                  colors: widget.uploadSingleList[0] ? [Colors.green,Colors.green.shade300] : [Colors.red,Colors.red.shade300],
                  height: 50
                ),
                const SizedBox(height: 20),
                KeyValueEditList(data: (widget.code as DataQRCode?)!.data),
              ],
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          child: FloatingActionButton(
            heroTag: 'addButton',
            backgroundColor: Colors.blue,
            onPressed: (){_onAddPress();},
            child:  const Icon(
              Icons.add,
              color: Colors.white
            )
          )
        ),
      ],
    );
  }
  void _onAddPress() {
    setState(() {
      (widget.code as DataQRCode?)!.data.add(KeyValuePair(key: "", value: ""));
    });
  }
}

class FriendEditQRPage<T extends DataQRCode> extends IScanPage implements MutablePage {
  const FriendEditQRPage({super.key, required super.code});

  @override
  Future<void> actionOnClose() async {
    await QRCodeDBManager<DataQRCode>().update(code as DataQRCode);
  }

  @override
  State<StatefulWidget> createState() => _FriendEditQRPageState();

}

class _FriendEditQRPageState extends State<FriendEditQRPage> {
  late bool editMode = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              editMode ?  _EditPublicButtons(code: widget.code as DataQRCode) : Container(),
              const SizedBox(height: 20),
              buildList()
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: FloatingActionButton(
            heroTag: 'editButton',
            backgroundColor: Colors.blue,
            onPressed: (){
              setState(() {
                editMode = !editMode;
              });
            },
            child:  const Icon(
              Icons.edit,
              color: Colors.white
            )
          )
        ),
      ],
    );
  }
  Widget buildList() {
    return editMode ? KeyValueEditList(data: (widget.code as DataQRCode).data) : KeyValueViewList(data: (widget.code as DataQRCode).data);
  }
}
/// Viewable but immutable to viewer
class FriendQRPage<T extends DataQRCode> extends IScanPage {
  const FriendQRPage({super.key, required super.code});
  @override
  State<StatefulWidget> createState() => _FriendQRPageState();
}

class _FriendQRPageState extends State<FriendQRPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              KeyValueViewList(data: (widget.code as DataQRCode).data)
            ],
          )
        )
      ],
    );
  }
}
class FriendScanPage<T extends FriendQRCode> extends IScanPage implements MutablePage {
  FriendScanPage({super.key, required super.code});
  final addFriendSingleList = [false]; // weird bypass for not putting late objects

  @override
  Future<void> actionOnClose() async {
    
  }
  
  @override
  State<StatefulWidget> createState() => _FriendScanPageState();
}

class _FriendScanPageState extends State<FriendScanPage> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _UserNameLoader(dbID: widget.code!.ownerID!),
            SquareGradientButton(
              onPress: (BuildContext context) {
                setState(() {
                  widget.addFriendSingleList[0] = !widget.addFriendSingleList[0];
                });
              },
              text: "Add as Friend", 
              colors: !widget.addFriendSingleList[0] ? [Colors.green,Colors.green.shade300] : [Colors.red,Colors.red.shade300],
              height: 50
            )
          ],
        ),
      ),
    );
  }
}

class _UserNameLoader extends WidgetLoader {
  final String dbID;
  _UserNameLoader({required this.dbID});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    User? user = snapshot.data;
    return Text(
      user!.getFullName(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white
      ),
    );
  }

  @override
  Future getFuture() {
    return UserRetriever(id: dbID).fromDatabase();
  }

}
class OwnFriendCodeQRPage<T extends FriendQRCode> extends IScanPage {
  const OwnFriendCodeQRPage({super.key, required super.code});
  
  
  @override
  State<StatefulWidget> createState() => _OwnFriendCodeQRPageState();

}

class _OwnFriendCodeQRPageState extends State<OwnFriendCodeQRPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You cannot be your own friend :(",
        style: TextStyle(
          color: Colors.white
        ),
      ),
    );
  }
}
 
class _EditPublicButtons extends StatefulWidget {
  final DataQRCode code;

  const _EditPublicButtons({required this.code});
  
  @override
  State<StatefulWidget> createState() => _EditPublicButtonsState();
}

class _EditPublicButtonsState extends State<_EditPublicButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SquareGradientButton(
            onPress: (BuildContext) {
              setState(() {
                widget.code.public = !widget.code.public;
                if (!widget.code.public) {
                  widget.code.publicEditable = false;
                }
              });
            }, 
            text: "Public",
            colors: widget.code.public ? [Colors.green,Colors.green.shade300] : [Colors.red,Colors.red.shade300],
            height: 80
          )
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SquareGradientButton(
            onPress: (BuildContext) {
              setState(() {
                widget.code.publicEditable = !widget.code.publicEditable;
                if (!widget.code.publicEditable) {
                  widget.code.public = false;
                }
              });
            }, 
            text: "Friends Can Edit",
            colors: widget.code.publicEditable ? [Colors.green,Colors.green.shade300] : [Colors.red,Colors.red.shade300],
            height: 80
          )
        ),
      ],
    );
  }

}