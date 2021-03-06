//
//  MSCEFClient.mm
//  MiniServo
//
//  Created by Patrick Walton on 11/6/14.
//  Copyright (c) 2014 Mozilla Foundation. All rights reserved.
//

#import "MSAppDelegate.h"
#import "NSString+MSStringAdditions.h"
#include "MSCEFClient.h"
#include <include/cef_client.h>

/* virtual override */ CefRefPtr<CefRenderHandler> MSCEFClient::GetRenderHandler() {
    return this;
}

/* virtual override */ CefRefPtr<CefLoadHandler> MSCEFClient::GetLoadHandler() {
    return this;
}

/* virtual override */ bool MSCEFClient::GetViewRect(CefRefPtr<CefBrowser> browser, CefRect& rect) {
    rect.x = rect.y = 0;
    rect.width = [mView frame].size.width;
    rect.height = [mView frame].size.height;
    return true;
}

/* virtual override */ bool MSCEFClient::GetBackingRect(CefRefPtr<CefBrowser> browser,
                                                        CefRect& rect) {
    NSRect backingFrame = [mView convertRectToBacking: [mView frame]];
    rect.x = rect.y = 0;
    rect.width = backingFrame.size.width;
    rect.height = backingFrame.size.height;
    return true;
}

/* virtual override */ void MSCEFClient::OnPaint(CefRefPtr<CefBrowser> browser,
                                                 CefRenderHandler::PaintElementType type,
                                                 const CefRenderHandler::RectList& dirtyRects,
                                                 const void* buffer,
                                                 int width,
                                                 int height) {
    [mView paint: buffer withSize: NSMakeSize(width, height)];
}

/* virtual override */ void MSCEFClient::OnPresent(CefRefPtr<CefBrowser> browser) {
    [mView present];
}

/* virtual override */ void MSCEFClient::OnLoadingStateChange(CefRefPtr<CefBrowser> browser,
                                                              bool isLoading,
                                                              bool canGoBack,
                                                              bool canGoForward) {
    [mAppDelegate setIsLoading: (BOOL)isLoading];
    [mAppDelegate performSelectorOnMainThread:@selector(updateNavigationState:)
                                   withObject:nil
                                waitUntilDone: NO];
}

/* virtual override */ void MSCEFClient::OnLoadEnd(CefRefPtr<CefBrowser> browser,
                                                   CefRefPtr<CefFrame> frame,
                                                   int httpStatusCode) {
    [mAppDelegate performSelectorOnMainThread:@selector(addHistoryEntryForMainFrame:)
                                   withObject:nil
                                waitUntilDone:NO];
}

/* virtual override */ void MSCEFClient::Visit(const CefString &string) {
    [mAppDelegate performSelectorOnMainThread:@selector(setTabTitle:)
                                   withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSString stringWithCEFString:string],
                                               @"title",
                                               [NSNumber numberWithInt:0],
                                               @"index",
                                               nil]
                                waitUntilDone:NO];
}
