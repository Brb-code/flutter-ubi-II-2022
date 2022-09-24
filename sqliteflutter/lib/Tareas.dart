class Tareas {
  int id;
  String name;
  String descripcion;
  Tareas(this.id, this.name, this.descripcion);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'descripcion': descripcion
    };
    return map;
  }

  Tareas.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    descripcion = map['descripcion'];
  }
}