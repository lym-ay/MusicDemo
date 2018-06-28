//
//  MusicNetPlayerController.m
//  MusicDemo
//
//  Created by olami on 2018/6/26.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import "MusicNetPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicData.h"


static const NSString *PlayerItemStatusContext;
@interface MusicNetPlayerController()
@property (nonatomic, strong) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) id timeObserver;
@property (strong, nonatomic) id itemEndObserver;
@end


@implementation MusicNetPlayerController

static MusicNetPlayerController *_instance = nil;

+(MusicNetPlayerController *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance =[[self alloc] init];
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

- (void)playIndex:(NSUInteger)index{
    MusicData *data = self.musicDataArray[index];
    _index = index;
    NSArray *keys = @[
                      @"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
                      ];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:data.songUrl options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.volume = 0.3;
    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:&PlayerItemStatusContext];
    _songStatus = PlayStatus;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    
    if (context == &PlayerItemStatusContext) {
        
        dispatch_async(dispatch_get_main_queue(), ^{                        // 1

            [self.playerItem removeObserver:self forKeyPath:@"status"];

            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {

                // Set up time observers.                                   // 2
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];

                CMTime duration = self.playerItem.duration;

                // Synchronize the time display                             // 3
                [self.delegate setCurrentTime:CMTimeGetSeconds(kCMTimeZero)
                                      duration:CMTimeGetSeconds(duration)];


                [self.player play];                                         // 5



            } else {
                NSLog(@"observe error");
            }
        });
        
       
    }
}

- (void)addPlayerItemTimeObserver{
    CMTime interval = CMTimeMakeWithSeconds(1,  NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __weak MusicNetPlayerController *weakSelf = self;
    void (^callback)(CMTime time) = ^(CMTime time){
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.delegate setCurrentTime:currentTime duration:duration];
    };
    
   self.timeObserver =  [self.player addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:callback];
}

- (void)addItemEndObserverForPlayerItem{
    NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    __weak MusicNetPlayerController *weakSelf = self;
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:self.playerItem queue:queue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.delegate playbackComplete];
        }];
    }];
}


- (void)pause{
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self.player pause];
        _songStatus = PauseStatus;
    }else{
        [self.player play];
        _songStatus = PlayStatus;
    }
}

- (void)stop{
    
}

- (void)prevSong{
    if (_index == 0) {
        //如果是第一首，就播放最后一首
        _index = _musicDataArray.count -1;
    }else{
        _index--;
    }
 
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
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
    
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    [self playIndex:_index];
}

- (void)seekToTime:(NSTimeInterval)time{
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)seekStart{
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void)seekEnd{
    [self addPlayerItemTimeObserver];
}


@end
