
class Category {
  Category(this.name);
  Category.load(this.id,this.name);
  int id=0;
  String name;

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map={
      "name":name
    };
    if (id!=0){
      map["id"]=id;
    }
    return map;
  }
}