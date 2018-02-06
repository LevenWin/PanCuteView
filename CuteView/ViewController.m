//
//  ViewController.m
//  CuteView
//
//  Created by leven on 2018/2/6.
//  Copyright © 2018年 leven. All rights reserved.
//

#import "ViewController.h"
#import "BXLMessageNoticeView.h"

@interface ViewController ()<BXLPanCuteViewDelegate>{
    BXLMessageNoticeView * _cuteView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cuteView = [BXLMessageNoticeView new];
    _cuteView.countString = @"13";
    _cuteView.delegate = self;
    [self.view addSubview:_cuteView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _cuteView.center = self.view.center;
}
- (void)BXLPanCuteViewDidGestureToDismiss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cuteView.hidden = NO;
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
