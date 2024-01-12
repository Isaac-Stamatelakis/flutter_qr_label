import 'package:flutter/material.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/user/user.dart';

abstract class APagination<T> extends StatefulWidget {
  final T user;
  final int displayedAmount = 10;
  final String textFieldLabel;
  final String emptyText;
  const APagination({super.key, required this.user, required this.textFieldLabel, required this.emptyText});

}

abstract class APaginationState<T> extends State<APagination> {
  late String search = "";
  late int pageNumber = 0;
  late List<T> displayed = [];
  late List<T> cache = [];
  late LimitSearchDatabaseQuery queryRetriever = getQuery();

  @override 
  void initState() {
    super.initState();
    retrieve();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                const SizedBox(width: 20),
                Flexible(
                child: TextField(
                  controller: TextEditingController(text: search),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: widget.textFieldLabel,
                    labelStyle: const TextStyle(
                      color: Colors.pink
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    search = text;
                  },
                  onEditingComplete: () {
                    pageNumber = 0;
                    cache.clear();
                    queryRetriever = getQuery();
                    retrieve();
                  },
                  style: const TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ],
            ), 
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                pageNumber != 0 
                  ? IconButton(
                    onPressed: _onLeftPress, 
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 50,
                      color: Colors.pink
                    )
                  ) 
                  : const SizedBox(width: 50),
                const SizedBox(width: 20),
                Container(
                  child: Text(
                    "Currently Viewing Page : ${pageNumber.toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.pink
                    ),
                  ),
                ),
                !queryRetriever.complete || (pageNumber+1)*widget.displayedAmount < cache.length
                  ? IconButton(
                  onPressed: _onRightPress,
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 50,
                    color: Colors.pink
                  )
                  )
                  : const SizedBox(width: 50),
                const SizedBox(width: 20),
              ],
            ), 
            ),
            
            getListState()
          ],
        )
      ],
    );
  }

  Widget getListState() {
    if (displayed.isEmpty) {
      if (queryRetriever.complete) {
        return Center(
          child: Text(
            widget.emptyText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30
            ),
          )
        );
      } else {
        return const Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(),
        )
      );
      }
    } else {
      return Expanded(
        child: getList()
      );
    }
  }

  Widget getList();

  Future<void> retrieve() async {
    List<T>? retrieved = await queryRetriever.fromDatabase() as List<T>?;
    cache.addAll(retrieved!);
    setState(() {
      displayed = retrieved;
    });
  }

  void _onRightPress() async {
    pageNumber ++;
    if (queryRetriever.complete) { // elements are already cached
      if ((pageNumber)*widget.displayedAmount < cache.length) { // displayed is full from cache
        displayed = cache.sublist(pageNumber*widget.displayedAmount, cache.length);
      } else {
        displayed = cache.sublist(pageNumber*widget.displayedAmount,(pageNumber+1)*widget.displayedAmount);
      }
      setState(() {
        
      });
    } else { // need to get elements from database
      await retrieve();
    }
  }

  LimitSearchDatabaseQuery getQuery();
  void _onLeftPress() {
    if (pageNumber <= 0) { // should never be visible at this point but here just incase
      return;
    } 
    pageNumber --;
    setState(() { // display elements from the previous cache. These elements shoudl always exist
      displayed = cache.sublist(pageNumber*widget.displayedAmount,(pageNumber+1)*widget.displayedAmount);
    }); 

  }
}