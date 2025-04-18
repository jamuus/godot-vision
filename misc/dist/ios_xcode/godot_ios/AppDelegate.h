//  Copyright © 2025 GodotEngine. All rights reserved.
//

/**************************************************************************/
/*  app_delegate.h                                                        */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/
#if TARGET_OS_VISION
#import <CompositorServices/CompositorServices.h>
#import <UIKit/UIKit.h>

@class ViewController;

// FIXME: Add support for both OpenGL and Vulkan when OpenGL is implemented again,
// so it can't be done with compilation time branching.
//#if defined(GLES3_ENABLED)
//@interface AppDelegate : NSObject <UIApplicationDelegate, GLViewDelegate> {
//#endif
//#if defined(VULKAN_ENABLED)
@interface AppDelegate : NSObject <UIApplicationDelegate>
//#endif

// @property(strong, nonatomic) UIWindow *window;
// @property(strong, class, readonly, nonatomic) ViewController *viewController;

@end

@protocol SwiftVisionController <NSObject>
@required
@end

@interface ViewController : NSObject

@property(nonatomic, readwrite) id<SwiftVisionController> swiftController;
- (BOOL)setup;

@end
#endif
