import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

TextEditingController inputName = TextEditingController();
TextEditingController inputEmail = TextEditingController();
TextEditingController inputGender = TextEditingController();

final inputName1 = TextEditingController();
final inputEmail1 = TextEditingController();
final inputGender1 = TextEditingController();

Future<http.Response> getData() async {
  var result =
      await http.get(Uri.parse("http://127.0.0.1:8082/api/user/getAll"));

  return result;
}

Future<http.Response> postData() async {
  Map<String, dynamic> data = {
    "nama": inputName.text,
    "email": inputEmail.text,
    "gender": inputGender.text
  };
  var result = await http.post(
    Uri.parse("http://127.0.0.1:8082/api/user/insert"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(data),
  );
  return result;
}

Future<http.Response> updateData(id) async {
  Map<String, dynamic> data = {
    "nama": inputName1.text,
    "email": inputEmail1.text,
    "gender": inputGender1.text,
  };
  var result = await http.put(
    Uri.parse("http://127.0.0.1:8082/api/user/update/${id}"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(data),
  );
  print(result.statusCode);
  print(result.body);

  return result;
}

Future<http.Response> deleteData(id) async {
  var result = await http.delete(
    Uri.parse("http://127.0.0.1:8082/api/user/delete/${id}"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
  );
  return result;
}

class NetworkApi extends StatefulWidget {
  const NetworkApi({super.key});

  @override
  State<NetworkApi> createState() => _NetworkApiState();
}

class _NetworkApiState extends State<NetworkApi> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // print(postData());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "GET DATA FROM API",
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Ionicons.settings))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.green.shade200),
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> json = jsonDecode(snapshot.data!.body);
                return ListView.builder(
                  itemCount: json.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                          leading: CircleAvatar(
                            child: Text(json[index]["nama"][0]),
                            backgroundColor: Colors.grey.shade300,
                          ),
                          title: Text(
                              "${json[index]['nama']} | ${json[index]['gender']}"),
                          subtitle: Text("${json[index]['email']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: (() {
                                  inputName1.text = json[index]["nama"];
                                  inputEmail1.text = json[index]["email"];
                                  inputGender1.text = json[index]["gender"];
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            backgroundColor:
                                                Colors.green.shade200,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: const Text(
                                              'Update User',
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Nama Tidak Boleh Kosong";
                                                      }
                                                      return null;
                                                    },
                                                    controller: inputName1,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Nama',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Email Tidak Boleh Kosong";
                                                      }
                                                      if (!EmailValidator
                                                          .validate(value)) {
                                                        return "Masukkan Alamt email Dengan Benar";
                                                      }
                                                      return null;
                                                    },
                                                    controller: inputEmail1,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Email',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    controller: inputGender1,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Jenis Kelamin',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Batal'),
                                                    child: const Text(
                                                      'Cancel',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await updateData(
                                                          json[index]["id"]);
                                                      inputName1.clear();
                                                      inputEmail1.clear();
                                                      inputGender1.clear();
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Simpan'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ));
                                }),
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await deleteData(json[index]['id']);
                                  setState(() {});
                                },
                              ),
                            ],
                          )),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.green.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: const Text(
                  'Tambah User',
                  textAlign: TextAlign.center,
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        controller: inputName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nama',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email Tidak Boleh Kosong";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Masukkan email dengan benar";
                          }
                          return null;
                        },
                        controller: inputEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: inputGender,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Jenis Kelamin',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Batal'),
                        child: const Text(
                          'Batal',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await postData();
                            inputEmail.clear();
                            inputGender.clear();
                            inputName.clear();
                            Navigator.pop(context);
                            setState(() {});
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ],
                  )
                ],
              ),
            );
            //
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Ionicons.logo_bitcoin)),
                IconButton(onPressed: () {}, icon: Icon(Ionicons.logo_dropbox))
              ],
            )));
  }
}
