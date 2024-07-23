// ignore_for_file: prefer_const_constructors , file_names, constant_identifier_names

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mix_widgets.dart';

class LogoAnimated extends StatefulWidget {
  const LogoAnimated({super.key});

  @override
  State<LogoAnimated> createState() => _LogoAnimatedState();
}

class _LogoAnimatedState extends State<LogoAnimated>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 2 * math.pi,
            child: child,
          );
        },
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/app.png'),
            ),
          ),
          child: wText("Web Image", size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

// animated container

class WAnimatedContainer extends StatefulWidget {
  final String image;
  const WAnimatedContainer({super.key, required this.image});

  @override
  State<WAnimatedContainer> createState() => _WAnimatedContainerState();
}

class _WAnimatedContainerState extends State<WAnimatedContainer> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
        },
        child: Center(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
              ),
              color: selected ? Colors.blue : Colors.green[900],
              borderRadius: BorderRadius.circular(selected ? 20.0 : 10.0),
            ),
            height: selected ? 200.0 : 100.0,
            width: selected ? 200.0 : 100.0,
            alignment:
                selected ? Alignment.center : AlignmentDirectional.topCenter,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: Center(
              child: wText(
                selected ? 'Selected' : 'Click Me',
                size: selected ? 20 : 10,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}

// Animated cross fade
class WCrossFade extends StatefulWidget {
  const WCrossFade({super.key});

  @override
  State<WCrossFade> createState() => _WCrossFadeState();
}

class _WCrossFadeState extends State<WCrossFade> {
  late bool _bool = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 200,
        ),
        GestureDetector(
          onVerticalDragStart: (details) {
            setState(() {
              _bool = !_bool;
            });
          },
          onTap: () {
            setState(() {
              _bool = !_bool;
            });
          },
          child: AnimatedCrossFade(
            duration: const Duration(seconds: 2),
            firstChild: Image.asset('assets/images/app.png'),
            secondChild: WebLogo(size: 200),
            crossFadeState:
                _bool ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ),
      ],
    );
  }
}

class WebLogo extends StatelessWidget {
  const WebLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app.png'),
        ),
      ),
    );
  }
}

// text Animation Widget
class WTextAnimation extends StatefulWidget {
  final String text;
  const WTextAnimation({super.key, required this.text});

  @override
  State<WTextAnimation> createState() => _WTextAnimationState();
}

class _WTextAnimationState extends State<WTextAnimation> {
  bool first = true;
  double _fontSize = 20;
  Color _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          first = !first;
          _fontSize = first ? 20 : 40;
          _color = first ? Colors.red : Colors.blueAccent;
        });
      },
      child: Center(
        child: AnimatedDefaultTextStyle(
            duration: const Duration(seconds: 2),
            style: TextStyle(
              fontSize: _fontSize,
              color: _color,
              fontWeight: FontWeight.bold,
            ),
            child: Text(
              widget.text,
              style: GoogleFonts.daiBannaSil(),
            ).animate().fade(duration: 500.ms).scale(delay: 500.ms)),
      ),
    );
  }
}

// Animated Icon Button
class WAnimatedIconB extends StatefulWidget {
  final IconData icon;
  final Function() onPressed;
  const WAnimatedIconB(
      {super.key, required this.icon, required this.onPressed});

  @override
  State<WAnimatedIconB> createState() => _WAnimatedIconBState();
}

class _WAnimatedIconBState extends State<WAnimatedIconB>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPlaying = !isPlaying;
            isPlaying ? _controller.forward() : _controller.reverse();
          });
        },
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animation,
          size: 100,
          color: Colors.blue,
        ),
      ),
    );
  }
}

// Animated Mix Widget
class WAnimatedMix extends StatefulWidget {
  const WAnimatedMix({super.key});

  @override
  State<WAnimatedMix> createState() => _WAnimatedMixState();
}

class _WAnimatedMixState extends State<WAnimatedMix>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onDoubleTap: () {
          _voltModalSheet(context);
        },
        onTap: () {
          if (_controller.isAnimating) {
            _controller.stop();
          } else {
            _controller.repeat();
          }
        },
        child: wAnimatedMix(
          animation: _animation,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fb.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  wAnimatedMix(
      {required Animation<double> animation, required Container child}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: animation.value * 2 * math.pi,
          child: child,
        );
      },
      child: child,
    );
  }

  void _voltModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Hello World!',
                style: GoogleFonts.gabarito(fontSize: 40),
              ),
            ),
          );
        });
  }

  myCustomContentWidget() {
    return Column(children: <Widget>[
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fb.png'),
          ),
        ),
      )
    ]);
  }
}
// Animated Padding

class WAnimatedPadding extends StatefulWidget {
  const WAnimatedPadding({super.key});

  @override
  State<WAnimatedPadding> createState() => _WAnimatedPaddingState();
}

class _WAnimatedPaddingState extends State<WAnimatedPadding> {
  double paddingValue = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            paddingValue = paddingValue == 0 ? 50 : 0;
          });
        },
        child: AnimatedPadding(
          duration: const Duration(seconds: 2),
          padding: EdgeInsets.all(paddingValue),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hotel.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Animated Positioned
class WAniPositioned extends StatefulWidget {
  const WAniPositioned({super.key});

  @override
  State<WAniPositioned> createState() => _WAniPositionedState();
}

class _WAniPositionedState extends State<WAniPositioned> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    // when screen up and down the container will move
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              top: selected ? 100 : 0,
              bottom: selected ? 0 : 100,
              left: selected ? 100 : 0,
              right: selected ? 0 : 100,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/hotel.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Large rich animation
class WAnimate extends StatelessWidget {
  final List<Effect> effects;
  final Widget child;
  const WAnimate({super.key, required this.effects, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Hello World!")
          .animate(effects: effects)
          .fadeIn()
          .scale()
          .rotate(
            duration: const Duration(seconds: 5),
          )
          .slide(),
    );
  }
}
