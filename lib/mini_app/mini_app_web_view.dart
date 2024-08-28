import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';


class MiniAppWebView extends StatefulWidget {
  final String miniAppUrl;

  MiniAppWebView({required this.miniAppUrl});

  @override
  _MiniAppWebViewState createState() => _MiniAppWebViewState();
}

class _MiniAppWebViewState extends State<MiniAppWebView> {
  late InAppWebViewController _webViewController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true; // State variable to track loading status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mini App")),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.miniAppUrl),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _setupJavascriptBridge(controller);
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true; // Show loading widget when page starts loading
              });
              print("Started loading: $url");
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false; // Hide loading widget when page stops loading
              });
              print("Finished loading: $url");
            },
            onConsoleMessage: (controller, consoleMessage) {
              print("Console message: ${consoleMessage.message}");
            },
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator()) // Loading widget
              : SizedBox.shrink(), // Empty widget to hide the loading indicator
        ],
      ),
    );
  }

  void _setupJavascriptBridge(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: "requestCameraPermission",
      callback: (args) async {
        bool granted = await requestCameraPermission();
        return granted;
      },
    );

    controller.addJavaScriptHandler(
      handlerName: "capturePhoto",
      callback: (args) async {
        String? photoData = await capturePhoto();
        return photoData;
      },
    );
  }

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<String?> capturePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return base64Encode(await image.readAsBytes());
    }
    return null;
  }
}
