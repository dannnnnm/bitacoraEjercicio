import 'package:bitacora_ejercicios/service/database_service.dart';
import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T, E extends Exception>{
  BaseRepository(this.tableName);
  final dbClient=DatabaseService.getDbClient();
  final String tableName;
  Future<T> saveOne(T item, {DatabaseExecutor? executor});

  Future<Result<T,E>> update(T item, {DatabaseExecutor? executor});

  Future<Option<T>> findOneByID(int id,{DatabaseExecutor? executor});

  T fromResult(Map<String,Object?> result);
}