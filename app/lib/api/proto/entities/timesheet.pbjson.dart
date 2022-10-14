///
//  Generated code. Do not modify.
//  source: entities/timesheet.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use timesheetDescriptor instead')
const Timesheet$json = const {
  '1': 'Timesheet',
  '2': const [
    const {'1': 'departments', '3': 1, '4': 3, '5': 11, '6': '.dev.array21.tactibetter.NamedId', '10': 'departments'},
    const {'1': 'task_groups', '3': 2, '4': 3, '5': 11, '6': '.dev.array21.tactibetter.NamedId', '10': 'taskGroups'},
    const {'1': 'noteText', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'noteText', '17': true},
    const {'1': 'blocks', '3': 4, '4': 3, '5': 11, '6': '.dev.array21.tactibetter.TimesheetBlock', '10': 'blocks'},
  ],
  '8': const [
    const {'1': '_noteText'},
  ],
};

/// Descriptor for `Timesheet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timesheetDescriptor = $convert.base64Decode('CglUaW1lc2hlZXQSQgoLZGVwYXJ0bWVudHMYASADKAsyIC5kZXYuYXJyYXkyMS50YWN0aWJldHRlci5OYW1lZElkUgtkZXBhcnRtZW50cxJBCgt0YXNrX2dyb3VwcxgCIAMoCzIgLmRldi5hcnJheTIxLnRhY3RpYmV0dGVyLk5hbWVkSWRSCnRhc2tHcm91cHMSHwoIbm90ZVRleHQYAyABKAlIAFIIbm90ZVRleHSIAQESPwoGYmxvY2tzGAQgAygLMicuZGV2LmFycmF5MjEudGFjdGliZXR0ZXIuVGltZXNoZWV0QmxvY2tSBmJsb2Nrc0ILCglfbm90ZVRleHQ=');
@$core.Deprecated('Use namedIdDescriptor instead')
const NamedId$json = const {
  '1': 'NamedId',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `NamedId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List namedIdDescriptor = $convert.base64Decode('CgdOYW1lZElkEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1l');
@$core.Deprecated('Use timesheetBlockDescriptor instead')
const TimesheetBlock$json = const {
  '1': 'TimesheetBlock',
  '2': const [
    const {'1': 'date', '3': 1, '4': 1, '5': 3, '10': 'date'},
    const {'1': 'begin', '3': 2, '4': 1, '5': 3, '10': 'begin'},
    const {'1': 'end', '3': 3, '4': 1, '5': 3, '10': 'end'},
    const {'1': 'department', '3': 4, '4': 1, '5': 9, '10': 'department'},
    const {'1': 'task', '3': 5, '4': 1, '5': 9, '10': 'task'},
    const {'1': 'submitted', '3': 6, '4': 1, '5': 8, '10': 'submitted'},
    const {'1': 'approved', '3': 7, '4': 1, '5': 8, '10': 'approved'},
  ],
};

/// Descriptor for `TimesheetBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timesheetBlockDescriptor = $convert.base64Decode('Cg5UaW1lc2hlZXRCbG9jaxISCgRkYXRlGAEgASgDUgRkYXRlEhQKBWJlZ2luGAIgASgDUgViZWdpbhIQCgNlbmQYAyABKANSA2VuZBIeCgpkZXBhcnRtZW50GAQgASgJUgpkZXBhcnRtZW50EhIKBHRhc2sYBSABKAlSBHRhc2sSHAoJc3VibWl0dGVkGAYgASgIUglzdWJtaXR0ZWQSGgoIYXBwcm92ZWQYByABKAhSCGFwcHJvdmVk');
