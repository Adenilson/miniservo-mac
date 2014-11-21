//
//  MSAppDelegate.h
//  MiniServo
//
//  Created by Patrick Walton on 11/6/14.
//  Copyright (c) 2014 Mozilla Foundation. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <include/cef_app.h>
#include <include/cef_base.h>

#define INITIAL_URL "http://asdf.com/"

@class MSView;

class CefBrowser;
class MSCEFClient;

@interface MSAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSWindowDelegate> {
    CefRefPtr<CefBrowser> mBrowser;
    CefRefPtr<MSCEFClient> mCEFClient;
    BOOL mDoingWork;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSegmentedControl *backForwardButton;
@property (assign) IBOutlet NSButton *stopReloadButton;
@property (assign) IBOutlet NSTextField *urlBar;
@property (assign) IBOutlet MSView *browserView;

- (IBAction)goBackOrForward:(id)sender;
- (IBAction)stopOrReload:(id)sender;
- (void)spinCEFEventLoop:(id)nothing;
- (void)windowDidResize:(NSNotification*)notification;
- (void)sendCEFMouseEventForButton:(int)button up:(BOOL)up point:(NSPoint)point;
- (void)sendCEFScrollEventWithDelta:(NSPoint)delta origin:(NSPoint)origin;
- (void)sendCEFKeyboardEventForKey:(short)keyCode character:(char16)character;
- (void)setCanGoBack:(BOOL)canGoBack forward:(BOOL)canGoForward;
- (void)composite;
- (void)initializeCompositing;

@end
