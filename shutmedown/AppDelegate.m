//
//  AppDelegate.m
//  shutmedown
//
//  Created by Till Meyer zu Westram on 03.12.12.
//  Copyright (c) 2012 Till Meyer zu Westram. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.timeUnit selectItemAtIndex:1];
    [self.textField setStringValue:@"1"];
}


- (IBAction)helpButton:(id)sender {    
}

- (IBAction)button:(id)sender {
    
    if ([self.timer isValid]) {
        [self cancelTimer];
        return;
    }

    static NSInteger SHUTDOWNATINDEX = 0;

    BOOL shutdownIsRequested = [self.modeSwitch isSelectedForSegment:SHUTDOWNATINDEX];
    
    NSInteger time = [self.textField integerValue];
    NSInteger selectedTimeUnit = [self.timeUnit indexOfSelectedItem];
    
    NSLog(@"selected time unit %ld", selectedTimeUnit);
    
    time = time * (pow(60, selectedTimeUnit));
    
    if (time < 5) {
        NSLog(@"time is %ld", time);
        return;
    }
    
    NSLog(@"shutting down in %ld seconds", time);
        
    if (shutdownIsRequested) {
        [self scheduleTimerWithSeconds:time AndCallback:@selector(shutdown)];
    } else {
        [self scheduleTimerWithSeconds:time AndCallback:@selector(sleep)];

    }

    
}

- (void)scheduleTimerWithSeconds:(NSInteger)seconds AndCallback:(SEL)callback {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:callback userInfo:nil repeats:NO];
    [self.progressIndicator setHidden:NO];
    [self.progressIndicator startAnimation:self];
    [self.button setTitle:@"abort"];

}


- (void)cancelTimer{
    NSLog(@"cancelling timer");
    [self reset];
}

- (void) shutdown{
    OSStatus error = noErr;
    error = SendAppleEventToSystemProcess(kAEShutDown);
    [self reset];

}

- (void) sleep{
    OSStatus error = noErr;
    error = SendAppleEventToSystemProcess(kAESleep);
    [self reset];

}

-(void) reset {
    [self.timer invalidate];
    self.timer = nil;
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    [self.button setTitle:@"go!"];
}

OSStatus SendAppleEventToSystemProcess(AEEventID EventToSend)
{
    AEAddressDesc targetDesc;
    static const ProcessSerialNumber kPSNOfSystemProcess = { 0, kSystemProcess };
    AppleEvent eventReply = {typeNull, NULL};
    AppleEvent appleEventToSend = {typeNull, NULL};
    
    OSStatus error = noErr;
    
    error = AECreateDesc(typeProcessSerialNumber, &kPSNOfSystemProcess,
                         sizeof(kPSNOfSystemProcess), &targetDesc);
    
    if (error != noErr)
    {
        return(error);
    }
    
    error = AECreateAppleEvent(kCoreEventClass, EventToSend, &targetDesc,
                               kAutoGenerateReturnID, kAnyTransactionID, &appleEventToSend);
    
    AEDisposeDesc(&targetDesc);
    if (error != noErr)
    {
        return(error);
    }
    
    error = AESend(&appleEventToSend, &eventReply, kAENoReply,
                   kAENormalPriority, kAEDefaultTimeout, NULL, NULL);
    
    AEDisposeDesc(&appleEventToSend);
    if (error != noErr)
    {
        return(error);
    }
    
    AEDisposeDesc(&eventReply);
    
    return(error); 
}

@end
