import 'package:flutter/material.dart';

//StateFul Widget
// Whose state changes during runtime
class NormalButton extends StatefulWidget {
  String text;
  double size;
  Function onPressed;

  NormalButton({Key? key, required this.text, this.size = 18, required this.onPressed})
      : super(key: key);

  @override
  _NormalButtonState createState() => _NormalButtonState();
}

class _NormalButtonState extends State<NormalButton> {
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
          width: 72,
          height: 65,
          duration: Duration(milliseconds: 150),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 150),
              child: Text(widget.text),
              style: TextStyle(
                color: _hovered ? Colors.white : Color(0xFF778590),
                fontWeight: FontWeight.w600,
                fontSize: widget.size,
                fontFamily: "poppins",
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: _hovered ? Color(0xFF778590) : Color(0xFF243441),
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