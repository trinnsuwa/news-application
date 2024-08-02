// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_new_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainNewsModelAdapter extends TypeAdapter<MainNewsModel> {
  @override
  final int typeId = 0;

  @override
  MainNewsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainNewsModel(
      title: fields[0] as String,
      snippet: fields[1] as String,
      fullArticleUrl: fields[3] as String,
      thumbnailUrl: fields[2] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MainNewsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.snippet)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.fullArticleUrl)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainNewsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
