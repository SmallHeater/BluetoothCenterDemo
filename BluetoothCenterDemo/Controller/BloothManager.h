//
//  BloothManager.h
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/7.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  蓝牙管理器

#import <Foundation/Foundation.h>
#import "BloothModel.h"


@protocol BloothManagerDelegate
//连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
//与外设断开连接（一般是外设的异常）
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
//接收到数据回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
//写入数据回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error;
@end

@interface BloothManager : NSObject

+(BloothManager *)sharedManager;
//蓝牙设备模型数组
@property (nonatomic,strong) NSMutableArray * bloothModelArray;
//外设
@property (nonatomic, strong) CBPeripheral *peripheral;
//特征
@property (nonatomic, strong) CBCharacteristic *characteristic;
//代理
@property (nonatomic,weak) id<BloothManagerDelegate>delegate;

//开始扫描
-(void)startScan;
//开始扫描
-(void)startScanWithServiceUUID:(NSString *)serviceUUID;
//停止扫描
-(void)stopScan;
@end


