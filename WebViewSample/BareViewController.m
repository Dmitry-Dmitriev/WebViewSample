//
//  BareViewController.m
//  WebViewSample
//
//  Created by dmitry on 03/02/17.
//  Copyright © 2017 DSR. All rights reserved.
//

#import "BareViewController.h"

@interface BareViewController ()

@end

@implementation BareViewController

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentViewControllerOrientation)])
    {
        switch ([self.delegate parentViewControllerOrientation])
        {
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;

        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;

        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;

        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskAll;
        }
    }
    return UIInterfaceOrientationMaskAll;
}

@end
