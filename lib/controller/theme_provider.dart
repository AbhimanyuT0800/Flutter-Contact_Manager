import 'package:contact_with_object_box/service/theme_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_provider.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  bool build() {
    return LocalSharePrefarences.getPref();
  }

  void setTheme() {
    state = !state!;

    LocalSharePrefarences.setPref(state!);
  }
}
