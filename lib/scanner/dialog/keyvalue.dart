import 'dart:math';

import 'package:flutter/material.dart';

/// A key and a value which can be transfored in and out of json
class KeyValuePair  {
  late String? key;
  late dynamic value;
  KeyValuePair({required this.key, required this.value});
}

class KeyValuePairFactory {
  static Map<String,dynamic> toJson(List<KeyValuePair> keyValuePairList) {
    Map<String, dynamic> json = {};
    for (KeyValuePair keyValuePair in keyValuePairList) {
      if (keyValuePair.key != null && !json.containsKey(keyValuePair.key)) {
        json[keyValuePair.key!] = keyValuePair.value;
      }
    }
    return json;
  }

  static List<KeyValuePair> fromJson(Map<String,dynamic> map) {
    List<KeyValuePair> keyValuePairList = [];
    for (String key in map.keys) {
      keyValuePairList.add(KeyValuePair(key: key, value: map[key]));
    }
    return keyValuePairList;
  }

  static List<String> toListOfKeys(List<KeyValuePair> keyValuePairList) {
    List<String> list = [];
    for (KeyValuePair keyValuePair in keyValuePairList) {
      list.add(keyValuePair.key!);
    }
    return list;
  }
  static List<dynamic> toListOfValues(List<KeyValuePair> keyValuePairList) {
    List<dynamic> value = [];
    for (KeyValuePair keyValuePair in keyValuePairList) {
      value.add(keyValuePair.key!);
    }
    return value;
  }
  static List<KeyValuePair> toList(List<String> keys, List<dynamic> values) {
    List<KeyValuePair> list = [];
    for (int i = 0; i < min(keys.length,values.length); i ++) {
      list.add(KeyValuePair(key: keys[i], value: values[i]));
    }
    return list;
  }
}


abstract class _AbstractKeyValueList extends StatefulWidget {
  final List<KeyValuePair> data;

  const _AbstractKeyValueList({super.key, required this.data});
  
}

abstract class _AbstractKeyValueListState extends State<_AbstractKeyValueList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.data!.length,
      separatorBuilder: (_,__) => const SizedBox(),
      itemBuilder: (context,int index) {
        return buildTile(widget.data[index]);
      } 
    );
  }

  Widget buildTile(KeyValuePair keyValuePair);
}

class KeyValueEditList extends _AbstractKeyValueList {
  const KeyValueEditList({super.key, required super.data});

  @override
  State<StatefulWidget> createState() => _EditListState();
}

class _EditListState extends _AbstractKeyValueListState {
  @override
  Widget buildTile(KeyValuePair keyValuePair) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 50),
            Expanded(
              child: TextField(
              controller: TextEditingController(text: keyValuePair.key.toString()),
              decoration: const InputDecoration(
                labelText: 'Label',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                keyValuePair.key = text;
              },
              style: const TextStyle(
                color: Colors.white
              ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: TextField(
              controller: TextEditingController(text: keyValuePair.value.toString()),
              decoration: const InputDecoration(
                labelText: 'Data',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white
              ),
              onChanged: (text) {
                keyValuePair.value = text;
              },
              ),
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  widget.data.remove(keyValuePair);
                });
              }, 
              icon: const Icon(
                Icons.delete,
                color: Colors.red
              )
            )
          ],
        ),
      const SizedBox(height: 20)
      ],
    );
  }
}

class KeyValueViewList extends _AbstractKeyValueList {
  const KeyValueViewList({super.key, required super.data});
  @override
  State<StatefulWidget> createState() => _ViewListState();

}

class _ViewListState extends _AbstractKeyValueListState {
  @override
  Widget buildTile(KeyValuePair keyValuePair) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
              controller: TextEditingController(text: keyValuePair.key.toString()),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Label',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                keyValuePair.key = text;
              },
              style: const TextStyle(
                color: Colors.white
              ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: TextField(
              controller: TextEditingController(text: keyValuePair.value.toString()),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data',
                labelStyle: TextStyle(
                  color: Colors.pink
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white
              ),
              onChanged: (text) {
                keyValuePair.value = text;
              },
              ),
            ),
          ],
        ),
      const SizedBox(height: 20)
      ],
    );
  }

}

