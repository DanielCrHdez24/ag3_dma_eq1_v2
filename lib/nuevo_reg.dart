import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class NuevoPage extends StatefulWidget {
  @override
  _NuevoPageState createState() => _NuevoPageState();
}

class _NuevoPageState extends State<NuevoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _clearForm() {
    _tituloController.clear();
    _generoController.clear();
    _autorController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de libro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(labelText: 'Género'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el género';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _autorController,
                decoration: InputDecoration(labelText: 'Autor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el autor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Seleccionar Imagen'),
              ),
              SizedBox(height: 10),
              _image != null ? Image.file(_image!) : Text('No se ha seleccionado ninguna imagen'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final titulo = _tituloController.text;
                    final genero = _generoController.text;
                    final autor = _autorController.text;

                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, selecciona una imagen')),
                      );
                      return;
                    }

                    var request = http.MultipartRequest(
                        'POST', Uri.parse('http://192.168.0.78/catalogo/guardar_libro.php'));
                    request.fields['titulo'] = titulo;
                    request.fields['genero'] = genero;
                    request.fields['autor'] = autor;
                    var imageFile = await http.MultipartFile.fromPath(
                        'imagen', _image!.path,
                        contentType: MediaType('image', 'jpg'));
                    request.files.add(imageFile);

                    try {
                      var response = await request.send();
                      final respStr = await response.stream.bytesToString();
                      print("Respuesta del servidor: $respStr");

                      final jsonResponse = jsonDecode(respStr);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(jsonResponse['message'])),
                      );
                      if (jsonResponse['success']) {
                        _clearForm();
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al conectar con el servidor: $e')),
                      );
                    }
                  }
                },
                child: Text('Registrar Libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
