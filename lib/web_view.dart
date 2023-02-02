import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("&&&&&&&&&&& ${widget.url}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            onLoadStart: (InAppWebViewController controller, Uri? url) {},
            onLoadStop: (InAppWebViewController controller, Uri? url) {
              //stripe payment success
            },
          ),
        ));
  }
}
