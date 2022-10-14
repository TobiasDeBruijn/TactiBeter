///
//  Generated code. Do not modify.
//  source: entities/timesheet.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Timesheet extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Timesheet', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.array21.tactibetter'), createEmptyInstance: create)
    ..pc<NamedId>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'departments', $pb.PbFieldType.PM, subBuilder: NamedId.create)
    ..pc<NamedId>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'taskGroups', $pb.PbFieldType.PM, subBuilder: NamedId.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'noteText', protoName: 'noteText')
    ..pc<TimesheetBlock>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blocks', $pb.PbFieldType.PM, subBuilder: TimesheetBlock.create)
    ..hasRequiredFields = false
  ;

  Timesheet._() : super();
  factory Timesheet({
    $core.Iterable<NamedId>? departments,
    $core.Iterable<NamedId>? taskGroups,
    $core.String? noteText,
    $core.Iterable<TimesheetBlock>? blocks,
  }) {
    final _result = create();
    if (departments != null) {
      _result.departments.addAll(departments);
    }
    if (taskGroups != null) {
      _result.taskGroups.addAll(taskGroups);
    }
    if (noteText != null) {
      _result.noteText = noteText;
    }
    if (blocks != null) {
      _result.blocks.addAll(blocks);
    }
    return _result;
  }
  factory Timesheet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Timesheet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Timesheet clone() => Timesheet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Timesheet copyWith(void Function(Timesheet) updates) => super.copyWith((message) => updates(message as Timesheet)) as Timesheet; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Timesheet create() => Timesheet._();
  Timesheet createEmptyInstance() => create();
  static $pb.PbList<Timesheet> createRepeated() => $pb.PbList<Timesheet>();
  @$core.pragma('dart2js:noInline')
  static Timesheet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timesheet>(create);
  static Timesheet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<NamedId> get departments => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<NamedId> get taskGroups => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get noteText => $_getSZ(2);
  @$pb.TagNumber(3)
  set noteText($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNoteText() => $_has(2);
  @$pb.TagNumber(3)
  void clearNoteText() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<TimesheetBlock> get blocks => $_getList(3);
}

class NamedId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NamedId', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.array21.tactibetter'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  NamedId._() : super();
  factory NamedId({
    $core.String? id,
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
  factory NamedId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NamedId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NamedId clone() => NamedId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NamedId copyWith(void Function(NamedId) updates) => super.copyWith((message) => updates(message as NamedId)) as NamedId; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NamedId create() => NamedId._();
  NamedId createEmptyInstance() => create();
  static $pb.PbList<NamedId> createRepeated() => $pb.PbList<NamedId>();
  @$core.pragma('dart2js:noInline')
  static NamedId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NamedId>(create);
  static NamedId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
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

class TimesheetBlock extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimesheetBlock', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.array21.tactibetter'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'date')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'begin')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'end')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'department')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'task')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitted')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'approved')
    ..hasRequiredFields = false
  ;

  TimesheetBlock._() : super();
  factory TimesheetBlock({
    $fixnum.Int64? date,
    $fixnum.Int64? begin,
    $fixnum.Int64? end,
    $core.String? department,
    $core.String? task,
    $core.bool? submitted,
    $core.bool? approved,
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
    if (department != null) {
      _result.department = department;
    }
    if (task != null) {
      _result.task = task;
    }
    if (submitted != null) {
      _result.submitted = submitted;
    }
    if (approved != null) {
      _result.approved = approved;
    }
    return _result;
  }
  factory TimesheetBlock.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimesheetBlock.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimesheetBlock clone() => TimesheetBlock()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimesheetBlock copyWith(void Function(TimesheetBlock) updates) => super.copyWith((message) => updates(message as TimesheetBlock)) as TimesheetBlock; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimesheetBlock create() => TimesheetBlock._();
  TimesheetBlock createEmptyInstance() => create();
  static $pb.PbList<TimesheetBlock> createRepeated() => $pb.PbList<TimesheetBlock>();
  @$core.pragma('dart2js:noInline')
  static TimesheetBlock getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimesheetBlock>(create);
  static TimesheetBlock? _defaultInstance;

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
  $core.String get department => $_getSZ(3);
  @$pb.TagNumber(4)
  set department($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDepartment() => $_has(3);
  @$pb.TagNumber(4)
  void clearDepartment() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get task => $_getSZ(4);
  @$pb.TagNumber(5)
  set task($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTask() => $_has(4);
  @$pb.TagNumber(5)
  void clearTask() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get submitted => $_getBF(5);
  @$pb.TagNumber(6)
  set submitted($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSubmitted() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubmitted() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get approved => $_getBF(6);
  @$pb.TagNumber(7)
  set approved($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasApproved() => $_has(6);
  @$pb.TagNumber(7)
  void clearApproved() => clearField(7);
}

