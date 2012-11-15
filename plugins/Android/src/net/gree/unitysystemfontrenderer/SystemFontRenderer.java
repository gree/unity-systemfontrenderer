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

package net.gree.unitysystemfontrenderer;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Canvas;
import android.graphics.Typeface;
import android.opengl.GLES10;
import android.opengl.GLUtils;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View.MeasureSpec;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.unity3d.player.UnityPlayer;

public class SystemFontRenderer
{
	public static final int ALIGNMENT_LEFT = 0;
	public static final int ALIGNMENT_CENTER = 1;
	public static final int ALIGNMENT_RIGHT = 2;
	public static final int VERTICALALIGNMENT_TOP = 0;
	public static final int VERTICALALIGNMENT_MIDDLE = 1;
	public static final int VERTICALALIGNMENT_BOTTOM = 2;
	public static final int STYLE_NORMAL = 0;
	public static final int STYLE_BOLD = 1;
	public static final int STYLE_ITALIC = 2;
	public static final int STYLE_BOLD_ITALIC = 3;

	public static void RenderTexture(String text, float size, float width, float height, int style, int alignment, int verticalAlignment, float letterSpacing, float lineSpacing, float leftMargin, float rightMargin, int textureId)
	{
		int w = 1;
		int h = 1;
		while (w < width)
			w <<= 1;
		while (h < height)
			h <<= 1;

		int gravity = 0;
		switch (alignment) {
		case ALIGNMENT_LEFT:
			gravity |= Gravity.LEFT;
			break;
		case ALIGNMENT_CENTER:
			gravity |= Gravity.CENTER_HORIZONTAL;
			break;
		case ALIGNMENT_RIGHT:
			gravity |= Gravity.RIGHT;
			break;
		}

		switch (verticalAlignment) {
		case VERTICALALIGNMENT_TOP:
			gravity |= Gravity.TOP;
			break;
		case VERTICALALIGNMENT_MIDDLE:
			gravity |= Gravity.CENTER_VERTICAL;
			break;
		case VERTICALALIGNMENT_BOTTOM:
			gravity |= Gravity.BOTTOM;
			break;
		}

		switch (style) {
		case STYLE_NORMAL:
			style = Typeface.NORMAL;
			break;
		case STYLE_BOLD:
			style = Typeface.BOLD;
			break;
		case STYLE_ITALIC:
			style = Typeface.ITALIC;
			break;
		case STYLE_BOLD_ITALIC:
			style = Typeface.BOLD_ITALIC;
			break;
		}

		Activity a = UnityPlayer.currentActivity;
		TextView textView = new TextView(a);
		textView.setTypeface(null, style);
		textView.setGravity(gravity);
		textView.setWidth((int)width);
		textView.setHeight((int)height);
		textView.setTextSize(TypedValue.COMPLEX_UNIT_PX, size);
		textView.setText(text);

		Bitmap bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ALPHA_8);
		Canvas canvas = new Canvas(bitmap);
		canvas.scale(1.0f, -1.0f, 0.0f, h / 2.0f);

		LinearLayout layout = new LinearLayout(a);
		layout.addView(textView);
		layout.measure(
			MeasureSpec.makeMeasureSpec(canvas.getWidth(), MeasureSpec.EXACTLY),
			MeasureSpec.makeMeasureSpec(canvas.getHeight(), MeasureSpec.EXACTLY));
		layout.layout(0, 0, layout.getMeasuredWidth(), layout.getMeasuredHeight());
		layout.draw(canvas);

		GLES10.glBindTexture(GLES10.GL_TEXTURE_2D, textureId);
		GLES10.glPixelStorei(GLES10.GL_UNPACK_ALIGNMENT, 1);
		GLUtils.texImage2D(GLES10.GL_TEXTURE_2D, 0, bitmap, 0);
		bitmap.recycle();
	}
}
