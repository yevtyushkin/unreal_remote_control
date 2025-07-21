import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:shadcn_flutter/shadcn_flutter.dart';

extension ColorHelper on ui.Color {
  int get redInt => _floatingChannelToInt(r);

  double get redLinear => _sRGBToLinear(r);

  int get greenInt => _floatingChannelToInt(g);

  double get greenLinear => _sRGBToLinear(g);

  int get blueInt => _floatingChannelToInt(b);

  double get blueLinear => _sRGBToLinear(b);

  int get alphaInt => _floatingChannelToInt(a);

  double get alphaDouble => a;

  static ui.Color colorLinear({
    required double r,
    required double g,
    required double b,
    required double a,
  }) {
    return ui.Color.from(
      // Alpha remains unchanged.
      alpha: a,
      red: _linearToSRGB(r),
      green: _linearToSRGB(g),
      blue: _linearToSRGB(b),
      // I have no idea what I'm doing here, lol.
      // This is basically an attempt to display colors outside of [0; 1] range
      // as close as it's possible to FLinearColor in UE.
      colorSpace: ui.ColorSpace.extendedSRGB,
    );
  }

  ui.Color withRedLinear(double red) {
    return withValues(
      red: _linearToSRGB(red),
      colorSpace: ui.ColorSpace.extendedSRGB,
    );
  }

  ui.Color withGreenLinear(double green) {
    return withValues(
      green: _linearToSRGB(green),
      colorSpace: ui.ColorSpace.extendedSRGB,
    );
  }

  ui.Color withBlueLinear(double blue) {
    return withValues(
      blue: _linearToSRGB(blue),
      colorSpace: ui.ColorSpace.extendedSRGB,
    );
  }

  ui.Color withAlphaDouble(double alpha) {
    return withValues(
      alpha: alpha,
      colorSpace: ui.ColorSpace.extendedSRGB,
    );
  }

  String get hex {
    final hex = toHex();

    // toHex() returns: AARRGGBB
    // UE expects: RRGGBBAA
    // Logic: # + RRGGBB (substring(2)) + AA (substring(0, 2))
    return '#${hex.substring(2)}${hex.substring(0, 2)}'.toUpperCase();
  }
}

int _floatingChannelToInt(double channel) {
  return (channel * 255.0).round() & 0xff;
}

double _linearToSRGB(double c) {
  if (c <= 0.0031308) {
    return 12.92 * c;
  } else {
    return 1.055 * math.pow(c, 1.0 / 2.4) - 0.055;
  }
}

double _sRGBToLinear(double c) {
  if (c <= 0.04045) {
    return c / 12.92;
  } else {
    return math.pow((c + 0.055) / 1.055, 2.4) as double;
  }
}
