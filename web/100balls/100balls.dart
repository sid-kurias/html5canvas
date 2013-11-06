import 'dart:html';
import 'dart:math';
import 'dart:async';

class JumpingBalls {
  CanvasElement canvas = null;
  CanvasRenderingContext2D context = null;
  AnchorElement startButton = null;
  DivElement glassPane = null;
  bool paused = null;
  List circles = null;
  
  JumpingBalls() {
    canvas = document.querySelector("#canvas");
    context = canvas.getContext("2d");
    startButton = querySelector("#startButton");
    glassPane = querySelector("#glasspane");
    paused = true;
    circles = [];
    context.lineWidth = 0.5;
    context.font = '32pt Ariel';
  }
  
  initializeCircles() {
    var rnd = new Random();
    for (var i=0; i < 100; ++i) {
      circles.add({ 
        'x': 100, 
        'y': 100, 
        'velocityX': 3 * rnd.nextDouble(), 
        'velocityY': 3 * rnd.nextDouble(), 
        'radius': 50 * rnd.nextDouble(),
        'color': 'rgba(' + rnd.nextInt(255).toString() + ', ' +
        rnd.nextInt(255).toString() + ', ' +
        rnd.nextInt(255).toString() + ', 1.0)' 
      }) ;
    }
  }

  adjustPosition(circle) {
    if (circle['x'] + circle['velocityX'] + circle['radius'] > 
      context.canvas.width || 
      circle['x'] + circle['velocityX'] - circle['radius'] < 0) 
        circle['velocityX'] = -circle['velocityX'];

    if (circle['y'] + circle['velocityY'] + circle['radius'] > 
      context.canvas.height ||
      circle['y'] + circle['velocityY'] - circle['radius']  < 0) 
        circle['velocityY'] = -circle['velocityY'];  

    circle['x'] += circle['velocityX'];
    circle['y'] += circle['velocityY'];
  }

  drawGrid(context, color, stepx, stepy) {
    context.strokeStyle = color;
    context.lineWidth = 0.5;

    for (var i = stepx + 0.5; i < context.canvas.width; i += stepx) {
      context.beginPath();
      context.moveTo(i, 0);
      context.lineTo(i, context.canvas.height);
      context.stroke();
    }

    for (var i = stepy + 0.5; i < context.canvas.height; i += stepy) {
      context.beginPath();
      context.moveTo(0, i);
      context.lineTo(context.canvas.width, i);
      context.stroke();
    }
  }

  drawCircles(num _) {
    if (!paused) {
      context.clearRect(0, 0, context.canvas.width, context.canvas.height);
      drawGrid(context, 'lightgray', 10, 10);
      circles.forEach((circle) {
        context.beginPath();
        context.arc(circle['x'], circle['y'], 
            circle['radius'], 0, PI*2, false);
        context.fillStyle = circle['color'];
        context.fill(); 
        adjustPosition(circle);
      });
    }
    window.requestAnimationFrame(drawCircles);
  }
  
  start () {
    drawGrid(context, 'lightgray', 10, 10);
    initializeCircles();
    startButton.onClick.listen((e) {
      e.preventDefault();
      e.stopPropagation();
      paused = ! paused;
      startButton.text = paused ? 'Start' : 'Stop';
    });
    glassPane.onMouseDown.listen((e) { 
      e.preventDefault();
      e.stopPropagation();
    });
    context.canvas.onMouseDown.listen ((e) {
      e.preventDefault();
      e.stopPropagation();
    });
    drawCircles(1);
//    Timer tm = new Timer.periodic(const Duration(milliseconds: 1000)~/60, 
//        drawCircles);
  }
}

void main () {
  new JumpingBalls().start();
}