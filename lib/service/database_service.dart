import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static late Database _client;
  static String dbName="bitacora.db";
  static void init({String? customDBName}) async{
    WidgetsFlutterBinding.ensureInitialized();
    var dbDir=(await getExternalStorageDirectory())!;

    if (customDBName==null){
      _client=await openDatabase("${dbDir.path}/$dbName");
    }
    else{
      _client=await openDatabase("${dbDir.path}/$customDBName");
    }


    _client.execute("CREATE TABLE IF NOT EXISTS user(id integer primary key, name text)");

    _client.execute("CREATE TABLE IF NOT EXISTS category(id integer primary key, name text)");

    _client.execute(
      """CREATE TABLE IF NOT EXISTS 
                            activity (id integer primary key, 
                              name text NOT NULL, description text, 
                                date integer NOT NULL, 
                                  experience real NOT NULL,
                                    completed boolean,
                                      deleted_at integer,
                                        category_id integer NOT NULL,
                                          FOREIGN KEY (category_id) references category(id)) ON DELETE CASCADE""",
    );


    _client.execute("""CREATE TABLE IF NOT EXISTS location(id integer primary key, 
                                                                    latitude real, 
                                                                      longitude real,
                                                                        activity_id integer,
                                                                          FOREIGN KEY(activity_id) references activity(id))""");
    
    
    _client.execute("""CREATE TABLE IF NOT EXISTS evidence(id integer primary key, 
                                                            image_bytes blob,
                                                              activity_id integer,
                                                                FOREIGN KEY(activity_id) references activity(id))""");

    



    _client.execute("""CREATE TABLE IF NOT EXISTS weather(id integer primary key,
                                                            weather_status text,
                                                              current_temperature integer,
                                                                max_temperature integer,
                                                                  min_temperature integer,
                                                                    wind_speed integer,
                                                                      activity_id integer,
                                                                      FOREIGN KEY(activity_id) references activity(id))""");
    
    
  }

  static Database getDbClient(){
    return _client;
  }

  static get client{
    return _client;
  }
}