//
//  JAViewController.m
//  JABaseUIKit
//
//  Created by lanmemory@163.com on 04/08/2021.
//  Copyright (c) 2021 lanmemory@163.com. All rights reserved.
//

#import "JAViewController.h"
#import <JABaseUIKit/JABaseUIKit-Swift.h>
@interface JAViewController ()

@end

@implementation JAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    QSWebViewController *web = [[QSWebViewController alloc] init];
    web.url = @"http://192.168.0.159:9009";
    web.modalPresentationStyle  = UIModalPresentationFullScreen;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"qsmain" ofType:@"html"];
    web.url = filePath;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
    nav.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
