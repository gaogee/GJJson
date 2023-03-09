//
//  GJViewController.m
//  GJJson
//
//  Created by gaogee on 03/09/2023.
//  Copyright (c) 2023 gaogee. All rights reserved.
//

#import "GJViewController.h"
#import "GJJson.h"
#import "GJTestModel.h"
@interface GJViewController ()

@end

@implementation GJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GJTestModel *model = [[GJTestModel alloc] init];
    model.name = @"张杰";
    model.userId = 002;
    NSDictionary *params = [model gj_JSONObject];
    NSLog(@"%@",params);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
