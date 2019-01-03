
abstract class PreferencesStore {
  Future<double> getPreferredFontSize();
  setPreferredFontSize(double value);
  Future<bool> getPreferredTheme();
  setPreferredTheme(bool value);
  Future<bool> isFirstLaunch();
  setIsFirstLaunch();
}