//
//  C4WorkSpace.m
//  autoRecorder
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "AudioFileRecorder.h"
#import "MeteringSample.h"
#import "MeteringShape.h"

enum RecordStage {
    RECORD = 0,
    PLAYBACK = 1,
    CLEANUP = 2
};

typedef NSUInteger RecordStage;

@interface C4WorkSpace () 
-(void)recordNewSampleForShape;
-(void)cleanup;
@property (readwrite, strong) NSMutableArray *visibleMeteringShapes;
@property (readwrite, strong) NSTimer *cleanupTimer;
@end

@implementation C4WorkSpace {
    AudioFileRecorder *recorder;
    NSInteger currentSample;
    NSUInteger currentStage;
    NSInteger meteringShapeCount, maxMeteringShapeCount;
    NSTimer *newSampleTimer;
}

@synthesize visibleMeteringShapes, cleanupTimer;

-(void)setup {
    meteringShapeCount = 0;
    maxMeteringShapeCount = 10;
    currentStage = -1;
    recorder = [AudioFileRecorder new];
    
    [self listenFor:@"audioFileRecorderDidFinishRecording" 
         fromObject:recorder 
       andRunMethod:@"audioRecorderDidFinishRecording:"];
    [self listenFor:@"audioRecorderIsAvailableToRecord" 
         fromObject:recorder
       andRunMethod:@"audioRecorderIsAvailableToRecord:"];

    visibleMeteringShapes = [[NSMutableArray alloc] initWithCapacity:0];
    newSampleTimer = [NSTimer timerWithTimeInterval:0.1f 
                                             target:self 
                                           selector:@selector(recordNewSampleForShape) 
                                           userInfo:nil 
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:newSampleTimer forMode:NSDefaultRunLoopMode];

    self.cleanupTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(cleanup) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.cleanupTimer forMode:NSDefaultRunLoopMode];
}

-(void)cleanup {
    for(MeteringShape *ms in self.canvas.subviews) {
        if (ms.meteringShapeCanBeRemoved == NO) {
            [ms removeFromSuperview];
            break;
        }
    }
}

-(void)audioRecorderDidFinishRecording:(NSNotification *)notification {
    MeteringShape *m = [MeteringShape shapeWithUrl:recorder.currentUrl];
    [self listenFor:@"meteringShapeWillRemoveFromSuperview" fromObject:m andRunMethod:@"meteringShapeWillRemoveFromSuperview:"];
    [self.canvas addShape:m];
    [self.visibleMeteringShapes addObject:m];
    [m beginMovingAndPlaying];
    m = nil;
}

-(void)audioRecorderIsAvailableToRecord:(NSNotification *)notification {
}

-(void)recordNewSampleForShape {
    if ([visibleMeteringShapes count] < maxMeteringShapeCount) {
        [recorder recordAudioFile];
    }
}

                         
-(void)meteringShapeWillRemoveFromSuperview:(NSNotification *)notification {   
    MeteringShape *m = (MeteringShape *)[notification object];
    if(m != nil) {
        if( m.audioFileUrl != nil) {
            if( m.meteringShapeCanBeRemoved) {
                [visibleMeteringShapes removeObject:m];
                [recorder removeAudioFileForURL:((MeteringShape *)[notification object]).audioFileUrl];
                m.meteringShapeCanBeRemoved = NO;
                [NSObject cancelPreviousPerformRequestsWithTarget:m];
            }
        }
    }
}
@end