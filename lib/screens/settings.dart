import 'package:flutter/material.dart';
import '../blocs/song_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  void dispose() {
    bloc.resetFont();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildSettingsBody(),
      backgroundColor: Color(0xDD212121),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      centerTitle: true,
      title: Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () => onSavePressed(),
          child: Center(
            child: Text(
              'Save',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSettingsBody() {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: StreamBuilder(
                  stream: bloc.fontSize,
                  initialData: 24.0,
                  builder: (context, AsyncSnapshot<double> snapshot) {
                    return Column(
                      children: [
                        Text(
                          'Font Size - ${snapshot.data.floor()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: snapshot.data
                          ),
                        ),
                        Slider(
                        activeColor: Colors.white,
                        min: 11.0,
                        max: 72.0,
                        onChanged: bloc.onFontSizeChanged,
                        value: snapshot.data,
                      ),
                      ]
                    );
                  }),
            )
          ],
        ),
      ],
    );
  }

  onSavePressed() {
    bloc.saveSettingsPressed();
    Navigator.pop(context);
  }
}
