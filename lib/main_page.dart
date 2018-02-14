import 'package:flutter/material.dart';
import 'package:myportfolio/bottom_bar.dart';
import 'package:myportfolio/middle_bar.dart';
import 'package:myportfolio/top_bar.dart';
import 'package:myportfolio/constants.dart';
import 'dart:math';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  double _topHeight;
  double _topScreenMaximumSize;
  double _middleHeight;
  double _widgetHeight;
  double _screenWidth;

  /// Annoyingly this is the screen height including decorations
  double _screenHeight;
  double _scrollAmount = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: _builder);
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    final Size _fullSize = constraints.biggest;

    // Have to initialise these values here as it's the earliest place where
    // I can get the screen size
    _screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    _topScreenMaximumSize =
        _screenHeight * topScreenMaximumRatio;
    _widgetHeight = _fullSize.height;

    /// TODO animate this size increase as we add and remove buttons
    _middleHeight = _screenHeight * middleScreenRatio;
    _screenWidth = _fullSize.width;

    /// Protection for null
    if (_topHeight == null) {
      _topHeight = _topScreenMaximumSize;
    }

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //Top bar, greeting - animation and size changes
        new AnimatedSize(
          child: new Container(
            height: _topHeight,
            child: new TopBar(
              widgetHeight: _topHeight,
              widgetWidth: _screenWidth,
              name: "Brendadine",
            ),

            /// TODO move this magic number into a theme or something
            color: const Color.fromARGB(255, 38, 7, 155),
            padding: const EdgeInsets.only(left: 16.0),
          ),
          duration: new Duration(milliseconds: 250),
          vsync: this,
        ),
        // Middle bar booking buttons
        new Container(
          child: new GestureDetector(
            child: new MiddleBar(
              widgetHeight: _middleHeight,
              widgetWidth: _screenWidth,
            ),
            onVerticalDragUpdate: _middleVerticalDragUpdate,
          ),
          height: _middleHeight,
        ),
        // Notifications and stuff
        /// TODO had to wrop this in a container - it would be nice to just use up the rest of the space rather than having to recalculate the bottom all the time.
        new Container(
          child: new BottomBar(
            widgetWidth: _screenWidth,
            scrollAmount: _scrollAmount,
          ),
          height: _widgetHeight - _middleHeight -_topHeight,
        ),
      ],
    );
  }

  void _middleVerticalDragUpdate(DragUpdateDetails details) {
    double _newHeight = _topHeight + details.delta.dy;
    //Protection for too small
    _newHeight = max(_newHeight, topScreenMinimumSize);
    //Too big
    _newHeight = min(_newHeight, _topScreenMaximumSize);

    // TODO - the bottom scroll is a complete hack for now - need to convert to better scrolling widget
    double _newScrollPosition = _scrollAmount;
    _newScrollPosition = max(0.0, _newScrollPosition);

    setState(() {
      _topHeight = _newHeight;
      _scrollAmount = _newScrollPosition;
    });
  }

  void _bottomVerticalDragUpdate(DragUpdateDetails details) {
    //Get the screen resized for now
    if (_topHeight > topScreenMinimumSize) {
      _middleVerticalDragUpdate(details);
    } else {
      double _setScrollAmount = _scrollAmount + details.delta.dy;
      // We can't have scrolling down screen
      _setScrollAmount = min(0.0, _setScrollAmount);
      setState(() {
        _scrollAmount = _setScrollAmount;
      });
    }
  }
}