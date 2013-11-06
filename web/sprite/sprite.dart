import 'dart:html';
import 'dart:async';


class SpriteInspector {
  CanvasElement canvas = null;
  CanvasRenderingContext2D context = null;
  ImageElement spriteSheet = null;
  Element readOut = null;
  
  SpriteInspector () {
    canvas = document.query("#canvas");
    context = canvas.getContext("2d");  
    spriteSheet = new ImageElement(src: 'running-sprite-sheet.png');
    readOut = document.query("#readout");        
  }
  
  drawSpriteSheet() {
    context.drawImage(spriteSheet, 0, 0);
  }
  
  drawBackground() {
     const num VLINE_SPACING = 12;
     var height = context.canvas.height;
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.strokeStyle = 'lightgray';
    context.lineWidth = 0.5;
    while (height > VLINE_SPACING*4) {
      context.beginPath();
      context.moveTo(0, height);
      context.lineTo(context.canvas.width, height);
      context.stroke();
      height -= VLINE_SPACING;
    }
  }
  
  drawGuideLines(num x, num y) {
    context.strokeStyle = 'rgba(0,0,230,0.8)';
    context.lineWidth = 0.5;
    drawVerticalLine(x);
    drawHorizontalLine(y);
  }
  
  updateReadout(num x, num y) {
    readOut.innerHtml = '(' + x.toStringAsFixed(0) + ',' + 
        y.toStringAsFixed(0) + ')'; 
  }
  
  drawHorizontalLine (num y) {
    context.beginPath();
    context.moveTo(0, y + .5);
    context.lineTo(context.canvas.width, y + .5);
    context.stroke();
  }
  
  drawVerticalLine(num x) {
    context.beginPath();
    context.moveTo(x + 0.5, 0);
    context.lineTo(x + .5, context.canvas.height);
    context.stroke();
  }
  
  windowToCanvas(CanvasElement canvas, Point loc) {
    var bbox = canvas.getBoundingClientRect();
    return {
      'x' : loc.x - bbox.left * (canvas.width / bbox.width),
      'y' : loc.y - bbox.top * (canvas.height / bbox.height)
    };
  }
  
  start() {
    canvas.onMouseMove.listen((e) {
      var loc = windowToCanvas(canvas,e.client);
      drawBackground();
      drawSpriteSheet();
      drawGuideLines(loc['x'], loc['y']);
      updateReadout(loc['x'], loc['y']);
    });
    spriteSheet.onLoad.listen(drawSpriteSheet());
    drawBackground();
  }
    
}

void main() {
  SpriteInspector si = new SpriteInspector();
  si.start();
}


