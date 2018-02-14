import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MiddleBar extends StatefulWidget {
  MiddleBar({Key key,
    @required this.widgetHeight,
    @required this.widgetWidth}) : super(key: key);

  final double widgetHeight;
  final double widgetWidth;

  @override
  _MiddleBarState createState() => new _MiddleBarState();
}

class _MiddleBarState extends State<MiddleBar> {
  @override
  Widget build(BuildContext context) {
    //TODO move these hacky numbers somewhere central?
    final double _padding = widget.widgetWidth / 120;
    //Decided to do 3*padding at ends + 2*padding per gap
    final double _imageWidth = (widget.widgetWidth - (_padding * 12)) / 4;

    return new Column(
      children: <Widget>[
        new Container(
          child: new Text(
            "Book Appointments",
            style: new TextStyle(fontSize: 18.0,
                color: Colors.black54),
          ),
          width: widget.widgetWidth,
          padding: new EdgeInsets.all(_padding * 5),
        ),
        new Row(children: <Widget>[
          new Container(
            child: new Image(
              image: new AssetImage("assets/gp.png",),
              width: _imageWidth,
            ),
            padding: new EdgeInsets.only(
              left: _padding * 3,
              right: _padding,
              top: _padding,
              bottom: _padding,
            ),
          ),
          new Container(
            child: new Image(
              image: new AssetImage("assets/dentist.png",),
              width: _imageWidth,
            ),
            padding: new EdgeInsets.all(_padding),
          ),
          new Container(
            child: new Image(
              image: new AssetImage("assets/physio.png"),
              width: _imageWidth,
            ),
            padding: new EdgeInsets.all(_padding),
          ),
          new Container(
            child: new Image(
              image: new AssetImage("assets/plus.png"),
              width: _imageWidth,
            ),
            padding: new EdgeInsets.only(
              left: _padding,
              right: _padding * 3,
              top: _padding,
              bottom: _padding,
            ),
          ),
        ],)
      ],
    );
  }
}