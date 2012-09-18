//
//  UITableView_NXEmptyViewTests.h
//  UITableView+NXEmptyViewTests
//
//  Created by Ullrich Schäfer on 21.06.12.
//  Copyright (c) 2012 nxtbgthng.com. All rights reserved.
//

#import <UITableView+NXEmptyView/UITableView+NXEmptyView.h>

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

@interface UITableView_NXEmptyViewTests : SenTestCase <UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) OCMockObject<UITableViewDataSource> *dataSourceMock;

@property (nonatomic, retain) NSArray *dataSourceItems;

@end
