String logTruncate(String text) {
  var len = 128;
  if (text.length > len) {
    text = text.substring(0, len);
  }
  return text;
}
