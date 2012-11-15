/*
 * Copyright (C) 2011 Keijiro Takahashi
 * Copyright (C) 2012 GREE, Inc.
 * 
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

#import <Foundation/Foundation.h>
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
# import <UIKit/UIKit.h>
# import <CoreGraphics/CoreGraphics.h>
# import <OpenGLES/ES1/gl.h>
#else	// __IPHONE_OS_VERSION_MAX_ALLOWED
# import <OpenGL/gl.h>
# import "UIStringDrawing.h"
# import "UIGraphics.h"
# import "UIFont.h"
#endif	// __IPHONE_OS_VERSION_MAX_ALLOWED

enum {
	ALIGNMENT_LEFT = 0,
	ALIGNMENT_CENTER,
	ALIGNMENT_RIGHT,

	VERTICALALIGNMENT_TOP = 0,
	VERTICALALIGNMENT_MIDDLE,
	VERTICALALIGNMENT_BOTTOM,

	STYLE_NORMAL = 0,
	STYLE_BOLD,
	STYLE_ITALIC,
	STYLE_BOLD_ITALIC,
};

#if !defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
@interface SystemFontRendererContext : NSObject
{
	NSString *text;
	float size;
	float width;
	float height;
	int style;
	int alignment;
	int verticalAlignment;
	float lineSpacing;
	float letterSpacing;
	float leftMargin;
	float rightMargin;
	int textureId;
}

@property (assign, nonatomic) NSString *text;
@property (assign, nonatomic) float size;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) int style;
@property (assign, nonatomic) int alignment;
@property (assign, nonatomic) int verticalAlignment;
@property (assign, nonatomic) float lineSpacing;
@property (assign, nonatomic) float letterSpacing;
@property (assign, nonatomic) float leftMargin;
@property (assign, nonatomic) float rightMargin;
@property (assign, nonatomic) int textureId;

@end

@implementation SystemFontRendererContext

@synthesize text;
@synthesize size;
@synthesize width;
@synthesize height;
@synthesize style;
@synthesize alignment;
@synthesize verticalAlignment;
@synthesize lineSpacing;
@synthesize letterSpacing;
@synthesize leftMargin;
@synthesize rightMargin;
@synthesize textureId;

- (id)init:(const char *)text_ size:(float)size_ width:(float)width_ height:(float)height_ style:(int)style_ alignment:(int)alignment_ verticalAlignment:(int)verticalAlignment_ lineSpacing:(float)lineSpacing_ letterSpacing:(float)letterSpacing_ leftMargin:(float)leftMargin_ rightMargin:(float)rightMargin_ textureId:(int)textureId_
{
	self = [super init];
	text = [[NSString alloc] initWithUTF8String:text_];
	size = size_;
	width = width_;
	height = height_;
	style = style_;
	alignment = alignment_;
	verticalAlignment = verticalAlignment_;
	lineSpacing = lineSpacing_;
	letterSpacing = letterSpacing_;
	leftMargin = leftMargin_;
	rightMargin = rightMargin_;
	textureId = textureId_;
	return self;
}

- (void)dealloc
{
	[text release];
	[super dealloc];
}

@end

static NSMutableArray *queue;
#endif	// !__IPHONE_OS_VERSION_MAX_ALLOWED

extern "C" {
	void _SystemFontRenderer_RenderTexture(const char *text, float size, float width, float height, int style, int alignment, int verticalAlignment, float lineSpacing, float letterSpacing, float leftMargin, float rightMargin, int textureId);
#if !defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
	void UnityRenderEvent(int eventId);
#endif	// !__IPHONE_OS_VERSION_MAX_ALLOWED
}

void _SystemFontRenderer_RenderTexture(const char *text, float size, float width, float height, int style, int alignment, int verticalAlignment, float lineSpacing, float letterSpacing, float leftMargin, float rightMargin, int textureId)
{
#if !defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
	if (queue == 0)
		queue = [[NSMutableArray alloc] init];

	@synchronized(queue) {
		[queue insertObject:[[[SystemFontRendererContext alloc]
			init:text
			size:size
			width:width
			height:height
			style:style
			alignment:alignment
			verticalAlignment:verticalAlignment
			lineSpacing:lineSpacing
			letterSpacing:letterSpacing
			leftMargin:leftMargin
			rightMargin:rightMargin
			textureId:textureId] autorelease] atIndex:0];
	}
}

void UnityRenderEvent(int eventId)
{
#endif	// !__IPHONE_OS_VERSION_MAX_ALLOWED
	@autoreleasepool {
#if !defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
		SystemFontRendererContext *context = nil;

		if (queue == 0)
			return;

		@synchronized(queue) {
			if (queue.count == 0)
				return;
			context = [queue lastObject];
			[queue removeLastObject];
		}

		NSString *text = context.text;
		float size = context.size;
		float width = context.width;
		float height = context.height;
		int style = context.style;
		int alignment = context.alignment;
		int verticalAlignment = context.verticalAlignment;
		float lineSpacing = context.lineSpacing;
		float letterSpacing = context.letterSpacing;
		float leftMargin = context.leftMargin;
		float rightMargin = context.rightMargin;
		int textureId = context.textureId;
#endif	// !__IPHONE_OS_VERSION_MAX_ALLOWED

		int w = 1;
		int h = 1;
		while (w < width)
			w <<= 1;
		while (h < height)
			h <<= 1;

		switch (alignment) {
		default:
			alignment = UITextAlignmentLeft;
			break;
		case ALIGNMENT_CENTER:
			alignment = UITextAlignmentCenter;
			break;
		case ALIGNMENT_RIGHT:
			alignment = UITextAlignmentRight;
			break;
		}

		NSMutableData *data = [NSMutableData dataWithLength:(w * h)];
		CGContextRef ctx = CGBitmapContextCreate([data mutableBytes],
			w, h, 8, w, NULL, kCGImageAlphaOnly);

		CGContextSetTextDrawingMode(ctx, kCGTextFill);
		CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);

		UIGraphicsPushContext(ctx);

		UIFont *font;
		switch (style) {
		case STYLE_BOLD:
		case STYLE_BOLD_ITALIC:
			font = [UIFont boldSystemFontOfSize:size];
			break;
		case STYLE_ITALIC:
			font = [UIFont italicSystemFontOfSize:size];
			break;
		default:
			font = [UIFont systemFontOfSize:size];
			break;
		}

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
		NSString *string = [NSString stringWithUTF8String:text];
#else	// __IPHONE_OS_VERSION_MAX_ALLOWED
		NSString *string = text;
#endif	// __IPHONE_OS_VERSION_MAX_ALLOWED

		float y = 0;

		switch (verticalAlignment) {
		case VERTICALALIGNMENT_TOP:
			y = -font.descender; 
			break;
		case VERTICALALIGNMENT_MIDDLE:
		case VERTICALALIGNMENT_BOTTOM:
			{
				CGSize textSize = [string sizeWithFont:font
					constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
					lineBreakMode:UILineBreakModeWordWrap];
				if (textSize.height <= height) {
					switch (verticalAlignment) {
					case VERTICALALIGNMENT_MIDDLE:
						y = (height - textSize.height) / 2.0f;
						height = textSize.height;
						break;
					case VERTICALALIGNMENT_BOTTOM:
						y = height - textSize.height;
						height = textSize.height;
						break;
					}
				}
			}
			break;
		}

		[string drawInRect:CGRectMake(0, y, width, height) withFont:font
			lineBreakMode:UILineBreakModeWordWrap
			alignment:(UITextAlignment)alignment];

		UIGraphicsPopContext();

		CGContextRelease(ctx);

		glBindTexture(GL_TEXTURE_2D, textureId);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA,
			w, h, 0, GL_ALPHA, GL_UNSIGNED_BYTE, [data bytes]);
	}
}
