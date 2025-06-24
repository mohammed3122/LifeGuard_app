import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.link,
    this.text,
    this.icon,
  });
  final String link;
  final String? text;
  final IconData? icon;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF339cd2), // الأزرق
                Color(0xFF2fc57f), // الأخضر
              ],
            ),
            borderRadius: BorderRadiusDirectional.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        title: Text(
          'اطمن علي صحتك',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'ElMessiri',
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(.25),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              // ignore: deprecated_member_use
              child: Center(
                child: Container(
                  height: 100,
                  width: 180,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff1d8181),
                        spreadRadius: 1,
                        blurRadius: 2,
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xfffef8f3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2EBEF2), // أزرق
                                Color(0xFF34C88A), // أخضر
                              ],
                            ).createShader(Rect.fromLTWH(
                                0, 0, bounds.width, bounds.height));
                          },
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        // textDirection: TextDirection.rtl,
                        'جاري التحميل ...',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xff2fbfac),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ElMessiri',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
