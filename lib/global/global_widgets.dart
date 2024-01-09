import 'package:flutter/material.dart';

class SquareGradientButton extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final double height;

  const SquareGradientButton({super.key, required this.onPress, required this.text, required this.colors, required this.height});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class SquareGradientButtonSizeable extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final Size size;

  const SquareGradientButtonSizeable({super.key, required this.onPress, required this.text, required this.colors, required this.size});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
class SingleButtonDialog extends StatelessWidget {
  final String displayText;
  final String buttonText;
  final List<Color> buttonColors;
  final List<Color> dialogColors;

  const SingleButtonDialog({super.key, required this.displayText, required this.buttonText, required this.buttonColors, required this.dialogColors});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: dialogColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayText,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
            const SizedBox(height: 20),
            SquareGradientButton(
              height: 50,
              colors: buttonColors,
              text: buttonText,
              onPress: _popBack
            )
          ],
        ),
        
      )
    );
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.displayText, required this.onConfirmCallback});
  final Function(BuildContext) onConfirmCallback;
  final String displayText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        height: 200,
        width: 300,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayText,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.blue,Colors.blue.shade400],text: "Confirm",onPress: _onConfirm),
                  const SizedBox(width: 20),
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.red,Colors.red.shade400],text: "Cancel",onPress: _popBack),
                ],
              )
            ) 
          ],
        ),
        
      )
    );
  }
  void _onConfirm(BuildContext context) {
    _popBack(context);
    onConfirmCallback(context);
    
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}


abstract class ASearchDropDownButton<T> extends StatefulWidget {
  final Function(T?) onSelect;
  final double width;
  final List<T?>? list;
  final String? label;
  final T? initialValue;
  const ASearchDropDownButton({super.key, required this.list, required this.width,required this.label, required this.onSelect, required this.initialValue});
}

abstract class ASearchDropDownButtonState<T> extends State<ASearchDropDownButton<T>> {
  late int selectedIndex;
  late String searchValue = "";
  late List<String> stringList = [];
  late List<T?> valueList = [];
  @override
  void initState() {
    super.initState();
    buildLists("");
    selectedIndex = getInitalIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: widget.label,
          ),
          onChanged: (String search) {
            setState(() {
              selectedIndex = 0;
              buildLists(search.toLowerCase());
              if (valueList.isNotEmpty) {
                widget.onSelect(valueList[selectedIndex]);
              } 
            });
            
          },
        ),
        const SizedBox(height: 20),
        Theme(
          data: ThemeData(
            canvasColor: Colors.black
          ), 
          child: SizedBox(
            width: widget.width,
            height: 50,
            child: DropdownButton<String>(
              isExpanded: true,
              value: getValueAtIndex(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedIndex = stringList.indexOf(newValue!);
                  widget.onSelect(valueList[selectedIndex]);
                });
              },
              items: stringList
                  .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white70
                      ),
                    ),
                  );
              }).toList(),
            ),
          )
        )
      ],
    );
  }

  String elementToString(T? element);

  void buildLists(String search) {
    List<String> newStringList = [];
    List<T?> newValueList = [];
    for (T? value in widget.list!) {
      String stringValue = elementToString(value);
      if (stringValue.toLowerCase().contains(search)) {
          newStringList.add(elementToString(value));
          newValueList.add(value);
      }
    }
    stringList = newStringList;
    valueList = newValueList;
  }
  String? getValueAtIndex() {
    if (stringList.isEmpty) {
      return null;
    }
    return stringList[selectedIndex];
  }

  int getInitalIndex();
}

abstract class AbstractDropDownSelector<T> extends StatefulWidget {
  final Function(T?) onSelect;
  final List<T> options;
  final T? initalSelect;
  const AbstractDropDownSelector({super.key, required this.onSelect, required this.options, required this.initalSelect});
}
  
abstract class AbstractDropDownSelectorState<T> extends State<AbstractDropDownSelector<T>> {
  late T? selected = widget.initalSelect;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.black
      ), 
      child: SizedBox(
        width: 300,
        height: 50, 
        child :DropdownButton<T>(
          value: selected,
          onChanged: (T? newValue) {
            setState(() {
              selected = newValue;
              widget.onSelect(newValue);
            });
            
          },
          items: widget.options.map((T option) {
            return DropdownMenuItem<T>(
              value: option,
              child: Row(
                children: [
                  Text(
                    optionToString(option),
                    style: const TextStyle(
                      color: Colors.white70
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      )
    );
  }

  String optionToString(T option);

}