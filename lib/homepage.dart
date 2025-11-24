import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calculator_app/buttons.dart';
import 'package:math_expressions/math_expressions.dart' hide Stack;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userQuestion = '';
  String userAnswer = '';

  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', 'x',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', 'ANS', '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2B0740), 
                  Color(0xFF000428), 
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),


          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(color: Colors.black.withOpacity(0)),
          ),

          SafeArea(
            child: Column(
              children: [

                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userQuestion,
                          style: TextStyle(
                            color: Colors.white,
                             fontFamily: "SFPro",
                             fontSize: 28,
                             fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          userAnswer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "SFPro",
                             fontSize: 28,
                             fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: buttons.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        return buildGlassyButton(buttons[index]);
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGlassyButton(String text) {
    bool isOperator = "/x-%+=ANS".contains(text);

    Color glassColor = isOperator
        ? const Color(0xFF7B5BFF).withOpacity(0.35)
        : Colors.white.withOpacity(0.15);


    Color txt = isOperator ? Colors.white : Colors.white.withOpacity(0.9);

    return GlassButton(
      text: text,
      bgColor: glassColor,
      textColor: txt,
      onTap: () => onButtonPress(text),
    );
  }

  void onButtonPress(String text) {
    setState(() {
      if (text == 'C') {
        userQuestion = '';
        userAnswer = '';
      } else if (text == 'DEL') {
        if (userQuestion.isNotEmpty) {
          userQuestion = userQuestion.substring(0, userQuestion.length - 1);
        }
      } else if (text == '=') {
        solve();
      } else if (text == 'ANS') {
        userQuestion += userAnswer;
      } else {
        userQuestion += text;
      }
    });
  }

  void solve() {
    try {
      String finalQ = userQuestion.replaceAll('x', '*');

      Parser p = Parser();
      Expression exp = p.parse(finalQ);
      double result = exp.evaluate(EvaluationType.REAL, ContextModel());

      userAnswer = result.toStringAsFixed(2);
    } catch (e) {
      userAnswer = "Error";
    }
  }
}
