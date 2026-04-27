import 'package:flutter_template/features/clients/data/models/client_item_model.dart';
import 'package:flutter_template/features/clients/data/models/clients_model.dart';
import 'package:flutter_template/features/clients/domain/entities/clients_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientsModel', () {
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

    const tClientsModel = ClientsModel(
      clientsLength: 1,
      clientsList: [tClientItemModel],
    );

    test('deve ser uma subclasse de ClientsEntity', () {
      expect(tClientsModel, isA<ClientsEntity>());
    });

    test('deve retornar um model valido quando o fromMapList receber uma lista valida', () {
      final List<dynamic> listMap = [
        {
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
        }
      ];

      final result = ClientsModel.fromMapList(listMap);

      expect(result, tClientsModel);
      expect(result.clientsLength, 1);
    });

    test('deve retornar model com lista vazia quando a entrada for vazia', () {
      final result = ClientsModel.fromMapList([]);

      expect(result.clientsLength, 0);
      expect(result.clientsList, isEmpty);
    });
  });
}
