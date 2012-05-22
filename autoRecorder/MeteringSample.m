//
//  MySample.m
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "MeteringSample.h"

@interface MeteringSample ()
@property (readwrite, strong) NSTimer *updateMetersTimer;
@end

@implementation MeteringSample
@synthesize player = _player, updateMetersTimer, audioFileUrl = _audioFileUrl;

+(MeteringSample *)sampleURL:(NSURL *)sampleURL {
    MeteringSample *s = [[MeteringSample alloc] initWithURL:sampleURL];
    return s;
}

-(id)initWithURL:(NSURL *)sampleURL {
    self = [super init]; 
    if(self != nil) {
        _audioFileUrl = sampleURL;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioFileUrl error:nil];
        self.player.delegate = self;
        self.meteringEnabled = YES;
        self.loops = YES;
    }
    return self;
}

-(void)startUpdatingMeters {
    self.updateMetersTimer = [NSTimer timerWithTimeInterval:1.0/30.0f target:self.player selector:@selector(updateMeters) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.updateMetersTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopUpdatingMeters {
    [self.updateMetersTimer invalidate];
    self.updateMetersTimer = nil;
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    C4Log(@"audioPlayerBeginInterruption:");
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    C4Log(@"audioPlayerDidFinishPlaying:");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    C4Log(@"audioPlayerDecodeErrorDidOccur:");
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    C4Log(@"audioPlayerEndInterruption:");
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    C4Log(@"audioPlayerEndInterruption:withFlags:");
}

@end