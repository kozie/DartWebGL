part of	HerpDerp;

class Shader {

	String name;
	GL.Program program;

	bool ready = false;

	Shader(this.name) {
		loadString('shader/${this.name}.vertex.glsl', (vertexSource) {
			loadString('shader/${this.name}.fragment.glsl', (fragmentSource) {
				create(vertexSource, fragmentSource);
				ready = true;
			});
		});
	}

	void create(String vertexSource, String fragmentSource) {
		GL.Shader vertexShader = compile(vertexSource, GL.VERTEX_SHADER);
		GL.Shader fragmentShader = compile(fragmentSource, GL.FRAGMENT_SHADER);
		program = link(vertexShader, fragmentShader);
	}

	void use() {
		gl.useProgram(program);
	}

	GL.Program link(GL.Shader vertexShader, GL.Shader fragmentShader) {
		GL.Program program = gl.createProgram();
		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (!gl.getProgramParameter(program, GL.LINK_STATUS)) {
			throw gl.getProgramInfoLog(program);
		}

		return program;
	}

	GL.Shader compile(String source, int type) {
		GL.Shader shader = gl.createShader(type);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);

		if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
			throw gl.getShaderInfoLog(shader);
		}

		return shader;
	}
}

void loadString(String url, Function onLoad) {
	HttpRequest req = new HttpRequest();
	req.open('GET', url);
	req.responseType = "text/plain";
	req.onLoadEnd.listen((e) {
		onLoad(req.response as String);
	});
	req.send();
}