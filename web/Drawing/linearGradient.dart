import 'dart:html';


class LinearGradient {
  CanvasElement canvas = null;
  CanvasRenderingContext2D context = null;
    
  start () {
    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    
    CanvasGradient gradient = context.createLinearGradient(0, 0, canvas.width, 0);
    
    gradient.addColorStop(0, 'blue');
    gradient.addColorStop(0.25, 'white');
    gradient.addColorStop(0.5, 'purple');
    gradient.addColorStop(0.75, 'red');
    gradient.addColorStop(1, 'yellow');
    
    context.fillStyle = gradient;
    context.fillRect(0, 0, canvas.width, canvas.height);
    }
}


void main () {
  new LinearGradient().start();
}