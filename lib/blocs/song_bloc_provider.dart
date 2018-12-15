import 'package:flutter/material.dart';
import 'song_bloc.dart';
export 'song_bloc.dart';

class SongBlocProvider extends InheritedWidget {

  final bloc = SongBloc();


  SongBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static SongBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SongBlocProvider) as SongBlocProvider).bloc;
  }

}