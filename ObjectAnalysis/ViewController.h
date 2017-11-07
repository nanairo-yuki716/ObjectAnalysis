//
//  ViewController.h
//  ObjectAnalysis
//
//  Created by kubo on 2017/11/03.
//  Copyright © 2017年 kubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ViewController : UIViewController <ARSCNViewDelegate, ARSessionDelegate>{

    IBOutlet ARSCNView  *sceneView;
    IBOutlet UILabel    *trackingStateLabel;
    IBOutlet UILabel    *statusLabel;
    IBOutlet UIButton   *resetBtn;
}


@end

