//
//  MeteringShape.h
//  autoRecorder
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Shape.h"
#import "C4DateTime.h"

@interface MeteringShape : C4Shape
+(MeteringShape *)shapeWithUrl:(NSURL *)audioFileUrl;
-(id)initWithFrame:(CGRect)frame url:(NSURL *)sampleUrl;
-(void)beginMovingAndPlaying;
-(void)cleanUp;
@property (readwrite) BOOL meteringShapeCanBeRemoved;
@property (readonly, nonatomic, assign) NSURL *audioFileUrl;
@end
