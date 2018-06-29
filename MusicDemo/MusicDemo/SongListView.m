//
//  SongListView.m
//  MusicDemo
//
//  Created by olami on 2018/6/29.
//  Copyright © 2018年 VIA Technologies, Inc. & OLAMI Team. All rights reserved.
//

#import "SongListView.h"
#import "MusicData.h"

@interface SongListView()
//<UITableViewDelegate,UITableViewDataSource>
@property UITableView *tableView;
@end

@implementation SongListView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return  self;
}


- (void)setupUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y-30, self.frame.size.width, self.frame.size.height)];
//    [self addSubview:_tableView];
//    _tableView.delegate  = self;
//    _tableView.dataSource = self;
    
    
    
}

- (void)setMusicDataArray:(NSArray *)musicDataArray{
    _musicDataArray = [musicDataArray copy];
}

- (void)tapView{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut    animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:nil];
}

#pragma mark --UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _musicDataArray.count;
}

@end
