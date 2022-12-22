bool isDigit(String s) {
  try {
    int.parse(s);
    return true;
  } catch (e) {
    return false;
  }
}