attribute vec3 aVertexPos;
attribute vec4 aVertexColor;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;

varying vec4 vColor;

void main(void) {
	gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPos, 1.0);
	vColor = aVertexColor;
}