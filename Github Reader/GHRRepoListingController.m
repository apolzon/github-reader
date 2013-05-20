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

@interface GHRRepoListingController () <UITableViewDataSource>
    @property (nonatomic, readwrite) NSMutableArray* repos;
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

    UITableView* tv = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    tv.dataSource = self;
    [repo_view addSubview:tv];
    
    self.view = repo_view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UAGithubEngine* engine = ((GHR_RootViewController*)self.presentingViewController).gh_engine;
    [engine repositoriesWithSuccess:^(id response) {
        NSMutableArray* repo_names = [NSMutableArray arrayWithCapacity:[response count]];
        for(NSDictionary* repo in response) {
            [repo_names addObject:[repo objectForKey:@"full_name"]];
        }
        self.repos = repo_names;
    } failure:^(NSError* err) {
        NSLog(@"GITHUB FAIL -- %@", err);
    }];
}

// UITableViewDatasource Messages:
- (UITableViewCell*)tableView: (UITableView*) table_view cellForRowAtIndexPath:(NSIndexPath *)index_path {
    static NSString* CellId = @"RepoCell";
    UITableViewCell* cell = [table_view dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        // create a new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    UILabel* label = [[UILabel alloc] init];
    NSString* repo_name = [self.repos objectAtIndex: index_path.item];
    if (repo_name != nil) {
        label.text = repo_name;
    } else {
        label.text = @"THIS IS AN EMPTY CELL";
    }
    [label sizeToFit];
    [cell.contentView addSubview:label];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.repos count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARRRRRN");
    // Dispose of any resources that can be recreated.
}

@end
