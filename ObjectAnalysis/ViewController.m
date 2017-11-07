//
//  ViewController.m
//  ObjectAnalysis
//
//  Created by kubo on 2017/11/03.
//  Copyright © 2017年 kubo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    SCNNode *startNode;
    SCNNode *endNode;
    SCNNode *lineNode;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sceneView.delegate = self;
    sceneView.session.delegate = self;
    sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    sceneView.scene = [[SCNScene alloc] init];
    
    [self reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    ARConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    [sceneView.session runWithConfiguration:configuration];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [sceneView.session pause];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame{
    // 毎フレーム呼ばれる
}

- (void)reset{
    [startNode removeFromParentNode];
    startNode = nil;
    
    [endNode removeFromParentNode];
    endNode = nil;
    
    [statusLabel setHidden:YES];
}

#pragma mark ----- ARSCNViewDelegate Method -----

-(void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
    
    ARFrame *frame = sceneView.session.currentFrame;
    if (frame != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (frame.anchors.count > 0){
                [statusLabel setHidden: NO];
            }
            
            if (startNode == nil){
                statusLabel.text = @"Tap";
            }
        });
    }
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
    ARPlaneAnchor *planeAnchor = planeAnchor = (ARPlaneAnchor *)anchor;
    if (anchor != nil){
        SCNGeometry *geometry = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.y];
        geometry.firstMaterial.diffuse.contents = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        
        SCNNode *planeNode = [SCNNode nodeWithGeometry:geometry];
        planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1, 0, 0);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [node addChildNode:planeNode];
        });
    }
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
    ARPlaneAnchor *planeAnchor = planeAnchor = (ARPlaneAnchor *)anchor;
    if (anchor != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            for (SCNNode *childNode in node.childNodes){
                SCNPlane *plane = (SCNPlane *)childNode.geometry;
                if (plane.width != planeAnchor.extent.x ||
                    plane.height != planeAnchor.extent.z){
                }
                else{
                    plane.width = planeAnchor.extent.x;
                    plane.height = planeAnchor.extent.z;
                }
            }
        });
    }
}

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera{
    
    trackingStateLabel.text = [camera description];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSArray *touchsArr = [touches allObjects];
    UITouch *touch = [touchsArr objectAtIndex:0];
    CGPoint pos = [touch locationInView:sceneView];
    
    [endNode removeFromParentNode];
    [lineNode removeFromParentNode];
    
    NSArray<ARHitTestResult *> *results =  [sceneView hitTest:pos types:ARHitTestResultTypeExistingPlane];
    ARHitTestResult *result = [results objectAtIndex:0];
    
    SCNMatrix4 mat = SCNMatrix4FromMat4(result.worldTransform);
    SCNVector3 hitPos = SCNVector3Make(mat.m41, mat.m42, mat.m43);
    
    SCNGeometry *geometry = [SCNSphere sphereWithRadius:0.01];
    geometry.firstMaterial.diffuse.contents = [UIColor grayColor];
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    
    [sceneView.scene.rootNode addChildNode:node];
    node.position = hitPos;
    endNode = node;
    
    float posX = endNode.position.x - startNode.position.x;
    float posY = endNode.position.y - startNode.position.y;
    float posZ = endNode.position.z - startNode.position.z;

    float distance = sqrtf(posX * posX + posY * posY + posZ * posZ);
    
    
    
}

@end
