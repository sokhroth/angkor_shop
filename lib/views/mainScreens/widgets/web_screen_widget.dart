import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const WebViewScreen({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Handle loading progress
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        onHttpError: (HttpResponseError error) {
          // Log the error information
        },
        onWebResourceError: (WebResourceError error) {
          print('Web resource error: ${error.errorCode}');
        },
        onNavigationRequest: (NavigationRequest request) {
          // Optionally intercept navigation requests here.
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF00CFFF),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
