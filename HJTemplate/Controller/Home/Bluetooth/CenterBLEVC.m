//
//  CenterBLEVC.m
//  HJTemplate
//
//  Created by zl on 2020/12/17.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "CenterBLEVC.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define mBLEName @"BT05"

@interface CenterBLEVC () <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *mCentral;
@property (strong, nonatomic) CBPeripheral *mPeripheral;
@property (strong, nonatomic) CBCharacteristic *mCharacteristic;
@property (strong, nonatomic) CBService *mService;
@property (strong, nonatomic) CBDescriptor *mDescriptor;
@property (strong, nonatomic) NSMutableString *macString;

@end

@implementation CenterBLEVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self mCentral];
    [self setUpCustomUI];
}
- (void)setUpCustomUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(50, 150, 200, 50)];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn setTitle:@"hjkl" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 停止扫描
    if([self.mCentral isScanning]){
        [self.mCentral stopScan];
    }
    // 断开连接
    if(self.mCentral != nil && self.mPeripheral.state == CBPeripheralStateConnected){
        [self.mCentral cancelPeripheralConnection:self.mPeripheral];
    }
}
// 17、发送数据
- (void)sendAction:(UIButton *)sender {
    Byte dataArr[2];
    dataArr[0] = 0x0044;
    dataArr[1] = 0x0033;
    NSData *myData = [NSData dataWithBytes:dataArr length:2];
    if(nil != self.mCharacteristic) {
        [self.mPeripheral writeValue:myData forCharacteristic:self.mCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}
- (void)sendDataToBLE:(NSString *)data {
    NSData *myData = [data dataUsingEncoding:NSUTF8StringEncoding];
    if(nil != self.mCharacteristic) {
        [self.mPeripheral writeValue:myData forCharacteristic:self.mCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}
// 1、中心管理者初始化
- (CBCentralManager *)mCentral {
    if(!_mCentral) {
        _mCentral = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    }
    return _mCentral;
}
#pragma mark - CBCentralManagerDelegate
// 2、只要中心管理者初始化，就会触发此代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"Central Manager State Unknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"Central Manager State Resetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"Central Manager State Unsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"Central Manager State Unauthorized");
            break;
        case CBManagerStatePoweredOn:{
            NSLog(@"Central Manager State Powered On");
            // 3、搜索外设
            [self.mCentral scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"Central Manager State Powered Off");
            break;
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSLog(@"Will Restore State %@", dict);
}
// 4、发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"搜索到name==%@2, identifier==%@",peripheral.name, peripheral.identifier);
    // RSSI 表示信号强度
    // 5、发现完之后就是进行连接
    if([peripheral.name isEqualToString:mBLEName]){
        self.mPeripheral = peripheral;
        self.mPeripheral.delegate = self;
        [self.mCentral connectPeripheral:peripheral options:nil];
    }
}
// 6、中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@==设备连接成功",peripheral.name);
    
    // 7、外设发现服务，传nil代表不过滤
    [self.mPeripheral discoverServices:nil];
}
// 外设连接断开
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"设备连接丢失==%@", peripheral.name);
}
// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"设备连接失败==%@", peripheral.name);
}
#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
}
// 8、发现外设的服务后调用的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if(error){
        NSLog(@"设备服务获取失败==%@", peripheral.name);
        return;
    }
    for(CBService *service in peripheral.services) {
        self.mService = service;
        NSLog(@"设备服务==%@, UUID==%@, count==%lu", service, service.UUID, peripheral.services.count);
        // 9、外设发现特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
// 10、从服务中发现外设特征的时候调用的代理方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for(CBCharacteristic *cha in service.characteristics) {
        // 该特征具有读写权限
        if(cha.properties & CBCharacteristicPropertyWrite && cha.properties & CBCharacteristicPropertyRead) {
            self.mCharacteristic = cha;
        }
        NSLog(@"设备的服务==%@， 服务对应的特征值==%@， UUID==%@, count==%lu", service, cha, cha.UUID, service.characteristics.count);
        // 11、获取特征对应的描述 回调didUpdateValueForDescriptor
        [peripheral discoverDescriptorsForCharacteristic:cha];
        // 12、获取特征值 回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:cha];
    }
    if(nil != self.mCharacteristic) {
        // 打开外设的通知，否则无法接受数据
        [peripheral setNotifyValue:YES forCharacteristic:self.mCharacteristic];
    }
}
// 13、更新描述值的时候会调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    NSLog(@"描述==%@",descriptor.description);
}
// 14、更新特征值的时候调用，可以理解为获取蓝牙发回的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    // 正常的数据返回值ASCII码格式
    NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    NSLog(@"设备的特征值==%@,获取的数据==%@", characteristic, value);
    // 专门处理Mac地址的值
    NSString *macValue = [NSString stringWithFormat:@"%@", characteristic.value];
    // Mac地址数据
    if([characteristic.UUID.UUIDString isEqualToString:@"2A23"]){
        _macString = [[NSMutableString alloc] init];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
    }
//    for (CBDescriptor *descriptor in characteristic.descriptors) {
//        self.mDescriptor = descriptor;
//        [peripheral readValueForDescriptor:descriptor];
//    }
}
// 15、通知状态改变时调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error){
        NSLog(@"改变通知状态");
    }
}
// 16、发现外设的特征的描述数组
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    for(CBDescriptor *descriptor in characteristic.descriptors) {
        self.mDescriptor = descriptor;
        NSLog(@"发现外设的特征descriptor==%@",descriptor);
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error){
        NSLog(@"发送数据失败");
    }
    NSLog(@"发送数据成功");
}
#pragma mark - CBPeripheralDelegate



@end
