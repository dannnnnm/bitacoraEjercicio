import 'dart:typed_data';

import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/evidence_image.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/repository/evidence_repository.dart';
import 'package:bitacora_ejercicios/service/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main(){
  late EvidenceRepository evidenceRepository;
  late CategoryRepository categoryRepository;
  Future<void> beforeEach() async {
    sqfliteFfiInit();
    await DatabaseService.init(
      customDB: await databaseFactoryFfi.openDatabase(":memory:"),
    );
    evidenceRepository = EvidenceRepository();
    categoryRepository = CategoryRepository();
    await categoryRepository.saveOne(Category("testCat"));
    await categoryRepository.saveOne(Category("testCat2"));
    var activity1 = {
      "name": "act1",
      "date": DateTime.now().millisecondsSinceEpoch,
      "description": "desc",
      "experience": 10.5,
      "completed": 0,
      "category_id": 1,
    };
    var activity2 = {
      "name": "act2",
      "date": DateTime.now().millisecondsSinceEpoch + 5000,
      "description": "desc2",
      "experience": 12.5,
      "completed": 1,
      "category_id": 2,
    };
    await DatabaseService.getDbClient().insert("activity", activity1);
    await DatabaseService.getDbClient().insert("activity", activity2);
  }

  ;

  setUp(beforeEach);
  tearDown(() async {
    DatabaseService.getDbClient().close();
  });

  test("guardar 1 agrega id", () async {
    EvidenceImage evidence=EvidenceImage(Uint8List.fromList([14,43,24,32]));
    evidence.activityID = 1;
    var saved = await evidenceRepository.saveOne(evidence);
    expect(saved.id, isNot(0));
  });
}