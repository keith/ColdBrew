//
//  NSBundle+LoginItem.m
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

#import "MPLoginItems.h"
#import "NSBundle+LoginItem.h"

@implementation NSBundle (LoginItem)

- (BOOL)isLoginItem
{
  return [MPLoginItems loginItemExists:self.bundleURL];
}

- (void)addToLoginItems
{
  [MPLoginItems addLoginItemWithURL:self.bundleURL];
}

- (void)removeFromLoginItems
{
  [MPLoginItems removeLoginItemWithURL:self.bundleURL];
}

@end
