import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task/model.dart';

Future<List<FormData>> fetchFormData() async {
  final response = await http.get(Uri.parse(
      'https://gateway.cronlink.ca/api/v1/authentication/companies-listing'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((data) => FormData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class FormDisplayScreen extends StatefulWidget {
  const FormDisplayScreen({super.key});

  @override
  State<FormDisplayScreen> createState() => _FormDisplayScreenState();
}

class _FormDisplayScreenState extends State<FormDisplayScreen> {
  late Future<List<FormData>> futureFormData;

  @override
  void initState() {
    super.initState();
    futureFormData = fetchFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Data'),
      ),
      body: FutureBuilder<List<FormData>>(
        future: futureFormData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, formIndex) {
                var formData = snapshot.data![formIndex];
                return Column(
                  children: formData.fields.map((field) {
                    return _buildField(field, formIndex);
                  }).toList(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildField(Field field, int formIndex) {
    switch (field.fieldType) {
      case 'TextInput':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: field.label,
              enabled: !field.disabled,
            ),
            onChanged: (value) {
              setState(() {
                var updatedField = field.copyWith(value: value);
                _updateField(updatedField, formIndex);
              });
            },
          ),
        );
      case 'FormElementSignature':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(field.text),
        );
      case 'DatetimePicker':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(field.text),
        );
      case 'SwitchInput':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SwitchListTile(
            title: Text(field.label),
            value: field.value ?? false,
            onChanged: (bool value) {
              setState(() {
                var updatedField = field.copyWith(value: value);
                _updateField(updatedField, formIndex);
              });
            },
          ),
        );
      case 'SelectList':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButtonFormField(
            decoration: InputDecoration(labelText: field.label),
            value: field.value is String ? field.value : null,
            items: (field.value is List
                ? (field.value as List).map<DropdownMenuItem>((item) {
                    return DropdownMenuItem(
                      value: item['optionValue'],
                      child: Text(item['optionLabel']),
                    );
                  }).toList()
                : []),
            onChanged: (newValue) {
              setState(() {
                var updatedField = field.copyWith(value: newValue);
                _updateField(updatedField, formIndex);
              });
            },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _updateField(Field updatedField, int formIndex) {
    setState(() {
      futureFormData = futureFormData.then((formDataList) {
        var updatedFields = List<Field>.from(formDataList[formIndex].fields);
        var fieldIndex =
            updatedFields.indexWhere((f) => f.name == updatedField.name);
        if (fieldIndex != -1) {
          updatedFields[fieldIndex] = updatedField;
        }
        formDataList[formIndex] = FormData(fields: updatedFields);
        return formDataList;
      });
    });
  }
}
