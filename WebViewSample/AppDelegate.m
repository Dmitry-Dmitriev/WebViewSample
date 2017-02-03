//
//  AppDelegate.m
//  WebViewSample
//
//  Created by dmitry on 02/02/17.
//  Copyright © 2017 DSR. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CustomNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *controller = [st instantiateViewControllerWithIdentifier:@"ViewController"];
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:controller];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];

    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

@end
