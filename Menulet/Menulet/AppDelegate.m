//
//  AppDelegate.m
//  Menulet
//
//  Created by Qusic on 11/22/12.
//  Copyright (c) 2012 Qusic. All rights reserved.
//

#import "AppDelegate.h"
#import "Menulet.h"
#import "MenuletController.h"
#import <Dropbox/Dropbox.h>
#import "Menulet-Swift.h"
#import <Foundation/Foundation.h>

#define APP_KEY     @"hqvkk5ty9usih09"
#define APP_SECRET  @"ktc3cp3ifbozryt"

@implementation AppDelegate

@synthesize statusItem;
@synthesize menulet;
@synthesize controller;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:thickness];
    menulet = [[Menulet alloc]initWithFrame:(NSRect){.size={thickness, thickness}}];
    controller = [[MenuletController alloc] init];
    menulet.delegate = controller;
    [statusItem setView:menulet];
    
    
    //load dropbox
    DBAccountManager* accountMgr = [[DBAccountManager alloc]
                                    initWithAppKey:APP_KEY
                                    secret:APP_SECRET];
    [DBAccountManager setSharedManager:accountMgr];
    
    // Listen for changes to the link status and update button accordingly
    [accountMgr addObserver:self block:^(DBAccount *account) {
        if (!account || !account.linked) {
            [DBFilesystem setSharedFilesystem:nil];
        }
    }];
    
    // Skip directly to test if we have a linked account stored on the keychain
    if (accountMgr.linkedAccount) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self doDropboxTestWithAccount:accountMgr.linkedAccount];
        });
    }
    else {
        [[DBAccountManager sharedManager] linkFromWindow: nil
                                     withCompletionBlock:^(DBAccount *account) {
                                         if (account) {
                                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                 [self doDropboxTestWithAccount:account];
                                             });
                                         }
                                     }];
    }
    
}

/*
 * Runs a simple test using Sync API and writes result to view
 *
 * Steps in test:
 * - Lists the contents of the app folder
 * - Writes test file if it doesn't already exist
 * - Reads contents of test file
 */
- (BOOL)doDropboxTestWithAccount:(DBAccount *)account {
    NSString *const TEST_DATA = @"Hello Dropbox";
    NSString *const FILE_NAME = @"MaskerData.masker";
    
    DBError *error = nil;
    
    // Check that we're given a linked account.
    if (!account || !account.linked) {
        return NO;
    }
    
    // Check if shared filesystem already exists - can't create more than
    // one DBFilesystem on the same account.
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    if (!filesystem) {
        filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    
    // Read contents of Dropbox app folder
    NSArray *contents = [filesystem listFolder:[DBPath root] error:&error];
    if (!contents)
        return NO;
    
    // Check if our test file already exists.
    DBPath *path = [[DBPath root] childPath:FILE_NAME];
    if (![filesystem fileInfoForPath:path error:&error]) { // see if path exists
        
        // Report error if path look up failed for some other reason than NOT FOUND
        if ([error code] != DBErrorNotFound)
            return NO;
        
        // Create a new test file.
        DBFile *file = [[DBFilesystem sharedFilesystem] createFile:path error:&error];
        if (!file)
            return NO;
        
        // Write to the new test file.
        if (![file writeString:TEST_DATA error:&error])
            return NO;
        [file close];
    }
    
    return YES;
}


@end
