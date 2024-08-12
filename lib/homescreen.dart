// // ignore_for_file: avoid_print
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:task/model.dart';

Future<FormModel> fetchFormModel() async {
  const url =
      'https://gateway.cronlink.ca/api/v1/authentication/companies-listing';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('Response Data: ${response.body}');
    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
      final nestedData = data['data'] as Map<String, dynamic>;
      if (nestedData.containsKey('forms')) {
        return FormModel.fromJson(nestedData['forms'] as List<dynamic>?);
      }
    }
    throw Exception('No forms key found in JSON');
  } else {
    throw Exception('Failed to load form data');
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late Future<FormModel> formModel;

  @override
  void initState() {
    super.initState();
    formModel = fetchFormModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form'),
      ),
      body: FutureBuilder<FormModel>(
        future: formModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.forms.length,
              itemBuilder: (context, index) {
                var form = snapshot.data!.forms[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...form.fields.map((field) {
                        switch (field.fieldType) {
                          case 'TextInput':
                            print(
                                'Rendering TextInput for field: ${field.label}');
                            return TextFormField(
                              initialValue: field.value,
                              decoration: InputDecoration(
                                labelText: field.label,
                              ),
                            );
                          case 'FormElementSignature':
                            print(
                                'Rendering Signature field for: ${field.label}');
                            return Container();
                          case 'DatetimePicker':
                            print(
                                'Rendering DatetimePicker for field: ${field.label}');
                            return Container();
                          case 'SwitchInput':
                            print(
                                'Rendering SwitchInput for field: ${field.label}');
                            return SwitchListTile(
                              title: Text(field.label),
                              value: field.value ?? false,
                              onChanged: (bool value) {
                                setState(() {
                                  field.value = value;
                                });
                              },
                            );
                          case 'SelectList':
                            print(
                                'Rendering SelectList for field: ${field.label}');
                            return DropdownButtonFormField<String>(
                              decoration:
                                  InputDecoration(labelText: field.label),
                              value: field.value,
                              items: field.options
                                  ?.map<DropdownMenuItem<String>>((option) {
                                return DropdownMenuItem<String>(
                                  value: option['optionValue'],
                                  child: Text(option['optionLabel']),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  field.value = newValue;
                                });
                              },
                            );
                          default:
                            print('Unknown field type: ${field.fieldType}');
                            return Container();
                        }
                      })
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}
