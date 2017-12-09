//
//  ChatViewController.m
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/8.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "ChatViewController.h"
#import "BloothManager.h"


@interface ChatViewController ()<UITextFieldDelegate,BloothManagerDelegate>
//状态label
@property (nonatomic,strong) UILabel * stateLabel;
//扫描外设按钮
@property (nonatomic,strong) UIButton * scanBtn;
//输入框
@property (nonatomic,strong) UITextField * textField;
//发送按钮
@property (nonatomic,strong) UIButton * sendBtn;
//收到的数据展示
@property (nonatomic,strong) UITextView * textView;
@end

@implementation ChatViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"蓝牙聊天";
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  代理
#pragma mark  ----  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark  ----  BloothManagerDelegate
//连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    self.stateLabel.text = @"状态：连接外设成功";
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    self.stateLabel.text = @"状态：连接外设失败";
}
//与外设断开连接（一般是外设的异常）
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
    self.stateLabel.text = @"状态：与外设断开连接";
}

//接收到数据回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    // 拿到外设发送过来的数据
    NSData *data = characteristic.value;
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * text = [[NSString alloc] initWithFormat:@"\n%@",str];
    
    NSString * showText = [self.textView.text stringByAppendingString:text];
    self.textView.text = showText;
}

//写入数据回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    if (error) {
        
    }
    else{
        
        //写入成功
        self.textField.text = @"";
    }
}

#pragma mark  ----  自定义函数
//扫描外设的响应事件
-(void)scanBtnClicked:(UIButton *)btn{
    
    [BloothManager sharedManager].delegate = self;
    [[BloothManager sharedManager] startScanWithServiceUUID:@"CDD1"];
}

//发送按钮的响应事件
-(void)sendBtnClicked:(UIButton *)btn{
    
    // 用NSData类型来写入
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    // 根据上面的特征self.characteristic来写入数据
   /[[BloothManager sharedManager].peripheral writeValue:data forCharacteristic:[BloothManager sharedManager].characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark  ----  懒加载
-(UILabel *)stateLabel{
    
    if (!_stateLabel) {
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, SCREENWIDTH - 40, 40)];
        _stateLabel.text = @"状态：";
    }
    return _stateLabel;
}

-(UIButton *)scanBtn{
    
    if (!_scanBtn) {
        
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(0, SCREENHEIGHT - 40, SCREENWIDTH, 40);
        [_scanBtn setTitle:@"扫描外设" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

-(UITextField *)textField{
    
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, SCREENWIDTH - 90, 40)];
         _textField.borderStyle = UITextBorderStyleLine;
        _textField.placeholder = @"输入";
        _textField.delegate = self;
    }
    return _textField;
}

-(UIButton *)sendBtn{
    
    if (!_sendBtn) {
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(CGRectGetMaxX(self.textField.frame) + 5, CGRectGetMinY(self.textField.frame), 40, 40);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(UITextView *)textView{
    
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField.frame) + 20, SCREENWIDTH - 40, 200)];
        _textView.text = @"接收到的数据：";
    }
    return _textView;
}

@end
