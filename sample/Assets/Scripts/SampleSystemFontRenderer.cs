/*
 * Copyright (c) 2012 GREE, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

using UnityEngine;

public class SampleSystemFontRenderer : MonoBehaviour
{
	public string text;
	public float fontSize;
	public float width;
	public float height;
	public SystemFont.Style style;
	public SystemFont.Align align;
	public SystemFont.VerticalAlign verticalAlign;
	public Color color;
	SystemFont.Renderer mRenderer;

	void Start()
	{
		/*
		 * Create SystemFont.Renderer instance.
		 */
		mRenderer = new SystemFont.Renderer(
			fontSize, width, height, style, align, verticalAlign);
		mRenderer.SetText(text, color);

		/*
		 * Set the Mesh to MeshFilter and set the Material to MeshRenderer.
		 */
		MeshFilter meshFilter = gameObject.AddComponent<MeshFilter>();
		meshFilter.sharedMesh = mRenderer.mesh;
		MeshRenderer meshRenderer = gameObject.AddComponent<MeshRenderer>();
		meshRenderer.sharedMaterial = mRenderer.material;
		meshRenderer.sharedMaterial.color = mRenderer.color;
	}
}
