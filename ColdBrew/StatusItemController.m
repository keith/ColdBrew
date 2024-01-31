//
//  StatusItemController.m
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

#import <IOKit/pwr_mgt/IOPMLib.h>
#import "NSBundle+LoginItem.h"
#import "NSMenuItem+Additions.h"
#import "StatusItemController.h"

@interface StatusItemController ()

@property (nonatomic) BOOL on;
@property (nonatomic) IOPMAssertionID assertionID;
@property (nonatomic) NSStatusItem *statusItem;

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
                     statusItemWithLength:NSSquareStatusItemLength];
  self.statusItem.button.target = self;
  self.statusItem.button.action = @selector(statusItemClicked:);
  NSEventMask mask = NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown;
  [self.statusItem.button sendActionOn:mask];
  NSImage *image = [NSImage imageNamed:@"active"];
  [image setTemplate:YES];
  self.statusItem.button.image = image;
  [self setState:self.on];
}

- (NSMenu *)statusMenu
{
  NSMenu *menu = [[NSMenu alloc] init];
  NSMenuItem *loginItem = [NSMenuItem itemWithTitle:NSLocalizedString(@"Open At Login", nil)
                                             target:self
                                             action:@selector(toggleStartAtLogin:)];
  loginItem.state = [self openAtLoginState];

  NSMenuItem *quitItem = [NSMenuItem itemWithTitle:NSLocalizedString(@"Quit", nil)
                                            target:self
                                            action:@selector(quit)];

  [menu addItem:loginItem];
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItem:quitItem];
  menu.delegate = self;

  return menu;
}

- (void)menuDidClose:(NSMenu *)menu {
  self.statusItem.menu = nil;
}

- (void)toggleStartAtLogin:(NSMenuItem *)item
{
  if ([[NSBundle mainBundle] isLoginItem]) {
    [[NSBundle mainBundle] removeFromLoginItems];
  } else {
    [[NSBundle mainBundle] addToLoginItems];
  }

  item.state = [self openAtLoginState];
}

- (NSControlStateValue)openAtLoginState
{
  return [[NSBundle mainBundle] isLoginItem] ? NSControlStateValueOn : NSControlStateValueOff;
}

- (void)quit
{
  [[NSApplication sharedApplication] terminate:self];
}

- (void)tearDown
{
  if (self.on) {
    BOOL success = [self removeAssertion];
    if (!success) {
      NSLog(@"ColdBrew teardown failed");
    }
  }

  [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
  self.statusItem = nil;
}

- (BOOL)isRightClick
{
  NSEvent *currentEvent = [NSApp currentEvent];
  BOOL rightClick = currentEvent.type == NSEventTypeRightMouseDown;
  BOOL controlClick = (currentEvent.modifierFlags & NSEventModifierFlagControl) == NSEventModifierFlagControl;
  return rightClick || controlClick;
}

- (void)statusItemClicked:(NSStatusItem *)sender
{
  if ([self isRightClick]) {
    [self.statusItem popUpStatusItemMenu:[self statusMenu]];
    return;
  } else {
    self.statusItem.menu = nil;
  }

  self.on = !self.on;
  [self caffinate:self.on];
}

- (void)setState:(BOOL)active
{
  self.statusItem.button.appearsDisabled = !active;
}

- (void)caffinate:(BOOL)keepAwake
{
  if (keepAwake) {
    BOOL success = [self createAssertion];
    if (!success) {
      self.on = !self.on;
    }
  } else {
    BOOL success = [self removeAssertion];
    if (!success) {
      self.on = !self.on;
    }
  }

  [self setState:self.on];
}

- (BOOL)createAssertion
{
  CFStringRef type = kIOPMAssertPreventUserIdleDisplaySleep;
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
