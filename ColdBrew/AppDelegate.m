//
//  AppDelegate.m
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

#import "AppDelegate.h"
#import "StatusItemController.h"

@interface AppDelegate ()

@property (nonatomic) StatusItemController *statusItemController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.statusItemController = [[StatusItemController alloc] initWithState:NO];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  [self.statusItemController tearDown];
}

@end
