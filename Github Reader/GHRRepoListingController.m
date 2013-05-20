//
//  GHRRepoListingController.m
//  Github Reader
//
//  Created by Christopher Apolzon on 5/19/13.
//  Copyright (c) 2013 Apples on the Tree. All rights reserved.
//

#import "GHRRepoListingController.h"
#import "GHR_RootViewController.h"
#import <UAGithubEngine/UAGithubEngine.h>

@interface GHRRepoListingController ()

@end

@implementation GHRRepoListingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    UIView* repo_view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    repo_view.backgroundColor = [UIColor yellowColor];
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor redColor];
    label.text = @"Your Repositories";
    [label sizeToFit];
    [repo_view addSubview:label];
    self.view = repo_view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView* scroll_view = [[UIScrollView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];

    UAGithubEngine* engine = ((GHR_RootViewController*)self.presentingViewController).gh_engine;
    [engine repositoriesWithSuccess:^(id response) {
        
        NSMutableArray* repo_names = [NSMutableArray arrayWithCapacity:[response count]];
        NSInteger last_y = 0;
        for(NSDictionary* repo in response) {
            [repo_names addObject:[repo objectForKey:@"full_name"]];
            UILabel* repo_name = [[UILabel alloc] init];
            repo_name.text = [repo objectForKey:@"full_name"];
            [repo_name sizeToFit];
            CGRect label_frame = repo_name.frame;
            label_frame.origin.x = 10;
            label_frame.origin.y = label_frame.size.height * [response indexOfObject:repo];
            last_y = label_frame.origin.y;
            repo_name.frame = label_frame;
            [scroll_view addSubview: repo_name];
        }
        
        CGSize scroll_size = scroll_view.bounds.size;
        scroll_size.height = last_y + 50;
        scroll_view.contentSize = scroll_size;
        [self.view addSubview:scroll_view];
        
    } failure:^(NSError* err) {
        NSLog(@"GITHUB FAIL -- %@", err);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARRRRRN");
    // Dispose of any resources that can be recreated.
}

@end
