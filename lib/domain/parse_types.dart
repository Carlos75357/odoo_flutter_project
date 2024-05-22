/// Check if the field is null or bool, if so, return null else return the value
dynamic parseStringField(dynamic value) {
  return (value is bool) ? null : value as String?;
}

/// Check if the field is bool, if so, return null else return the value parsed to int
int? parseIntField(dynamic value) {
  if (value is double) {
    return value.toInt();
  } else if (value is bool) {
    return null;
  } else {
    return value[0] as int?;
  }
}

/// Check if the field is bool, if so, return null else return the value parsed to double
double? parseDoublefield(dynamic value) {
  if (value is int || value is double) {
    return value.toDouble();
  } else {
    return null;
  }
}

String? parseListToString(dynamic list) {
  if (list is! List) {
    return null;
  }
  for (var item in list) {
    if (item is bool) {
      return null;
    }
    if (item is String) {
      return item;
    }
  }
  return null;
}

List<int>? parseListInt(dynamic list) {
  final List<dynamic>? listJson = list;
  List<int>? parse;
  if (listJson != null) {
    parse = listJson.map<int>((dynamic id) => id as int).toList();
  }
  return null;
}