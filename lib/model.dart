class FormModel {
  final List<FormData> forms;

  FormModel({required this.forms});

  factory FormModel.fromJson(List<dynamic>? parsedJson) {
    if (parsedJson == null) {
      print('Parsed JSON is null');
      return FormModel(forms: []);
    }

    print('Parsed JSON contains ${parsedJson.length} items');
    return FormModel(
      forms: parsedJson.map((data) => FormData.fromJson(data)).toList(),
    );
  }
}

class FormData {
  final String title;
  final List<FormField> fields;

  FormData({required this.title, required this.fields});

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      title: json['title'] ?? '',
      fields: json['fields'] != null
          ? (json['fields'] as List<dynamic>)
              .map((field) => FormField.fromJson(field))
              .toList()
          : [],
    );
  }
}

class FormField {
  final String name;
  final int span;
  final String text;
  final String group;
  final String label;
  dynamic value;
  final String fieldType;
  final bool isRequired;
  final int labelWidth;
  final bool disabled;
  final bool isUnique;
  final bool addMoreFeature;
  final bool isHelpBlockVisible;
  final bool isPlaceholderVisible;
  final Map<String, dynamic>? events;
  final List<dynamic>? options;

  FormField({
    required this.name,
    required this.span,
    required this.text,
    required this.group,
    required this.label,
    required this.value,
    required this.fieldType,
    required this.isRequired,
    required this.labelWidth,
    required this.disabled,
    required this.isUnique,
    required this.addMoreFeature,
    required this.isHelpBlockVisible,
    required this.isPlaceholderVisible,
    this.events,
    this.options,
  });

  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      name: json['name'],
      span: json['span'],
      text: json['text'],
      group: json['group'],
      label: json['label'],
      value: json['value'],
      fieldType: json['fieldType'],
      isRequired: json['isRequired'],
      labelWidth: json['labelWidth'],
      disabled: json['disabled'],
      isUnique: json['isUnique'],
      addMoreFeature: json['addMoreFeature'],
      isHelpBlockVisible: json['isHelpBlockVisible'],
      isPlaceholderVisible: json['isPlaceholderVisible'],
      events: json['events'],
      options: json['options'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'span': span,
      'text': text,
      'group': group,
      'label': label,
      'value': value,
      'fieldType': fieldType,
      'isRequired': isRequired,
      'labelWidth': labelWidth,
      'disabled': disabled,
      'isUnique': isUnique,
      'addMoreFeature': addMoreFeature,
      'isHelpBlockVisible': isHelpBlockVisible,
      'isPlaceholderVisible': isPlaceholderVisible,
      'events': events,
      'options': options,
    };
  }
}
