// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sunflower;

import 'dart:html';
import 'dart:math';

const String ORANGE = "orange";
const int SEED_RADIUS = 2;
const int SCALE_FACTOR = 4;
const num TAU = PI * 2;
const int MAX_D = 300;
const num centerX = MAX_D / 2;
const num centerY = centerX;

final InputElement slider = querySelector("#slider");
final InputElement phiSlider = querySelector("#phi_slider");
final Element notes = querySelector("#notes");
final Element theta = querySelector("#theta");
final num PHI = (sqrt(5) + 1) / 2;
int seeds = 0;
num phi = PHI;

final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  slider.onChange.listen((e) => draw());
  slider.onMouseMove.listen((e) => draw());
  slider.onKeyDown.listen((e) => draw());
  phiSlider.onChange.listen((e) => draw());
  phiSlider.onMouseMove.listen((e) => draw());
  phiSlider.onKeyDown.listen((e) => draw());
  draw();
}

/// Draw the complete figure for the current number of seeds.
void draw() {
  seeds = int.parse(slider.value);
  phi = int.parse(phiSlider.value) / 10000;
  context.clearRect(0, 0, MAX_D, MAX_D);
  for (var i = 0; i < seeds; i++) {
    final num theta = i * TAU / phi;
    final num r = sqrt(i) * SCALE_FACTOR;
    drawSeed(centerX + r * cos(theta), centerY - r * sin(theta));
  }
  drawEnclosingArc();
  notes.text = "${seeds} seeds";
  theta.text = "${phi} = phi";
}

/// Draw a small circle representing a seed centered at (x,y).
void drawSeed(num x, num y) {
  context..beginPath()
         ..lineWidth = 2
         ..fillStyle = ORANGE
         ..strokeStyle = ORANGE
         ..arc(x, y, SEED_RADIUS, 0, TAU, false)
         ..fill()
         ..closePath()
         ..stroke();
}

/// Draw arc around all the seeds
void drawEnclosingArc() {
  context..beginPath()
         ..lineWidth = 1
         ..strokeStyle = 'blue'
         ..arc(centerX, centerY, sqrt(seeds) * SCALE_FACTOR, 0, TAU, false)
         ..closePath()
         ..stroke();
}
