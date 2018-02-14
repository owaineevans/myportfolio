import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key,
    @required this.widgetWidth,
    @required this.scrollAmount,}) : super(key: key);

  final double widgetWidth;
  final double scrollAmount;

  @override
  _BottomBarState createState() => new _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  static double scrollAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    //TODO move magic numbers somewhere central that is aware of the screen sizes
    double padding = widget.widgetWidth / 120;
    scrollAmount = widget.scrollAmount;

    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new Container(
          child: new Text(
            "Notifications and Appointments",
            style: new TextStyle(fontSize: 18.0,
                color: Colors.black54),
          ),
          padding: new EdgeInsets.all(padding * 5),
        ),
        makeCard(
          Icons.email,
          "Reschdule notice",
          "Please call 1300 890 456",
        ),
        makeCard(
          Icons.calendar_today,
          "GP Appointment in 3 days",
          "12:30 PM at General Hospital.",
        ),
        makeCard(
          Icons.calendar_today,
          "Physio on Tuesday next week.",
          "7:30 PM at Brenda's Phycios",
        ),
        makeCard(
          Icons.calendar_today,
          "Dentist on 30/03/18.",
          "9:30 AM at Bunnings Cannington",
        ),
      ],
    );
  }

  Widget makeCard(final IconData iconData,
      final String topText, final String bottomText) {
    return
      new Card(elevation: 4.0,
        child: new Container(
          child: new Row(
            children: <Widget>[
              new Container(
                child: new Icon(
                  iconData,
                  color: Colors.black45,
                  size: 50.0,
                ),
                padding: new EdgeInsets.all(12.0),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        topText,
                        style: new TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.left,
                      ),
                      padding: new EdgeInsets.only(left: 8.0),
                    ),
                    new Container(
                      child: new Text(
                        bottomText,
                        style: new TextStyle(fontSize: 14.0),
                        textAlign: TextAlign.left,
                      ),
                      padding: new EdgeInsets.all(8.0),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              new Container(
                child: new Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black45,
                  size: 30.0,
                ),
                padding: new EdgeInsets.all(8.0),
              ),
            ],
          ),
          padding: new EdgeInsets.all(8.0),
        ),
//      ),
      );
  }
}