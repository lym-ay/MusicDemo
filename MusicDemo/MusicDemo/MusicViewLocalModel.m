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



- (void)getNetMusic{
    NSURL *url1 = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/C4000031PqYN0sj8K3.m4a?vkey=DA49B554D1AA5AD9EB677E8CF0F8A71DB761EEFE97DD67998E37E4DF810BBD13F065CA58D4311365B5FA77AF5D18263B1DEA6C6AACA8BA00&guid=4589218520&uin=0&fromtag=66"];
    MusicData *data1 = [[MusicData alloc] init];
    data1.songName =@"阴天";
    data1.songSinger = @"莫文蔚";
    data1.songUrl = url1;
    data1.songAlbum = @"you can";
    NSString *picPath1 = [[NSBundle mainBundle] pathForResource:@"mo2" ofType:@"jpg"];
    UIImage *img1 = [UIImage imageNamed:picPath1];
    data1.songImage = img1;
    [self.musicDataArray addObject:data1];
    
    NSURL *url3 = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/C400004MnWHW4IdbcT.m4a?vkey=498183AA19B171F105065985B1C5706E33F5084318A16BC7681E1EF663DC308D759D594F0D3E7D7CBF1D271A5C391EA3D7551A3C58B7BF62&guid=9260923125&uin=0&fromtag=66"];
    MusicData *data3 = [[MusicData alloc] init];
    data3.songName =@"如果你是李白";
    data3.songSinger = @"莫文蔚";
    data3.songUrl = url3;
    data3.songAlbum = @"[i]";
    NSString *picPath3 = [[NSBundle mainBundle] pathForResource:@"mo3" ofType:@"jpg"];
    UIImage *img3 = [UIImage imageNamed:picPath3];
    data3.songImage = img3;
    [self.musicDataArray addObject:data3];
    
    
    NSURL *url2 = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/C400000ZrWu830BQUc.m4a?vkey=6F6CF7CC6831B5C810069EE5AE67E8C96EB459A20E68576B5263CA53393173171BCE30B78CE7A7E5F5C558CCA2675CEF23C236163661B40B&guid=2402296845&uin=0&fromtag=66"];
    MusicData *data2 = [[MusicData alloc] init];
    data2.songName =@"盛夏的果实";
    data2.songSinger = @"莫文蔚";
    data2.songUrl = url2;
    data2.songAlbum = @"新曲-精选全纪录";
    NSString *picPath2 = [[NSBundle mainBundle] pathForResource:@"mo1" ofType:@"jpg"];
    UIImage *img2 = [UIImage imageNamed:picPath2];
    data2.songImage = img2;
    [self.musicDataArray addObject:data2];
    
   
    
    
     
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
