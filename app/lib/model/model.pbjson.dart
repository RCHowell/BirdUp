///
//  Generated code. Do not modify.
//  source: model.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use locationDescriptor instead')
const Location$json = const {
  '1': 'Location',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode('CghMb2NhdGlvbhIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZQ==');
@$core.Deprecated('Use historyDescriptor instead')
const History$json = const {
  '1': 'History',
  '2': const [
    const {'1': 'times', '3': 1, '4': 3, '5': 13, '10': 'times'},
    const {'1': 'temp', '3': 2, '4': 3, '5': 2, '10': 'temp'},
    const {'1': 'windSpeed', '3': 3, '4': 3, '5': 2, '10': 'windSpeed'},
    const {'1': 'windDirection', '3': 4, '4': 3, '5': 2, '10': 'windDirection'},
    const {'1': 'pressure', '3': 5, '4': 3, '5': 2, '10': 'pressure'},
    const {'1': 'humidity', '3': 6, '4': 3, '5': 2, '10': 'humidity'},
  ],
};

/// Descriptor for `History`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyDescriptor = $convert.base64Decode('CgdIaXN0b3J5EhQKBXRpbWVzGAEgAygNUgV0aW1lcxISCgR0ZW1wGAIgAygCUgR0ZW1wEhwKCXdpbmRTcGVlZBgDIAMoAlIJd2luZFNwZWVkEiQKDXdpbmREaXJlY3Rpb24YBCADKAJSDXdpbmREaXJlY3Rpb24SGgoIcHJlc3N1cmUYBSADKAJSCHByZXNzdXJlEhoKCGh1bWlkaXR5GAYgAygCUghodW1pZGl0eQ==');
@$core.Deprecated('Use sampleDescriptor instead')
const Sample$json = const {
  '1': 'Sample',
  '2': const [
    const {'1': 'location', '3': 1, '4': 1, '5': 5, '10': 'location'},
    const {'1': 'timestamp', '3': 2, '4': 1, '5': 13, '10': 'timestamp'},
    const {'1': 'temp', '3': 3, '4': 1, '5': 2, '10': 'temp'},
    const {'1': 'tempMax', '3': 4, '4': 1, '5': 2, '10': 'tempMax'},
    const {'1': 'tempMin', '3': 5, '4': 1, '5': 2, '10': 'tempMin'},
    const {'1': 'pressure', '3': 6, '4': 1, '5': 2, '10': 'pressure'},
    const {'1': 'humidity', '3': 7, '4': 1, '5': 2, '10': 'humidity'},
    const {'1': 'windSpeed', '3': 8, '4': 1, '5': 2, '10': 'windSpeed'},
    const {'1': 'windSpeedMax', '3': 9, '4': 1, '5': 2, '10': 'windSpeedMax'},
    const {'1': 'windDirection', '3': 10, '4': 1, '5': 2, '10': 'windDirection'},
    const {'1': 'voltage', '3': 11, '4': 1, '5': 2, '10': 'voltage'},
    const {'1': 'voltageMax', '3': 12, '4': 1, '5': 2, '10': 'voltageMax'},
    const {'1': 'voltageMin', '3': 13, '4': 1, '5': 2, '10': 'voltageMin'},
    const {'1': 'a', '3': 14, '4': 1, '5': 2, '10': 'a'},
    const {'1': 'aMax', '3': 15, '4': 1, '5': 2, '10': 'aMax'},
    const {'1': 'r', '3': 16, '4': 1, '5': 2, '10': 'r'},
    const {'1': 'ex', '3': 17, '4': 1, '5': 2, '10': 'ex'},
    const {'1': 'ed', '3': 18, '4': 1, '5': 2, '10': 'ed'},
    const {'1': 'er', '3': 19, '4': 1, '5': 2, '10': 'er'},
  ],
};

/// Descriptor for `Sample`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleDescriptor = $convert.base64Decode('CgZTYW1wbGUSGgoIbG9jYXRpb24YASABKAVSCGxvY2F0aW9uEhwKCXRpbWVzdGFtcBgCIAEoDVIJdGltZXN0YW1wEhIKBHRlbXAYAyABKAJSBHRlbXASGAoHdGVtcE1heBgEIAEoAlIHdGVtcE1heBIYCgd0ZW1wTWluGAUgASgCUgd0ZW1wTWluEhoKCHByZXNzdXJlGAYgASgCUghwcmVzc3VyZRIaCghodW1pZGl0eRgHIAEoAlIIaHVtaWRpdHkSHAoJd2luZFNwZWVkGAggASgCUgl3aW5kU3BlZWQSIgoMd2luZFNwZWVkTWF4GAkgASgCUgx3aW5kU3BlZWRNYXgSJAoNd2luZERpcmVjdGlvbhgKIAEoAlINd2luZERpcmVjdGlvbhIYCgd2b2x0YWdlGAsgASgCUgd2b2x0YWdlEh4KCnZvbHRhZ2VNYXgYDCABKAJSCnZvbHRhZ2VNYXgSHgoKdm9sdGFnZU1pbhgNIAEoAlIKdm9sdGFnZU1pbhIMCgFhGA4gASgCUgFhEhIKBGFNYXgYDyABKAJSBGFNYXgSDAoBchgQIAEoAlIBchIOCgJleBgRIAEoAlICZXgSDgoCZWQYEiABKAJSAmVkEg4KAmVyGBMgASgCUgJlcg==');
