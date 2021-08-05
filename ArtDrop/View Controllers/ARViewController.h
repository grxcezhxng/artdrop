//
//  ARViewController.h
//  ArtDrop
//
//  Created by gracezhg on 8/5/21.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARViewController : UIViewController

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet ARSCNView *sceneView;
@property (nonatomic, strong) SCNNode *currentNode;

@end

NS_ASSUME_NONNULL_END
