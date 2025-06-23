import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static late Database _client;
  static String dbName = "bitacora.db";
  static Future<void> init({Database? customDB}) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (customDB == null) {
      Directory dbDir;
      if (!Platform.isAndroid){
        sqfliteFfiInit();
        dbDir=(await getApplicationDocumentsDirectory())!;
        _client = await databaseFactoryFfi.openDatabase("${dbDir.path}/$dbName");
      }
      else{
        dbDir= (await getExternalStorageDirectory())!;
        _client = await openDatabase("${dbDir.path}/$dbName");
      }
      
    } else {
      _client = customDB;
    }

    _client.execute(
      "CREATE TABLE IF NOT EXISTS user(id integer primary key, name text)",
    );

    _client.execute(
      "CREATE TABLE IF NOT EXISTS category(id integer primary key, name text)",
    );

    _client.execute(
      """CREATE TABLE IF NOT EXISTS 
                            activity (id integer primary key, 
                              name text NOT NULL, description text NOT NULL, 
                                date integer NOT NULL, 
                                  experience real NOT NULL,
                                    completed boolean NOT NULL,
                                      deleted_at integer,
                                        category_id integer NOT NULL,
                                          FOREIGN KEY (category_id) references category(id))""",
    );

    _client.execute(
      """CREATE TABLE IF NOT EXISTS location(id integer primary key, 
                                                                    latitude real, 
                                                                      longitude real,
                                                                        activity_id integer,
                                                                          FOREIGN KEY(activity_id) references activity(id))""",
    );

    _client.execute(
      """CREATE TABLE IF NOT EXISTS evidence(id integer primary key, 
                                                            image_bytes blob,
                                                              activity_id integer,
                                                                FOREIGN KEY(activity_id) references activity(id))""",
    );

    _client.execute(
      """CREATE TABLE IF NOT EXISTS weather(id integer primary key,
                                                            status text NOT NULL,
                                                              description text NOY NULL,
                                                                current_temperature real NOT NULL,
                                                                  max_temperature real,
                                                                    min_temperature real,
                                                                      wind_speed integer,
                                                                        activity_id integer,
                                                                        FOREIGN KEY(activity_id) references activity(id))""",
    );
  }

  static Database getDbClient() {
    return _client;
  }
}
