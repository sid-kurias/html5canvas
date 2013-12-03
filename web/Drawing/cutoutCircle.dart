import 'dart:html';
import 'dart:math';


class CutoutCircle {
	CanvasElement canvas = null;
	CanvasRenderingContext2D context = null;
	InputElement directionCheckbox, annotationCheckbox = null;
	final num COUNTER_CLOCKWISE = 2,  CLOCKWISE = 1;

// Functions.....................................................
 drawGrid(color, stepx, stepy) {
   context.save();

   context.strokeStyle = color;
   context.fillStyle = '#ffffff';
   context.lineWidth = 0.5;
   context.fillRect(0, 0, context.canvas.width, context.canvas.height);

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

   context.restore();
}

 drawText() {
   context.save();
   context.font = '18px Arial';
   context.fillStyle = 'rgb(0, 0, 200)';
   context.fillText('Two arcs, one path', 10, 30);

   context.font = '16px Lucida Sans';
   context.fillStyle = 'navy';
   context.fillText('context.arc(300, 200, 150, 0, PI*2, false)', 10, 360);
   context.fillText('context.arc(300, 200, 100, 0, PI*2, !sameDirection)', 10, 380);
   context.restore();
}

 drawArcAnnotations(sameDirection) {
   context.save();
   context.font = '16px Lucida Sans';
   context.fillStyle = 'blue';
   context.fillText('CW', 345, 145);
   context.fillText(sameDirection ? 'CW' : 'CCW', 425, 75);
   context.restore();
}

 drawOuterCircleAnnotations(sameDirection) {
   context.save();
   context.beginPath();
   context.moveTo(410, 210);
   context.lineTo(500, 250);
   context.stroke();

   context.beginPath();
   context.arc(500, 250, 3, 0, PI*2, false);
   context.fillStyle = 'navy';
   context.fill();

   context.font = '16px Lucida Sans';
   context.fillText(sameDirection ? '+1' : '-1', 455, 225);
   context.fillText(sameDirection ? '1' : '-1', 515, 255);
   context.restore();
}

 drawInnerCircleAnnotations(sameDirection) {
   context.save();
   context.beginPath();
   context.moveTo(300, 175);
   context.lineTo(100, 250);
   context.stroke();

   context.beginPath();
   context.arc(100, 250, 3, 0, PI*2, false);
   context.fillStyle = 'navy';
   context.fill();

   context.font = '16px Lucida Sans';
   context.fillText('+1', 125, 225);
   context.fillText(sameDirection ? '+1' : '-1', 215, 185);
   context.fillText(sameDirection ? '2' : '0', 75, 255);
   context.restore();
}

 drawAnnotations(sameDirection) {
   context.save();
   context.strokeStyle = 'blue';
   drawInnerCircleAnnotations(sameDirection);
   drawOuterCircleAnnotations(sameDirection);
   drawArcAnnotations(sameDirection);
   context.restore();
}

 drawTwoArcs(sameDirection) {
   context.beginPath();
   context.arc(300, 170, 150, 0, PI*2, false); // outer: CW
   context.arc(300, 170, 100, 0, PI*2, !sameDirection); // innner

	 context.fill();
   context.shadowColor = '0';
   context.shadowOffsetX = 0;
   context.shadowOffsetY = 0;
   context.stroke();
}

 draw(sameDirection) {
   context.clearRect(0, 0, context.canvas.width,
                           context.canvas.height);
   drawGrid('lightgray', 10, 10);

   context.save();

   context.shadowColor = 'rgba(0, 0, 0, 0.8)';
   context.shadowOffsetX = 12;
   context.shadowOffsetY = 12;
   context.shadowBlur = 15;

   drawTwoArcs(directionCheckbox.checked);

   context.restore();

   drawText();

   if (annotationCheckbox.checked) {
      drawAnnotations(directionCheckbox.checked);
   }
}

// Event handlers................................................
// Initialization................................................


	start() {
	canvas = document.getElementById('canvas');
  context = canvas.getContext('2d');
  directionCheckbox = document.getElementById('directionCheckbox');
  annotationCheckbox = document.getElementById('annotationCheckbox');

	context.fillStyle = 'rgba(100, 140, 230, 0.5)';
	context.strokeStyle = context.fillStyle;//'rgba(20, 60, 150, 0.5)';

	draw(directionCheckbox.checked);

	directionCheckbox.onClick.listen((e) {
	draw(directionCheckbox.checked);
	});
	
	annotationCheckbox.onClick.listen((e) {
	draw(directionCheckbox.checked);
	});
}

}

void main() {
	new CutoutCircle().start();
}