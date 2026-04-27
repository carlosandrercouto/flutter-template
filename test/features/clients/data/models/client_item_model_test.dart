import 'package:flutter_template/features/clients/data/models/client_item_model.dart';
import 'package:flutter_template/features/clients/domain/entities/client_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientItemModel', () {
    const tClientItemModel = ClientItemModel(
      id: '1',
      index: 0,
      guid: 'guid1',
      isActive: true,
      balance: '100',
      name: 'Client 1',
      picture: 'pic1.png',
      age: 30,
      about: 'About',
      registered: 'date',
      tags: ['tag1'],
    );

    test('deve ser uma subclasse de ClientItemEntity', () {
      expect(tClientItemModel, isA<ClientItemEntity>());
    });

    test('deve retornar um model valido quando o map do JSON for correto', () {
      final Map<String, dynamic> jsonMap = {
        '_id': '1',
        'index': 0,
        'guid': 'guid1',
        'isActive': true,
        'balance': '100',
        'name': 'Client 1',
        'picture': 'pic1.png',
        'age': 30,
        'about': 'About',
        'registered': 'date',
        'tags': ['tag1'],
      };

      final result = ClientItemModel.fromMap(jsonMap);

      expect(result, tClientItemModel);
    });

    test('deve retornar um model valido com valores padrao quando os campos do JSON estiverem ausentes', () {
      final Map<String, dynamic> jsonMap = {};

      final result = ClientItemModel.fromMap(jsonMap);

      expect(result.id, '');
      expect(result.index, 0);
      expect(result.isActive, false);
      expect(result.tags, isEmpty);
    });
  });
}
