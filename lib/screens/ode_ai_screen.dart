import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:raie/models/ode_message_model.dart';
import 'package:raie/widgets/ode_messages_widget.dart';

class OdeAiChat extends StatefulWidget {
  const OdeAiChat({super.key});

  @override
  State<OdeAiChat> createState() => _OdeAiChatState();
}

class _OdeAiChatState extends State<OdeAiChat> with TickerProviderStateMixin {
  final TextEditingController _userMessage = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const apiKey = "AIzaSyAnMTnZ58QfTqwl75ONNoxBxsYAutFYRFw";
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  final List<Message> _messages = [];

  late AnimationController _gradientController;
  late AnimationController _avatarController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _avatarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _userMessage.dispose();
    _scrollController.dispose();
    _gradientController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 20,
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
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        title: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.9), // خلفية بيضا شبه شفافة
                borderRadius: BorderRadius.circular(20),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff00bf63), Color(0xff39b5fc)],
                    stops: [
                      0.0,
                      0.5 + 0.5 * sin(_gradientController.value * 2 * pi),
                    ],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  );
                },
                child: const Text(
                  'Ode Ai Chat',
                  style: TextStyle(
                    color: Colors.white, // لازم أبيض علشان ShaderMask
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ElMessiri',
                    fontSize: 30,
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FadeTransition(
              opacity: Tween(begin: 0.7, end: 1.0).animate(_avatarController),
              child: ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.05).animate(_avatarController),
                child: Container(
                  padding: const EdgeInsets.all(3), // سمك الإطار
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff34b7fe), Color(0xff25d366)],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white, // خلفية بيضاء داخل الإطار
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          AssetImage('assets/images/icons/ode_face.webp'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/images/icons/life_guard_image.webp"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      cursorColor: const Color(0xff29888d),
                      textAlign: TextAlign.right,
                      controller: _userMessage,
                      decoration: InputDecoration(
                        hintText: '...عايز تسأل عن أيه',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff29888d),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Color(0xff29888d),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2EBEF2),
                          Color(0xFF34C88A),
                        ],
                      ),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(15),
                      iconSize: 25,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(const CircleBorder()),
                        shadowColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
