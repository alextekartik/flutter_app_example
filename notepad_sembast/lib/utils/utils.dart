String logTruncate(String text) {
  int len = 128;
  if (text != null && text.length > len) {
    text = text.substring(0, len);
  }
  return text;
}
