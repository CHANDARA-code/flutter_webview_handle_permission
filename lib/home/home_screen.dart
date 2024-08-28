import 'package:flutter/material.dart';
import 'package:flutter_webview_handle_permission/mini_app/mini_app_web_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MiniAppWebView(
                    miniAppUrl:
                        "https://euphonious-pastelito-a6a8b2.netlify.app"),
              ),
            );
          },
          child: Text("Open Mini App"),
        ),
      ),
    );
  }
}
