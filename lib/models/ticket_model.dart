import 'package:flutter/material.dart';

class TicketModel {
  final int id; // TAMBAHAN
  final String location;
  final String status;
  final bool isCompleted;
  final String title;
  final String subtitle;
  final String detail;
  final String bookingCode;
  final String imageAsset;
  final Color iconBgColor;

  TicketModel({
    required this.id, // TAMBAHAN
    required this.location,
    required this.status,
    required this.isCompleted,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.bookingCode,
    required this.imageAsset,
    required this.iconBgColor,
  });
}