//
//  NSMenuItem+Additions.h
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

@import Cocoa;

@interface NSMenuItem (Additions)

+ (instancetype)itemWithTitle:(NSString *)title
                       target:(id)target
                       action:(SEL)action;

@end
