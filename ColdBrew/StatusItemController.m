//
//  StatusItemController.m
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

#import <IOKit/pwr_mgt/IOPMLib.h>
#import "StatusItemController.h"

@interface StatusItemController ()

@property (nonatomic) BOOL on;
@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) IOPMAssertionID assertionID;

@end

static NSString * const AssertionReason = @"User activated Cold Brew";

@implementation StatusItemController

- (instancetype)initWithState:(BOOL)on
{
  self = [super init];
  if (!self) return nil;

  self.on = on;
  [self setupStatusItem];
  if (self.on) {
    [self caffinate:self.on];
  }

  return self;
}

- (void)setupStatusItem
{
  self.statusItem = [[NSStatusBar systemStatusBar]
                     statusItemWithLength:NSVariableStatusItemLength];
  self.statusItem.target = self;
  self.statusItem.action = @selector(statusItemClicked:);
  NSImage *image = nil;
  if (self.on) {
    image = nil;
  }

  // image
  self.statusItem.image = [NSImage imageNamed:NSImageNameFolder];
}

- (void)tearDown
{
  if (self.on) {
    BOOL success = [self removeAssertion];
    if (success) {
      NSLog(@"ColdBrew teardown success");
    } else {
      NSLog(@"ColdBrew teardown failed");
    }
  }

  [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
  self.statusItem = nil;
}

- (void)statusItemClicked:(NSStatusItem *)sender
{
  self.on = !self.on;
  [self caffinate:self.on];
}

- (void)caffinate:(BOOL)keepAwake
{
  NSLog(@"Here: %@", keepAwake ? @"Yes": @"NO");
  if (keepAwake) {
    NSLog(@"Adding");
    BOOL success = [self createAssertion];
    if (success) {
      NSLog(@"Successs time");
    } else {
      NSLog(@"Create fail");
    }
  } else {
    NSLog(@"Removing");
    BOOL success = [self removeAssertion];
    if (success) {
      NSLog(@"Success release");
    } else {
      NSLog(@"Failed release");
    }
  }
}

- (BOOL)createAssertion
{
  CFStringRef type = kIOPMAssertionTypePreventUserIdleSystemSleep;
  IOPMAssertionLevel level = kIOPMAssertionLevelOn;
  CFStringRef reason = (__bridge CFStringRef)(AssertionReason);
  IOReturn status = IOPMAssertionCreateWithName(type, level,
                                                reason, &_assertionID);
  BOOL success = (status == kIOReturnSuccess);
  if (!success) {
    NSLog(@"ColdBrew create assertion failed with status: %d", status);
  }

  return success;
}

- (BOOL)removeAssertion
{
  IOReturn status = IOPMAssertionRelease(self.assertionID);
  BOOL success = (status == kIOReturnSuccess);
  if (!success) {
    NSLog(@"ColdBrew remove assertion failed with status: %d", status);
  }

  return success;
}


@end
