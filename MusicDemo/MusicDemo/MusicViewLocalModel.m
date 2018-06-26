//
//  MusicViewLocalModel.m
//  MusicDemo
//
//  Created by olami on 2018/6/25.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import "MusicViewLocalModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicViewLocalModel()

@property (nonatomic, assign) NSUInteger number;
@end;
@implementation MusicViewLocalModel


-(void)processMusic:(completeSearch)block{
    NSArray *arry = @[@"zj",@"MP3Sample",@"by"];
    for (NSString *name in arry) {
        [self getLocalSong:name complete:block];
    }
}

- (void)getLibrarySong{
    //    MPMediaQuery *listQuery = [MPMediaQuery playlistsQuery];
    //    NSArray *playlist = [listQuery collections];
    //    for (MPMediaPlaylist *list in playlist) {
    //        NSArray *songs = [list items];
    //        NSLog(@"songs count is %lu",songs.count);
    //        for (MPMediaItem *song in songs) {
    //            MusicData *data =[[MusicData alloc] init];
    //            data.songName = [song valueForProperty:MPMediaItemPropertyTitle];
    //            data.songSinger = [song valueForProperty:MPMediaItemPropertyArtist];
    //            data.songUrl = [[song valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
    //            [self.musicDataArray addObject:data];
    //        }
    //    }
}


- (void)getLocalSong:(NSString *)name complete:(completeSearch)block{
   
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *keys = @[@"availableMetadataFormats"];
    __weak typeof(self) weakSelf = self;;
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError *error;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"availableMetadataFormats" error:&error];
        if (error) {
            NSLog(@"error is %@",error);
            return;
        }
        
        if (status == AVKeyValueStatusLoaded) {
            
            for (NSString *format in asset.availableMetadataFormats) {
                if ([format isEqualToString:@"org.id3"]) {
                    NSArray *items = [asset metadataForFormat:format];
                    MusicData *data = [[MusicData alloc] init];
                    data.songUrl = url;
                    for (AVMetadataItem *item in items) {
//                        NSLog(@"item indentifier is %@",item.identifier);
//                        NSLog(@"item key is %@,value is %@",item.key,item.value);
//
                    if ([item.identifier isEqualToString:AVMetadataIdentifierID3MetadataLeadPerformer]) {//歌手
                            data.songSinger =(NSString*)item.value;
                        }else if([item.identifier isEqualToString:AVMetadataIdentifierID3MetadataAlbumTitle]){//专辑
                            data.songAlbum = (NSString*)item.value;
                        }else if([item.identifier isEqualToString:AVMetadataIdentifierID3MetadataTitleDescription]){//歌曲名
                            data.songName = (NSString*)item.value;
                        }else if([item.identifier isEqualToString:AVMetadataIdentifierID3MetadataAttachedPicture]){//图片
                            data.songImage = [[UIImage alloc] initWithData:item.dataValue];
                        }
                        
                        

                        
                    }
                    
                   [weakSelf.musicDataArray addObject:data];
                    weakSelf.number++;
                    if (weakSelf.number > 2) {
                        block(YES);
                    }
                }
            }
          
            
        }
        
       
        
       
    }];
    

}



@end
