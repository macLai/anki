//
//  MenuletController.m
//  Menulet
//
//  Created by Qusic on 11/22/12.
//  Copyright (c) 2012 Qusic. All rights reserved.
//

#import "MenuletController.h"
#import "AppDelegate.h"
#import "PopoverController.h"
#import "Menulet.h"

@implementation MenuletController

@synthesize active;
@synthesize popover;

- (void)clicked
{
    self.active = !active;
    if (active) {
        [self setupPopover];
        AppDelegate *appDelegate = [NSApp delegate];
        [popover showRelativeToRect:[appDelegate.menulet frame] ofView:appDelegate.menulet preferredEdge:CGRectMinYEdge];
    } else {
        [popover performClose:self];
    }
}

- (void)setupPopover
{
    if (!popover) {
        popover = [[NSPopover alloc] init];
        popover.contentViewController = [[PopoverController alloc] initWithNibName:@"PopoverController" bundle:nil];
    }
}

@end
