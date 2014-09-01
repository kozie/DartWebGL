attribute vec3 aVertexPos;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;

void main(void) {
	gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPos, 1.0);
}