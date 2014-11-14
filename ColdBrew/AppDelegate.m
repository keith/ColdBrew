//
//  AppDelegate.m
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

#import "AppDelegate.h"
#import "MPLoginItems.h"
#import "StatusItemController.h"

@interface AppDelegate ()

@property (nonatomic) StatusItemController *statusItemController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.statusItemController = [[StatusItemController alloc] initWithState:NO];
  NSURL *URL = [[NSBundle mainBundle] bundleURL];
  NSLog(@"E: %@", [MPLoginItems loginItemExists:URL] ? @"Yes": @"NO");
  if ([MPLoginItems loginItemExists:URL]) {
    [MPLoginItems removeLoginItemWithURL:URL];
  } else {
    [MPLoginItems addLoginItemWithURL:URL];
  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  [self.statusItemController tearDown];
}

@end
