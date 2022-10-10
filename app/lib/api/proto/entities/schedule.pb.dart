///
//  Generated code. Do not modify.
//  source: entities/schedule.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Schedule extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Schedule', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.array21.tactibetter'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'date')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'begin')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'end')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'created')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'department')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'task')
    ..hasRequiredFields = false
  ;

  Schedule._() : super();
  factory Schedule({
    $fixnum.Int64? date,
    $fixnum.Int64? begin,
    $fixnum.Int64? end,
    $fixnum.Int64? created,
    $core.String? department,
    $core.String? task,
  }) {
    final _result = create();
    if (date != null) {
      _result.date = date;
    }
    if (begin != null) {
      _result.begin = begin;
    }
    if (end != null) {
      _result.end = end;
    }
    if (created != null) {
      _result.created = created;
    }
    if (department != null) {
      _result.department = department;
    }
    if (task != null) {
      _result.task = task;
    }
    return _result;
  }
  factory Schedule.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Schedule.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Schedule clone() => Schedule()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Schedule copyWith(void Function(Schedule) updates) => super.copyWith((message) => updates(message as Schedule)) as Schedule; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Schedule create() => Schedule._();
  Schedule createEmptyInstance() => create();
  static $pb.PbList<Schedule> createRepeated() => $pb.PbList<Schedule>();
  @$core.pragma('dart2js:noInline')
  static Schedule getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Schedule>(create);
  static Schedule? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get date => $_getI64(0);
  @$pb.TagNumber(1)
  set date($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get begin => $_getI64(1);
  @$pb.TagNumber(2)
  set begin($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBegin() => $_has(1);
  @$pb.TagNumber(2)
  void clearBegin() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get end => $_getI64(2);
  @$pb.TagNumber(3)
  set end($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnd() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get created => $_getI64(3);
  @$pb.TagNumber(4)
  set created($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCreated() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreated() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get department => $_getSZ(4);
  @$pb.TagNumber(5)
  set department($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDepartment() => $_has(4);
  @$pb.TagNumber(5)
  void clearDepartment() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get task => $_getSZ(5);
  @$pb.TagNumber(6)
  set task($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTask() => $_has(5);
  @$pb.TagNumber(6)
  void clearTask() => clearField(6);
}

