// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sunflower;

import 'dart:html';
import 'dart:math';
import 'dart:async';

const String ORANGE = "orange";
const int SEED_RADIUS = 2;
const int SCALE_FACTOR = 4;
const num TAU = PI * 2;
const int MAX_D = 500;
const num centerX = MAX_D / 2;
const num centerY = centerX;
Duration x1Delay = const Duration(milliseconds:21);
Duration x2Delay = const Duration(milliseconds:13);
Duration x3Delay = const Duration(milliseconds:8);
Duration x5Delay = const Duration(milliseconds:5);
Duration x8Delay = const Duration(milliseconds:3);
Duration x13Delay = const Duration(milliseconds:2);

final InputElement slider = querySelector("#slider");
final InputElement phiSlider = querySelector("#phi_slider");
final ButtonElement x1Button = querySelector("#x1");
final ButtonElement x2Button = querySelector("#x2");
final ButtonElement x3Button = querySelector("#x3");
final ButtonElement x5Button = querySelector("#x5");
final ButtonElement x8Button = querySelector("#x8");
final ButtonElement x13Button = querySelector("#x13");
final ButtonElement clearButton = querySelector("#clearButton");
final Element notes = querySelector("#notes");
final Element theta = querySelector("#theta");
final num PHI = (sqrt(5) + 1) / 2;
int seeds = 0;
int n = 0;
num phi = PHI;
Timer timer;
//boolean autoMode;

final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  slider.onChange.listen((e) => draw());
  slider.onInput.listen((e) => draw());
  slider.onKeyDown.listen((e) => draw());
  phiSlider.onChange.listen((e) => draw());
  phiSlider.onInput.listen((e) => draw());
  phiSlider.onKeyDown.listen((e) => draw());
  x1Button.onClick.listen((e) => grow(x1Delay));
  x2Button.onClick.listen((e) => grow(x2Delay));
  x3Button.onClick.listen((e) => grow(x3Delay));
  x5Button.onClick.listen((e) => grow(x5Delay));
  x8Button.onClick.listen((e) => grow(x8Delay));
  x13Button.onClick.listen((e) => grow(x13Delay));
  clearButton.onClick.listen((e) => clear());
//  autoBox.onChange.listen((e) => setMode());
//  draw();
}

void clear() {
  if (timer != null) {
    timer.cancel();
  }
  context.clearRect(0, 0, MAX_D, MAX_D);
}

/// Draw the complete figure for the current number of seeds.
void draw() {
  seeds = int.parse(slider.value);
  phi = int.parse(phiSlider.value) / 10000;
  context.clearRect(0, 0, MAX_D, MAX_D);
  for (var i = 0; i < seeds; i++) {
    drawSeed(i);
  }
  drawEnclosingArc();
  notes.text = "${seeds} seeds";
  theta.text = "${phi} = phi";
}

void grow(Duration delay) {
  if (timer != null) {
    timer.cancel();
  }
  seeds = int.parse(slider.value);
  phi = int.parse(phiSlider.value) / 10000;
  context.clearRect(0, 0, MAX_D, MAX_D);
  n = 1;
  timer = new Timer.periodic(delay, (Timer t) => growSeed(t));
  drawEnclosingArc();
  notes.text = "${seeds} seeds";
  theta.text = "${phi} = phi";
}

void drawSeed(int i) {
  final num theta = i * TAU / phi;
  final num r = sqrt(i) * SCALE_FACTOR;
  drawSeedAt(centerX + r * cos(theta), centerY - r * sin(theta));
}

bool growSeed(Timer t) {
  final num theta = n * TAU / phi;
  final num r = sqrt(n) * SCALE_FACTOR;
  drawSeedAt(centerX + r * cos(theta), centerY - r * sin(theta));
    if (n < seeds) {
      n++;
    } else {
      t.cancel();
    }
}

/// Draw a small circle representing a seed centered at (x,y).
void drawSeedAt(num x, num y) {
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
