import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScrean extends StatefulWidget {
  String link, name;
  WebViewScrean({required this.link, required this.name});

  @override
  WebViewScreanState createState() => WebViewScreanState();
}

class WebViewScreanState extends State<WebViewScrean> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whitecolor,
        iconTheme: IconThemeData(color: MainColor),
        title: Text(
          widget.name,
          style: style5,
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

class WebViewRollet extends StatefulWidget {
  String link, name;
  WebViewRollet({required this.link, required this.name});

  @override
  WebViewRolletState createState() => WebViewRolletState();
}

class WebViewRolletState extends State<WebViewRollet> {
  late final WebViewController _controller;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();

    // إعداد الـ creation params حسب نوع المنصة عشان allowsInlineMediaPlayback
    // بتتظبط وقت الإنشاء على iOS (WebKit)، مش بعد كده
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.link));

    // على أندرويد، السماح بتشغيل الميديا تلقائيًا بيتظبط عن طريق
    // AndroidWebViewController مش WebViewController نفسها
    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return WebViewWidget(
      key: _key,
      controller: _controller,
      gestureRecognizers: gestureRecognizers,
    );
  }
}