
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatelessWidget {

  const HomePage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob inline ads'),
      ),
      body: FutureBuilder<dynamic>(
          future: _initGoogleMobileAds(),
          builder: (context, snapshot) {
            List<Widget> children = [];

            if (snapshot.connectionState == ConnectionState.waiting) {
              children.add(const Center(
                child: SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: CircularProgressIndicator(),
                ),
              ));
            } else {
              if (snapshot.hasData) {
                children.addAll([
                  ElevatedButton(
                    child: const Text('Banner inline ad'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/banner');
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    child: const Text('Native inline ad'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/native');
                    },
                  ),
                ]);
              } else if (snapshot.hasError) {
                children.add(Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 8.0),
                      Text('Failed to initialize AdMob SDK'),
                    ],
                  ),
                ));
              }
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            );
          }),
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
