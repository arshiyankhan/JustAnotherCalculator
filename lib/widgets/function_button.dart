import 'package:flutter/material.dart';

//StateFul Widget
// Whose state changes during runtime
class FunctionButton extends StatefulWidget {
  String text;
  double size;
  double width;
  Function onPressed;

  FunctionButton({Key? key, required this.text, this.width = 72, this.size = 18, required this.onPressed})
      : super(key: key);

  @override
  _FunctionButtonState createState() => _FunctionButtonState();
}

class _FunctionButtonState extends State<FunctionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: AnimatedContainer(
          width: widget.width,
          height: 65,
          duration: Duration(milliseconds: 150),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 150),
              child: Text(widget.text),
              style: TextStyle(
                color: _hovered ? Colors.white : Color(0xFFED802E),
                fontWeight: FontWeight.w600,
                fontSize: widget.size,
                fontFamily: "poppins",
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: _hovered ? Color(0xFFED802E) : Color(0xFF243441),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(70, 0, 0, 0),
                    blurRadius: 4,
                    offset: Offset(0, 4)),
                BoxShadow(
                    color: Color.fromARGB(40, 255, 255, 255),
                    blurRadius: 1,
                    offset: Offset(0, -2))
              ]),
        ),
      ),
    );
  }
}