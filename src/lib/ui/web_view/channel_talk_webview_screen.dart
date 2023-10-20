import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChannelTalkWebViewScreen extends StatefulWidget {
  const ChannelTalkWebViewScreen({super.key});

  @override
  _ChannelTalkWebViewScreenState createState() => _ChannelTalkWebViewScreenState();
}

class _ChannelTalkWebViewScreenState extends State<ChannelTalkWebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildWebView(),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri("https://puppycat.channel.io")),
    );
  }
}
