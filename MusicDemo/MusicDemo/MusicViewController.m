//
//  MusicViewController.m
//  MusicDemo
//
//  Created by olami on 2018/6/22.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicViewModel.h"
#import "MusicViewLocalModel.h"
#import "MusicPlayerController.h"
#import "MusicNetPlayerController.h"

@interface MusicViewController ()<MusicNetPlayerControllerDelegate>
@property (nonatomic, strong) MusicViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *songSingerAlbum;
@property (weak, nonatomic) IBOutlet UIImageView *songPic;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *eclipseTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderButton;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) MusicNetPlayerController *musicPlayer;





@end

@implementation MusicViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel = [[MusicViewLocalModel alloc] init];
    self.musicPlayer = [MusicNetPlayerController getInstance];
    self.musicPlayer.delegate = self;
    __weak MusicViewController *weakSelf = self;
    [_viewModel processMusic:^(BOOL result) {
        if (result) {
            self.musicPlayer.musicDataArray = weakSelf.viewModel.musicDataArray;
            if (self.musicPlayer.songStatus == StopStatus) {
                [self.musicPlayer playIndex:0];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf setupUI];
            });
           
            
        }
    }];
    
    [self.sliderButton addTarget:self action:@selector(touchUp)
          forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];//当滑块上的按钮的位置发生改变，或者被按下时，我们需要让歌曲先暂停。
    [self.sliderButton addTarget:self action:@selector(touchDown)
          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];//当滑块被松开，按到外面了，或者取消时，我们需要让歌曲的播放从当前的时间开始播放。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI{
    if (self.musicPlayer.songStatus == StopStatus ||
        self.musicPlayer.songStatus == PlayStatus ) {
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else {
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    
    [self updateUI];
    
}


- (void)updateUI{
    NSUInteger index = self.musicPlayer.index;
    
    MusicData *data = _viewModel.musicDataArray[index];
    _songName.text = data.songName;
    
    NSString *title = [NSString stringWithFormat:@"%@ - %@",data.songSinger,data.songAlbum];
    _songSingerAlbum.text = title;
    
    if (data.songImage) {
        [_songPic setImage:data.songImage];
    }else{
        [_songPic setImage:[UIImage imageNamed:@"songpic"]];
    }
 
    _totalTimeLabel.text = [self duration];
    
//    _sliderButton.maximumValue = self.musicPlayer.duration;
//    _sliderButton.minimumValue = 0;
    
    
    //启动计时器
    //[self.timer setFireDate:[NSDate distantPast]];
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self
                                                selector:@selector(timerAction) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];//在创建计时器的时候把计时器先暂停。
    }return _timer;
}



- (IBAction)circleButton:(id)sender {
}

- (IBAction)prevSong:(id)sender {
    [self.musicPlayer prevSong];
    [self updateUI];
    
    
}

- (IBAction)playSong:(id)sender {
    if (self.musicPlayer.songStatus == PlayStatus) {
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }else if (self.musicPlayer.songStatus == PauseStatus){
         [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    
    [self.musicPlayer pause];
}


- (IBAction)nextSong:(id)sender {
    [self.musicPlayer nextSong];
    [self updateUI];
}
- (IBAction)heartSong:(id)sender {
    
}

- (NSString*)duration{
//    NSTimeInterval totalTime = self.musicPlayer.duration;
//    NSInteger min = totalTime/60;
//    NSInteger sec = (NSInteger)totalTime%60;
//
//    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
    return nil;
    
}

- (NSString *)currentTime{
//    NSTimeInterval curTime = self.musicPlayer.currentTime;
//    NSInteger min = curTime/60;
//    NSInteger sec = (NSInteger)curTime%60;
//    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
    return nil;
}


- (void)timerAction{
//    self.eclipseTime.text = [self currentTime];
//    self.sliderButton.value = self.musicPlayer.currentTime;
    
}

- (void)touchUp{
    //[self.timer setFireDate:[NSDate distantFuture]];//暂停定时器
    //[self.timer invalidate];
    NSTimeInterval curTime = _sliderButton.value;
    NSInteger min = curTime/60;
    NSInteger sec = (NSInteger)curTime%60;
    _eclipseTime.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

- (void)touchDown{
    if (self.musicPlayer.songStatus == PlayStatus) {
        //self.musicPlayer.currentTime = _sliderButton.value;
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration{
    NSTimeInterval totalTime = duration;
    NSInteger min = totalTime/60;
    NSInteger sec = (NSInteger)totalTime%60;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
    
    self.sliderButton.maximumValue= duration;
    self.sliderButton.minimumValue = 0;
    self.sliderButton.value = time;
    
    NSTimeInterval curTime = time;
    NSInteger min1 = curTime/60;
    NSInteger sec1 = (NSInteger)curTime%60;
    self.eclipseTime.text =  [NSString stringWithFormat:@"%02ld:%02ld",min1,sec1];
   
    
}


 


@end
