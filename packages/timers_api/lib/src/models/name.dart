import 'package:equatable/equatable.dart';

class Name extends Equatable {
  const Name({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
