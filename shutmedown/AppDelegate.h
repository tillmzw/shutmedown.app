//
//  AppDelegate.h
//  shutmedown
//
//  Created by Till Meyer zu Westram on 03.12.12.
//  Copyright (c) 2012 Till Meyer zu Westram. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <CoreServices/CoreServices.h>
#include <Carbon/Carbon.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSComboBox *timeUnit;
@property (weak) IBOutlet NSSegmentedControl *modeSwitch;
@property (weak) IBOutlet NSButton *button;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (strong) NSTimer *timer;

- (IBAction)helpButton:(id)sender;
- (IBAction)button:(id)sender;

- (void)scheduleTimerWithSeconds:(NSInteger)seconds AndCallback:(SEL)callback;
- (void)cancelTimer;
- (void)shutdown;
- (void)sleep;
- (void)reset;

@end
