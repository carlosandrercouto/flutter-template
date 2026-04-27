import '../../domain/entities/client_item_entity.dart';

/// Model responsável por fazer o parse de um cliente vindo do JSON.
class ClientItemModel extends ClientItemEntity {
  const ClientItemModel({
    required super.id,
    required super.index,
    required super.guid,
    required super.isActive,
    required super.balance,
    required super.name,
    required super.picture,
    required super.age,
    required super.about,
    required super.registered,
    required super.tags,
  });

  factory ClientItemModel.fromMap(Map<String, dynamic> map) {
    return ClientItemModel(
      id: map['_id'] as String? ?? '',
      index: map['index'] as int? ?? 0,
      guid: map['guid'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? false,
      balance: map['balance'] as String? ?? '',
      name: map['name'] as String? ?? '',
      picture: map['picture'] as String? ?? '',
      age: map['age'] as int? ?? 0,
      about: map['about'] as String? ?? '',
      registered: map['registered'] as String? ?? '',
      tags: (map['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );
  }
}
