///
//  Generated code. Do not modify.
//  source: payloads/schedule.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../entities/schedule.pb.dart' as $0;

class GetScheduleResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetScheduleResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.array21.tactibetter'), createEmptyInstance: create)
    ..pc<$0.ScheduleDay>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scheduleDays', $pb.PbFieldType.PM, protoName: 'scheduleDays', subBuilder: $0.ScheduleDay.create)
    ..hasRequiredFields = false
  ;

  GetScheduleResponse._() : super();
  factory GetScheduleResponse({
    $core.Iterable<$0.ScheduleDay>? scheduleDays,
  }) {
    final _result = create();
    if (scheduleDays != null) {
      _result.scheduleDays.addAll(scheduleDays);
    }
    return _result;
  }
  factory GetScheduleResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetScheduleResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetScheduleResponse clone() => GetScheduleResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetScheduleResponse copyWith(void Function(GetScheduleResponse) updates) => super.copyWith((message) => updates(message as GetScheduleResponse)) as GetScheduleResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetScheduleResponse create() => GetScheduleResponse._();
  GetScheduleResponse createEmptyInstance() => create();
  static $pb.PbList<GetScheduleResponse> createRepeated() => $pb.PbList<GetScheduleResponse>();
  @$core.pragma('dart2js:noInline')
  static GetScheduleResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetScheduleResponse>(create);
  static GetScheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.ScheduleDay> get scheduleDays => $_getList(0);
}

