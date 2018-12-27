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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget buildAppBar() {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      title: Text(
        'Settings',
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: () => onSavePressed(),
            child: Center(
              child: Text(
                'Save',
                style:
                    Theme.of(context).textTheme.title,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSettingsBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
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
                          'Size - ${snapshot.hasData ? snapshot.data.floor() : 24.0}',
                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: snapshot.hasData ? snapshot.data : 24.0,
                          ),
                        ),
                        Slider(
                          activeColor: Theme.of(context).accentColor,
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Theme.of(context).accentColor,
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
              title: Text('Theme', style: Theme.of(context).textTheme.title),
              inactiveTrackColor: Theme.of(context).accentColor,
              activeTrackColor: Theme.of(context).accentColor,
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
