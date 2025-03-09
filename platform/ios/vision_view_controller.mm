/**************************************************************************/
/*  vision_view_controller.mm                                             */
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

#if defined(VISIONOS)
#import "vision_view_controller.h"

#import "app_delegate.h"
#import "display_server_ios.h"
#import "godot_view_renderer.h"
#import "godot_vision_view.h"
#import "key_mapping_ios.h"
#import "keyboard_input_view.h"
#import "os_ios.h"

#include "core/config/project_settings.h"

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <GameController/GameController.h>

@interface RenderThread : NSThread {
}

- (instancetype)init:(cp_layer_renderer_t)layerRenderer;
@end
@implementation RenderThread

- (instancetype)init:(cp_layer_renderer_t)layerRenderer {
	self = [self init];
	return self;
}

- (void)main {
	[[AppDelegate viewController] runLoop];
}

@end

@interface ViewController () <GodotViewDelegate>

@property(strong, nonatomic) GodotViewRenderer *renderer;
@property(strong, nonatomic) GodotKeyboardInputView *keyboardView;
@property(strong, readwrite, nonatomic) GodotView *view;
// @property(nonatomic, assign) cp_layer_renderer_t __unsafe_unretained layerRenderer;

// @property(strong, nonatomic) UIView *godotLoadingOverlay;

@end

@implementation ViewController

- (GodotView *)godotView {
	return (GodotView *)self.view;
}
- (BOOL)setup {
	RenderThread *renderThread = [[RenderThread alloc] init:nil];
	renderThread.name = @"Spatial Renderer Thread";
	[renderThread start];
	return true;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
}

- (void)viewDidAppear {
    print_line("viewDidAppear");
}

bool _running = true;
- (void)runLoop {
	[self.view setup];
	while (_running) {
		@autoreleasepool {
			[self.view drawView];
		}
	}
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
}

- (void)loadView {
	GodotView *view = [[GodotView alloc] init];
	GodotViewRenderer *renderer = [[GodotViewRenderer alloc] init];

	self.renderer = renderer;
	self.view = view;

	view.renderer = self.renderer;
	view.delegate = self;
}

- (BOOL)godotViewFinishedSetup:(GodotView *)view {
	return YES;
}

- (void)dealloc {
	self.keyboardView = nil;

	self.renderer = nil;

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardOnScreen:(NSNotification *)notification {
}

- (void)keyboardHidden:(NSNotification *)notification {
}

@end
#endif
