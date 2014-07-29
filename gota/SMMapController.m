//
//  SMMapController.m
//  gota
//
//  Created by James Haggerty on 28/07/2014.
//  Copyright (c) 2014 James Haggerty. All rights reserved.
//

#import "SMMapController.h"
#import "GLKit/GLKMath.h"

typedef NS_ENUM(NSUInteger, Nations) {
    SPAIN,
    PORTUGAL,
    FRANCE,
    ENGLAND,
    NATIONS_COUNT
};

@interface SMMapController () {
    BOOL showControl;
    
    GLuint _worldMapVAO;
    GLuint _provinceVAOs[NATIONS_COUNT];
    GLKBaseEffect *provinceEffects[NATIONS_COUNT];
}

@property GLKBaseEffect *mapEffect;

@end

@implementation SMMapController

typedef struct {
    GLKVector2 position;
    GLKVector2 texCoord;
} Vertex;

const Vertex squareVertices[] = {
    {{1, -1}, {1, 0}},
    {{1, 1}, {1, 1}},
    {{-1, 1}, {0, 1}},
    {{-1, -1}, {0, 0}},
};

const GLKVector2 provinceVertices[] = {
    {-0.983471, 0.568421},
    {-0.983471, 0.494737},
    {-0.917355, 0.694737},
    {-0.900826, 0.526316},
    {-0.900826, 0.421053},
    {-0.900826, 0.347368},
    {-0.884298, 0.757895},
    {-0.884298, 0.726316},
    {-0.884298, 0.526316},
    {-0.867769, 0.410526},
    {-0.851240, 0.768421},
    {-0.834711, 0.336842},
    {-0.818182, 0.378947},
    {-0.801653, 0.778947},
    {-0.801653, 0.284211},
    {-0.785124, 0.905263},
    {-0.785124, 0.842105},
    {-0.785124, 0.810526},
    {-0.785124, 0.789474},
    {-0.785124, 0.252632},
    {-0.768595, 0.905263},
    {-0.768595, 0.821053},
    {-0.768595, 0.694737},
    {-0.768595, 0.515789},
    {-0.768595, 0.378947},
    {-0.752066, 1.000000},
    {-0.752066, 0.957895},
    {-0.752066, 0.821053},
    {-0.752066, 0.294737},
    {-0.735537, 0.947368},
    {-0.735537, 0.884211},
    {-0.702479, 0.821053},
    {-0.702479, 0.210526},
    {-0.636364, 0.778947},
    {-0.603306, 0.157895},
    {-0.586777, 0.326316},
    {-0.570248, 0.778947},
    {-0.570248, 0.515789},
    {-0.570248, 0.168421},
    {-0.553719, 0.284211},
    {-0.553719, 0.263158},
    {-0.520661, 0.378947},
    {-0.520661, 0.168421},
    {-0.504132, 1.000000},
    {-0.504132, 0.863158},
    {-0.454545, 0.105263},
    {-0.404959, 0.221053},
    {-0.388430, 0.126316},
    {-0.371901, 0.305263},
    {-0.355372, 0.778947},
    {-0.355372, 0.663158},
    {-0.355372, 0.515789},
    {-0.355372, 0.421053},
    {-0.355372, -0.021053},
    {-0.355372, -0.147368},
    {-0.338843, 0.284211},
    {-0.305785, 0.084211},
    {-0.289256, 0.021053},
    {-0.256198, 0.126316},
    {-0.223140, -0.242105},
    {-0.190083, 0.305263},
    {-0.173554, 0.431579},
    {-0.157025, 1.000000},
    {-0.157025, 0.778947},
    {-0.157025, 0.452632},
    {-0.140496, 0.147368},
    {-0.107438, 0.410526},
    {-0.107438, 0.347368},
    {-0.074380, 0.557895},
    {-0.074380, 0.305263},
    {-0.074380, 0.242105},
    {-0.074380, 0.147368},
    {-0.057851, 0.347368},
    {-0.057851, 0.126316},
    {-0.041322, 0.368421},
    {-0.041322, 0.263158},
    {-0.041322, 0.221053},
    {-0.024793, 0.452632},
    {-0.024793, 0.147368},
    {-0.008264, 0.663158},
    {-0.008264, 0.021053},
    {-0.008264, -0.021053},
    {-0.008264, -0.242105},
    {0.008264, 0.231579},
    {0.008264, -0.378947},
    {0.008264, -0.442105},
    {0.041322, 0.126316},
    {0.057851, 0.263158},
    {0.090909, 0.515789},
    {0.090909, 0.242105},
    {0.107438, 0.947368},
    {0.107438, 0.926316},
    {0.123967, -0.705263},
    {0.190083, 0.526316},
    {0.190083, 0.252632},
    {0.190083, 0.126316},
    {0.206612, 0.557895},
    {0.206612, -0.842105},
    {0.223140, 1.000000},
    {0.223140, 0.968421},
    {0.223140, -0.389474},
    {0.223140, -0.442105},
    {0.223140, -0.536842},
    {0.223140, -0.705263},
    {0.239669, 0.894737},
    {0.239669, 0.168421},
    {0.256198, 0.200000},
    {0.256198, 0.105263},
    {0.256198, -0.021053},
    {0.272727, 0.863158},
    {0.305785, 0.894737},
    {0.371901, -0.768421},
    {0.371901, -0.915789},
    {0.388430, 0.905263},
    {0.388430, -0.852632},
    {0.404959, -0.778947},
    {0.421488, 0.947368},
    {0.421488, 0.842105},
    {0.421488, 0.778947},
    {0.421488, 0.663158},
    {0.421488, -0.705263},
    {0.438017, -0.305263},
    {0.438017, -0.389474},
    {0.438017, -0.494737},
    {0.438017, -0.536842},
    {0.438017, -0.852632},
    {0.454545, -0.947368},
    {0.454545, -1.000000},
    {0.471074, -0.905263},
    {0.487603, 0.052632},
    {0.487603, -0.936842},
    {0.504132, -0.263158},
    {0.504132, -0.610526},
    {0.504132, -0.642105},
    {0.553719, -0.915789},
    {0.570248, -0.042105},
    {0.570248, -0.221053},
    {0.586777, -0.021053},
    {0.586777, -0.610526},
    {0.619835, -0.536842},
    {0.636364, 0.726316},
    {0.636364, -0.547368},
    {0.652893, 0.715789},
    {0.652893, -0.357895},
    {0.669421, 0.989474},
    {0.669421, -0.157895},
    {0.669421, -0.536842},
    {0.685950, 0.747368},
    {0.702479, 0.726316},
    {0.719008, 0.947368},
    {0.719008, 0.705263},
    {0.735537, 0.968421},
    {0.735537, 0.926316},
    {0.735537, 0.747368},
    {0.752066, 0.715789},
    {0.768595, -0.284211},
    {0.785124, 0.968421},
    {0.801653, -0.073684},
    {0.834711, 0.884211},
    {0.851240, 0.947368},
    {0.867769, 0.715789},
    {0.884298, -0.284211},
    {0.900826, 0.842105},
    {0.900826, -0.105263},
    {0.900826, -0.231579},
    {0.917355, 0.768421},
    {0.966942, -0.115789},
    {0.983471, -0.136842},
    {0.983471, -0.168421},
    {1.000000, 0.452632},
    {1.000000, 0.105263},
};

const GLubyte square[] = {
    // work out why triangle strip fails...
    // cf http://stackoverflow.com/questions/16792722/black-texture-with-opengl-when-image-is-too-big
    // (since presumably it worked for him...)
    // ok, it's probably to do with ordering. argh. Stupid clockwise/anti-clockwise stuff.
    // Let's just forget about triangle strips for now.
    0, 1, 2,
    2, 3, 0
};

const GLubyte province1[] = {
    33, 22, 37,
    22, 23, 37,
    33, 37, 36,
};
const GLubyte province2[] = {
    63, 49, 50,
    79, 63, 50,
    63, 79, 118,
    79, 119, 118,

};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (GLKBaseEffect *)makeOwnershipEffect:(GLKVector3)colour {
    GLKBaseEffect *baseEffect = [[GLKBaseEffect alloc] init];
    baseEffect.useConstantColor = TRUE;
    baseEffect.constantColor = GLKVector4Make(colour.x, colour.y, colour.z, 0.6);
    return baseEffect;
}

- (void)setupGL {
    // TODO err this is dumb because I need to cleanup the buffers
    GLuint name;
    
    self.mapView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.mapView.context];
    glEnable(GL_CULL_FACE);
    
    self.mapEffect = [[GLKBaseEffect alloc] init];
    provinceEffects[SPAIN] = [self makeOwnershipEffect:GLKVector3Make(1.0, 0.0, 0.0)];
    provinceEffects[PORTUGAL] = [self makeOwnershipEffect:GLKVector3Make(0.0, 1.0, 1.0)];
    provinceEffects[FRANCE] = [self makeOwnershipEffect:GLKVector3Make(0.0, 0.0, 1.0)];
    provinceEffects[ENGLAND] = [self makeOwnershipEffect:GLKVector3Make(1.0, 0.0, 1.0)];
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],
                              GLKTextureLoaderOriginBottomLeft,
                              nil];
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    self.mapEffect.texture2d0.name = info.name;
    self.mapEffect.texture2d0.enabled = GL_TRUE;
    
    glGenVertexArraysOES(1, &_worldMapVAO);
    glBindVertexArrayOES(_worldMapVAO);
    
    glGenBuffers(1, &name);
    glBindBuffer(GL_ARRAY_BUFFER, name);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertices), squareVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &name);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, name);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(square), square, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
                          (const GLvoid *)offsetof(Vertex, position));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
                          (const GLvoid *)offsetof(Vertex, texCoord));

    // province setup
    GLuint allVerticesName;
    glGenVertexArraysOES(sizeof(_provinceVAOs) / sizeof(_provinceVAOs[0]), _provinceVAOs);
    
    glBindVertexArrayOES(_provinceVAOs[SPAIN]);
    
    glGenBuffers(1, &allVerticesName);
    glBindBuffer(GL_ARRAY_BUFFER, allVerticesName);
    glBufferData(GL_ARRAY_BUFFER, sizeof(provinceVertices), provinceVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &name);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, name);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(province1), province1, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(GLKVector2),
                          (const GLvoid *)0);
    // Portugal
    glBindVertexArrayOES(_provinceVAOs[PORTUGAL]);
    glBindBuffer(GL_ARRAY_BUFFER, allVerticesName);
    
    glGenBuffers(1, &name);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, name);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(province2), province2, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(GLKVector2),
                          (const GLvoid *)0);

    glBindVertexArrayOES(0);
}

- (void)tearDownGL {
    // TODO: this is not even called...
    //[EAGLContext setCurrentContext:self.mapView.context];
    
    //glDeleteBuffers(1, &_vertexBuffer);
    //glDeleteBuffers(1, &_indexBuffer);
    //glDeleteVertexArraysOES(1, &_vertexArray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [EAGLContext setCurrentContext:view.context];
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.mapEffect prepareToDraw];
    glBindVertexArrayOES(_worldMapVAO);
    glDrawElements(GL_TRIANGLES, sizeof(square) / sizeof(square[0]), GL_UNSIGNED_BYTE, 0);
    
    //glEnable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    if (true || showControl) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        [provinceEffects[SPAIN] prepareToDraw];
        glBindVertexArrayOES(_provinceVAOs[SPAIN]);
        glDrawElements(GL_TRIANGLES, sizeof(province1) / sizeof(province1[0]), GL_UNSIGNED_BYTE, 0);
        
        [provinceEffects[PORTUGAL] prepareToDraw];
        glBindVertexArrayOES(_provinceVAOs[PORTUGAL]);
        glDrawElements(GL_TRIANGLES, sizeof(province2) / sizeof(province2[0]), GL_UNSIGNED_BYTE, 0);
        
        glDisable(GL_BLEND);
    }
}

- (IBAction)handleMapTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        showControl = !showControl;
        [self.mapView setNeedsDisplay];
        CGPoint tapLocation = [sender locationInView:self.mapView];
        NSLog(@"tapped: %f, %f", tapLocation.x, tapLocation.y);
        
        // Are we in Nevada?
        CGPoint points[] = {
            {-0.570248, 0.515789},
            {-0.570248, 0.778947},
            {-0.636364, 0.778947},
            {-0.768595, 0.694737},
            {-0.768595, 0.515789}
        };
        CGSize mapViewSize = self.mapView.frame.size;
        CGAffineTransform cgat = CGAffineTransformIdentity;
        cgat = CGAffineTransformScale(cgat, mapViewSize.width / 2, mapViewSize.height / 2);
        cgat = CGAffineTransformTranslate(cgat, 1.0, 1.0);
        cgat = CGAffineTransformScale(cgat, 1, -1);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddLines(path, &cgat, points, sizeof(points) / sizeof(points[0]));
        NSLog(@"contains point %d", CGPathContainsPoint(path, NULL, tapLocation, TRUE));
        // --------------------------
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
