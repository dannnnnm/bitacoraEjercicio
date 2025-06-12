import 'dart:typed_data';

import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/utilTypes/json_map.dart';
import 'package:flutter/material.dart';

class EvidenceImage {
  EvidenceImage(this.bytes) : image = Image.memory(bytes), activityID = 0;
  EvidenceImage.load(int id, this.activityID, Uint8List bytes)
    : image = Image.memory(bytes);
  int id = 0;
  Uint8List bytes = Uint8List(0);
  Image image;
  int activityID;

  JSONMap toJson() {
    JSONMap json = {"image_bytes": bytes, "activity_id": activityID};
    if (id != 0) {
      json["id"] = id;
    }
    if (activityID != 0) {
      throw UnregisteredComponentException(runtimeType.toString(), "activity");
    }
    return json;
  }
}
