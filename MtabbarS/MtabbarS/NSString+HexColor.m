//
//  NSString+HexColor.m
//  imgo.tv
//
//  Created by Herb on 6/9/11.
//  Copyright 2011 hunantv. All rights reserved.
//

#import "NSString+HexColor.h"

@implementation  NSString (HexColor)

-(UIColor*)colorValue {
	NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	if ([cString length] < 6) return nil;
	if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
	if ([cString length] != 6) return nil;

	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	if (!rString || !gString || !bString) {
		return nil;
	}
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
	
}

@end

