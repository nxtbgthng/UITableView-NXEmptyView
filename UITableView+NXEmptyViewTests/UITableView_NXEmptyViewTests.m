//
//  UITableView_NXEmptyViewTests.m
//  UITableView+NXEmptyViewTests
//
//  Created by Ullrich Schäfer on 21.06.12.
//  Copyright (c) 2012 nxtbgthng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "UITableView_NXEmptyViewTests.h"

@implementation UITableView_NXEmptyViewTests

- (void)setUp
{
    [super setUp];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    self.tableView.nxEV_emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.dataSourceMock = [OCMockObject niceMockForProtocol:@protocol(UITableViewNXEmptyViewDataSource)];
    self.tableView.dataSource = self.dataSourceMock;
    
    // configuring the database mock
    UITableViewCell *dummyCell = [OCMockObject niceMockForClass:[UITableViewCell class]];
    NSInteger sections = 1; // this needs to be in a seperate variable for OCMOCK_VALUE to work
    
    [[[self.dataSourceMock stub] andReturn:dummyCell] tableView:OCMOCK_ANY cellForRowAtIndexPath:OCMOCK_ANY];
    [[[self.dataSourceMock stub] andReturnValue:OCMOCK_VALUE(sections)] numberOfSectionsInTableView:OCMOCK_ANY];
    
    // dynamically get the number of rows from dataSourceItems 
    __block id blockSelf = self;
    void(^numberOfRowsBlock)(NSInvocation *) = ^(NSInvocation *i) {
        NSInteger rowCount = [[blockSelf dataSourceItems] count];
        [i setReturnValue:&rowCount];
    };
    [[[self.dataSourceMock stub] andDo:numberOfRowsBlock] tableView:OCMOCK_ANY numberOfRowsInSection:0];
}

- (void)tearDown
{
    self.tableView = nil;
    self.dataSourceMock = nil;
    [super tearDown];
}

#pragma mark -
#pragma mark Tests

- (void)testTheMocking
{
    self.dataSourceItems = [NSArray arrayWithObject:@"x"];
    [self.tableView reloadData];
    STAssertEquals([self.tableView numberOfRowsInSection:0], 1, @"Better check the mocking of the tests (1)");
    
    self.dataSourceItems = [NSArray array];
    [self.tableView reloadData];
    STAssertEquals([self.tableView numberOfRowsInSection:0], 0, @"Better check the mocking of the tests (2)");
}

- (void)testForNilEmptyView
{
    self.dataSourceItems = [NSArray arrayWithObject:@"x"];
    [self.tableView reloadData];
    STAssertTrue([self.tableView numberOfRowsInSection:0] > 0, @"There should be cells in the table view");
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNil(self.tableView.nxEV_emptyView.superview, @"The empty view should not be visible");
}

- (void)testForEmptyView
{
    self.dataSourceItems = [NSArray array];
    [self.tableView reloadData];
    STAssertTrue([self.tableView numberOfRowsInSection:0] == 0, @"There should be no cells in the table view");
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNotNil(self.tableView.nxEV_emptyView.superview, @"The empty view should be visible");
}

- (void)testThatTheFrameOfTheEmptyViewIsSetCorrectly
{
    [self.tableView reloadData];
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNotNil(self.tableView.nxEV_emptyView.superview, @"The empty view should be visible");
    STAssertTrue(CGRectEqualToRect(self.tableView.nxEV_emptyView.frame, self.tableView.bounds), @"The frame of the emptyView should be the bounds of the table view");
}

- (void)testThatTheFrameOfTheEmptyViewIsUpdatedTogetherWithTheTableView
{
    [self.tableView reloadData];
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNotNil(self.tableView.nxEV_emptyView.superview, @"The empty view should be visible");
    STAssertTrue(CGRectEqualToRect(self.tableView.nxEV_emptyView.frame, self.tableView.bounds), @"The frame of the emptyView should be the bounds of the table view");
    self.tableView.frame = CGRectMake(10, 10, 200, 200);
    STAssertTrue(CGRectEqualToRect(self.tableView.nxEV_emptyView.frame, self.tableView.bounds), @"The frame of the emptyView should be the bounds of the table view, even after updating and not %@", NSStringFromCGRect(self.tableView.nxEV_emptyView.frame));
}

- (void)testBypassingOfTheEmptyView
{
    [self.tableView reloadData];
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNotNil(self.tableView.nxEV_emptyView.superview, @"The empty view should be visible");
    
    BOOL shouldBypassEmptyView = YES;
    [[[self.dataSourceMock stub] andReturnValue:OCMOCK_VALUE(shouldBypassEmptyView)] tableViewShouldBypassNXEmptyView:OCMOCK_ANY];
    [self.tableView reloadData];
    
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNil(self.tableView.nxEV_emptyView.superview, @"The empty view should not be visible");
}

- (void)testTableViewShouldStillWorkWithDefaultDatasourceProtocol
{
    id plainDataSource = [OCMockObject niceMockForProtocol:@protocol(UITableViewDataSource)];
    [[[plainDataSource stub] andReturnValue:[NSNumber numberWithInteger:0]] tableView:OCMOCK_ANY numberOfRowsInSection:0];
    self.tableView.dataSource = plainDataSource;
    [self.tableView reloadData];
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertNotNil(self.tableView.nxEV_emptyView.superview, @"The empty view should be visible");
}

- (void)testEmptyViewShouldScrollWithTableView
{
    [self.tableView reloadData];
    STAssertNotNil(self.tableView.nxEV_emptyView, @"There should be an empty view");
    STAssertTrue(CGPointEqualToPoint(self.tableView.nxEV_emptyView.frame.origin, CGPointZero), @"Empty view should be positioned correctly");

    [self.tableView setContentOffset:CGPointMake(0, 40)];
    // needs the layout subviews here, because setContentOffset is just calling setNeedsLayout and we don't want
    // to add asynchrony to the test :)
    [self.tableView layoutSubviews];

    STAssertTrue(CGPointEqualToPoint(self.tableView.nxEV_emptyView.frame.origin, CGPointZero), @"Empty view should be positioned correctly");
}

- (void)testTableViewShouldNotHideSeparatorLinesWhenShowingEmptyView
{
    self.dataSourceItems = [NSArray arrayWithObject:@"x"];
    [self.tableView reloadData];
    UITableViewCellSeparatorStyle separatorStyle = self.tableView.separatorStyle;

    STAssertTrue(self.tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLine, @"Default separator style should be present");

    self.dataSourceItems = [NSArray array];
    [self.tableView reloadData];

    STAssertTrue(self.tableView.separatorStyle == separatorStyle, @"Separator style should not change when empty view is shown");
}

- (void)testTableViewShouldHideSeparatorLinesWhenShowingEmptyViewWhenRequested
{
    self.tableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;

    self.dataSourceItems = [NSArray arrayWithObject:@"x"];
    [self.tableView reloadData];
    UITableViewCellSeparatorStyle separatorStyle = self.tableView.separatorStyle;

    self.dataSourceItems = [NSArray array];
    [self.tableView reloadData];

    STAssertTrue(self.tableView.separatorStyle == UITableViewCellSeparatorStyleNone, @"Separator should be hidden");

    self.dataSourceItems = [NSArray arrayWithObject:@"x"];
    [self.tableView reloadData];

    STAssertTrue(self.tableView.separatorStyle == separatorStyle, @"Separator should reappear");
}

- (void)testEmptyViewShouldRespectTableHeaderView
{
    [self.tableView reloadData];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.tableView layoutSubviews];
    
    STAssertTrue(CGPointEqualToPoint(self.tableView.nxEV_emptyView.frame.origin, CGPointMake(0, 50)), @"Empty view should be positioned correctly");
}

@end
