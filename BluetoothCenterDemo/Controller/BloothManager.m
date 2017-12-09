//
//  BloothManager.m
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/7.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "BloothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define CHARACTERISTIC_UUID @"CDD2"

@interface BloothManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>
//中心设备
@property (nonatomic, strong) CBCentralManager *centralManager;
//正在连接的设备模型
@property (nonatomic,strong) BloothModel * connectingModel;
@property (nonatomic,strong) NSString * serviceUUID;


@end

@implementation BloothManager
#pragma mark  ----  生命周期函数
+(BloothManager *)sharedManager{
    
    static BloothManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[BloothManager alloc] init];
    });
    
    return manager;
}
#pragma mark  ----  代理
#pragma mark  ----  CBCentralManagerDelegate
//设备蓝牙状态的回调
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    /** 判断手机蓝牙状态
     CBManagerStateUnknown = 0,  未知
     CBManagerStateResetting,    重置中
     CBManagerStateUnsupported,  不支持
     CBManagerStateUnauthorized, 未验证
     CBManagerStatePoweredOff,   未启动
     CBManagerStatePoweredOn,    可用
     */
    // 蓝牙可用，开始扫描外设
    if (central.state == CBManagerStatePoweredOn) {
        
        NSLog(@"蓝牙可用");
        // 根据SERVICE_UUID来扫描外设，如果不设置SERVICE_UUID，则扫描所有蓝牙设备
        if (self.serviceUUID && self.serviceUUID.length > 0) {
            
             [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceUUID]] options:nil];
        }
        else{
         
            [central scanForPeripheralsWithServices:nil options:nil];
        }
    }
    if(central.state==CBManagerStateUnsupported) {
        
        NSLog(@"该设备不支持蓝牙");
    }
    if (central.state==CBManagerStatePoweredOff) {
        
        NSLog(@"蓝牙已关闭");
        //系统会自动弹出提示框
    }
}

//发现外设，回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"外设：%@,外设名：%@",peripheral,peripheral.name);
    
    if (self.serviceUUID && self.serviceUUID.length > 0) {
        
        // 对外设对象进行强引用
        self.peripheral = peripheral;
        // 连接外设
        [central connectPeripheral:peripheral options:nil];
    }
    else{
     
        BloothModel * model = [[BloothModel alloc] init];
        model.peripheral = peripheral;
        if (peripheral.name && peripheral.name.length > 0) {
            
            model.name = peripheral.name;
        }
        else{
            
            model.name = @"未知设备";
        }
        
        model.identifier = peripheral.identifier.UUIDString;
        
        switch (peripheral.state) {
            case CBPeripheralStateDisconnected:
            {
                model.state = @"未连接";
                break;
            }
            case CBPeripheralStateConnecting:
            {
                model.state = @"连接中";
                break;
            }
            case CBPeripheralStateConnected:
            {
                model.state = @"已连接";
                break;
            }
            case CBPeripheralStateDisconnecting:
            {
                model.state = @"正在断开连接";
                break;
            }
                
            default:
                break;
        }
        [self.bloothModelArray addObject:model];
    }
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    // 可以停止扫描
    [self.centralManager stopScan];
    // 设置代理
    peripheral.delegate = self;
    NSLog(@"连接成功");
    self.connectingModel.state = @"连接成功";
    
    if (self.serviceUUID && self.serviceUUID.length > 0) {
        
        // 根据UUID来寻找服务
        [peripheral discoverServices:@[[CBUUID UUIDWithString:self.serviceUUID]]];
    }
    else{
        
        
    }
    
    if (self.delegate) {
        
        [self.delegate centralManager:central didConnectPeripheral:peripheral];
    }
}

//连接失败的回调
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"连接失败");
    self.connectingModel.state = @"连接失败";
    if (self.delegate) {
        
        [self.delegate centralManager:central didFailToConnectPeripheral:peripheral error:error];
    }
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    NSLog(@"断开连接:%@",error);
    // 断开连接可以设置重新连接
    [central connectPeripheral:peripheral options:nil];
    self.connectingModel.state = @"断开连接";
    if (self.delegate) {
        
        [self.delegate centralManager:central didDisconnectPeripheral:peripheral error:error];
    }
}

#pragma mark  ----  CBPeripheralDelegate
//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    // 遍历出外设中所有的服务
    for (CBService *service in peripheral.services) {
        NSLog(@"所有的服务：%@",service);
    }
    
    if (self.serviceUUID && self.serviceUUID.length > 0) {
        
        // 这里仅有一个服务，所以直接获取
        CBService *service = peripheral.services.lastObject;
        // 根据UUID寻找服务中的特征
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];
    }
    else{
        
        
    }
}

//发现特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    // 遍历出所需要的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"所有特征：%@", characteristic);
        // 从外设开发人员那里拿到不同特征的UUID，不同特征做不同事情，比如有读取数据的特征，也有写入数据的特征
    }
    
    if (self.serviceUUID && self.serviceUUID.length > 0) {
        
        // 这里只获取一个特征，写入数据的时候需要用到这个特征
        self.characteristic = service.characteristics.lastObject;
        // 直接读取这个特征数据，会调用didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:self.characteristic];
        // 订阅通知
        [peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }
    else{
        
        
    }
}

//订阅状态的改变
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功");
    } else {
        NSLog(@"取消订阅");
    }
}

//接收到数据回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (self.delegate) {
        
        [self.delegate peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
}

//写入数据回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        
        NSLog(@"写入失败");
    }
    else{
     
        NSLog(@"写入成功");
    }
    if (self.delegate) {
        
        [self.delegate peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    }
}

#pragma mark  ----  自定义函数
//开始扫描
-(void)startScan{
    
    [self.bloothModelArray removeAllObjects];
    // 创建中心设备管理器，会回调centralManagerDidUpdateState
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

//开始扫描
-(void)startScanWithServiceUUID:(NSString *)serviceUUID{
    
    self.serviceUUID = serviceUUID;
    // 创建中心设备管理器，会回调centralManagerDidUpdateState
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

//停止扫描
-(void)stopScan{
    
    [self.centralManager stopScan];
}


#pragma mark  ----  懒加载
-(NSMutableArray *)bloothModelArray{
    
    if (!_bloothModelArray) {
        
        _bloothModelArray = [[NSMutableArray alloc] init];
    }
    return _bloothModelArray;
}

@end
