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
//    NSArray *arry = @[@"zj",@"MP3Sample",@"by"];
//    for (NSString *name in arry) {
//        [self getLocalSong:name complete:block];
//    }
    [self getNetMusic];
    block(YES);
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

- (void)getNetMusic{
    NSURL *url1 = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/C4000031PqYN0sj8K3.m4a?vkey=7489DD29B94AEF783AEF6F95CFF528DC6F30578D5AF485B0DA5524D6C86BAF2674CD0EB85414F949AF9347250708DEB544381F237BC46291&guid=3708371200&uin=0&fromtag=66"];
    MusicData *data1 = [[MusicData alloc] init];
    data1.songName =@"阴天";
    data1.songSinger = @"莫文蔚";
    data1.songUrl = url1;
    data1.songAlbum = @"you can";
    NSString *picPath1 = [[NSBundle mainBundle] pathForResource:@"mo2" ofType:@"jpg"];
    UIImage *img1 = [UIImage imageNamed:picPath1];
    data1.songImage = img1;
    [self.musicDataArray addObject:data1];
    NSURL *url2 = [NSURL URLWithString:@"http://fs.w.kugou.com/201806281116/cfd2cd098e3ef708ad0d08039ec901b9/G002/M02/0B/05/Qg0DAFS4VaqAVV2hADx4AKxhoHg263.mp3"];
    MusicData *data2 = [[MusicData alloc] init];
    data2.songName =@"盛夏的果实";
    data2.songSinger = @"莫文蔚";
    data2.songUrl = url2;
    data2.songAlbum = @"新曲-精选全纪录";
    NSString *picPath2 = [[NSBundle mainBundle] pathForResource:@"mo1" ofType:@"jpg"];
    UIImage *img2 = [UIImage imageNamed:picPath2];
    data2.songImage = img2;
    [self.musicDataArray addObject:data2];
    
    NSURL *url3 = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/C400004MnWHW4IdbcT.m4a?vkey=89969EAF699E8D6AC50CF72FE5B56FF4411C999CCC177213B204384A68B311AF9B7CA9251A93B1A4B96949A204A1B25A0CBBAC831FBD1C06&guid=9611377172&uin=0&fromtag=66"];
    MusicData *data3 = [[MusicData alloc] init];
    data3.songName =@"如果你是李白";
    data3.songSinger = @"莫文蔚";
    data3.songUrl = url3;
    data3.songAlbum = @"[i]";
    NSString *picPath3 = [[NSBundle mainBundle] pathForResource:@"mo3" ofType:@"jpg"];
    UIImage *img3 = [UIImage imageNamed:picPath3];
    data3.songImage = img3;
    [self.musicDataArray addObject:data3];
    
    
     
    NSURL *url4 = [[NSBundle mainBundle] URLForResource:@"by" withExtension:@"mp3"];
    MusicData *data4= [[MusicData alloc] init];
    data4.songName =@"冰雨";
    data4.songSinger = @"刘德华";
    data4.songUrl = url4;
    data4.songAlbum = @"2012世界巡回演唱会";
    //NSString *picPath4 = [[NSBundle mainBundle] pathForResource:@"mo3" ofType:@"jpg"];
    //UIImage *img3 = [UIImage imageNamed:picPath3];
    //data3.songImage = img3;
    [self.musicDataArray addObject:data4];
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
