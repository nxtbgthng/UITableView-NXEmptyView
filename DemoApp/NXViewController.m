//
//  NXViewController.m
//  DemoApp
//
//  Created by Ullrich Schäfer on 21.06.12.
//  Copyright (c) 2012 nxtbgthng.com. All rights reserved.
//

#import <UITableView+NXEmptyView/UITableView+NXEmptyView.h>
#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"

#import "NXViewController.h"


@interface NXViewController ()

@property (nonatomic, retain) NSArray *items;
@end

@implementation NXViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSArray arrayWithObjects:@"0", @"1", nil];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self action:@selector(add:)];
        UIBarButtonItem *removeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
                                                                                    target:self action:@selector(remove:)];
        self.toolbarItems = [NSArray arrayWithObjects:addItem, removeItem, nil];
    }
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    self.tableView.nxEV_hideSeparatorLinesWheyShowingEmptyView = YES;

    Class refreshControlClass = NSClassFromString(@"UIRefreshControl");
    if (refreshControlClass) {
        id refreshControl = [[refreshControlClass alloc] init];

        [refreshControl addTarget:self
                           action:@selector(refresh:)
                 forControlEvents:UIControlEventValueChanged];

        [self setRefreshControl:refreshControl];
    } else {
        __block id blockSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [blockSelf refresh:nil];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden = NO;
}


#pragma mark Actions

- (IBAction)add:(id)sender;
{
    self.items = [self.items arrayByAddingObject:[NSString stringWithFormat:@"%d", self.items.count]];
}

- (IBAction)remove:(id)sender
{
    NSInteger length = fmaxf((NSInteger)self.items.count - 1, 0);
    self.items = [self.items subarrayWithRange:NSMakeRange(0, length)];
}

- (IBAction)refresh:(id)sender
{
    if ([self respondsToSelector:@selector(refreshControl)]) {
        [self.refreshControl endRefreshing];
    }

    if ([self.tableView respondsToSelector:@selector(pullToRefreshView)]) {
        [self.tableView.pullToRefreshView stopAnimating];
    }

    if (self.items.count == 0) {
        [self add:nil];
    }
}


#pragma mark The DataSource

- (void)setItems:(NSArray *)items;
{
    _items = items;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *identifier = @"xx";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    return cell;
}

@end
