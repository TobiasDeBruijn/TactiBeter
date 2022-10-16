///
//  Generated code. Do not modify.
//  source: payloads/timesheet.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../entities/timesheet.pb.dart' as $1;

class SaveTimesheetRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SaveTimesheetRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.array21.tactibetter'), createEmptyInstance: create)
    ..pc<$1.TimesheetBlock>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blocks', $pb.PbFieldType.PM, subBuilder: $1.TimesheetBlock.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'note')
    ..hasRequiredFields = false
  ;

  SaveTimesheetRequest._() : super();
  factory SaveTimesheetRequest({
    $core.Iterable<$1.TimesheetBlock>? blocks,
    $core.String? note,
  }) {
    final _result = create();
    if (blocks != null) {
      _result.blocks.addAll(blocks);
    }
    if (note != null) {
      _result.note = note;
    }
    return _result;
  }
  factory SaveTimesheetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SaveTimesheetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SaveTimesheetRequest clone() => SaveTimesheetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SaveTimesheetRequest copyWith(void Function(SaveTimesheetRequest) updates) => super.copyWith((message) => updates(message as SaveTimesheetRequest)) as SaveTimesheetRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SaveTimesheetRequest create() => SaveTimesheetRequest._();
  SaveTimesheetRequest createEmptyInstance() => create();
  static $pb.PbList<SaveTimesheetRequest> createRepeated() => $pb.PbList<SaveTimesheetRequest>();
  @$core.pragma('dart2js:noInline')
  static SaveTimesheetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveTimesheetRequest>(create);
  static SaveTimesheetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$1.TimesheetBlock> get blocks => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => clearField(2);
}

