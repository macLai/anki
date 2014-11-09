//
//  MenuletController.h
//  Menulet
//
//  Created by Qusic on 11/22/12.
//  Copyright (c) 2012 Qusic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuletDelegate

- (BOOL)isActive;
- (void)clicked;

@end

@interface MenuletController : NSObject

@property (assign, nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSPopover *popover;

@end
