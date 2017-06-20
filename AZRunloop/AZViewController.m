//
//  AZViewController.m
//  AZRunloop
//
//  Created by 徐振 on 2017/6/20.
//  Copyright © 2017年 徐振. All rights reserved.
//

#import "AZViewController.h"
#import "ViewController.h"
@interface AZViewController ()

@end

@implementation AZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onButtonClick:(id)sender {
    [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
