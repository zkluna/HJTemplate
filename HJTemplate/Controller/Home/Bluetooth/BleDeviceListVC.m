//
//  BleDeviceListVC.m
//  HJTemplate
//
//  Created by zl on 2020/12/16.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "BleDeviceListVC.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIViewController+Extend.h"
#import "BlueToothInfoCell.h"


@interface BleDeviceListVC ()<CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *peripheral;

@end

@implementation BleDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BluetoothDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupTableView];
}
- (void)setupData {
    _dataSource = [NSMutableArray array];
    dispatch_queue_t centralQueue = dispatch_queue_create("centralQueue", DISPATCH_QUEUE_SERIAL);
    /**
     * key1:  初始化时，蓝牙没有打开将Alert提示
     * key2: 唯一标识，蓝牙进程被杀掉后恢复连接用
     */
    NSDictionary *dict = @{
        CBCentralManagerOptionShowPowerAlertKey : @(YES),
        CBCentralManagerOptionRestoreIdentifierKey: @"unique identifier"
    };
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue options:dict];
    NSDictionary *option = @{
        CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO],
        CBCentralManagerOptionShowPowerAlertKey: @YES
    };
    [self.centralManager scanForPeripheralsWithServices:nil options:option];
}
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.estimatedRowHeight = 120;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerNib:[BlueToothInfoCell nib] forCellReuseIdentifier:@"BlueToothInfoCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlueToothInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlueToothInfoCell"];
    CBPeripheral *peri = _dataSource[indexPath.row];
    cell.idStr.text = peri.identifier.UUIDString;
    cell.name.text = peri.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - CBCentralManagerDelegate
// 蓝牙状态改变的回调
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"蓝牙状态未知");
            break;
        case CBManagerStateResetting:
            NSLog(@"蓝牙重置中");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"不支持蓝牙");
            [self showAlertWithMessage:@"该设备不支持蓝牙" action:nil];
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"蓝牙未授权使用");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙未开启");
            [self showAlertWithMessage:@"蓝牙未开启" action:^{
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"prefs:root=General&path=Bluetooth"] options:nil completionHandler:nil];
            }];
            break;
        case CBManagerStatePoweredOn: {
            NSLog(@"蓝牙已开启");
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }
}
// 蓝牙将重新保存相关信息
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    //
}
// 发现外设后调用
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
//    NSLog(@"central = %@, peripheral = %@, advertisementData = %@, RSSI = %@",central,peripheral,advertisementData,RSSI);
    BOOL isHave = false;
    for (CBPeripheral *temp in self.dataSource) {
        if ([temp.identifier.UUIDString isEqual:peripheral.identifier.UUIDString]) {
            isHave = true;
            break;
        }
    }
    if (!isHave) {
        [_dataSource addObject:peripheral];
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    }
//    self.peripheral = peripheral;
//    [self.cManager connectPeripheral:peripheral options:nil];
}
// 连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@ 连接成功",peripheral.name);
    // 连接成功后，进行服务和特征的发现
    // 设置外设的代理
//    self.peripheral.delegate = self;
//    [self.peripheral discoverServices:nil];
    //peripheral.delegate = self;
    //[peripheral discoverServices:nil];
}
// 连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"%@ 连接失败，失败原因: %@",peripheral.name, error.localizedDescription);
}
// 外设连接断开丢失
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"%@ 连接丢失，原因：%@",peripheral.name, error.localizedDescription);
}
#pragma mark  -- CBPeripheralDelegate --
// 外设更新名称
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    NSLog(@"name: %@",peripheral.name);
}
// 外设服务改变
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    NSLog(@"invalidated service count: %ld",invalidatedServices.count);
}
// 读取RSSI时候调用
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    if(error){
        NSLog(@"read RSSI fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"read RSSI success, RSSI = %@",RSSI);
    }
}
// discover services的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if(error){
        NSLog(@"discover services fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"discover services success, service count = %ld",peripheral.services.count);
    }
}
// discover include services的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    if(error){
        NSLog(@"discover include services fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"discover include services success, include service count = %ld",service.includedServices.count);
    }
}
// 发现外设服务里的特征的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if(error){
        NSLog(@"discover characteristics fail, reason:%@",error.localizedDescription);
    } else {
        NSLog(@"discover charactersitics success");
        for (CBCharacteristic *cha in service.characteristics) {
            NSLog(@"char = %@",cha);
        }
    }
}
// 更新外设特征的value的时候会调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if(error){
        NSLog(@"update value for characteristic fail, reason:%@",error.localizedDescription);
    } else {
        NSLog(@"update value for characteristic success");
        NSLog(@"characteristic = %@",characteristic.value);
    }
}
// 更新外设notification state的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if(error){
        NSLog(@"update notification characteristic fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"update notification characteristic success");
    }
}
// 发现descirptor characteristic的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if(error){
        NSLog(@"discover descriptors fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"discover descriptors success");
    }
}
// 更新Descriptor的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    if(error){
        NSLog(@"update descriptor fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"update desciptor success.");
    }
}
// 写入desciptor的时候调用
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    if(error){
        NSLog(@"write descriptor fail, reason: %@",error.localizedDescription);
    } else {
        NSLog(@"write descriptor success");
    }
}
// iOS11
- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral {
    
}
- (void)peripheral:(CBPeripheral *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error {
    
}

@end
