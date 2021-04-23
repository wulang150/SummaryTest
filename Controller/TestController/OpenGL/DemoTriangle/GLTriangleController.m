//
//  GLTriangleController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/10/16.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "GLTriangleController.h"
#import "ShaderOperations.h"

@interface GLTriangleController ()
{
    EAGLContext *_eaglContext; // OpenGL context,管理使用opengl es进行绘制的状态,命令及资源
    CAEAGLLayer *_eaglLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer; // 帧缓冲区
    
    GLuint _glProgram;
    GLuint _positionSlot; // 用于绑定shader中的Position参数
    GLuint _colorSlot;      // 用于绑定shader中的SourceColor参数
}

@end

@implementation GLTriangleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavWithTitle:@"Triangle" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
    //初始化一些环境和参数
    //上下文
    [self setupOpenGLContext];
    [self setupCAEAGLLayer];
    [self tearDownOpenGLBuffers];
    //渲染的buffer
    [self setupOpenGLBuffers];
    
    // 设置清屏颜色
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    // 用来指定要用清屏颜色来清除由mask指定的buffer，此处是color buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, _eaglLayer.bounds.size.width, _eaglLayer.bounds.size.height);
    //编译shaders
    [self processShaders];
    //进行渲染
    [self render];
    //把渲染的内容展示出来
    // 将指定renderBuffer渲染在屏幕上
    // 绘制三角形，红色是由fragment shader决定
    // 图像经过render之后，已经在FBO中了，即使不将其拿到RenderBuffer中，依然可以使用getResultImage取到图像数据。
    // 用[_eaglContext presentRenderbuffer:GL_RENDERBUFFER];，实际上就是将FBO中的图像拿到RenderBuffer中（即屏幕上）
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupOpenGLContext {
    //setup context, 渲染上下文，管理所有绘制的状态，命令及资源信息。
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //opengl es 2.0
    [EAGLContext setCurrentContext:_eaglContext]; //设置为当前上下文。
}
- (void)setupCAEAGLLayer {
    //setup layer, 必须要是CAEAGLLayer才行，才能在其上描绘OpenGL内容
    //如果在viewController中，使用[self.view.layer addSublayer:eaglLayer];
    //如果在view中，可以直接重写UIView的layerClass类方法即可return [CAEAGLLayer class]。
    _eaglLayer = [CAEAGLLayer layer];
//    _eaglLayer.frame = self.view.frame;
    _eaglLayer.frame = CGRectMake(0, NavigationBar_HEIGHT, self.view.frame.size.width, SCREEN_HEIGHT-NavigationBar_HEIGHT);
    _eaglLayer.opaque = YES; //CALayer默认是透明的
    
    // 描绘属性：这里不维持渲染内容
    // kEAGLDrawablePropertyRetainedBacking:若为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)计算得到的最终结果颜色的透明度会考虑目标颜色的透明度值。
    // 若为NO，则不考虑目标颜色的透明度值，将其当做1来处理。
    // 使用场景：目标颜色为非透明，源颜色有透明度，若设为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)得到的结果颜色会有一定的透明度（与实际不符）。若未NO则不会（符合实际）。
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    [self.view.layer addSublayer:_eaglLayer];
}

#pragma mark - tearDownOpenGLBuffers

- (void)tearDownOpenGLBuffers {
    //destory render and frame buffer
    if (_colorRenderBuffer) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
}

#pragma mark - setupOpenGLBuffers

- (void)setupOpenGLBuffers {
    //先要renderbuffer，然后framebuffer，顺序不能互换。
    
    // OpenGlES共有三种：colorBuffer，depthBuffer，stencilBuffer。
    // 生成一个renderBuffer，id是_colorRenderBuffer
    glGenRenderbuffers(1, &_colorRenderBuffer);
    // 设置为当前renderBuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    //为color renderbuffer 分配存储空间
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    // FBO用于管理colorRenderBuffer，离屏渲染
    glGenFramebuffers(1, &_frameBuffer);
    //设置为当前framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)processShaders {
    // 编译shaders
    _glProgram = [ShaderOperations compileShaders:@"DemoTriangleVertex" shaderFragment:@"DemoTriangleFragment"];
    
    glUseProgram(_glProgram);
    // 获取指向vertex shader传入变量的指针, 然后就通过该指针来使用
    // 即将_positionSlot 与 shader中的Position参数绑定起来，作为输入
    _colorSlot = glGetAttribLocation(_glProgram, "SourceColor");
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    
}

- (void)render
{
    [self renderVertices];
}

- (void)renderVertices {
    const GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
        
    };
    // Load the vertex data，(不使用VBO)则直接从CPU中传递顶点数据到GPU中进行渲染
    // 给_positionSlot传递vertices数据
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
    };
    // 取出Colors数组中的每个坐标点的颜色值，赋给_colorSlot
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // Draw triangle
    glDrawArrays(GL_TRIANGLES, 0, 3);
}
@end
