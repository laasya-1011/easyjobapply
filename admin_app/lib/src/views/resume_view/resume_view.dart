import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ResumeViewer extends StatelessWidget {
  const ResumeViewer({Key key, @required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
