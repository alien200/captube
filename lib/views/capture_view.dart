import 'package:http/http.dart';
import 'package:flutter/material.dart';
  
class CaptureView extends StatefulWidget {
  CaptureView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CaptureViewState createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  bool _isLoading = false;
  var _data = "Not loaded";
  var _apiURL = 'http://captube.net/api/v1/capture';
 
  void _fetchData(String url) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"url": "$url", "language": "eng"}';

    setState(() {
      _isLoading = true;
    });

    print('Calling API...');
    var response;
    try{
      response = await post(_apiURL, headers: headers, body: json);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _data = response.body;
      });
      print("Response: ${response.statusCode}");
    } else {
      throw Exception('Failed to load data');
    }
    } catch (err) {
      setState(() {
        _isLoading = false;
        _data = '$err';
      //print('Caught error: $err');
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
              ),
            RaisedButton(
              child: Text("Submit"),
                onPressed: () {
                  String text = _controller.text.toString();
                  _fetchData(text);
                  //if (!text.contains("https://")) {
                  //  text = "https://" + text;
                  //}
                  // text here will always have https://
                },
            ),
              Text(_isLoading ? "Loading.." : _data),
            ],
          ),
        ),   
    );
  }
}

