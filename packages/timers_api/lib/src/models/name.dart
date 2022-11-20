import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'name.g.dart';

@JsonSerializable()
class Name extends Equatable {
  Name({
    String? id,
    required this.name,
  }) : id = id ?? Uuid().v4();

  final String id;
  final String name;

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);

  @override
  List<Object?> get props => [id, name];
}
