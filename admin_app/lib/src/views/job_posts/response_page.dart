import 'package:admin_app/src/widgets/response_card.dart';
import 'package:flutter/material.dart';

class ResponsePage extends StatefulWidget {
  final String userId;
  final String jobTitle;
  final bool selected;
  final bool tapWork;
  final String response;
  ResponsePage(
      {this.jobTitle, this.selected, this.userId, this.response, this.tapWork});
  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          width: width,
          height: height,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              ResponseCard(
                  jobTitle: widget.jobTitle,
                  selected: widget.selected,
                  context: context,
                  userId: widget.userId,
                  tapWork: false),
              Container(
                alignment: Alignment.topCenter,
                width: width,
                margin: EdgeInsets.fromLTRB(35, 35, 35, 4),
                child: Text(
                  'Admin Feedback',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: width,
                margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
                child: Text(widget.response,
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                    textAlign: TextAlign.justify),
              ),
            ],
          ),
        ));
  }
}
