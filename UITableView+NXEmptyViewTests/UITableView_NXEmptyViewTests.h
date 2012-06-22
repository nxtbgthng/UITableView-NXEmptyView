//
//  UITableView_NXEmptyViewTests.h
//  UITableView+NXEmptyViewTests
//
//  Created by Ullrich Schäfer on 21.06.12.
//  Copyright (c) 2012 nxtbgthng.com. All rights reserved.
//

#import <UITableView+NXEmptyView/UITableView+NXEmptyView.h>

#import <SenTestingKit/SenTestingKit.h>

@interface UITableView_NXEmptyViewTests : SenTestCase <UITableViewDataSource>

@property (nonatomic, retain) UITableViewController *controller;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *items;

@end
