dynamic parseStringField(dynamic value) {
  if (value is int) {
    return value.toString();
  }
  if (value is List) {
    for (var item in value) {
      if (item is String) {
        return item;
      }
    }
    return null;
  }
  return (value is bool) ? null : value as String?;
}

int? parseIntField(dynamic value) {
  if (value is double) {
    return value.toInt();
  } else if (value is bool) {
    return null;
  } else if (value is List){
    return value[0] as int?;
  } else {
    return (value is int) ? value : null;
  }
}

double? parseDoubleField(dynamic value) {
  if (value is String) {
    try {
      return double.parse(value);
    } on FormatException {
      return null;
    }
  } else if (value is num) {
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

int? parseListToInt(dynamic list) {
  if (list is! List) {
    return null;
  }
  for (var item in list) {
    if (item is bool) {
      return null;
    }
    if (item is int) {
      return item;
    }
  }
  return null;
}

List<int>? parseListInt(dynamic list) {
  if (list is int) {
    return [list];
  }
  final List<dynamic>? listJson = list;
  List<int>? parse;
  if (listJson != null) {
    parse = [];
    for (var id in listJson) {
      if (id is int) {
        parse.add(id);
      } else {
        print('No hay int en la lista: $id');
      }
    }
  }
  return parse;
}

