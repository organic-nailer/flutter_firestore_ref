import 'package:firestore_ref/firestore_ref.dart';
import 'package:cloud_firestore/cloud_firestore' hide FieldValue;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

mixin HasTimestamp {
  DateTime get createdAt;
  DateTime get updatedAt;

  Map<String, dynamic> get timestampJson {
    return <String, dynamic>{
      if (createdAt == null)
        TimestampField.createdAt: FieldValue.serverTimestamp(),
      TimestampField.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static DateTime parseCreatedAt(Map<String, dynamic> json) {
    return _parseTimestamp(json: json, key: TimestampField.createdAt);
  }

  static DateTime parseUpdatedAt(Map<String, dynamic> json) {
    return _parseTimestamp(json: json, key: TimestampField.updatedAt);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HasTimestamp &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => createdAt.hashCode ^ updatedAt.hashCode;
}

class TimestampField {
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

DateTime _parseTimestamp({
  @required Map<String, dynamic> json,
  @required String key,
}) {
  return dateFromTimestampValue(json[key]);
}

DateTime dateFromTimestampValue(dynamic value) =>
    (value as Timestamp)?.toDate();

Timestamp timestampFromDateValue(dynamic value) =>
    value is DateTime ? Timestamp.fromDate(value) : null;

const timestampJsonKey = JsonKey(
  fromJson: dateFromTimestampValue,
  toJson: timestampFromDateValue,
);
