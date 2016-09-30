//
//  ViewController.m
//  Demo
//
//  Created by 符现超 on 16/9/30.
//  Copyright © 2016年 Zero.D.Saber. All rights reserved.
//

#import "ViewController.h"
#import "ZDNetworkHelper.h"

NSString *const url1 = @"https://daka.facenano.com/checkin/v1/app_binding?phone_number=18700000001&app_version_code=2&device=mobile_ios&company_tag=iPhone-demo&phone_imei=6D56F277-0AAA-4F32-AD01-6C55AEE75964&verification_code=3216";
NSString *const url2 = @"http://api.douban.com/v2/movie/top250";
NSString *const url3 = @"http://10.255.223.149:80/media/api.go?action=getDepositShowView&fromPaltform=ds_ios&paymentId=1014&token=9047a07dc6153188b690c8c740cb84f1";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myTextView.text = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)fetchDataAction:(id)sender {
    [self fetchData];
    //[self syncGCD];
}

#pragma mark -

- (void)fetchData {
    __weak __typeof(&*self) weakSelf = self;
    [[ZDNetworkHelper shareInstance] requestWithURL:url2 params:nil httpMethod:HttpMethod_POST cachedResponse:^(id  _Nullable cachedResponse) {
        __strong __typeof(&*weakSelf) strongSelf = weakSelf;
        NSLog(@"\n\n%@\n\n%@", cachedResponse, [strongSelf stringWithJson:cachedResponse]);
    } progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"完成进度: %lld", progress.completedUnitCount/progress.totalUnitCount);
    } success:^(id  _Nullable responseObject) {
        __strong __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.myTextView.text = [strongSelf stringWithJson:responseObject];
        NSLog(@"\n\n%@\n\n%@", responseObject, [strongSelf stringWithJson:responseObject]);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"\nerror:%@", error.localizedDescription);
    }];
}

- (NSString *)stringWithJson:(id)temps { //把字典和数组转换成json字符串
    if (!temps) return nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temps
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    return strs;
}

//MARK:利用GCD notify同步线程
- (void)syncGCD {
    dispatch_queue_t queue1 = dispatch_queue_create("Myqueue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"睡眠2秒");
        sleep(2);
    });
    dispatch_group_async(group, queue1, ^{
        NSLog(@"睡眠5秒");
        sleep(5);
    });
    
    dispatch_group_notify(group, queue1, ^{
        NSLog(@"执行完毕");
    });
}


@end
