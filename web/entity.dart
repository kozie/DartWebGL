part of HerpDerp;

class Entity {
	GL.Buffer vertexPositionBuffer;
	GL.Buffer vertexColorBuffer;
	GL.Buffer vertexIndexBuffer;

	Entity() {
		initBuffers();
	}

	void initBuffers() {
		// Vertex buffer
		vertexPositionBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexPositionBuffer);

		Float32List vertices = new Float32List.fromList([
			// Front
			-1.0,  1.0, -1.0,
			 1.0,  1.0, -1.0,
			-1.0, -1.0, -1.0,
			 1.0, -1.0, -1.0,

			 // Back
			-1.0,  1.0,  1.0,
 			 1.0,  1.0,  1.0,
 			-1.0, -1.0,  1.0,
 			 1.0, -1.0,  1.0
		]);

		gl.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);

		// Color buffer
		vertexColorBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexColorBuffer);

		Float32List colors = new Float32List.fromList([
			// Front
			1.0, 0.0, 0.0, 1.0,
			0.0, 1.0, 0.0, 1.0,
			0.0, 0.0, 1.0, 1.0,
			0.0, 0.0, 1.0, 1.0,

			// Back
			1.0, 0.0, 0.0, 1.0,
			0.0, 1.0, 0.0, 1.0,
			0.0, 0.0, 1.0, 1.0,
			0.0, 0.0, 1.0, 1.0
		]);

		gl.bufferData(GL.ARRAY_BUFFER, colors, GL.STATIC_DRAW);

		// Index buffer
		vertexIndexBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, vertexIndexBuffer);

		Uint16List index = new Uint16List.fromList([
			0, 1, 2,	1, 2, 3,	// Front
			4, 5, 6,	5, 6, 7 	// Back
		]);

		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, index, GL.STATIC_DRAW);
	}

	void render(delta) {
		defaultShader.use();

		int aVertexPosition = gl.getAttribLocation(defaultShader.program, "aVertexPos");
		gl.enableVertexAttribArray(aVertexPosition);

		int aVertexColor = gl.getAttribLocation(defaultShader.program, "aVertexColor");
		gl.enableVertexAttribArray(aVertexColor);

		GL.UniformLocation uPMatrix = gl.getUniformLocation(defaultShader.program, "uPMatrix");
		GL.UniformLocation uMVMatrix = gl.getUniformLocation(defaultShader.program, "uMVMatrix");

		mvMatrix.setIdentity();
		mvMatrix.translate(new Vector3(-1.0, 0.0, -7.0));
		mvMatrix.rotateZ(delta / 2000);
		mvMatrix.rotateX(delta / 2000);

		gl.bindBuffer(GL.ARRAY_BUFFER, vertexPositionBuffer);
		gl.vertexAttribPointer(aVertexPosition, 3, GL.FLOAT, false, 0, 0);

		gl.bindBuffer(GL.ARRAY_BUFFER, vertexColorBuffer);
		gl.vertexAttribPointer(aVertexColor, 4, GL.FLOAT, false, 0, 0);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, vertexIndexBuffer);

		gl.uniformMatrix4fv(uPMatrix, false, pMatrix.storage);
		gl.uniformMatrix4fv(uMVMatrix, false, mvMatrix.storage);

		gl.drawElements(GL.TRIANGLES, 12, GL.UNSIGNED_SHORT, 0);
	}
}
