//
//  AudioFileRecorder.m
//  recorderRemake
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "AudioFileRecorder.h"

@interface AudioFileRecorder()
@property (readwrite, strong) NSMutableArray *audioFileUrls;
@property (readwrite, strong) NSMutableDictionary *settings;
@property (readwrite, strong) AVAudioRecorder *audioRecorder;
@end

@implementation AudioFileRecorder
@synthesize ableToRecord = _ableToRecord, audioFileUrls, audioRecorder, currentUrl, delegate = _delegate, settings;

-(id)init {
    self = [super init];
    if(self != nil) {
        _ableToRecord = YES;
    }
    return self;
}

-(void)recordAudioFile {
    [self recordAudioFileWithId:[C4DateTime millis]];
}

-(void)recordAudioFileWithId:(NSInteger)sampleId {
    if(self.isAbleToRecord) {
        _ableToRecord = NO;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        if(err){
            NSLog(@"audioSession setCategory:error -> %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        err = nil;
        [audioSession setActive:YES error:&err];
        if(err){
            NSLog(@"audioSession setActive:error -> %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        
        self.settings = [[NSMutableDictionary alloc] init];
        
        // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
        [self.settings setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        
        // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
        [self.settings setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        
        // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
        [self.settings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        // These settings are used if we are using kAudioFormatLinearPCM format
        //[self.settings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //[self.settings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        //[self.settings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        self.currentUrl = nil;
        self.currentUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@MySound%d.caf", NSTemporaryDirectory(), sampleId]];
//        C4Log(@"recording: %@",self.currentUrl);
        err = nil;
        
        NSData *audioData = [NSData dataWithContentsOfFile:[self.currentUrl path] options: 0 error:&err];
        if(audioData)
        {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[self.currentUrl path] error:&err];
        }
        
        err = nil;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.currentUrl settings:self.settings error:&err];
        if(!self.audioRecorder){
            C4Log(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        
        //prepare to record
        [self.audioRecorder setDelegate:self];
        [self.audioRecorder prepareToRecord];
        self.audioRecorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.inputIsAvailable;
        if (!audioHWAvailable) {
            C4Log(@"Audio Session unavailable, have to exit now, sorry...");
            return;
        }
        
        // start recording
        [self.audioRecorder recordForDuration:2.0f];
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self.audioFileUrls addObject:self.currentUrl];
    [self postNotification:@"audioFileRecorderDidFinishRecording"];
    _ableToRecord = YES;
    [self postNotification:@"audioRecorderIsAvailableToRecord"];
}

-(void)deleteAudioFile {   
	NSError *err = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
    
	err = nil;
    if([fm fileExistsAtPath:[self.currentUrl path]]) {
        [fm removeItemAtPath:[self.currentUrl path] error:&err];
        if(err)
            C4Log(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        else {
            C4Log(@"No error in deleting file: %@", [self.currentUrl path]);
            [self postNotification:@"noErrorInDeletingFile"];
        }
    } else {
        C4Log(@"file doesn't exist");
    }
}

-(void)prepareForRemoval {
    self.currentUrl = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self postNotification:@"readyToBeRemoved"];
}

-(void)removeAudioFileForURL:(NSURL *)url {

	NSError *err;
	NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:[url path]]) {
        [fm removeItemAtPath:[url path] error:&err];
        if(err)
            C4Log(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        else {
//            C4Log(@"No error in deleting file: %@", [url path]);
//            [self postNotification:@"noErrorInDeletingFile"];
        }
    } else {
        C4Log(@"file doesn't exist");
    }
}

@end
