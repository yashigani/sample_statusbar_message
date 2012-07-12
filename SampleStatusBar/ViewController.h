//
//  ViewController.h
//  SampleStatusBar
//
//  Created by yashigani on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) UIView *messageBaseView;
@property (strong, nonatomic) IBOutlet UITextField *first;
@property (strong, nonatomic) IBOutlet UITextField *second;

- (IBAction)doTapped:(id)sender;

@end
