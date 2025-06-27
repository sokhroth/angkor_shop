import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebView extends StatefulWidget {
  final String paymentUrl;
  final Function(String token) onPaymentSuccess;

  const PaypalWebView({
    super.key,
    required this.paymentUrl,
    required this.onPaymentSuccess,
  });

  @override
  State<PaypalWebView> createState() => _PaypalWebViewState();
}

class _PaypalWebViewState extends State<PaypalWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                final url = request.url;

                if (url.startsWith(
                  'https://sesmpv1a96.execute-api.us-east-1.amazonaws.com/paypal-success',
                )) {
                  final uri = Uri.parse(url);
                  final token = uri.queryParameters['token'];

                  Navigator.pop(context);

                  if (token != null) {
                    Future.microtask(() {
                      widget.onPaymentSuccess(token);
                    });
                  }

                  return NavigationDecision.prevent;
                }

                if (url.startsWith(
                  'https://sesmpv1a96.execute-api.us-east-1.amazonaws.com/paypal-cancel',
                )) {
                  Navigator.pop(context);
                  Future.microtask(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment was cancelled.')),
                    );
                  });

                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
              onPageStarted: (_) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pay with PayPal",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF00CFFF)),
            ),
        ],
      ),
    );
  }
}
