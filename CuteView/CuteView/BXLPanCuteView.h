//
//  BXLPanCuteView.h
//  iOSClient
//
//  Created by leven on 2018/1/25.
//  Copyright © 2018年 borderxlab. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BXLPanCuteViewDelegate <NSObject>

- (void)BXLPanCuteViewDidGestureToDismiss;

@end

@interface BXLPanCuteView : UIView

@property (nonatomic) CGFloat viscosity; // 默认 0.11，最大值0.3，越小越粘
@property (nonatomic, readonly) CGPoint currentCenter;

@property (nonatomic) BOOL gestureToDismiss; // default YES;

@property (nonatomic, weak) id<BXLPanCuteViewDelegate> delegate;

@end
