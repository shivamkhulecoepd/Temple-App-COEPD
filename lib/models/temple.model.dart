import 'package:flutter/material.dart';

class TempleSection {
  final int id;
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final List<TimelineEvent> timelineEvents;
  final bool hasAudio;
  final String audioUrl;
  final bool hasDownload;
  final String downloadUrl;
  final String content;
  final List<Deity>? deities;
  final List<Trustee>? trustees;
  final List<TempleImageInfo>? images;
  final String? image;
  final String? name;
  final String? description;
  final bool? hasWhatsApp;

  TempleSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.timelineEvents,
    required this.hasAudio,
    required this.audioUrl,
    required this.hasDownload,
    required this.downloadUrl,
    required this.content,
    this.deities,
    this.trustees,
    this.images,
    this.image,
    this.name,
    this.description,
    this.hasWhatsApp,
  });
}

class TimelineEvent {
  final String year;
  final String title;
  final String details;

  TimelineEvent({
    required this.year,
    required this.title,
    required this.details,
  });
}

class Deity {
  final String name;
  final String description;
  final String? icon;
  final String? imageUrl; // Added for deity images

  Deity({
    required this.name,
    required this.description,
    this.icon,
    this.imageUrl,
  });
}

class Trustee {
  final String name;
  final String position;
  final String contact;

  Trustee({required this.name, required this.position, required this.contact});
}

class TempleImageInfo {
  // Renamed to avoid conflict
  final String url;
  final String? title;
  final String caption;

  TempleImageInfo({required this.url, required this.caption, this.title});
}
