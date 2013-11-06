/*
 * 
 * License:
 *
 * Permission is hereby granted, free of charge, to any person 
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * The Software may not be used to create training material of any sort,
 * including courses, books, instructional videos, presentations, etc.
 * without the express written consent of David Geary.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:html';


class RBand  {
  
  CanvasElement canvas = null;
  CanvasRenderingContext2D context = null;
  DivElement rubberbandDiv = null;
  InputElement resetButton = null;
  ImageElement image = null;
  Map mousedown =  null, rubberbandRectangle = null;
  bool dragging = false;
  
  RBand() {
    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    rubberbandDiv = document.getElementById('rubberbandDiv');
    resetButton = document.getElementById('resetButton');
    image = new ImageElement(src: '../shared/images/arch.png');
    mousedown = {'x' : 0, 'y' : 0};
    rubberbandRectangle = {'top' : 0, 'left' : 0, 'width' : 0, 'height' : 0};
    dragging = false;
  }

  rubberbandStart(x, y) {
    mousedown['x'] = x;
    mousedown['y'] = y;

    rubberbandRectangle['left'] = mousedown['x'];
    rubberbandRectangle['top'] = mousedown['y'];

    moveRubberbandDiv();
    showRubberbandDiv();

    dragging = true;
  }

  rubberbandStretch(x, y) {
    rubberbandRectangle['left'] = x < mousedown['x'] ?
        x : mousedown['x'];
    rubberbandRectangle['top']  = y < mousedown['y'] ?
        y : mousedown['y'];

    rubberbandRectangle['width']  =  (x - mousedown['x']).abs();
        rubberbandRectangle['height'] = (y - mousedown['y']).abs();

    moveRubberbandDiv();
    resizeRubberbandDiv();
  }

  rubberbandEnd() {
    var bbox = canvas.getBoundingClientRect();
    try {
      context.drawImage(image, 0, 0);
//      .drawImage(canvas,
//                        rubberbandRectangle.left - bbox.left,
//                        rubberbandRectangle.top - bbox.top,
//                        rubberbandRectangle.width,
//                        rubberbandRectangle.height,
//                        0, 0, canvas.width, canvas.height);
   }
   catch (e) {
      // suppress error message when mouse is released
      // outside the canvas
   }

   resetRubberbandRectangle();

   rubberbandDiv.style.width = '0px';
   rubberbandDiv.style.height = '0px';

   hideRubberbandDiv();

   dragging = false;
   
   
  }

  moveRubberbandDiv() {
    rubberbandDiv.style.top  = "${rubberbandRectangle['top']}" + "px";
    rubberbandDiv.style.left = "${rubberbandRectangle['left']}" + "px";
  }
  
 resizeRubberbandDiv() {
    rubberbandDiv.style.width  = "${rubberbandRectangle['width']}" + "px";
    rubberbandDiv.style.height = "${rubberbandRectangle['height']}" + "px";
  }


 showRubberbandDiv() {
   rubberbandDiv.style.display = 'inline';
  }

 hideRubberbandDiv() {
   rubberbandDiv.style.display = 'none';
  }

 resetRubberbandRectangle() {
   rubberbandRectangle = { 'top': 0, 'left': 0, 'width': 0, 'height': 0 };
  }

  start () {
    context.canvas.onMouseDown.listen(mouseDown);
    window.onMouseMove.listen(windowMouseMove);
    window.onMouseUp.listen(windowMouseUp);
    image.onLoad.listen(loadImage);
    resetButton.onClick.listen(reset);
  }

  mouseDown(MouseEvent event) {
   num x = event.client.x,
       y = event.client.y;
    event.preventDefault(); 
    rubberbandStart(x, y);
  }
  
  windowMouseMove(MouseEvent event) {
    num x = event.client.x,
       y = event.client.y;
    event.preventDefault();
    if (dragging) {
      rubberbandStretch(x, y);
    }        
  }

  windowMouseUp(MouseEvent event) {
     event.preventDefault();
     rubberbandEnd();    
  }
  
  loadImage(Event e) {
    context.drawImage(image, 0, 0);
  }
  
  reset(Event e) {
   context.clearRect(0, 0, context.canvas.width,context.canvas.height);
   context.drawImage(image, 0, 0);
  }
}

main () {
  new RBand().start();
}