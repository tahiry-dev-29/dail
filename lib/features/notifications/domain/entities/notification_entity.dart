import 'package:flutter/material.dart';

class NotificationEntity {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isNew;
  final bool hasBorder;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isNew = false,
    this.hasBorder = false,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    IconData? icon,
    Color? iconColor,
    bool? isNew,
    bool? hasBorder,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      isNew: isNew ?? this.isNew,
      hasBorder: hasBorder ?? this.hasBorder,
    );
  }
}
