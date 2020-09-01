import 'package:flutter/material.dart';

class Reaction {
  final int id;

  /// Widget showing as button after selecting preview Icon from box appear.
  final Widget icon;

  /// Widget showing when reactions box appear.
  ///
  /// If it's null will replace by [icon].
  Widget previewIcon;

  final bool enabled;

  final String reactionText;

  bool reactionSoundEffect=false;


  Reaction({
    this.id,
    this.previewIcon,
    @required this.icon,
    @required this.reactionText,
    this.reactionSoundEffect,
    this.enabled = true,
  }) {
    assert(reactionText != null);
    assert(icon != null);
    this.previewIcon = previewIcon ?? this.icon;
  }

  @override
  bool operator ==(Object object) =>
      object != null && object is Reaction && this.id == object.id;

  @override
  int get hashCode => id.hashCode;
}
