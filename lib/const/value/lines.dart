import 'package:flutter/material.dart';

import '../../ui/component/widget_container.dart';

class Lines extends WidgetContainer {
  const Lines.h1(Color coloBorder) : super(height: 1, colorBorder: coloBorder, colorBg: coloBorder);

  const Lines.h2(Color coloBorder) : super(height: 2, colorBorder: coloBorder, colorBg: coloBorder);

  const Lines.h3(Color coloBorder) : super(height: 3, colorBorder: coloBorder, colorBg: coloBorder);

  const Lines.h4(Color coloBorder) : super(height: 4, colorBorder: coloBorder, colorBg: coloBorder);

  const Lines.h10(Color coloBorder) : super(height: 10, colorBorder: coloBorder, colorBg: coloBorder);
}

class LinesWidth extends WidgetContainer {
  const LinesWidth.h1(Color coloBorder) : super(height: 1, colorBorder: coloBorder, width: 50, colorBg: coloBorder);

  const LinesWidth.h2(Color coloBorder) : super(height: 2, colorBorder: coloBorder, width: 50, colorBg: coloBorder);

  const LinesWidth.h3(Color coloBorder) : super(height: 3, colorBorder: coloBorder, width: 50, colorBg: coloBorder);

  const LinesWidth.h4(Color coloBorder) : super(height: 4, colorBorder: coloBorder, width: 50, colorBg: coloBorder);
}
