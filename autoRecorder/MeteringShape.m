//
//  MeteringShape.m
//  autoRecorder
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "MeteringShape.h"
#import "MeteringSample.h"
@class C4WorkSpace;

@interface MeteringShape ()
-(void)play;
-(void)stop;
@property (readwrite, strong) C4Shape *fillShape;
@property (readwrite, strong) MeteringSample* sample;
@property (readwrite, strong) NSTimer *meterTimer, *movementTimer;
@end

@implementation MeteringShape {
    NSUInteger objectID;
//    UIColor *baseBackgroundColor, *baseStrokeColor;
    SEL fadeOutSEL, stopSEL;
}

@synthesize audioFileUrl = _audioFileUrl, sample, meterTimer, movementTimer, meteringShapeCanBeRemoved, fillShape;

+(MeteringShape *)shapeWithUrl:(NSURL *)audioFileUrl {
    CGRect randomFrame = CGRectMake([C4Math randomInt:728], [C4Math randomInt:984], 40, 40);
    MeteringShape *ms = [[MeteringShape alloc] initWithFrame:randomFrame 
                                                         url:audioFileUrl];
    return ms;
}

- (id)initWithFrame:(CGRect)frame url:(NSURL *)sampleUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        fadeOutSEL = @selector(fadeOut);
        stopSEL = @selector(stop);
        objectID = [C4DateTime millis];
        self.meteringShapeCanBeRemoved = YES;
        self.sample = [MeteringSample sampleURL:sampleUrl];
        [self.sample prepareToPlay];
        [self ellipse:self.frame];
        self.strokeColor = C4GREY;
        self.fillColor = [C4GREY colorWithAlphaComponent:0.5];
    }
    return self;
}

-(NSURL *)audioFileUrl {
    return sample.audioFileUrl;
}

-(void)touchesBegan {
}

-(void)updateFillShapeColor {
//    @try {
//        CGFloat currentMeterValue = [self.sample.player averagePowerForChannel:0];
//        CGFloat newAlpha = [C4Math pow:10 raisedTo:0.05 * currentMeterValue]*5;
//        if (newAlpha < 0) newAlpha = 0;
//        else if(newAlpha > 1) newAlpha = 1;
//        self.animationDuration = 0.0f;
//        self.lineWidth = newAlpha *15+1;
//    }
//    @catch (NSException *exception) {
//        C4Log(@"%@",exception);
//    }
}

-(void)beginMovingAndPlaying {
    if(self.movementTimer != nil) {
        [self.movementTimer invalidate];
        self.movementTimer = nil;
    }

    self.movementTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(setRandomOrigin) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.movementTimer forMode:NSDefaultRunLoopMode];
    [self play];
}

-(void)setRandomOrigin {
    self.animationDuration = 1.0f;
    self.origin = CGPointMake([C4Math randomInt:728], [C4Math randomInt:984]);
}

-(void)play {
    if(self.sample.isPlaying == NO) {
        [self.sample startUpdatingMeters];
//        if(self.meterTimer != nil) {
//            [self.meterTimer invalidate];
//            self.meterTimer = nil;
//        }
        self.meterTimer = [NSTimer timerWithTimeInterval:1.0/10.0f
                                                  target:self 
                                                selector:@selector(updateFillShapeColor) 
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.meterTimer forMode:NSDefaultRunLoopMode];
        [self.sample play];
        [self performSelector:fadeOutSEL withObject:nil afterDelay:25];
    }
}

-(void)fadeOut {
    if (self.sample.volume > 0.0f) {
        self.sample.volume -= 0.01f;
        self.animationDuration = 0.0f;
        self.strokeColor = [C4GREY colorWithAlphaComponent:self.sample.volume];
        [self performSelector:fadeOutSEL withObject:nil afterDelay:1.0f/30.0f];
    } else {
        [self.sample stopUpdatingMeters];
        [meterTimer invalidate];
        [movementTimer invalidate];
        [self performSelector:stopSEL withObject:nil afterDelay:[movementTimer timeInterval] + 0.1];
    }
}

-(void)stop {
    if(self.sample.isPlaying) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.sample stop];
        [self postNotification:@"meteringShapeWillRemoveFromSuperview"];
    }
}

-(void)cleanUp {
//    self.sample = nil;
//    _audioFileUrl = nil;
//    meterTimer = nil;
//    movementTimer = nil;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [self removeFromSuperview];
}

//-(void)removeFromSuperview {
//    [super removeFromSuperview];
//}

//-(void)setDelegate:(id)delegate {
//    _delegate = delegate;
//    [delegate listenFor:@"meteringShapeWillRemoveFromSuperview" andRunMethod:@"meteringShapeWillRemoveFromSuperview:"];
//}

//-(void)removeFromSuperview {
//    if(self.meteringShapeCanBeRemoved == YES) {
//        [self postNotification:@"meteringShapeWillRemoveFromSuperview"];
//        self.meteringShapeCanBeRemoved = NO;
//        [super removeFromSuperview];
////        [self cleanUp];
//    }
//}

@end
