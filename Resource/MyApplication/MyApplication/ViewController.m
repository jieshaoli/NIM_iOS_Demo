//
//  ViewController.m
//  MyApplication
//
//  Created by chris on 16/5/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "ViewController.h"
#import "NTESLoginViewController.h"
#import "NTESDemoConfig.h"
#import "NTESCustomAttachmentDecoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NIMSDK sharedSDK] enableConsoleLog];
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] cerName];
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];

}

- (IBAction)enterIm:(id)sender
{
    NTESLoginViewController *vc = [[NTESLoginViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
