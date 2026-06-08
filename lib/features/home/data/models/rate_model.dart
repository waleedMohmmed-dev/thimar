import 'package:thimar/features/home/domain/entities/rate_entity.dart';

class RateModel extends RateEntity {
  const RateModel({
    required super.value,
    required super.comment,
    required super.clientName,
    required super.clientImage,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      value: (json['value'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? '',
      clientImage: json['client_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'comment': comment,
      'client_name': clientName,
      'client_image': clientImage,
    };
  }

  RateEntity toEntity() {
    return RateEntity(
      value: value,
      comment: comment,
      clientName: clientName,
      clientImage: clientImage,
    );
  }
}
