import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScreenArguments {
  final int animeId;

  ScreenArguments(this.animeId);
}

class AnimeDetailsScreen extends StatelessWidget {
  const AnimeDetailsScreen({super.key});

  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontFamily: 'RodinNTLG'),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF2e51a2),
      ),

      body: WebView(
        initialUrl: "https://myanimelist.net/anime/${args.animeId}",
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      )
    );
  }
}
