import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:myportfolio/constants.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key key,
    @required this.widgetHeight,
    @required this.widgetWidth,
    @required this.name}) : super(key: key);

  final double widgetHeight;
  final double widgetWidth;
  final String name;

  @override
  _State createState() => new _State();
}

//Feels a bit hacky - but need to get screen size to the _MultiChildDelegate
double _screenWidth;
double _screenHeight;

class _State extends State<TopBar> {

  @override
  Widget build(BuildContext context) {
    // Need the context for this information - note it includes the decoration.
    _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    _screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return new CustomMultiChildLayout(
      delegate: new _MultiChildDelegate(),
      children: <Widget>[
        new LayoutId(
          id: _iconId,
          child: new Container(
            child: new Image(
              image: new AssetImage("assets/he-logo.png"),
            ),
            height: topScreenMinimumSize,
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
          ),
        ),
        new LayoutId(
          id: _healthId,
          child: new RichText(
            text: new TextSpan(
                style: const TextStyle(
                  fontSize: topFontSize,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: "Breath",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const TextSpan(
                    text: "Engine",
                  ),
                ]
            ),
          ),
        ),
        new LayoutId(
          id: _greetingId,
          child: const Text(
            "Good morning",
            style: const TextStyle(
              fontSize: topFontSize,
              color: Colors.white,
            ),
          ),
        ),
        new LayoutId(
          id: _nameId,
          child: new Text(
            widget.name,
            style: const TextStyle(
              fontSize: topFontSize,
              color: Colors.white,
            ),
          ),
        ),
        new LayoutId(
          id: _sId,
          child: const Text("'s ",
            style: const TextStyle(
              fontSize: topFontSize,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

//TODO move somewhere better?
const String _iconId = "icon";
const String _healthId = "health";
const String _greetingId = "greeting";
const String _nameId = "name";
const String _sId = "s";

class _MultiChildDelegate extends MultiChildLayoutDelegate {
  /// Trying to animate text transition - not too sure whether to do it in the build or here
  /// here is more convenient because I know the size
  /// I suspect to change the font size I need to be in build, so I suspect I'll have to do it in both

  @override
  void performLayout(Size size) {
    //Icon is always shown and size does not change
    final Size iconSize = layoutChild(_iconId, new BoxConstraints.loose(size));
    positionChild(_iconId, Offset.zero);
    //HealthEngine moves to the right when bar shrinks
    final Size healthSize = layoutChild(
        _healthId, new BoxConstraints.loose(size));
    final Size greetingSize = layoutChild(
        _greetingId, new BoxConstraints.loose(size));
    final Size nameSize = layoutChild(_nameId, new BoxConstraints.loose(size));
    final Size sSize = layoutChild(_sId, new BoxConstraints.loose(size));

    //Calculate where we are on the animation path in convenient 0.0 -> 1
    final double delta = 1.0 - (size.height - topScreenMinimumSize) /
        ((topScreenMaximumRatio * _screenHeight) - topScreenMinimumSize);
    //divide up the vertical black space by 3 to space things equally
    double space = size.height - iconSize.height - greetingSize.height -
        nameSize.height;
    space = space / 3;
    // Start moving things with the delta
    // HeathEngine text only moves horizontally
    final double healthXPos = new Tween<double>(
        begin: iconSize.width,
        end: (iconSize.width + nameSize.width + sSize.width)).lerp(delta);
    final double healthYPos = (iconSize.height - healthSize.height) / 2;
    // Name will move in X and Y
    final double nameXPos = new Tween<double>(
        begin: 0.0,
        end: iconSize.width).lerp(delta);
    final double nameYPos = new Tween<double>(
        begin: (_screenHeight * topScreenMaximumRatio - space -
            nameSize.height),
        end: (iconSize.height - nameSize.height) / 2).lerp(delta);
    // Greeting text might need a speedup as it clips the name
    // TODO added a magic number here as it clips the name - maybe use a different curve in future
    final double greetingXPos = new Tween<double>(
        begin: 0.0,
        end: (-greetingSize.width * 1.5)).lerp(delta);
    // Keep "'s" off screen until it's needed
    // TODO flutter complains if I do not positionChild - hopefully as it's off screen it's not a concern
    // TODO another magic number for the start position
    final double sYPos = new Tween<double>(
        begin: -300.0,
        end: (iconSize.height - nameSize.height) / 2).lerp(delta);
    //Position health
    positionChild(_healthId,
        new Offset(healthXPos, healthYPos));
    //Position greeting
    positionChild(
        _greetingId, new Offset(greetingXPos, iconSize.height + space));
    //Position name
    positionChild(
        _nameId, new Offset(nameXPos, nameYPos));
    //Position 's
    positionChild(_sId, new Offset(iconSize.width + nameSize.width, sYPos));
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}