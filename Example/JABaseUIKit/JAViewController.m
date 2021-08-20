//
//  JAViewController.m
//  JABaseUIKit
//
//  Created by lanmemory@163.com on 04/08/2021.
//  Copyright (c) 2021 lanmemory@163.com. All rights reserved.
//

#import "JAViewController.h"
/*!
 1.在Build Setting设置Defines Module 为Yes
 2.设置Product Module Name 为当前工程名 (系统会自动为我们设置好)，此时系统会为工程创建一个“工程名-Swift.h”的文件(不会显示出来,可以引用)，
 此文件不可手动创建，必须使用系统创建的
 */
#import "JABaseUIKit_Example-Swift.h"
#import <JABaseUIKit/JABaseUIKit-Swift.h>
#define width UIScreen.mainScreen.bounds.size.width

@interface JAViewController ()

@end

@implementation JAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *arr = @[@"基础VC",@"WKwebVC",@"TableViewVC",@"CollectionView",@"Swift问题解读"];
    for (int i = 0; i < arr.count; i++) {
        
        NSString *title = arr[i];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.backgroundColor = UIColor.redColor;
        [button setTitle:title forState:(UIControlStateNormal)];
        
        button.frame = CGRectMake((width - 300)/2, 100 + i * (40), 300, 35);
        [self.view addSubview:button];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    UIImageView *a = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 80, 80)];
    [self.view addSubview:a];
    a.image = [UIImage imageNamed:@"aaa"];
}

- (void)btnClick:(UIButton *)sender {
    
    NSInteger tag = sender.tag - 100;
    
    switch (tag) {
        case 0:{
            QSViewController *vc = [[QSViewController alloc] init];
            vc.modalPresentationStyle  = UIModalPresentationFullScreen;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle  = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:{
            NSString *url =@"http://192.168.0.159:9009";
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"qsmain" ofType:@"html"];
            url = filePath;
            QSWebViewController *vc = [[QSWebViewController alloc] initWithUrl:url];
            vc.modalPresentationStyle  = UIModalPresentationFullScreen;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle  = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:{
            QSTableViewController *vc = [[QSTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            for (int i = 0; i < 10; i++) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (int a = 0; a < 30; a++) {
                    NSString *value = [NSString stringWithFormat:@"%d-%d",i+1,a+1];
                    [array addObject:value];
                }
                [vc.dataSource addObject:array];
                //指针首地址
                NSString* fooString = [NSString stringWithFormat: @"%p", array];
                
                NSString *title = [NSString stringWithFormat: @"头部标题%d",i+1];
                NSString *image = [NSString stringWithFormat: @"头部图片%d",i+1];
                [vc.headDict setObject:@{@"title":title,@"image":image} forKey:fooString];
                
                title = [NSString stringWithFormat: @"底部标题%d",i+1];
                image = [NSString stringWithFormat: @"底部图片%d",i+1];
                [vc.footerDict setObject:@{@"title":title,@"image":image} forKey:fooString];
                NSLog(@"===指针首地址：%@",fooString);
            }

            vc.modalPresentationStyle  = UIModalPresentationFullScreen;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle  = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 3:{
            QSCollectionViewController *vc = [[QSCollectionViewController alloc] initWithCount:7 height:90];
            
            for (int i = 0; i < 10; i++) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (int a = 0; a < 30; a++) {
                    NSString *value = [NSString stringWithFormat:@"%d-%d",i+1,a+1];
                    [array addObject:value];
                }
                
                [vc.dataSource addObject:array];
                
                //指针首地址
                NSString* fooString = [NSString stringWithFormat: @"%p", array];
                
                NSString *title = [NSString stringWithFormat: @"头部标题%d",i+1];
                NSString *image = [NSString stringWithFormat: @"头部图片%d",i+1];
                [vc.headDict setObject:@{@"title":title,@"image":image} forKey:fooString];
                
                title = [NSString stringWithFormat: @"底部标题%d",i+1];
                image = [NSString stringWithFormat: @"底部图片%d",i+1];
                [vc.footerDict setObject:@{@"title":title,@"image":image} forKey:fooString];
                
                NSLog(@"===指针首地址：%@",fooString);
            }

            vc.modalPresentationStyle  = UIModalPresentationFullScreen;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle  = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 4:{
            JATestCollectionViewController *vc = [[JATestCollectionViewController alloc] initWithCount:4 height:100];
            vc.modalPresentationStyle  = UIModalPresentationFullScreen;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle  = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }

}


- (void)openVC0{
        NSString *method_name = [NSString stringWithFormat:@"openVC%d",2];
    
        SEL selector = NSSelectorFromString(method_name);
        if(!selector) return;
        if ([self respondsToSelector:selector]){ //判断是否存在这个方法
            [self performSelector:selector];
        }
}
@end
