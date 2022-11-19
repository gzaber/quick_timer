import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Name extends Equatable {
  Name({
    String? id,
    required this.name,
  }) : id = id ?? Uuid().v4();

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
