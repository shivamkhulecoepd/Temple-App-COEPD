// Add this to a separate file or at the top of your main file
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
  final String icon;

  Deity({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class Trustee {
  final String name;
  final String position;
  final String contact;

  Trustee({
    required this.name,
    required this.position,
    required this.contact,
  });
}