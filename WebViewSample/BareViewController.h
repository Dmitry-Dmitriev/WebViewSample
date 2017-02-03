//
//  BareViewController.h
//  WebViewSample
//
//  Created by dmitry on 03/02/17.
//  Copyright © 2017 DSR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerDelegate <NSObject>

- (UIInterfaceOrientation)parentViewControllerOrientation;

@end

@interface BareViewController : UIViewController

@property (strong, nonnull) id<UIViewControllerDelegate> delegate;

@end
