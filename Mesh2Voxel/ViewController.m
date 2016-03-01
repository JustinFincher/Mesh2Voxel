//
//  ViewController.m
//  Mesh2Voxel
//
//  Created by Fincher Justin on 16/3/1.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSOpenPanel *FileOpenPanel;

@property MDLAsset *FileImportedMDLAsset;
@property MDLVoxelArray *MDLAssetVoxelArray;
@property MDLMesh *MDLAssetVoxeledMesh;

@end

@implementation ViewController
@synthesize VoxelsCountLabel,FileOpenPanel,ModelShowingView,FileImportedMDLAsset,MDLAssetVoxelArray,MDLAssetVoxeledMesh,EnableWireFrameCheckButton,VoxelsDivisionLevelLabel;

#pragma mark - Init Stuff

- (void)viewDidLoad
{
    [super viewDidLoad];

    FileOpenPanel = [NSOpenPanel openPanel];
    
    ModelShowingView.debugOptions = SCNDebugOptionShowWireframe;
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - Load Meshes
- (IBAction)LoadMeshesButtonPressed:(id)sender
{
    [FileOpenPanel setAllowsMultipleSelection:NO];
    [FileOpenPanel setMessage:@"Choose your 3D model from here~"];
    [FileOpenPanel setAllowedFileTypes:@[@"abc",@"ply",@"stl",@"obj"]];
    

    [FileOpenPanel beginWithCompletionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSURL* theDoc = [[FileOpenPanel URLs] objectAtIndex:0];
            // Open  the document.
            NSLog(@"%@",theDoc);
            
            FileImportedMDLAsset = [[MDLAsset alloc] initWithURL:theDoc];
            [self loadImportedModelToSCNView:FileImportedMDLAsset];
        }
    }];
}

- (void)loadImportedModelToSCNView:(MDLAsset *)asset
{
    ModelShowingView.scene = [SCNScene sceneWithMDLAsset:asset];
}

#pragma mark -  Make Voxels
- (IBAction)MakeVoxelsButtonPressed:(id)sender
{
    if (VoxelsDivisionLevelLabel.cell.title.intValue < 1)
    {
        VoxelsDivisionLevelLabel.cell.title = @"1";
    }
    
    MDLAssetVoxelArray = [[MDLVoxelArray alloc] initWithAsset:FileImportedMDLAsset divisions:VoxelsDivisionLevelLabel.cell.title.intValue interiorShells:0.0f exteriorShells:0.0f patchRadius:0.0f];
    
    VoxelsCountLabel.cell.title = [NSString stringWithFormat:@"Voxels Count : %lu",(unsigned long)[MDLAssetVoxelArray count]];
    
    MDLAssetVoxeledMesh = [MDLAssetVoxelArray meshUsingAllocator:nil];
    
    
    for (int i = 0; i < [FileImportedMDLAsset count]; i++)
    {
        [FileImportedMDLAsset removeObject:[FileImportedMDLAsset objectAtIndex:i]];
    }
    
    [FileImportedMDLAsset addObject:MDLAssetVoxeledMesh];
    [self loadImportedModelToSCNView:FileImportedMDLAsset];
    [self ExportVoxelModel];
    
}

- (void)ExportVoxelModel
{
    NSSavePanel *save = [NSSavePanel savePanel];
    [save setAllowedFileTypes:[NSArray arrayWithObject:@"obj"]];
    [save setAllowsOtherFileTypes:NO];
    
    NSInteger result = [save runModal];
    NSError *error = nil;
    
    if (result == NSModalResponseOK)
    {
        [FileImportedMDLAsset exportAssetToURL:[save URL] error:&error];
    }
    
    if (error)
    {
        [NSApp presentError:error];
    }
}


#pragma mark - Debug Stuff
- (IBAction)EnableWireFrameCheckButtonPressed:(id)sender
{
    if (EnableWireFrameCheckButton.state == 1)
    {
        ModelShowingView.debugOptions = SCNDebugOptionShowWireframe;
    }else
    {
        ModelShowingView.debugOptions = SCNDebugOptionNone;
    }
}

@end
