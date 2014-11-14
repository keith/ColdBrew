//
//  NSMenuItem+Additions.m
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

#import "NSMenuItem+Additions.h"

@implementation NSMenuItem (Additions)

+ (instancetype)itemWithTitle:(NSString *)title
                       target:(id)target
                       action:(SEL)action
{
  NSMenuItem *item = [[self alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:@""];
  item.target = target;
  return item;
}

@end
