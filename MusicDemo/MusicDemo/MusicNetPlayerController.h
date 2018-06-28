//
//  MusicNetPlayerController.h
//  MusicDemo
//
//  Created by olami on 2018/6/26.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusicNetPlayerControllerDelegate
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)playbackComplete;
@end;

@interface MusicNetPlayerController : NSObject
+(MusicNetPlayerController *)getInstance;
@property (nonatomic, copy) NSArray *musicDataArray;
@property (nonatomic, assign) SongStatus songStatus;
@property (nonatomic, assign) NSUInteger index;//当前播放歌曲的索引值
@property (nonatomic, weak) id<MusicNetPlayerControllerDelegate> delegate;
- (void)playIndex:(NSUInteger) index;
- (void)pause;
- (void)stop;
- (void)prevSong;
- (void)nextSong;
@end
