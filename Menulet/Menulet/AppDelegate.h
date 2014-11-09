//
//  AppDelegate.h
//  Menulet
//
//  Created by Qusic on 11/22/12.
//  Copyright (c) 2012 Qusic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Menulet, MenuletController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) Menulet *menulet;
@property (strong, nonatomic) MenuletController *controller;

@end
