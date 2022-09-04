import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/ortapazar_auth.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    init();
  }

  void init() {}

  Future<void> signOut() async {
    await OrtapazarAuth().signOutGoogle();
  }
}
