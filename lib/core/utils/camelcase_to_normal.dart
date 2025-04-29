String camelCaseToNormal(String camelCaseString) {
  final regExp = RegExp(r'([a-z])([A-Z])');
  // Add space between lowercase and uppercase letters
  String result = camelCaseString.replaceAllMapped(regExp, (match) {
    return '${match.group(1)} ${match.group(2)}';
  });
  // Capitalize the first letter of the result
  return result[0].toUpperCase() + result.substring(1);
}
