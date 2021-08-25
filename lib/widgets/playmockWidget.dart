import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  OptionTile(
      {@required this.option,
      @required this.description,
      @required this.correctAnswer,
      @required this.optionSelected});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.optionSelected != widget.description
              ? Colors.black.withOpacity(0.8)
              : Colors.blue.withOpacity(0.8),
          width: 3.0,
        ),
        color: widget.optionSelected == widget.description
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.option + " :- ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.optionSelected == widget.description
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.8),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 20,
                color: widget.optionSelected == widget.description
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8),
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
