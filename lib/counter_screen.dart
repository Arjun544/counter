import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({
    Key key,
    this.title,
    this.initialValue,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.withSpring = true,
  }) : super(key: key);

  final String title;
  final Axis direction;
  final int initialValue;
  final ValueChanged<int> onChanged;

  /// if you want a springSimulation to happens the the user let go the stepper
  /// defaults to true
  final bool withSpring;

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _slideAnimation;
  Animation _textAnimation;
  int _value;
  double _startAnimationPosX;
  double _startAnimationPosY;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 0;
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);

    _controller.value = 0.0;

    _controller.addListener(() {});

    if (widget.direction == Axis.horizontal) {
      _slideAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
              .animate(_controller);
      _textAnimation = _slideAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.2))
              .animate(_controller);
    } else {
      _slideAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 2))
              .animate(_controller);
      _textAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.2))
              .animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction == Axis.horizontal) {
      _slideAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
              .animate(_controller);
      _textAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.2))
              .animate(_controller);
    } else {
      _slideAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 2))
              .animate(_controller);

      _textAnimation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.2))
              .animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Click & Drag',
              style: TextStyle(
                  color: Color(0xFF0f3057),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RotatedBox(
                  quarterTurns: 45,
                  child: Icon(Icons.arrow_back_ios_rounded,
                      size: 40.0, color: Colors.pinkAccent.withOpacity(0.5)),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onHorizontalDragStart: _onPanStart,
                  onHorizontalDragUpdate: _onPanUpdate,
                  onHorizontalDragEnd: _onPanEnd,
                  child: Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        height: 140,
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.5),
                                blurRadius: 30.0,
                                offset: Offset(0, 15),
                                spreadRadius: 2,
                              ),
                            ]),
                        child: SlideTransition(
                          position: _textAnimation,
                          child: Text(
                            '$_value',
                            key: ValueKey<int>(_value),
                            style: TextStyle(
                                color: Color(0xFF0f3057),
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RotatedBox(
                  quarterTurns: 45,
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 40.0, color: Colors.pinkAccent.withOpacity(0.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;
    if (widget.direction == Axis.horizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();

    bool isHor = widget.direction == Axis.horizontal;
    bool changed = false;
    if (_controller.value <= -0.20) {
      setState(() => isHor ? _value-- : _value++);
      changed = true;
    } else if (_controller.value >= 0.20) {
      setState(() => isHor ? _value++ : _value--);
      changed = true;
    }
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
          new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      if (widget.direction == Axis.horizontal) {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
      } else {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed && widget.onChanged != null) {
      widget.onChanged(_value);
    }
  }
}

// != carbon.sh
