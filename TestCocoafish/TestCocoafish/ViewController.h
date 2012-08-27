//
//  ViewController.h
//  TestCocoafish
//
//  Created by EdwardSun on 8/24/12.
//  Copyright (c) 2012 EdwardSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Cocoafish/Cocoafish.h"

@interface ViewController : UIViewController <CCRequestDelegate>

//@property (nonatomic, assign) id<CCRequestDelegate> requestDelegate;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)showView:(id)sender;

@end
