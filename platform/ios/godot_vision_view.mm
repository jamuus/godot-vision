/**************************************************************************/
/*  godot_vision_view.mm                                                  */
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
#import "godot_vision_view.h"

#import "display_layer.h"
#import "display_server_ios.h"
#import "godot_view_renderer.h"
#import "godot_vision_view.h"

#include "core/config/project_settings.h"
#include "core/os/keyboard.h"
#include "core/string/ustring.h"
#import <CompositorServices/CompositorServices.h>
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import <CoreMotion/CoreMotion.h>

// static const float earth_gravity = 9.80665;

@interface GodotView () {
}

@property(assign, nonatomic) BOOL isActive;

@end

@implementation GodotView

// - (CGSize)screen_get_size:(int)p_screen {
// 	return self.size;
// }
// - (CGRect)get_display_safe_area {
// 	CGSize s = [self screen_get_size:0];
// 	return CGRectMake(0, 0, s.width, s.height);
// }
bool _is_initialized;
- (GodotView<DisplayLayer> *)initializeRenderingForDriver:(NSString *)driverName {
	if (_is_initialized) {
		return (GodotView<DisplayLayer> *)self;
	}

	if (![driverName isEqualToString:@"metal"]) {
		print_verbose("error: only metal driver is not supported on VisionOS");
		return nil;
	}

	// [self initializeDisplayLayer];
	_is_initialized = YES;
	return (GodotView<DisplayLayer> *)self;
}

- (instancetype)init {
	if (self) {
		[self godot_commonInit];
	}
	return self;
}

- (void)dealloc {
	[self stopRendering];

	self.renderer = nil;

}

- (void)godot_commonInit {
}

- (void)system_theme_changed {
	DisplayServerIOS *ds = (DisplayServerIOS *)DisplayServer::get_singleton();
	if (ds) {
		ds->emit_system_theme_changed();
	}
}
- (BOOL)setup {
	NSLog(@"setup Called");
	return YES;
}

- (void)stopRendering {
	if (!self.isActive) {
		return;
	}

	self.isActive = NO;
	print_verbose("Stop animation!");
}

- (void)startRendering {
	if (self.isActive) {
		return;
	}

	self.isActive = YES;
	print_verbose("Start animation!");
}

- (void)drawView {
	if (!self.isActive) {
		// print_verbose("Draw view not active!");
		//		return;
	}
	RenderingDevice *rendering_device = RenderingDevice::get_singleton();
	if (rendering_device) {
		rendering_device->make_current();
		// NSLog(@"RenderingDevice is now current.");
		//		return;
	}

	if (!self.renderer) {
		return;
	}

	//The UIView is never used...
	if ([self.renderer setupView:nil]) {
		return;
	}

	if (self.delegate) {
		BOOL delegateFinishedSetup = [self.delegate godotViewFinishedSetup:self];

		if (!delegateFinishedSetup) {
			return;
		}
	}

	[self.renderer renderOnView:nil];
}

// - (CGRect)bounds {
// 	CGSize s = self.size;
// 	return CGRectMake(0, 0, s.width, s.height);
// }

// CGSize _size = CGSizeZero;
// - (CGSize)size {
// 	if (self.drawable) {
// 		id<MTLTexture> texture = cp_drawable_get_color_texture(self.drawable, 0);
// 		if (texture) {
// 			_size = CGSizeMake(texture.width, texture.height);
// 			return _size;
// 		}
// 	}
// 	if (_size.width == 0 || _size.height == 0) {
// #if VISIONOS_SIMULATOR
// 		_size = CGSizeMake(2732, 2048);
// #else
// 		//The max size for the VisionPro on device is 1920x1824 when you create the display buffer
// 		_size = CGSizeMake(1920, 1800);
// #endif
// 	}
// 	return _size;
// }
// - (void)setsize:(CGSize)newValue {
// 	_size = newValue;
// }

- (bool)shouldDraw {
    return true;
}

- (bool)pre_draw_viewport {
	return true;
}
- (void)stopRenderDisplayLayer {
	NSLog(@"stopRenderDisplayLayer");
}

// MARK: Motion

- (void)handleMotion {
}

@end
#endif
