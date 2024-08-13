class Field {
  final String name;
  final int span;
  final String text;
  final String group;
  final String label;
  final dynamic value; // can be Map, List, or any other type
  final String fieldType;
  final bool disabled;
  final bool isRequired;

  Field({
    required this.name,
    required this.span,
    required this.text,
    required this.group,
    required this.label,
    required this.value,
    required this.fieldType,
    required this.disabled,
    required this.isRequired,
  });

  Field copyWith({dynamic value}) {
    return Field(
      name: name,
      span: span,
      text: text,
      group: group,
      label: label,
      value: value ?? this.value,
      fieldType: fieldType,
      disabled: disabled,
      isRequired: isRequired,
    );
  }

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      name: json['name'] ?? '',
      span: json['span'] ?? 0,
      text: json['text'] ?? '',
      group: json['group'] ?? '',
      label: json['label'] ?? '',
      value: json['value'],
      fieldType: json['fieldType'] ?? '',
      disabled: json['disabled'] ?? false,
      isRequired: json['isRequired'] ?? false,
    );
  }
}

class FormData {
  final List<Field> fields;

  FormData({required this.fields});

  factory FormData.fromJson(Map<String, dynamic> json) {
    var fieldsJson = json['fields'] as List;
    List<Field> fieldsList = fieldsJson.map((i) => Field.fromJson(i)).toList();

    return FormData(fields: fieldsList);
  }
}
