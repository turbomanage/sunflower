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
const maxDelay = const Duration(milliseconds:500);

final InputElement slider = querySelector("#slider");
final InputElement phiSlider = querySelector("#phi_slider");
final ButtonElement x1Button = querySelector("#x1");
final ButtonElement x5Button = querySelector("#x5");
final ButtonElement x10Button = querySelector("#x10");
final ButtonElement x15Button = querySelector("#x15");
final ButtonElement x20Button = querySelector("#x20");
final ButtonElement x30Button = querySelector("#x30");
final ButtonElement x50Button = querySelector("#x50");
final ButtonElement x100Button = querySelector("#x100");
final ButtonElement x200Button = querySelector("#x200");
final ButtonElement clearButton = querySelector("#clearButton");
final TextInputElement notes = querySelector("#notes");
final TextInputElement theta = querySelector("#theta");
final ButtonElement resetButton = querySelector("#resetButton");
final num PHI = (sqrt(5) + 1) / 2;
int seeds = 0;
int n = 0;
num phi = PHI;
Timer timer;
//boolean autoMode;

final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  slider.onChange.listen((e) => onSlide());
  slider.onInput.listen((e) => onSlide());
  slider.onKeyDown.listen((e) => onSlide());
  phiSlider.onChange.listen((e) => onSlide());
  phiSlider.onInput.listen((e) => onSlide());
  phiSlider.onKeyDown.listen((e) => onSlide());
  x1Button.onClick.listen((e) => grow(1));
  x5Button.onClick.listen((e) => grow(5));
  x10Button.onClick.listen((e) => grow(10));
  x15Button.onClick.listen((e) => grow(15));
  x20Button.onClick.listen((e) => grow(20));
  x30Button.onClick.listen((e) => grow(30));
  x50Button.onClick.listen((e) => grow(50));
  x100Button.onClick.listen((e) => grow(100));
  x200Button.onClick.listen((e) => grow(200));
  clearButton.onClick.listen((e) => clear());
  notes.onChange.listen((e) => onInput());
  theta.onChange.listen((e) => onInput());
  resetButton.onClick.listen((e) => reset());
  // init
  onSlide();
}

void onInput() {
  seeds = int.parse(notes.value);
  phi = double.parse(theta.value);
  slider.value = notes.value;
  phiSlider.value = "${phi * 10000}";
  draw();
}

void onSlide() {
  seeds = int.parse(slider.value);
  phi = int.parse(phiSlider.value) / 10000;
  notes.value = "${seeds}";
  theta.value = "${phi}";
  draw();
}

void reset() {
  notes.value = "${500}";
  theta.value = "${PHI}";
  onInput();
}

void clear() {
  if (timer != null) {
    timer.cancel();
  }
  context.clearRect(0, 0, MAX_D, MAX_D);
}

/// Draw the complete figure for the current number of seeds.
void draw() {
  context.clearRect(0, 0, MAX_D, MAX_D);
  for (var i = 0; i < seeds; i++) {
    drawSeed(i);
  }
  drawEnclosingArc();
}

void grow(int speed) {
  if (timer != null) {
    timer.cancel();
  }
  context.clearRect(0, 0, MAX_D, MAX_D);
  n = 1;
  timer = new Timer.periodic(maxDelay~/speed, (Timer t) => growSeed(t));
  drawEnclosingArc();
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
         ..arc(centerX, centerY, sqrt(seeds) * SCALE_FACTOR + SEED_RADIUS * 2, 0, TAU,
  false)
         ..closePath()
         ..stroke();
}
