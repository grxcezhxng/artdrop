//
//  ARViewController.m
//  ArtDrop
//
//  Created by gracezhg on 8/5/21.
//

#import "ARViewController.h"

@interface ARViewController () <ARSCNViewDelegate>

@end

@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ARWorldTrackingConfiguration *const config = [ARWorldTrackingConfiguration new];
    config.planeDetection = ARPlaneDetectionVertical;
    [self.sceneView.session runWithConfiguration:config];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

#pragma mark - IB Actions

- (IBAction)handleBack:(id)sender {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ARSCNViewDelegate

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
            return;
        }
    
    if (self.currentNode == nil) {
        NSLog(@"plane detected");
            
        ARPlaneAnchor *const planeAnchor = (ARPlaneAnchor *)anchor;
            
        // calculate dimensions in meters
        const double artWidth = [self.post.width floatValue] / 100.0;
        const double artHeight = [self.post.height floatValue] / 100.0;
        const CGFloat myWidth = (CGFloat) artWidth;
        const CGFloat myHeight = (CGFloat) artHeight;
        SCNPlane *const plane = [SCNPlane planeWithWidth:myWidth height:myHeight];
        PFFileObject *const pfImage = self.post.image;
        [pfImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error == nil) {
                UIImage *const postImage = [UIImage imageWithData:data];
                plane.materials.firstObject.diffuse.contents = postImage;
            }
        }];
        
        self.currentNode = [SCNNode nodeWithGeometry:plane];
        self.currentNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [self.currentNode setTransform:SCNMatrix4MakeRotation(-M_PI / 2, 1, 0, 0)];
        [node addChildNode:self.currentNode];
    }
}

@end
