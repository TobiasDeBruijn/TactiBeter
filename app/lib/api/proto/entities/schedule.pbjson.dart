///
//  Generated code. Do not modify.
//  source: entities/schedule.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use scheduleDayDescriptor instead')
const ScheduleDay$json = const {
  '1': 'ScheduleDay',
  '2': const [
    const {'1': 'date', '3': 1, '4': 1, '5': 3, '10': 'date'},
    const {'1': 'begin', '3': 2, '4': 1, '5': 3, '10': 'begin'},
    const {'1': 'end', '3': 3, '4': 1, '5': 3, '10': 'end'},
    const {'1': 'scheduleEntries', '3': 4, '4': 3, '5': 11, '6': '.dev.array21.tactibetter.ScheduleEntry', '10': 'scheduleEntries'},
  ],
};

/// Descriptor for `ScheduleDay`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleDayDescriptor = $convert.base64Decode('CgtTY2hlZHVsZURheRISCgRkYXRlGAEgASgDUgRkYXRlEhQKBWJlZ2luGAIgASgDUgViZWdpbhIQCgNlbmQYAyABKANSA2VuZBJQCg9zY2hlZHVsZUVudHJpZXMYBCADKAsyJi5kZXYuYXJyYXkyMS50YWN0aWJldHRlci5TY2hlZHVsZUVudHJ5Ug9zY2hlZHVsZUVudHJpZXM=');
@$core.Deprecated('Use scheduleEntryDescriptor instead')
const ScheduleEntry$json = const {
  '1': 'ScheduleEntry',
  '2': const [
    const {'1': 'begin', '3': 2, '4': 1, '5': 3, '10': 'begin'},
    const {'1': 'end', '3': 3, '4': 1, '5': 3, '10': 'end'},
    const {'1': 'created', '3': 4, '4': 1, '5': 3, '10': 'created'},
    const {'1': 'department', '3': 5, '4': 1, '5': 9, '10': 'department'},
    const {'1': 'task', '3': 6, '4': 1, '5': 9, '10': 'task'},
  ],
};

/// Descriptor for `ScheduleEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleEntryDescriptor = $convert.base64Decode('Cg1TY2hlZHVsZUVudHJ5EhQKBWJlZ2luGAIgASgDUgViZWdpbhIQCgNlbmQYAyABKANSA2VuZBIYCgdjcmVhdGVkGAQgASgDUgdjcmVhdGVkEh4KCmRlcGFydG1lbnQYBSABKAlSCmRlcGFydG1lbnQSEgoEdGFzaxgGIAEoCVIEdGFzaw==');
