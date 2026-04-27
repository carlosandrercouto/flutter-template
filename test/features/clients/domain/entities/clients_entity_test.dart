import 'package:flutter_template/features/clients/domain/entities/client_item_entity.dart';
import 'package:flutter_template/features/clients/domain/entities/clients_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientsEntity', () {
    test('deve suportar comparação de valor via Equatable corretamente', () {
      const item1 = ClientItemEntity(
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

      const entity1 = ClientsEntity(
        clientsLength: 1,
        clientsList: [item1],
      );

      const entity2 = ClientsEntity(
        clientsLength: 1,
        clientsList: [item1],
      );

      const entityDiferente = ClientsEntity(
        clientsLength: 2,
        clientsList: [item1, item1],
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entityDiferente)));
    });
  });
}
