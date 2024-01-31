//
//  StatusItemController.h
//  ColdBrew
//
//  Created by Keith Smiley on 11/14/14.
//  Copyright (c) 2014 Keith Smiley. All rights reserved.
//

@import AppKit;
@import Foundation;

@interface StatusItemController<NSMenuDelegate> : NSObject

- (instancetype)initWithState:(BOOL)on;
- (void)tearDown;

@end
