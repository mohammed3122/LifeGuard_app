import 'package:flutter/material.dart';
import 'package:raie/models/cards_model.dart';
import 'package:raie/screens/unit_details_screen.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({required this.card, super.key});

  final CardModel card;

  @override
  // ignore: library_private_types_in_public_api
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Details(
        link: widget.card.url,
      );
    }));
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            shadowColor: const Color(0xff29888d),
            margin: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 120,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.card.image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
