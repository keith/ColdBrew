//
//  NSBundle+LoginItem.h
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

@import Foundation;

@interface NSBundle (LoginItem)

- (BOOL)isLoginItem;
- (void)addToLoginItems;
- (void)removeFromLoginItems;

@end
