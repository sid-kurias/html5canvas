import 'dart:html';
import 'dart:async';

class Patterns {
  CanvasElement canvas = null;
  CanvasRenderingContext2D context = null;
  ImageElement image = null;
  
  fillCanvasWithPattern(repeatString) {
    var pattern = context.createPatternFromImage(image, repeatString);
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = pattern;
    context.fillRect(0, 0, canvas.width, canvas.height);
  }

  start () {
    var repeatRadio = document.getElementById('repeatRadio'),
        noRepeatRadio = document.getElementById('noRepeatRadio'),
        repeatXRadio = document.getElementById('repeatXRadio'),
        repeatYRadio = document.getElementById('repeatYRadio');

    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    image = new ImageElement();

 
    repeatRadio.onClick.listen((e) {
      fillCanvasWithPattern('repeat'); 
    });

    repeatXRadio.onClick.listen((e) {
      fillCanvasWithPattern('repeat-x'); 
    });

    repeatYRadio.onClick.listen((e) {
      fillCanvasWithPattern('repeat-y'); 
    });

    noRepeatRadio.onClick.listen((e) {
      fillCanvasWithPattern('no-repeat'); 
    });

    image.src = 'redball.png';
    image.onLoad.listen((e) {
      fillCanvasWithPattern('repeat');
    });    
    }
}

void main () {
  new Patterns().start();
}