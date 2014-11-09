//
//  Menulet.m
//  Menulet
//
//  Created by Qusic on 11/22/12.
//  Copyright (c) 2012 Qusic. All rights reserved.
//

#import "Menulet.h"
#import "MenuletController.h"

@implementation Menulet

@synthesize delegate;

- (void)setDelegate:(id)newDelegate
{
    [(NSObject *)newDelegate addObserver:self forKeyPath:@"active" options:NSKeyValueObservingOptionNew context:nil];
    delegate = newDelegate;
}

- (void)mouseDown:(NSEvent *)event
{
    [delegate clicked];
}

- (void)drawRect:(NSRect)rect
{
    rect = CGRectInset(rect, 2, 2);
    if ([delegate isActive]) {
        [[NSColor highlightColor] set];
    } else {
        [[NSColor textColor] set];
    }
    NSRectFill(rect);
    [[NSImage imageNamed:@"Menulet"] drawInRect:rect fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1.0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay:YES];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

@end
