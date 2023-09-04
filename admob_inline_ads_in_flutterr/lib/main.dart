import 'package:admob_inline_ads_in_flutter/destination.dart';
import 'package:admob_inline_ads_in_flutter/banner_inline_page.dart';
import 'package:admob_inline_ads_in_flutter/home_page.dart';
import 'package:admob_inline_ads_in_flutter/native_inline_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/banner': (context) =>
            BannerInlinePage(entries: Destination.samples),
        '/native': (context) =>
            NativeInlinePage(entries: Destination.samples),
      },
    );
  }
}
