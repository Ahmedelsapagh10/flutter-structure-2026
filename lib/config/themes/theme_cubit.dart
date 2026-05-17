import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_strucuture/core/preferences/flutter_secure_storage.dart';
import 'package:new_strucuture/core/utils/restart_app_class.dart';
import 'package:one_context/one_context.dart';
import 'theme_noti.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    bool isDark = await MySecureStorage.getIsDark();
    ThemeNotifier.isDarkMode = isDark;
    ThemeNotifier.themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme(BuildContext context) async {
    final isDark = state == ThemeMode.dark;
    final newIsDark = !isDark;
    
    await MySecureStorage.setIsDark(newIsDark);
    ThemeNotifier.isDarkMode = newIsDark;
    ThemeNotifier.themeModeNotifier.value = newIsDark ? ThemeMode.dark : ThemeMode.light;
    
    emit(newIsDark ? ThemeMode.dark : ThemeMode.light);
    
    try {
      HotRestartController.performHotRestart(context);
    } catch (e) {
      log("Error reloading layout: ${e.toString()}");
    }
    
    log("Theme toggled: isDarkMode=$newIsDark");
  }
}
