import 'dart:html';

class Axes {

	CanvasElement canvas = null;
	CanvasRenderingContext2D context = null;

	final num AXIS_MARGIN = 40, HORIZONTAL_TICK_SPACING = 10, 
						VERTICAL_TICK_SPACING = 10, TICK_WIDTH = 10,
						TICKS_LINEWIDTH = 0.5, AXIS_LINEWIDTH = 1.0;	
	
	final String TICKS_COLOR = 'navy', AXIS_COLOR = 'blue';
	
	var AXIS_ORIGIN;
	
	num axisTop, axisRight, axisWidth, axisHeight, numVerticalTicks,
			numHorizontalTicks;
	
	
	Axes() {
	canvas = document.getElementById('canvas');
	context = canvas.getContext('2d');
	AXIS_ORIGIN = { "x": AXIS_MARGIN, "y": canvas.height-AXIS_MARGIN };
	axisTop   = AXIS_MARGIN;
	axisRight = canvas.width-AXIS_MARGIN;
	axisWidth  = axisRight - AXIS_ORIGIN["x"];
	axisHeight = AXIS_ORIGIN["y"] - axisTop;
	numVerticalTicks   = axisHeight / VERTICAL_TICK_SPACING;
	numHorizontalTicks = axisWidth  / HORIZONTAL_TICK_SPACING;
	}
	
 drawGrid(color, stepx, stepy) {
   context.save();

   context.fillStyle = 'white';
   context.fillRect(0, 0, context.canvas.width, context.canvas.height);

   context.lineWidth = 0.5;
   context.strokeStyle = color;

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

 drawAxes() {
   context.save(); 
   context.strokeStyle = AXIS_COLOR;
   context.lineWidth = AXIS_LINEWIDTH;

   drawHorizontalAxis();
   drawVerticalAxis();

   context.lineWidth = 0.5;
   context.lineWidth = TICKS_LINEWIDTH;
   context.strokeStyle = TICKS_COLOR;

   drawVerticalAxisTicks();
   drawHorizontalAxisTicks();

   context.restore();
}

 drawHorizontalAxis() {
   context.beginPath();
   context.moveTo(AXIS_ORIGIN["x"], AXIS_ORIGIN["y"]);
   context.lineTo(axisRight,    AXIS_ORIGIN["y"]);
   context.stroke();
}

drawVerticalAxis() {
   context.beginPath();
   context.moveTo(AXIS_ORIGIN["x"], AXIS_ORIGIN["y"]);
   context.lineTo(AXIS_ORIGIN["x"], axisTop);
   context.stroke();
}

drawVerticalAxisTicks() {
   var deltaX;
   
   for (var i=1; i < numVerticalTicks; ++i) {
      context.beginPath();

      if (i % 5 == 0) deltaX = TICK_WIDTH;
      else deltaX = TICK_WIDTH/2;
              
      context.moveTo(AXIS_ORIGIN["x"] - deltaX,
                     AXIS_ORIGIN["y"] - i * VERTICAL_TICK_SPACING);

      context.lineTo(AXIS_ORIGIN["x"] + deltaX,
                     AXIS_ORIGIN["y"] - i * VERTICAL_TICK_SPACING);

      context.stroke();
   }
}

 drawHorizontalAxisTicks() {
   var deltaY;
   
   for (var i=1; i < numHorizontalTicks; ++i) {
      context.beginPath();

      if (i % 5 == 0) deltaY = TICK_WIDTH;
      else deltaY = TICK_WIDTH/2;
              
      context.moveTo(AXIS_ORIGIN["x"] + i * HORIZONTAL_TICK_SPACING,
                     AXIS_ORIGIN["y"] - deltaY);

      context.lineTo(AXIS_ORIGIN["x"] + i * HORIZONTAL_TICK_SPACING,
                     AXIS_ORIGIN["y"] + deltaY);

      context.stroke();
   }
}

// Initialization................................................



start() {
	drawGrid('lightgray', 10, 10);
	drawAxes();	
}

}
void main() {
	new Axes().start();
}