import 'package:flutter/material.dart';
import 'package:mockpedia/services/constant.dart';

class PreviewQuesiton extends StatelessWidget {
  final String question;
  final List options;

  const PreviewQuesiton({Key key, this.question, this.options})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview Question"),
      ),
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: ResultMockPlayTile(
            question: question,
            options: options,
          ),
        ),
      ),
    );
  }
}

class ResultMockPlayTile extends StatefulWidget {
  final List options;
  final String question;

  const ResultMockPlayTile({Key key, this.options, this.question})
      : super(key: key);

  @override
  _ResultMockPlayTileState createState() => _ResultMockPlayTileState();
}

class _ResultMockPlayTileState extends State<ResultMockPlayTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            Constants.myBoxShadow(),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Q - " + widget.question,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ResultOptionTile(
              option: "A",
              description: widget.options[0],
            ),
            ResultOptionTile(
              option: "B",
              description: widget.options[1],
            ),
            ResultOptionTile(
              option: "C",
              description: widget.options[2],
            ),
            ResultOptionTile(
              option: "D",
              description: widget.options[3],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultOptionTile extends StatefulWidget {
  final String option, description;
  ResultOptionTile({
    @required this.option,
    @required this.description,
  });

  @override
  _ResultOptionTileState createState() => _ResultOptionTileState();
}

class _ResultOptionTileState extends State<ResultOptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3.0,
        ),
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
            ),
          ),
          Expanded(
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 20,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
