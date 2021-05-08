import 'package:admin_app/src/views/job_posts/applications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget jobCard(
    {BuildContext context,
    String jobTitle,
    String description,
    DocumentSnapshot doc}) {
  return Container(
    alignment: Alignment.topCenter,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.22,
    margin: EdgeInsets.fromLTRB(25, 3, 25, 25),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 2)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              width: MediaQuery.of(context).size.width * 0.03,
              height: MediaQuery.of(context).size.width * 0.03,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                jobTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            description,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 11),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Applications(
                        doc: doc,
                      )),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.red,
            ),
            child: Text(
              'View Applications',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10),
            ),
          ),
        ),
      ],
    ),
  );
}
