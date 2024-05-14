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
