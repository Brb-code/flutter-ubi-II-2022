import 'package:flutter/material.dart';
import 'package:flutter_sqlite_crud/Tareas.dart';
import 'package:flutter_sqlite_crud/db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<Tareas>> students;
  String _studentName;
  String _DescripcionData;
  bool isUpdate = false;
  int studentIdForUpdate;
  DBHelper dbHelper;
  final _studentNameController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshStudentList();
  }

  refreshStudentList() {
    setState(() {
      students = dbHelper.getTareas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ABM Tareas'),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Intro Titulo';
                          }
                          if (value.trim() == "")
                            return "No es valido!!!";
                          return null;
                        },
                        onSaved: (value) {
                          _studentName = value;
                        },
                        controller: _studentNameController,
                        decoration: InputDecoration(
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.amberAccent,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          // hintText: "Student Name",
                          labelText: "Titulo",
                          icon: Icon(
                            Icons.business_center,
                            color: Colors.black,
                          ),
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Intro Descripcion';
                          }
                          if (value.trim() == "")
                            return "Descripcion No es valido!!!";
                          return null;
                        },
                        onSaved: (value) {
                          _DescripcionData = value;
                        },
                        controller: _descripcionController,
                        decoration: InputDecoration(
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.amberAccent,
                                  width: 2,
                                  style: BorderStyle.solid,
                              ),
                          ),
                          // hintText: "Student Name",
                          labelText: "Descripcion",
                          icon: Icon(
                            Icons.camera,
                            color: Colors.black,
                          ),
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),



                    ],
                  )
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.amber,
                child: Text(
                  (isUpdate ? 'MODIFICAR' : 'CREAR'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      dbHelper
                          .update(Tareas(studentIdForUpdate, _studentName, _DescripcionData))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      dbHelper.add(Tareas(null, _studentName, _DescripcionData));
                    }
                  }
                  _studentNameController.text = '';
                  _descripcionController.text = '';
                  refreshStudentList();
                },
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              RaisedButton(
                color: Colors.amberAccent,
                child: Text(
                  (isUpdate ? 'CANCEL MODIFICAR' : 'LIMPIAR'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _studentNameController.text = '';
                  _descripcionController.text = '';
                  setState(() {
                    isUpdate = false;
                    studentIdForUpdate = null;
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data);
                }
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Text('No Data Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Tareas> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Titulo'),
            ),
            DataColumn(
              label: Text('Descripcion'),
            ),
            DataColumn(
              label: Text('Eliminar'),
            )
          ],
          rows: students
              .map(
                (student) => DataRow(
                  cells: [
                    DataCell(
                      Text(student.name),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          studentIdForUpdate = student.id;
                        });
                        _studentNameController.text = student.name;
                      },
                    ),
                    DataCell(
                      Text(student.name),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          studentIdForUpdate = student.id;
                        });
                        _descripcionController.text = student.descripcion;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          dbHelper.delete(student.id);
                          refreshStudentList();
                        },
                      ),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}