import 'package:flutter/material.dart';
import '../blocs/song_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    bloc.fetchFontSize();
  }

  @override
  void dispose() {
    bloc.resetFont();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bloc.fetchTheme();

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
                  initialData:
                      bloc.fontSizeValue != null ? bloc.fontSizeValue : 24.0,
                  builder: (context, AsyncSnapshot<double> snapshot) {
                    return Column(children: [
                      Text(
                        'Lyrics - ${snapshot.hasData ? snapshot.data.floor() : 24.0}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: snapshot.hasData ? snapshot.data : 24.0,
                        ),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        min: 11.0,
                        max: 72.0,
                        onChanged: bloc.onFontSizeChanged,
                        value: snapshot.hasData ? snapshot.data : 24.0,
                      ),
                    ]);
                  }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.white,
            height: 1.0,
          ),
        ),
        StreamBuilder(
          stream: bloc.theme,
          initialData: false,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return SwitchListTile(
              value: snapshot.hasData ? snapshot.data : false,
              onChanged: (v) => bloc.themeValueChanged(v),
              title: Text('Theme', style: TextStyle(color: Colors.white)),
              inactiveTrackColor: snapshot.hasData && snapshot.data ? Colors.white : Colors.grey[900],
              activeTrackColor: snapshot.hasData && snapshot.data ? Colors.white : Colors.grey[900],
            );
          },
        )
      ],
    );
  }

  onSavePressed() {
    bloc.saveSettingsPressed();
    Navigator.pop(context);
  }
}
