//precision mediump float;
varying lowp vec4 DestinationColor;
void main(void) {
//    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); // must set gl_FragColor for fragment shader
    gl_FragColor = DestinationColor;
}
