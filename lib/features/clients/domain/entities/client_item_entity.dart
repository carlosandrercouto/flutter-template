import 'package:equatable/equatable.dart';

/// Representa um cliente individual no domínio.
class ClientItemEntity extends Equatable {
  final String id;
  final int index;
  final String guid;
  final bool isActive;
  final String balance;
  final String name;
  final String picture;
  final int age;
  final String about;
  final String registered;
  final List<String> tags;

  const ClientItemEntity({
    required this.id,
    required this.index,
    required this.guid,
    required this.isActive,
    required this.balance,
    required this.name,
    required this.picture,
    required this.age,
    required this.about,
    required this.registered,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        index,
        guid,
        isActive,
        balance,
        name,
        picture,
        age,
        about,
        registered,
        tags,
      ];
}
