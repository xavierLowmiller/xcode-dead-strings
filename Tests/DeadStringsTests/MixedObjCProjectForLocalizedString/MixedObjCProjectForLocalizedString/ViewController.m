//
//  ViewController.m
//  MixedObjCProjectForLocalizedString
//
//  Created by Xaver Lohmüller on 20.03.21.
//

#import "ViewController.h"
#import <MixedObjCProjectForLocalizedString-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"my_view_controller", @"");

    [self.button setTitle:NSLocalizedString(@"push_first_vc", @"") forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(didTapButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapButton {
    UIViewController *vc = [[SwiftViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
