/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Reading type in your schema. */
@immutable
class Reading extends Model {
  static const classType = const _ReadingModelType();
  final String? _device_id;
  final int? _timestamp;
  final double? _temperature;
  final double? _moisture;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  ReadingModelIdentifier get modelIdentifier {
    try {
      return ReadingModelIdentifier(
        device_id: _device_id!,
        timestamp: _timestamp!
      );
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get device_id {
    try {
      return _device_id!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get temperature {
    return _temperature;
  }
  
  double? get moisture {
    return _moisture;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Reading._internal({required device_id, required timestamp, temperature, moisture, createdAt, updatedAt}): _device_id = device_id, _timestamp = timestamp, _temperature = temperature, _moisture = moisture, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Reading({required String device_id, required int timestamp, double? temperature, double? moisture}) {
    return Reading._internal(
      device_id: device_id,
      timestamp: timestamp,
      temperature: temperature,
      moisture: moisture);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Reading &&
      _device_id == other._device_id &&
      _timestamp == other._timestamp &&
      _temperature == other._temperature &&
      _moisture == other._moisture;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Reading {");
    buffer.write("device_id=" + "$_device_id" + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.toString() : "null") + ", ");
    buffer.write("temperature=" + (_temperature != null ? _temperature!.toString() : "null") + ", ");
    buffer.write("moisture=" + (_moisture != null ? _moisture!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Reading copyWith({double? temperature, double? moisture}) {
    return Reading._internal(
      device_id: device_id,
      timestamp: timestamp,
      temperature: temperature ?? this.temperature,
      moisture: moisture ?? this.moisture);
  }
  
  Reading.fromJson(Map<String, dynamic> json)  
    : _device_id = json['device_id'],
      _timestamp = (json['timestamp'] as num?)?.toInt(),
      _temperature = (json['temperature'] as num?)?.toDouble(),
      _moisture = (json['moisture'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'device_id': _device_id, 'timestamp': _timestamp, 'temperature': _temperature, 'moisture': _moisture, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'device_id': _device_id, 'timestamp': _timestamp, 'temperature': _temperature, 'moisture': _moisture, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<ReadingModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<ReadingModelIdentifier>();
  static final QueryField DEVICE_ID = QueryField(fieldName: "device_id");
  static final QueryField TIMESTAMP = QueryField(fieldName: "timestamp");
  static final QueryField TEMPERATURE = QueryField(fieldName: "temperature");
  static final QueryField MOISTURE = QueryField(fieldName: "moisture");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Reading";
    modelSchemaDefinition.pluralName = "Readings";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      ModelIndex(fields: const ["device_id", "timestamp"], name: null)
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Reading.DEVICE_ID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Reading.TIMESTAMP,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Reading.TEMPERATURE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Reading.MOISTURE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ReadingModelType extends ModelType<Reading> {
  const _ReadingModelType();
  
  @override
  Reading fromJson(Map<String, dynamic> jsonData) {
    return Reading.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Reading';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Reading] in your schema.
 */
@immutable
class ReadingModelIdentifier implements ModelIdentifier<Reading> {
  final String device_id;
  final int timestamp;

  /**
   * Create an instance of ReadingModelIdentifier using [device_id] the primary key.
   * And [timestamp] the sort key.
   */
  const ReadingModelIdentifier({
    required this.device_id,
    required this.timestamp});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'device_id': device_id,
    'timestamp': timestamp
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'ReadingModelIdentifier(device_id: $device_id, timestamp: $timestamp)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ReadingModelIdentifier &&
      device_id == other.device_id &&
      timestamp == other.timestamp;
  }
  
  @override
  int get hashCode =>
    device_id.hashCode ^
    timestamp.hashCode;
}