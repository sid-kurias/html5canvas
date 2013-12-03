import 'dart:html';


class RubberBandLines {
  CanvasElement canvas = null;
  CanvasRenderingContext2D context = null;
  ButtonInputElement eraseAllButton;
  SelectElement strokeStyleSelect;
  CheckboxInputElement guideWireCheckBox;
  ImageData drawingSurfaceImageData;
  Map mouseDown, rubberBandRect;
  bool dragging, guideWires;

	
  RubberBandLines () {
    mouseDown = new Map<String, num>();
    rubberBandRect = new Map <String, num>();
    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    eraseAllButton = document.getElementById('eraseAllButton');
    strokeStyleSelect = document.getElementById('strokeStyleSelect');
    guideWireCheckBox = document.getElementById('guidewireCheckbox');
    dragging = false;
    guideWires = guideWireCheckBox.checked;
  }
	
  start() {
	
    canvas.onMouseDown.listen((e) {
      var loc = windowToCanvas(e.client.x, e.client.y);
   
      e.preventDefault(); // prevent cursor change

      saveDrawingSurface();
      mouseDown['x'] = loc['x'];
      mouseDown['y']= loc['y'];
      dragging = true;
    });

    canvas.onMouseMove.listen((e) {
      var loc; 

      if (dragging) {
        e.preventDefault(); // prevent selections

        loc = windowToCanvas(e.client.x, e.client.y);
        restoreDrawingSurface();
        updateRubberband(loc);

        if(guideWires) {
          drawGuidewires(loc['x'], loc['y']);
        }
      }
    });

    canvas.onMouseUp.listen((e) {
      var loc = windowToCanvas(e.client.x, e.client.y);
      restoreDrawingSurface();
      updateRubberband(loc);
      dragging = false;
    });

    // Controls event handlers.......................................

    eraseAllButton.onClick.listen((e) {
      context.clearRect(0, 0, canvas.width, canvas.height);
      drawGrid('lightgray', 10, 10);
//      saveDrawingSurface(); 
    });

    strokeStyleSelect.onChange.listen((e) {
      context.strokeStyle = strokeStyleSelect.value;
    });

    guideWireCheckBox.onChange.listen((e) {
      guideWires = guideWireCheckBox.checked;
    });

    // Initialization................................................

    context.strokeStyle = strokeStyleSelect.value;
    drawGrid('lightgray', 10, 10);
  }


  // Functions..........................................................

  drawGrid(color, stepx, stepy) {
    context.save();

    context.strokeStyle = color;
    context.lineWidth = 0.5;
    context.clearRect(0, 0, context.canvas.width, context.canvas.height);

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

  windowToCanvas(x, y) {
    var bbox = canvas.getBoundingClientRect();
    return { 'x': x - bbox.left * (canvas.width  / bbox.width),
      'y': y - bbox.top  * (canvas.height / bbox.height) };
  }

  // Save and restore drawing surface...................................
  saveDrawingSurface() {
    drawingSurfaceImageData = context.getImageData(0, 0,
        canvas.width,
        canvas.height);
  }

  restoreDrawingSurface() {
    context.putImageData(drawingSurfaceImageData, 0, 0);
  }

  // Rubberbands........................................................

  updateRubberbandRectangle(Map loc) {
 	 num temp;
 	 temp = loc['x'] - mouseDown['x'];	
    rubberBandRect['width']  = temp.abs();
	 temp = loc['y'] - mouseDown['y'];
    rubberBandRect['y'] = temp.abs();

    if (loc['x'] > mouseDown['x']) rubberBandRect['left'] = mouseDown['x'];
    else                     rubberBandRect['left'] = loc['x'];

    if (loc['y'] > mouseDown['y']) rubberBandRect['top'] = mouseDown['y'];
    else                     rubberBandRect['top'] = loc['y'];

    context.save();
    context.strokeStyle = 'red';
    context.restore();
  } 

  drawRubberbandShape(Map loc) {
    context.beginPath();
    context.moveTo(mouseDown['x'], mouseDown['y']);
    context.lineTo(loc['x'], loc['y']);
    context.stroke();
  }

  updateRubberband(Map loc) {
    updateRubberbandRectangle(loc);
    drawRubberbandShape(loc);
  }

  // Guidewires.........................................................

  Map drawHorizontalLine (y) {
    context.beginPath();
    context.moveTo(0,y+0.5);
    context.lineTo(context.canvas.width,y+0.5);
    context.stroke();
  }

  Map drawVerticalLine (x) {
    context.beginPath();
    context.moveTo(x+0.5,0);
    context.lineTo(x+0.5,context.canvas.height);
    context.stroke();
  }

  Map drawGuidewires(x, y) {
    context.save();
    context.strokeStyle = 'rgba(0,0,230,0.4)';
    context.lineWidth = 0.5;
    drawVerticalLine(x);
    drawHorizontalLine(y);
    context.restore();
  }

}

void main() {
  new RubberBandLines().start();
}