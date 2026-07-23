import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

/// A few sample palettes so a dev can see, live, how swapping
/// `VmColorPalette` changes the theme without touching any component.
final mockPalettes = <String, VmColorPalette>{
  'Ocean': VmColorPalette.mock(),
  'Sunset': const VmColorPalette(
    primary: Color(0xFFE0475C),
    secondary: Color(0xFF00A699),
    tertiary: Color(0xFFFFB400),
    error: Color(0xFFB3261E),
  ),
  'Forest': const VmColorPalette(
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFF9CCC65),
    tertiary: Color(0xFF6D4C41),
    error: Color(0xFFB3261E),
  ),
};
