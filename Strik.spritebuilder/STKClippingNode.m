//
//  STKClippingNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 28/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKClippingNode.h"

@implementation STKClippingNode

#pragma mark init
- (id)initWithMask:(UIImage *)mask andNode:(CCNode *)node
{
	// Create UIImage from the node
	UIImage *imageNode = [self imageFromNode:node];
	
	// Scale the maskedImage up if needed
	if(imageNode.size.width < mask.size.width || imageNode.size.height < mask.size.height)
	{
		// Determine smallest direction (horizontal, vertical)
		CGFloat smallestImageSize;
		CGFloat correspondingClippingSpriteSize;
		
		// It is the width
		if(imageNode.size.width < mask.size.width)
		{
			smallestImageSize = imageNode.size.width;
			correspondingClippingSpriteSize = mask.size.width;
		}
		// It is the height
		else
		{
			smallestImageSize = imageNode.size.height;
			correspondingClippingSpriteSize = mask.size.height;
		}
		
		// Determine the needed scale
		float difference = 1 - (smallestImageSize / correspondingClippingSpriteSize);
		float newScale = 1 + difference;
		
		// And scale it a bit up
		imageNode = [self imageWithImage:imageNode scaledToSize:CGSizeMake(imageNode.size.width * newScale, imageNode.size.height * newScale)];
	}
	
	// Mask the image with CG
	UIImage *maskedImage = [self maskImage:imageNode withMask:mask];
	
	// Create a texture from the image
	CCTexture *maskedTexture = [[CCTexture alloc] initWithCGImage:maskedImage.CGImage contentScale:maskedImage.scale];
	
	// And create the sprite with that texture
	if(self = [super initWithTexture:maskedTexture])
	{
		
	}
	
	return self;
}

+ (id)clippingNodeWithMask:(UIImage *)mask andNode:(CCNode *)node
{
	return [[STKClippingNode alloc] initWithMask:mask andNode:node];
}


#pragma mark CCNode to UIImage

// And Thank you http://stackoverflow.com/questions/13136206/how-to-convert-a-ccsprite-image-to-uiimage
- (UIImage *) imageFromNode :(CCNode *)node
{
    int tx = node.contentSize.width;
    int ty = node.contentSize.height;
	
    CCRenderTexture *renderer   = [CCRenderTexture renderTextureWithWidth:tx height:ty];
	
    node.anchorPoint  = CGPointZero;
	
    [renderer begin];
    [node visit];
    [renderer end];
	
    return [renderer getUIImage];
}

#pragma mark UIImage manipulation

// Thank you: http://jeroendeleeuw.com/post/33638733049/how-to-mask-images-with-core-graphics-in-ios
- (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
	
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference scale:image.scale orientation:image.imageOrientation];
	
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

// Thanks http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
