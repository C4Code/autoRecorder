//
//  AudioFileRecorder.h
//  recorderRemake
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#import "C4DateTime.h"

@interface AudioFileRecorder : C4Object <AVAudioRecorderDelegate>
-(void)recordAudioFile;
-(void)recordAudioFileWithId:(NSInteger)sampleId;
-(void)deleteAudioFile;
-(void)prepareForRemoval;
-(void)removeAudioFileForURL:(NSURL *)url;

@property (readwrite, nonatomic, strong) id delegate;
@property (readwrite, strong) NSURL *currentUrl;
@property (readonly, getter = isAbleToRecord) BOOL ableToRecord;
@end
