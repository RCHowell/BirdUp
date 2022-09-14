///
//  Generated code. Do not modify.
//  source: model.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Location extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Location', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'birdup'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  Location._() : super();
  factory Location({
    $core.int? id,
    $core.String? name,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory Location.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Location.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Location clone() => Location()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Location copyWith(void Function(Location) updates) => super.copyWith((message) => updates(message as Location)) as Location; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  Location createEmptyInstance() => create();
  static $pb.PbList<Location> createRepeated() => $pb.PbList<Location>();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class History extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'History', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'birdup'), createEmptyInstance: create)
    ..p<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'times', $pb.PbFieldType.KU3)
    ..p<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temp', $pb.PbFieldType.KF)
    ..p<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'windSpeed', $pb.PbFieldType.KF, protoName: 'windSpeed')
    ..p<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'windDirection', $pb.PbFieldType.KF, protoName: 'windDirection')
    ..p<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pressure', $pb.PbFieldType.KF)
    ..p<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'humidity', $pb.PbFieldType.KF)
    ..hasRequiredFields = false
  ;

  History._() : super();
  factory History({
    $core.Iterable<$core.int>? times,
    $core.Iterable<$core.double>? temp,
    $core.Iterable<$core.double>? windSpeed,
    $core.Iterable<$core.double>? windDirection,
    $core.Iterable<$core.double>? pressure,
    $core.Iterable<$core.double>? humidity,
  }) {
    final _result = create();
    if (times != null) {
      _result.times.addAll(times);
    }
    if (temp != null) {
      _result.temp.addAll(temp);
    }
    if (windSpeed != null) {
      _result.windSpeed.addAll(windSpeed);
    }
    if (windDirection != null) {
      _result.windDirection.addAll(windDirection);
    }
    if (pressure != null) {
      _result.pressure.addAll(pressure);
    }
    if (humidity != null) {
      _result.humidity.addAll(humidity);
    }
    return _result;
  }
  factory History.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory History.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  History clone() => History()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  History copyWith(void Function(History) updates) => super.copyWith((message) => updates(message as History)) as History; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static History create() => History._();
  History createEmptyInstance() => create();
  static $pb.PbList<History> createRepeated() => $pb.PbList<History>();
  @$core.pragma('dart2js:noInline')
  static History getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<History>(create);
  static History? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get times => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.double> get temp => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.double> get windSpeed => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.double> get windDirection => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$core.double> get pressure => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$core.double> get humidity => $_getList(5);
}

class Sample extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Sample', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'birdup'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'location', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp', $pb.PbFieldType.OU3)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temp', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempMax', $pb.PbFieldType.OF, protoName: 'tempMax')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tempMin', $pb.PbFieldType.OF, protoName: 'tempMin')
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pressure', $pb.PbFieldType.OF)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'humidity', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'windSpeed', $pb.PbFieldType.OF, protoName: 'windSpeed')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'windSpeedMax', $pb.PbFieldType.OF, protoName: 'windSpeedMax')
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'windDirection', $pb.PbFieldType.OF, protoName: 'windDirection')
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltage', $pb.PbFieldType.OF)
    ..a<$core.double>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltageMax', $pb.PbFieldType.OF, protoName: 'voltageMax')
    ..a<$core.double>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voltageMin', $pb.PbFieldType.OF, protoName: 'voltageMin')
    ..a<$core.double>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'a', $pb.PbFieldType.OF)
    ..a<$core.double>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'aMax', $pb.PbFieldType.OF, protoName: 'aMax')
    ..a<$core.double>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'r', $pb.PbFieldType.OF)
    ..a<$core.double>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ex', $pb.PbFieldType.OF)
    ..a<$core.double>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ed', $pb.PbFieldType.OF)
    ..a<$core.double>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'er', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Sample._() : super();
  factory Sample({
    $core.int? location,
    $core.int? timestamp,
    $core.double? temp,
    $core.double? tempMax,
    $core.double? tempMin,
    $core.double? pressure,
    $core.double? humidity,
    $core.double? windSpeed,
    $core.double? windSpeedMax,
    $core.double? windDirection,
    $core.double? voltage,
    $core.double? voltageMax,
    $core.double? voltageMin,
    $core.double? a,
    $core.double? aMax,
    $core.double? r,
    $core.double? ex,
    $core.double? ed,
    $core.double? er,
  }) {
    final _result = create();
    if (location != null) {
      _result.location = location;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (temp != null) {
      _result.temp = temp;
    }
    if (tempMax != null) {
      _result.tempMax = tempMax;
    }
    if (tempMin != null) {
      _result.tempMin = tempMin;
    }
    if (pressure != null) {
      _result.pressure = pressure;
    }
    if (humidity != null) {
      _result.humidity = humidity;
    }
    if (windSpeed != null) {
      _result.windSpeed = windSpeed;
    }
    if (windSpeedMax != null) {
      _result.windSpeedMax = windSpeedMax;
    }
    if (windDirection != null) {
      _result.windDirection = windDirection;
    }
    if (voltage != null) {
      _result.voltage = voltage;
    }
    if (voltageMax != null) {
      _result.voltageMax = voltageMax;
    }
    if (voltageMin != null) {
      _result.voltageMin = voltageMin;
    }
    if (a != null) {
      _result.a = a;
    }
    if (aMax != null) {
      _result.aMax = aMax;
    }
    if (r != null) {
      _result.r = r;
    }
    if (ex != null) {
      _result.ex = ex;
    }
    if (ed != null) {
      _result.ed = ed;
    }
    if (er != null) {
      _result.er = er;
    }
    return _result;
  }
  factory Sample.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Sample.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Sample clone() => Sample()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Sample copyWith(void Function(Sample) updates) => super.copyWith((message) => updates(message as Sample)) as Sample; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Sample create() => Sample._();
  Sample createEmptyInstance() => create();
  static $pb.PbList<Sample> createRepeated() => $pb.PbList<Sample>();
  @$core.pragma('dart2js:noInline')
  static Sample getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sample>(create);
  static Sample? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get location => $_getIZ(0);
  @$pb.TagNumber(1)
  set location($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get timestamp => $_getIZ(1);
  @$pb.TagNumber(2)
  set timestamp($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get temp => $_getN(2);
  @$pb.TagNumber(3)
  set temp($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTemp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemp() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get tempMax => $_getN(3);
  @$pb.TagNumber(4)
  set tempMax($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTempMax() => $_has(3);
  @$pb.TagNumber(4)
  void clearTempMax() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get tempMin => $_getN(4);
  @$pb.TagNumber(5)
  set tempMin($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTempMin() => $_has(4);
  @$pb.TagNumber(5)
  void clearTempMin() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get pressure => $_getN(5);
  @$pb.TagNumber(6)
  set pressure($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPressure() => $_has(5);
  @$pb.TagNumber(6)
  void clearPressure() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get humidity => $_getN(6);
  @$pb.TagNumber(7)
  set humidity($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasHumidity() => $_has(6);
  @$pb.TagNumber(7)
  void clearHumidity() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get windSpeed => $_getN(7);
  @$pb.TagNumber(8)
  set windSpeed($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasWindSpeed() => $_has(7);
  @$pb.TagNumber(8)
  void clearWindSpeed() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get windSpeedMax => $_getN(8);
  @$pb.TagNumber(9)
  set windSpeedMax($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasWindSpeedMax() => $_has(8);
  @$pb.TagNumber(9)
  void clearWindSpeedMax() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get windDirection => $_getN(9);
  @$pb.TagNumber(10)
  set windDirection($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasWindDirection() => $_has(9);
  @$pb.TagNumber(10)
  void clearWindDirection() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get voltage => $_getN(10);
  @$pb.TagNumber(11)
  set voltage($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasVoltage() => $_has(10);
  @$pb.TagNumber(11)
  void clearVoltage() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get voltageMax => $_getN(11);
  @$pb.TagNumber(12)
  set voltageMax($core.double v) { $_setFloat(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasVoltageMax() => $_has(11);
  @$pb.TagNumber(12)
  void clearVoltageMax() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get voltageMin => $_getN(12);
  @$pb.TagNumber(13)
  set voltageMin($core.double v) { $_setFloat(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasVoltageMin() => $_has(12);
  @$pb.TagNumber(13)
  void clearVoltageMin() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get a => $_getN(13);
  @$pb.TagNumber(14)
  set a($core.double v) { $_setFloat(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasA() => $_has(13);
  @$pb.TagNumber(14)
  void clearA() => clearField(14);

  @$pb.TagNumber(15)
  $core.double get aMax => $_getN(14);
  @$pb.TagNumber(15)
  set aMax($core.double v) { $_setFloat(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasAMax() => $_has(14);
  @$pb.TagNumber(15)
  void clearAMax() => clearField(15);

  @$pb.TagNumber(16)
  $core.double get r => $_getN(15);
  @$pb.TagNumber(16)
  set r($core.double v) { $_setFloat(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasR() => $_has(15);
  @$pb.TagNumber(16)
  void clearR() => clearField(16);

  @$pb.TagNumber(17)
  $core.double get ex => $_getN(16);
  @$pb.TagNumber(17)
  set ex($core.double v) { $_setFloat(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasEx() => $_has(16);
  @$pb.TagNumber(17)
  void clearEx() => clearField(17);

  @$pb.TagNumber(18)
  $core.double get ed => $_getN(17);
  @$pb.TagNumber(18)
  set ed($core.double v) { $_setFloat(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasEd() => $_has(17);
  @$pb.TagNumber(18)
  void clearEd() => clearField(18);

  @$pb.TagNumber(19)
  $core.double get er => $_getN(18);
  @$pb.TagNumber(19)
  set er($core.double v) { $_setFloat(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasEr() => $_has(18);
  @$pb.TagNumber(19)
  void clearEr() => clearField(19);
}

