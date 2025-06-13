import 'package:bitacora_ejercicios/exception/no_id_exception.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/repository/base_repository.dart';
import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:sqflite/sqflite.dart';

typedef CategoryResultMap=Map<String,Object?>;
class CategoryRepository extends BaseRepository<Category, Exception>{
  CategoryRepository():super("category");
  @override
  Future<Category> saveOne(Category category, {DatabaseExecutor? executor})async{
    executor??=super.dbClient;
    int lastId=await executor.insert(tableName, category.toJson());
    Category savedCategory=(await findOneByID(lastId)).unwrap();
    return savedCategory;
  }

  @override
  Future<Option<Category>> findOneByID(int id, {DatabaseExecutor? executor}) async {
    if (id==0){
      return None();
    }
    executor??=super.dbClient;
    List<CategoryResultMap> found = await executor.query(tableName,where: "id=?",whereArgs: [id]);
    if (found.isEmpty){
      return None();
    }
    var category=fromResult(found.first);
    return Some(category);

  }

  @override
  Future<Result<Category,Exception>> update(Category category,{DatabaseExecutor? executor}) async{
    executor??=super.dbClient;
    if (category.id==0){
      return Err(NoIDException());
    }
    // ignore: unused_local_variable
    int _result=await executor.update(tableName, category.toJson(),where: "id=?",whereArgs: [category.id]);
    var found=await findOneByID(category.id);
    return Ok(found.unwrap());
  }

  Future<List<Category>> findByNameLike(String partialName, {DatabaseExecutor? executor}) async{
    executor??=super.dbClient;
    List<CategoryResultMap> found=await executor.query(tableName, where: "name LIKE ?",whereArgs: ["%$partialName%"]);
    var results=<Category>[];
    for (var entry in found) {
      results.add(fromResult(entry));
    }
    return results;
  }




  @override
  Category fromResult(CategoryResultMap result){
    int id=result["id"] as int;
    String name=result["name"] as String;
    return Category.load(id, name);
  }
  
  
}
