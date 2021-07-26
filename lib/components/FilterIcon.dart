import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final int? count;
  final void Function() onPressed;
  const FilterIcon({Key? key, this.count, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new IconButton(icon: Icon(Icons.filter_alt), onPressed: onPressed),
        count != null
            ? new Positioned(
                right: 10,
                top: 10,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : new Container()
      ],
    );
  }
}
