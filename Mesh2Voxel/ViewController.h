//
//  ViewController.h
//  Mesh2Voxel
//
//  Created by Fincher Justin on 16/3/1.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import SceneKit;
@import ModelIO;
@import SceneKit.ModelIO;

@interface ViewController : NSViewController

@property (weak) IBOutlet SCNView *ModelShowingView;
@property (weak) IBOutlet NSButton *LoadMeshesButton;
@property (weak) IBOutlet NSButton *MakeVoxelsButton;
@property (weak) IBOutlet NSTextField *VoxelsCountLabel;
@property (weak) IBOutlet NSTextField *VoxelsDivisionLevelLabel;
@property (weak) IBOutlet NSButton *EnableWireFrameCheckButton;


- (IBAction)LoadMeshesButtonPressed:(id)sender;
- (IBAction)MakeVoxelsButtonPressed:(id)sender;
- (IBAction)EnableWireFrameCheckButtonPressed:(id)sender;

@end

