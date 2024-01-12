import 'package:flutter/material.dart';
import 'package:qr_label/global/global_helper.dart';

abstract class IInteractableList<T> {
  onPress(T element, BuildContext context);
  onLongPress(T element, BuildContext context);
}

abstract class AbstractList<T,H> extends StatefulWidget {
  final T? user;
  final List<H>? list;
  final double height;
  const AbstractList({super.key, required this.user, required this.list, required this.height});
}

abstract class AbstractListState<T,H> extends State<AbstractList<T,H>> implements IInteractableList<H> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.list!.length,
      separatorBuilder: (_,__) => const SizedBox(),
      itemBuilder: (context,int index) {
        return buildTile(widget.list![index], widget.user);
      } 
    );
  }

  Widget buildTile(H element, T? user) {
    return Column(
      children: [
        const SizedBox(height: 20),
          Container(
            height: widget.height,
            alignment: Alignment.center,
            width: GlobalHelper.getPreferredWidth(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: getTileColors(),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: GestureDetector(
            child: ListTile(
              title: getListTitleText(element),
              subtitle: getListSubTitleText(element),
              trailing: getTrailing(element),
              leading: getLeading(element),
              onTap: () {
                onPress(element, context);
              },
              onLongPress: (){
                onLongPress(element, context);
              },
            )
          ),
        )
      ],
    );
  }

  Widget getListTitleText(H element);
  Widget? getListSubTitleText(H element) {
    return null;
  }
  List<Color> getTileColors();
  Widget? getTrailing(H element) {
    return null;
  }
  Widget? getLeading(H element) {
    return null;
  }

}