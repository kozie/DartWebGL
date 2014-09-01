part of HerpDerp;

class Entity {
	GL.Buffer vertexBuffer;

	Entity() {
		initBuffers();
	}

	void initBuffers() {
		vertexBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);

		Float32List vertices = new Float32List.fromList([
			 0.0,  1.0,  0.0,
			-1.0, -1.0,  0.0,
			 1.0, -1.0,  0.0
		]);

		gl.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
	}

	void render(delta) {
		defaultShader.use();

		int aVertexPosition = gl.getAttribLocation(defaultShader.program, "aVertexPos");
		gl.enableVertexAttribArray(aVertexPosition);

		GL.UniformLocation uPMatrix = gl.getUniformLocation(defaultShader.program, "uPMatrix");
		GL.UniformLocation uMVMatrix = gl.getUniformLocation(defaultShader.program, "uMVMatrix");

		mvMatrix.setIdentity();
		mvMatrix.translate(new Vector3(-1.0, 0.0, -7.0));
		mvMatrix.rotateZ(delta / 2000);
		mvMatrix.rotateX(delta / 2000);
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);

		gl.vertexAttribPointer(aVertexPosition, 3, GL.FLOAT, false, 0, 0);
		gl.uniformMatrix4fv(uPMatrix, false, pMatrix.storage);
		gl.uniformMatrix4fv(uMVMatrix, false, mvMatrix.storage);

		gl.drawArrays(GL.TRIANGLES, 0, 3);
	}
}