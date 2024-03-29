//
//  C4WorkSpace.h
//  autoRecorder
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace : C4CanvasController
-(void)audioRecorderIsAvailableToRecord:(NSNotification *)notification;
-(void)audioRecorderDidFinishRecording:(NSNotification *)notification;
-(void)meteringShapeWillRemoveFromSuperview:(NSNotification *)notification;
@end
