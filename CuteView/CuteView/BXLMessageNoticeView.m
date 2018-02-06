//
//  BXLMessageNoticeButton.m
//  iOSClient
//
//  Created by leven on 2018/1/11.
//  Copyright © 2018年 borderxlab. All rights reserved.
//

#import "BXLMessageNoticeView.h"
#import "BXLPanCuteView.h"
#import <YYKit.h>

#define VALID_STRING(string) ((string) && ([(string) isKindOfClass:[NSString class]]) && ([(string) length] > 0))

@interface BXLMessageNoticeView()
@end

@implementation BXLMessageNoticeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGPoint center = self.center;
    if (!CGPointEqualToPoint(CGPointZero, self.currentCenter)) {
        center = self.currentCenter;
    }
    if (VALID_STRING(self.countString)) {
        self.height = self.textLabel.font.lineHeight + 4;
        CGFloat width = [self.countString sizeForFont:self.textLabel.font size:CGSizeMake(100, self.textLabel.font.lineHeight + 4) mode:NSLineBreakByCharWrapping].width + 8;
        width = width < self.height ? self.height : width;
        
        self.textLabel.frame = CGRectMake(0, 0, width, width);
        self.width = width;
    }else{
        self.size = CGSizeMake(8, 8);
        self.textLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    self.textLabel.center = CGPointMake(self.width/2, self.height/2);
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
    self.center = center;
}

- (void)initUI {
    [self setBackgroundColor:[UIColor colorWithHexString:@"C1192C"]];
    _textLabel = [UILabel new];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont systemFontOfSize:11];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _countString = _textLabel.text;
    [self addSubview:_textLabel];
}

- (void)setCountString:(NSString *)countString {
    _countString = [countString copy];
    _textLabel.text = _countString;
}

@end
