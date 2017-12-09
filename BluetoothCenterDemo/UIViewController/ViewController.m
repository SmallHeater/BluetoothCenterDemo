//
//  ViewController.m
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/7.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "ViewController.h"
#import "BloothTableViewVC.h"
#import "ChatViewController.h"
#import "ChatViewController.h"

@interface ViewController ()

//去和外设设备聊天页面按钮
@property (nonatomic,strong) UIButton * firstBtn;
//去蓝牙设备列表页按钮
@property (nonatomic,strong) UIButton * secondBtn;


@end

@implementation ViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationBar.titleLabel.text = @"中心设备工程";
    
    
    [self.view addSubview:self.firstBtn];
    [self.view addSubview:self.secondBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
-(void)firstBtnClicked:(UIButton *)btn{
    
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)secondBtnClicked:(UIButton *)btn{
    
    BloothTableViewVC * bloothTableViewVC = [[BloothTableViewVC alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:bloothTableViewVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark  ----  懒加载
-(UIButton *)firstBtn{
    
    if (!_firstBtn) {
        
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _firstBtn.frame = CGRectMake(100, 100, 100, 40);
        [_firstBtn setTitle:@"去聊天" forState:UIControlStateNormal];
        [_firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_firstBtn addTarget:self action:@selector(firstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstBtn;
}

-(UIButton *)secondBtn{
    
    if (!_secondBtn) {
        
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.frame = CGRectMake(100, CGRectGetMaxY(self.firstBtn.frame) + 20, 140, 40);
        [_secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secondBtn setTitle:@"去蓝牙设备列表" forState:UIControlStateNormal];
        [_secondBtn addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondBtn;
}


@end
