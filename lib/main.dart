import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:calculator/widgets/function_button.dart';
import 'package:calculator/widgets/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Window.initialize();
  // await Window.setEffect(
  //   effect: WindowEffect.solid,
  //   color: Color(0xDD243441),
  // );

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: double.maxFinite,
        duration: 2500,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        nextScreen: HomeScreen(),
        backgroundColor: Color(0xFF303337),
        splash: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 1,
              ),
            ),
            Image.asset(
              'assets/jaclogo.png',
              width: 267,
              height: 100,
              ),
            SizedBox(
              height: 20,
            ),
            Text(
                'Just Another Calculator',
                 style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'spartan',
                  color: Colors.white,
                ),
              ),
            Expanded(
              child: SizedBox(
                height: 1,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 1,
                  ),
                ),
                Image.asset('assets/gitlogo.png'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'arshiyankhan',
                  style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'spartan',
                  color: Colors.white,
                ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      )));

  if (Platform.isWindows){
  doWhenWindowReady(() {
    Size size = Size(380, 750);
    appWindow.minSize = size;
    appWindow.size = size;
    // appWindow.maxSize = size;
    appWindow.title = "Just Another Calculator";
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
  }
}

// Stateless Widget & Stateless Widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentResult = "0";
  String currentValue = "0";
  List functions = ["%", "÷", "x", "-", "+"];

  void handleButton(String value, {bool isFunction = false}) {
    if (!isFunction) {
      if (currentValue == "0") {
        removeLastLetter();
      }
      setState(() {
        currentValue += value;
      });
    } else {
      if (value == "AC") {
        setState(() {
          currentResult = "0";
          currentValue = "0";
        });
      } else if (value == "C") {
        removeLastLetter();
      } else if (value == "%") {
      } else if (value == "/") {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += '÷';
        });
      } else if (value == "x") {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += 'x';
        });
      } else if (value == "-") {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += '-';
        });
      } else if (value == "+") {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += '+';
        });
      } else if (value == "=") {
        checkAndCalculateValue(forceUpdate: true);
      } else if (value == ".") {
        handleDot();
      }
    }
  }

  void handleDot() {
    if (currentValue.length == 1) {
      setState(() {
        currentValue += '.';
      });
      return;
    }
    if (!(currentValue.length > 1)) {
      return;
    }

    String lastLetter = currentValue.substring(currentValue.length - 1);

    if (functions.contains(lastLetter)) {
      return;
    }

    bool anyFunction = false;

    for (String function in functions) {
      if (currentValue.contains(function)) {
        anyFunction = true;
        break;
      }
    }

    if (anyFunction) {
      if (".".allMatches(currentValue).length >= 2) {
        return;
      }
      setState(() {
        currentValue += ".";
      });
    } else {
      if (currentValue.contains(".")) {
        return;
      }
      setState(() {
        currentValue += ".";
      });
    }
  }

  void removeLastLetter() {
    setState(() {
      try {
        currentValue = currentValue.substring(0, currentValue.length - 1);
      } catch (e) {}
    });
  }

  checkAndCalculateValue({bool forceUpdate = false}) {
    for (String function in functions) {
      // Try to split the current values using the function
      List splitted = currentValue.split(function);
      // If the splitted list has atleast 2 members AND the second member is not empty
      if (splitted.length >= 2 && splitted[1] != '') {
        // Assign the numbers from splitted list
        double num1 = double.parse(splitted[0]);
        double num2 = double.parse(splitted[1]);

        // Create a variable to hold result
        double? result;

        // Calculating the numbers as per the function they were splitted from
        // and assigning the result to the result variable
        if (function == functions[1]) {
          result = num1 / num2;
        } else if (function == functions[2]) {
          result = num1 * num2;
        } else if (function == functions[3]) {
          result = num1 - num2;
        } else if (function == functions[4]) {
          result = num1 + num2;
        }

        // Checking the the result ends with .0
        // If YES then we can remove it from the last
        // FINALLY set the current value to this result
        if (result.toString().endsWith(".0")) {
          setState(() {
            // If Force Update i.e current value goes empty
            if (forceUpdate) {
              currentValue = "";
            } else {
              currentValue =
                  "${result.toString().substring(0, result.toString().length - 2)}";
            }
            currentResult =
                "${result.toString().substring(0, result.toString().length - 2)}";
          });
        } else {
          setState(() {
            // If Force Update i.e current value goes empty
            if (forceUpdate) {
              currentValue = "";
            } else {
              currentValue = "${result}";
            }
            currentResult = "${result}";
          });
        }
      }
    }
  }

  bool isPreviousPressAFunction() {
    if (!(currentValue.length > 1)) {
      return false;
    }
    String lastLetter = currentValue.substring(currentValue.length - 1);

    if (functions.contains(lastLetter)) {
      return true;
    }
    return false;
  }

  void keyBoardEventHandler(event) {
    if (event is RawKeyDownEvent) {
      if (event.isKeyPressed(LogicalKeyboardKey.numpad1)) {
        handleButton("1");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad2)) {
        handleButton("2");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad3)) {
        handleButton("3");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad4)) {
        handleButton("4");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad5)) {
        handleButton("5");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad6)) {
        handleButton("6");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad7)) {
        handleButton("7");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad8)) {
        handleButton("8");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad9)) {
        handleButton("9");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpad0)) {
        handleButton("0");
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpadAdd)) {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += '+';
        });
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpadSubtract)) {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += '-';
        });
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpadMultiply)) {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += 'x';
        });
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpadDivide)) {
        if (currentValue.length == 0) {
          return;
        }
        checkAndCalculateValue();
        if (isPreviousPressAFunction()) {
          removeLastLetter();
        }
        setState(() {
          currentValue += '÷';
        });
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpadEnter) ||
          event.isKeyPressed(LogicalKeyboardKey.enter)) {
        checkAndCalculateValue(forceUpdate: true);
      } else if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
        removeLastLetter();
      } else if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
        setState(() {
          currentResult = "0";
          currentValue = "";
        });
      } else if (event.isKeyPressed(LogicalKeyboardKey.numpadDecimal)) {
        handleDot();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: keyBoardEventHandler,
      child: Scaffold(
        backgroundColor: Color(0xFF243441),
        body: Column(
          children: [
            //Title Bar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MoveWindow(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(child: SizedBox(width: 1)),
                      IconButton(
                        padding: EdgeInsets.only(bottom: 14),
                        onPressed: () {
                          appWindow.minimize();
                        },
                        icon: Icon(
                          Icons.minimize,
                          color: Colors.grey,
                          size: 22,
                        ),
                        splashColor: Colors.transparent,
                        hoverColor: Color.fromARGB(255, 26, 36, 44),
                        focusColor: Colors.transparent,
                        splashRadius: 15,
                      ),
                      IconButton(
                        onPressed: (){
                          appWindow.maximize();
                        },
                        icon: Icon(
                          Icons.check_box_outline_blank_sharp,
                          color: Colors.grey,
                          size: 18,
                        ),
                        splashColor: Colors.transparent,
                        hoverColor: Color.fromARGB(255, 26, 36, 44),
                        focusColor: Colors.transparent,
                        splashRadius: 16,
                        ),
                      IconButton(
                        onPressed: () {
                          appWindow.close();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 22,
                        ),
                        splashColor: Colors.transparent,
                        hoverColor: Color(0xFFD31123),
                        focusColor: Colors.transparent,
                        splashRadius: 15,
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  SizedBox(
                    height: 115,
                    child: Text(
                      currentResult,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontFamily: "poppins",
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 35,
                    child: Text(
                      currentValue,
                      style: TextStyle(
                        color: Color(0xFF778590),
                        fontSize: 21,
                        fontFamily: "poppins",
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FunctionButton(
                  text: "AC",
                  onPressed: () {
                    handleButton("AC", isFunction: true);
                  },
                ),
                FunctionButton(
                  text: "C",
                  onPressed: () {
                    handleButton("C", isFunction: true);
                  },
                ),
                FunctionButton(
                  text: "%",
                  size: 22,
                  onPressed: () {
                    handleButton("%", isFunction: true);
                  },
                ),
                FunctionButton(
                  text: "÷",
                  size: 28,
                  onPressed: () {
                    handleButton("/", isFunction: true);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NormalButton(
                  text: "7",
                  onPressed: () {
                    handleButton("7");
                  },
                ),
                NormalButton(
                  text: "8",
                  onPressed: () {
                    handleButton("8");
                  },
                ),
                NormalButton(
                  text: "9",
                  onPressed: () {
                    handleButton("9");
                  },
                ),
                FunctionButton(
                  text: "x",
                  size: 22,
                  onPressed: () {
                    handleButton("x", isFunction: true);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NormalButton(
                  text: "4",
                  onPressed: () {
                    handleButton("4");
                  },
                ),
                NormalButton(
                  text: "5",
                  onPressed: () {
                    handleButton("5");
                  },
                ),
                NormalButton(
                  text: "6",
                  onPressed: () {
                    handleButton("6");
                  },
                ),
                FunctionButton(
                  text: "-",
                  size: 22,
                  onPressed: () {
                    handleButton("-", isFunction: true);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NormalButton(
                  text: "1",
                  onPressed: () {
                    handleButton("1");
                  },
                ),
                NormalButton(
                  text: "2",
                  onPressed: () {
                    handleButton("2");
                  },
                ),
                NormalButton(
                  text: "3",
                  onPressed: () {
                    handleButton("3");
                  },
                ),
                FunctionButton(
                  text: "+",
                  size: 22,
                  onPressed: () {
                    handleButton("+", isFunction: true);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NormalButton(
                  text: "0",
                  onPressed: () {
                    handleButton("0");
                  },
                ),
                NormalButton(
                  text: ".",
                  onPressed: () {
                    handleButton(".", isFunction: true);
                  },
                ),
                FunctionButton(
                  text: "=",
                  size: 22,
                  width: 162,
                  onPressed: () {
                    handleButton("=", isFunction: true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
