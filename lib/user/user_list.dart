import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_label/global/global_list.dart';
import 'package:qr_label/user/user.dart';

abstract class AUserList<T> extends AbstractList<T,User> {
  const AUserList({super.key, required super.user, required super.list, required super.height});
  
}

abstract class AUserListState<T> extends AbstractListState<T,User> {
  @override
  Widget getListTitleText(User element) {
    return Row(
      children: [
        const Icon(
          Icons.person_outline_sharp,
          color: Colors.white,
          size: 50,
        ),
        const SizedBox(width: 20),
        Text(
          element.getFullName(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white
          ),
        )
      ],
    );
  }

  @override
  List<Color> getTileColors() {
    return [Colors.indigo, Colors.indigo.shade300]; 
  }
}

