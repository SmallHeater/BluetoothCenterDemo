//
//  BloothModel.h
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/7.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  蓝牙模型

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BloothModel : NSObject
//外设名
@property (nonatomic,strong) NSString * name;
//标志
@property (nonatomic,strong) NSString * identifier;
//状态
@property (nonatomic,strong) NSString * state;

@property (nonatomic,strong) CBPeripheral * peripheral;
@end
