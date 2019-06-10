program glDemo1;

type
  // Android classes
  Bundle = external class(android.os.Bundle)
  end;

  Context = external class(android.content.Context)
  end;

  EGLConfig = external class(javax.microedition.khronos.egl.EGLConfig)
  end;
	
	Buffer = external class(java.nio.Buffer) 
	  function position(newPosition: Integer): Buffer; virtual; overload;
		function position: Integer; virtual; overload;
	end;
	
  GL10 = external interface(javax.microedition.khronos.opengles.GL10)
	// https://developer.android.com/reference/javax/microedition/khronos/opengles/GL10
	const
		GL_TRIANGLES        = $0004;
		GL_DEPTH_BUFFER_BIT = $0100;
		GL_LEQUAL           = $0203;
		GL_CW               = $0900;
	  GL_CULL_FACE        = $0b44;
		GL_DEPTH_TEST       = $0b71;
		GL_UNSIGNED_BYTE    = $1401;
		GL_FLOAT            = $1406;
		GL_MODELVIEW        = $1700;
		GL_PROJECTION       = $1701;
		GL_COLOR_BUFFER_BIT = $4000;
		GL_VERTEX_ARRAY     = $8074;
		GL_COLOR_ARRAY      = $8076;
	public	
	  procedure glClearColor(red, green, blue, alpha: Single);
		procedure glClearDepthf(depth: Single);
		procedure glDepthFunc(func: Integer);
		procedure glEnable(cap: Integer);
		procedure glFrontFace(mode: Integer);
		procedure glViewport(x, y, width, height: Integer);
		procedure glMatrixMode(mode: Integer);
		procedure glLoadIdentity;
		procedure glClear(mask: Integer);
		procedure glTranslatef(x, y, z: Single);
		procedure glRotatef(angle, x, y, z: Single);
		procedure glVertexPointer(size, type_, stride: Integer; pointer: Buffer);
		procedure glColorPointer(size, type_, stride: Integer; pointer: Buffer);
		procedure glEnableClientState(array_: Integer);
		procedure glDrawElements(mode, count, type_: Integer; indices: Buffer);
		procedure glDisableClientState(array_: Integer);
  end;
	
	GLU = external class(android.opengl.GLU)
	  class function gluPerspective(gl: GL10; fovy, aspect, zNear, zFar: Single);
  end;
	
	FloatBuffer = external class(java.nio.FloatBuffer, Buffer)
    function put(src: array of Single): FloatBuffer; virtual;
	end;

	ByteOrder = external class(java.nio.ByteOrder)
	  class function nativeOrder(): ByteOrder;
	end;
	
	ByteBuffer = external class(java.nio.ByteBuffer, Buffer)
	  class function allocateDirect(capacity: Integer): ByteBuffer;
		function asFloatBuffer: FloatBuffer;
		function order: ByteOrder; overload;
		function order(bo: ByteOrder): ByteBuffer; overload;
    function put(src: array of Byte): ByteBuffer; virtual;
	end;
	
  View = external class(android.view.View)
  // https://developer.android.com/reference/android/view/View.html
  end;
	
	SurfaceView = external class(android.view.SurfaceView, View)
	// https://developer.android.com/reference/android/view/SurfaceView
	end;
	
  GLSurfaceView = external class(android.opengl.GLSurfaceView, SurfaceView)
	// https://developer.android.com/reference/android/opengl/GLSurfaceView
  type
    Renderer = interface
      procedure onSurfaceCreated(gl: GL10; config: EGLConfig);
      procedure onSurfaceChanged(gl: GL10; width, height: Integer);
      procedure onDrawFrame(gl: GL10);
    end;
  public
    constructor Create(context: Context);
    procedure setRenderer(renderer: Renderer); virtual;
    procedure onPause; virtual;
    procedure onResume; virtual;
  end;

  Activity = external class(android.app.Activity, Context)
    constructor Create;
    procedure onCreate(savedInstanceState: Bundle); virtual;
    procedure setContentView(view: View); virtual;
    procedure onPause; virtual;
    procedure onResume; virtual;
  end;

  // user defined classes

  GLRenderer = class(GLSurfaceView.Renderer)
	private
    FVertices: FloatBuffer;
    FColors  : FloatBuffer;
    FIndices : ByteBuffer;
    FRotation: Single;
	public
  // GLViewSurface.Renderer
    procedure onSurfaceCreated(gl: GL10; config: EGLConfig);
    procedure onSurfaceChanged(gl: GL10; width, height: Integer);
    procedure onDrawFrame(gl: GL10);
  end;

  cube = class(Activity)
	private
    FSurface: GLSurfaceView;
	public
    procedure onCreate(savedInstanceState: Bundle); override;
    procedure onPause; override;
    procedure onResume; override;
  end;

const
  vertices: array of Single = (
		-1.0, -1.0, -1.0,
		 1.0, -1.0, -1.0,
		 1.0,  1.0, -1.0,
		-1.0,  1.0, -1.0,
		-1.0, -1.0,  1.0,
		 1.0, -1.0,  1.0,
		 1.0,  1.0,  1.0,
		-1.0,  1.0,  1.0
  );
  
	colors: array of Single = (
		0.0,  1.0,  0.0,  1.0,
		0.0,  1.0,  0.0,  1.0,
		1.0,  0.5,  0.0,  1.0,
		1.0,  0.5,  0.0,  1.0,
		1.0,  0.0,  0.0,  1.0,
		1.0,  0.0,  0.0,  1.0,
		0.0,  0.0,  1.0,  1.0,
		1.0,  0.0,  1.0,  1.0
  );

  indices: array of Byte = (
		0, 4, 5, 0, 5, 1,
		1, 5, 6, 1, 6, 2,
		2, 6, 7, 2, 7, 3,
		3, 7, 4, 3, 4, 0,
		4, 7, 6, 4, 6, 5,
		3, 0, 1, 3, 1, 2
  );
	
{ cube }

procedure cube.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  FSurface := GLSurfaceView.Create(Self);
  FSurface.setRenderer(GLRenderer.Create());
	setContentView(FSurface);
end;

procedure cube.onPause;
begin
  inherited;
  FSurface.onPause;
end;

procedure cube.onResume;
begin
  inherited;
  FSurface.onResume;
end;

{ GLRenderer }

procedure GLRenderer.onSurfaceCreated(gl: GL10; config: EGLConfig);
var
  byteBuf: ByteBuffer;
begin
  gl.glClearColor(0, 0, 0, 0);
  gl.glClearDepthf(1.0);
  gl.glEnable(GL10.GL_CULL_FACE);
  gl.glFrontFace(GL10.GL_CW);
  gl.glEnable(GL10.GL_DEPTH_TEST);
  gl.glDepthFunc(GL10.GL_LEQUAL);

  byteBuf := ByteBuffer.allocateDirect(vertices.length * 4);
  byteBuf.order(ByteOrder.nativeOrder());
  FVertices := byteBuf.asFloatBuffer();
  FVertices.put(vertices);
  FVertices.position(0);

  byteBuf := ByteBuffer.allocateDirect(colors.length * 4);
  byteBuf.order(ByteOrder.nativeOrder());
  FColors := byteBuf.asFloatBuffer();
  FColors.put(colors);
  FColors.position(0);

  FIndices := ByteBuffer.allocateDirect(indices.length);
  FIndices.put(indices);
  FIndices.position(0);
end;

procedure GLRenderer.onSurfaceChanged(gl: GL10; width, height: Integer);
begin
  // draw on the entire screen
  gl.glViewport(0, 0, width, height);
  // setup projection matrix
  gl.glMatrixMode(GL10.GL_PROJECTION);
  gl.glLoadIdentity();
  GLU.gluPerspective(gl, 45, width / height, 1, 1000);
  gl.glMatrixMode(GL10.GL_MODELVIEW);
end;

procedure GLRenderer.onDrawFrame(gl: GL10);
begin
  gl.glClear(GL10.GL_COLOR_BUFFER_BIT or GL10.GL_DEPTH_BUFFER_BIT);
  gl.glLoadIdentity();

  gl.glTranslatef(0.0, 0.0, -10.0);
  gl.glRotatef(FRotation, 1.0, 1.0, 1.0);

  gl.glVertexPointer(3, GL10.GL_FLOAT, 0, FVertices);
  gl.glColorPointer(4, GL10.GL_FLOAT, 0, FColors);

  gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
  gl.glEnableClientState(GL10.GL_COLOR_ARRAY);

  gl.glDrawElements(GL10.GL_TRIANGLES, 36, GL10.GL_UNSIGNED_BYTE, FIndices);

  gl.glDisableClientState(GL10.GL_VERTEX_ARRAY);
  gl.glDisableClientState(GL10.GL_COLOR_ARRAY);

  Inc(FRotation, 0.5);
end;

begin
  cube.Create();
end.