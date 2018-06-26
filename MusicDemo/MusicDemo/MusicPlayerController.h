//
//  MusicPlayerController.h
//  MusicDemo
//
//  Created by olami on 2018/6/26.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

 

@interface MusicPlayerController : NSObject
+(MusicPlayerController *)getInstance;
@property (nonatomic, copy) NSArray *musicDataArray;
@property (nonatomic, assign) SongStatus songStatus;
@property (nonatomic, assign) NSUInteger index;//当前播放歌曲的索引值
@property (nonatomic, assign) NSTimeInterval duration;//歌曲的长度
@property (nonatomic, assign) NSTimeInterval currentTime;//当前播放的时间
- (void)playIndex:(NSUInteger) index;
- (void)pause;
- (void)stop;
- (void)prevSong;
- (void)nextSong;
- (void)playAtTime:(NSTimeInterval)time;

@end
