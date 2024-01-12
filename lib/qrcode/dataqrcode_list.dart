import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_label/global/global_list.dart';
import 'package:qr_label/qrcode/qrcode.dart';
import 'package:qr_label/scanner/dialog/keyvalue.dart';

abstract class AbstractDataQRCodeList<T> extends AbstractList<T,DataQRCode> {
  const AbstractDataQRCodeList({super.key, required super.user, required super.list}) : super(height: 60);

}

abstract class AbstractDataQRCodeListState<T> extends AbstractListState<T,DataQRCode> {
  late double size = 40;
  @override
  Widget getListTitleText(DataQRCode element) {
    List<Color> colors = QRCodeFactory.hashToColor(element.hash!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(colors[0], BlendMode.srcIn),
          child: Image.asset(
            'assets/qrcode_img/frame.png',
            height: size,
            width: size
          ),
        ),
        ColorFiltered(
          colorFilter: ColorFilter.mode(colors[1], BlendMode.srcIn),
          child: Image.asset(
            'assets/qrcode_img/square.png',
            height: size,
            width: size
          ),
        ),
        ColorFiltered(
          colorFilter: ColorFilter.mode(colors[2], BlendMode.srcIn),
          child: Image.asset(
            'assets/qrcode_img/rest.png',
            height: size,
            width: size
          ),
        ),
      ],
    ),
    const SizedBox(width: 20),
    Text(
      getTextString(element.data),
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Colors.white
        ),
      ) 
  ],
);
    
    /*
    return Text(
      element.hash!,
      style: const TextStyle(color: Colors.white),
    );
    */
  }
  

  String getTextString(List<KeyValuePair> data) {
    String str = "";
    for (int i = 0; i < data.length; i ++) {
      str += data[i].key!;
      if (i != data.length-1) {
        str += ", ";
      }
    }
    return str;
    
  }
  

  @override
  List<Color> getTileColors() {
    return [Colors.black, Colors.black];
  }
}
