library HerpDerp;

import "dart:html";
import "dart:typed_data";
import "dart:web_gl" as GL;
import "package:vector_math/vector_math.dart";

part "shader.dart";
part "entity.dart";

const double MIN_RATIO = 4/3;
const double MAX_RATIO = 2/1;

// Core canvas and WebGL stuff
CanvasElement canvas;
GL.RenderingContext gl;

// Core gl stuff
Matrix4 mvMatrix = new Matrix4.identity();
Matrix4 pMatrix = new Matrix4.identity();

// List with entities
List<Entity> entities = new List<Entity>();

// Shaders
Shader defaultShader = new Shader('default');

void main() {
	canvas = document.querySelector("#stage");
	gl = canvas.getContext("webgl");

	if (gl == null) gl = canvas.getContext('experimental-webgl');

	if (gl == null) {
		noWebGL();
		return;
	} else {
		resize();
	}

	// Resize
	window.onResize.listen((e) => resize());

	gl.clearColor(0, 0, 0, 1.0);
	gl.enable(GL.DEPTH_TEST);
	gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

	// Init entities
	entities.add(new Entity());

	// Render when possible
	window.requestAnimationFrame(render);
}

void render(delta) {
	if (defaultShader.ready) {
		entities.forEach((entity) {
			entity.render(delta);
		});
	}

	window.requestAnimationFrame(render);
}

void resize() {
	int width = window.innerWidth;
	int height = window.innerHeight;
	int screenWidth = width;
	int screenHeight = height;
	double ratio = width/height;

	if (ratio < MIN_RATIO) {
		screenHeight ~/= MIN_RATIO / ratio;
	}

	if (ratio > MAX_RATIO) {
		screenWidth ~/= ratio / MAX_RATIO;
	}

	// Set camera perspective and viewport
	gl.viewport(0, 0, screenWidth, screenHeight);
	setPerspectiveMatrix(pMatrix, 45, screenWidth / screenHeight, 0.1, 100.0);

	canvas.width = screenWidth;
	canvas.height = screenHeight;
	canvas.style.width = '${screenWidth}px';
	canvas.style.height= '${screenHeight}px';
	canvas.style.left = '${(width - screenWidth) ~/ 2}px';
	canvas.style.top = '${(height - screenHeight) ~/ 2.5}px';
}

void noWebGL() {
	throw new Exception("No WebGL support!");
}
