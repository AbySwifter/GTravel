//
//  NSData+Additions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "NSData+Additions.h"
#import "UIImage+Additions.h"

@implementation NSData (Additions)
+ (NSData *)compressImageData:(NSData *)data toLength:(NSInteger)length
{
    NSData *compressedData = data;
    if (compressedData.length > length) {
        double iWidth = sqrt(length / 4.0);
        UIImage *image = [UIImage imageWithData:compressedData];
        UIImage *imageScaled = [UIImage scaleImage:image toSize:CGSizeMake(iWidth, iWidth)];
        compressedData = UIImageJPEGRepresentation(imageScaled, 1.0);
    }
    return compressedData;
}
@end
