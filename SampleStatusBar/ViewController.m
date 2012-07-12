//
//  ViewController.m
//  SampleStatusBar
//
//  Created by yashigani on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface StatusBarMessage : UIView
@property (strong, nonatomic) UILabel *currentLabel;
- (void)showMessage:(NSString *)message inView:(UIView *)view finish:(BOOL)finish;
@end

@implementation StatusBarMessage
@synthesize currentLabel = currentLabel_;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 20)];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)showMessage:(NSString *)message inView:(UIView *)view finish:(BOOL)finish
{
    CGRect f = {{0, 20}, self.bounds.size};
    UILabel *label = [[UILabel alloc] initWithFrame:f];
    label.textAlignment = UITextAlignmentCenter;
    label.text = message;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];

    if ([self superview] != view) {
        [self removeFromSuperview];
        [view addSubview:self];
    }
    UIApplication *app = [UIApplication sharedApplication];

    const CGFloat duration = 0.5;
    StatusBarMessage *bself = self;
    [UIView animateWithDuration:duration
                     animations:^{
                         [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                         if (bself.currentLabel) {
                             CGRect target = {{0, -20}, bself.currentLabel.frame.size};
                             bself.currentLabel.frame = target;
                         }
                         CGRect target = {CGPointZero, label.frame.size};
                         label.frame = target;
                         bself.currentLabel = label;
                     }
                     completion:^(BOOL finished1) {
                                    if (finish) {
                                        [UIView animateWithDuration:duration
                                                              delay:0.5
                                                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionNone
                                                         animations:^{
                                                             CGRect target = {{0, 40}, bself.currentLabel.frame.size};
                                                             bself.currentLabel.frame = target;
                                                         }
                                                         completion:^(BOOL finished2) {
                                                                        [bself.currentLabel removeFromSuperview];
                                                                        [bself removeFromSuperview];
                                                                        bself.currentLabel = nil;
                                                                    }];
                                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                                        dispatch_after(popTime, dispatch_get_main_queue(), ^{
                                                [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                                                });
                                    }
                                }];
}

@end

@interface ViewController ()

@end

@implementation ViewController
@synthesize messageBaseView = messageBaseView_;
@synthesize first = first_;
@synthesize second = second_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageBaseView = [[StatusBarMessage alloc] init];
    [self.navigationController.view addSubview:self.messageBaseView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doTapped:(id)sender
{
    StatusBarMessage *statusbar = (StatusBarMessage *)self.messageBaseView;
    [statusbar showMessage:self.first.text inView:self.navigationController.view finish:NO];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [statusbar showMessage:self.second.text inView:self.navigationController.view finish:YES];
    });
}

@end
