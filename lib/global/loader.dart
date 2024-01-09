
import 'package:flutter/material.dart';

abstract class WidgetLoader extends StatelessWidget {
  const WidgetLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFuture(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
              
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else { 
            return generateContent(snapshot);
          }
        }
    );
  }
  Widget generateContent(AsyncSnapshot<dynamic> snapshot);
  Future getFuture();
}

abstract class SizedWidgetLoader extends StatelessWidget {
  final Size size;
  const SizedWidgetLoader({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFuture(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: const CircularProgressIndicator()
            )
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else { 
          return generateContent(snapshot);
        }
      }
    );
  }
  Widget generateContent(AsyncSnapshot<dynamic> snapshot);
  Future getFuture();
}


abstract class AsyncSizedWidgetLoader extends StatelessWidget {
  final Size size;
  const AsyncSizedWidgetLoader({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFuture(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: const CircularProgressIndicator()
            )
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else { 
          return generateContent(snapshot);
        }
      }
    );
  }
  Widget generateContent(AsyncSnapshot<dynamic> snapshot);
  Future getFuture();
}