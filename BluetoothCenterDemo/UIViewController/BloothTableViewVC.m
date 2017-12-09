//
//  BloothTableViewVC.m
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/7.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "BloothTableViewVC.h"
#import "BloothModel.h"
#import "BloothCell.h"
#import "BloothManager.h"



@interface BloothTableViewVC ()<UITableViewDelegate,UITableViewDataSource>
//模型数组
@property (nonatomic,strong) NSMutableArray * bloothModelArray;
@property (nonatomic,strong) UITableView * bloothTableView;
//正在连接的设备模型
@property (nonatomic,strong) BloothModel * connectingModel;
@property (nonatomic, strong) CBCentralManager *centralManager;

//开始扫描
@property (nonatomic,strong) UIButton * scanBtn;
//停止扫描
@property (nonatomic,strong) UIButton * stopScanBtn;

@end

@implementation BloothTableViewVC

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"蓝牙列表";
    [self.view addSubview:self.bloothTableView];
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.stopScanBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  代理
#pragma mark  ----  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BloothModel * model = self.bloothModelArray[indexPath.row];
    self.connectingModel = model;
    [self.centralManager connectPeripheral:model.peripheral options:nil];
}

#pragma mark  ----  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bloothModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"BloothCell";
    BloothCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[BloothCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BloothModel * model = self.bloothModelArray[indexPath.row];
    cell.label.text = [[NSString alloc] initWithFormat:@"name:%@;state:%@;\nidentifier:%@",model.name,model.state,model.identifier];
    
    return cell;
}

#pragma mark  ----  自定义函数
-(void)scanBtnClicked{
    
    [[BloothManager sharedManager] startScan];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.bloothModelArray removeAllObjects];
        [self.bloothModelArray addObjectsFromArray:[BloothManager sharedManager].bloothModelArray];
        [self.bloothTableView reloadData];
        [[BloothManager sharedManager] stopScan];
    });
}

-(void)stopScanBtnClicked{
    
    [[BloothManager sharedManager] stopScan];;
}

#pragma mark  ----  懒加载


-(UITableView *)bloothTableView{
    
    if (!_bloothTableView) {
        
        _bloothTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 40) style:UITableViewStylePlain];
        _bloothTableView.delegate = self;
        _bloothTableView.dataSource = self;
        _bloothTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _bloothTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _bloothTableView;
}

-(NSMutableArray *)bloothModelArray{
    
    if (!_bloothModelArray) {
        
        _bloothModelArray = [[NSMutableArray alloc] init];
    }
    return _bloothModelArray;
}

-(UIButton *)scanBtn{
    
    if (!_scanBtn) {
        
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(0, SCREENHEIGHT - 40, SCREENWIDTH / 2, 40);
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scanBtn setTitle:@"开始扫描" forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(scanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

-(UIButton *)stopScanBtn{
    
    if (!_stopScanBtn) {
        
        _stopScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopScanBtn.frame = CGRectMake(CGRectGetMaxX(self.scanBtn.frame), SCREENHEIGHT - 40, SCREENWIDTH / 2, 40);
        [_stopScanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stopScanBtn setTitle:@"停止扫描" forState:UIControlStateNormal];
        [_stopScanBtn addTarget:self action:@selector(stopScanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopScanBtn;
}

@end
