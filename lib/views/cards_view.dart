import 'dart:async';
import 'package:flutter/material.dart';
import 'package:raie/models/cards_model.dart';
import 'package:raie/widgets/card_widget.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  late Timer _timer;
// https://life-guard-monitor.atwebpages.com/oxygen_info.php
  final List<CardModel> cards = [
    CardModel(
        image: 'assets/images/cards/heart.webp',
        url: 'http://life-guard-monitortst.getenjoyment.net/heart_info.php'),
    CardModel(
        image: 'assets/images/cards/o2.webp',
        url: 'http://life-guard-monitortst.getenjoyment.net/oxygen_info.php'),
    CardModel(
        image: 'assets/images/cards/temp.webp',
        url: 'http://life-guard-monitortst.getenjoyment.net/temp_info.php'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage = _pageController.page!.round() + 1;
      if (nextPage >= cards.length) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return CardWidget(card: cards[index]);
        },
      ),
    );
  }
}
