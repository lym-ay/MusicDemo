//
//  MusicPlayerController.m
//  MusicDemo
//
//  Created by olami on 2018/6/26.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import "MusicPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicData.h"

@interface MusicPlayerController()
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MusicPlayerController


static MusicPlayerController* _instance = nil;

+(MusicPlayerController *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)init{
    if (self = [super init]) {
        _songStatus = StopStatus;
    }
    
    return self;
}

- (void)setMusicDataArray:(NSArray *)musicDataArray{
    _musicDataArray = [musicDataArray copy];
}



- (void)playIndex:(NSUInteger) index{
     MusicData *data = self.musicDataArray[index];
    _index = index;
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:data.songUrl error:&error];
    if (error) {
        NSLog(@"play error is %@",error);
        return;
    }
    _audioPlayer.currentTime = 0.0f;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    NSTimeInterval duration = _audioPlayer.duration;
    NSLog(@"duration is %f",duration);
    _songStatus = PlayStatus;
}

- (void)pause{
    if (_audioPlayer.isPlaying) {
        [_audioPlayer pause];
        _songStatus = PauseStatus;
    }else {
        [_audioPlayer play];
        _songStatus = PlayStatus;
    }
}

- (void)stop{
    if(_audioPlayer.isPlaying){
        [_audioPlayer stop];
        _audioPlayer.currentTime = 0.0f;
        _songStatus = StopStatus;
    }
}
- (void)prevSong{
    if (_index == 0) {
        //如果是第一首，就播放最后一首
        _index = _musicDataArray.count -1;
    }else{
        _index--;
    }
    
    [self playIndex:_index];
}

- (void)nextSong{
    if (_index == _musicDataArray.count -1) {
        //如果是最后一首，播放第一首
        _index = 0;
    }else{
        _index++;
    }
    
    [self playIndex:_index];
}

- (NSTimeInterval)duration{
    return _audioPlayer.duration;
}

- (NSTimeInterval)currentTime{
    return _audioPlayer.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime{
    _audioPlayer.currentTime = currentTime;
}

 

 
@end
