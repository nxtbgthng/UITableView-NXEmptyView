//
//  UITableView_NXEmptyViewTests.m
//  UITableView+NXEmptyViewTests
//
//  Created by Ullrich Schäfer on 21.06.12.
//  Copyright (c) 2012 nxtbgthng.com. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "UITableView_NXEmptyViewTests.h"

@implementation UITableView_NXEmptyViewTests

- (void)setUp
{
    [super setUp];
    
    self.controller = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.tableView = self.controller.tableView;
    self.tableView.nxEV_emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
}

- (void)tearDown
{
    self.controller = nil;
    self.tableView = nil;
    [super tearDown];
}

- (void)testTheMocking
{
    self.items = [NSArray arrayWithObject:@"x"];
    int x = [self.tableView.dataSource tableView:self.controller.tableView numberOfRowsInSection:0];
    STAssertEquals([self.tableView numberOfRowsInSection:0], x, @"Better check the mocking of the tests (1)");
    
    self.items = [NSArray array];
    STAssertEquals([self.tableView numberOfRowsInSection:0], 0, @"Better check the mocking of the tests (2)");
}

- (void)testForNilEmptyView
{
    self.items = [NSArray arrayWithObject:@"x"];
    STAssertTrue([self.tableView numberOfRowsInSection:0] > 0, @"There should be cells in the table view");
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNil(self.tableView.nxEV_emptyView.superview, @"The empty view should not be visible");
}

- (void)testForEmptyView
{
    self.items = [NSArray array];
    STAssertTrue([self.tableView numberOfRowsInSection:0] == 0, @"There should be no cells in the table view");
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNotNil(self.tableView.nxEV_emptyView.superview, @"The empty view should be visible");
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
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

@end
