import 'package:flutter_template/features/clients/domain/entities/client_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientItemEntity', () {
    test('deve suportar comparação de valor via Equatable corretamente', () {
      const entity1 = ClientItemEntity(
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

      const entity2 = ClientItemEntity(
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

      const entityDiferente = ClientItemEntity(
        id: '2',
        index: 1,
        guid: 'guid2',
        isActive: false,
        balance: '200',
        name: 'Client 2',
        picture: 'pic2.png',
        age: 25,
        about: 'About 2',
        registered: 'date 2',
        tags: ['tag2'],
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entityDiferente)));
    });
  });
}
