//
//  UITableView+NXEmptyView.m
//  TableWithEmptyView
//
//  Created by Ullrich Schäfer on 21.06.12.
//
//

#import <objc/runtime.h>

#import "UITableView+NXEmptyView.h"


static const NSString *NXEmptyViewAssociatedKey = @"NXEmptyViewAssociatedKey";


void nxEV_swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}



@implementation UITableView (NXEmptyView)

#pragma mark Entry

+ (void)load;
{
    Class c = [UITableView class];
    nxEV_swizzle(c, @selector(reloadData), @selector(nxEV_reloadData));
    nxEV_swizzle(c, @selector(layoutSubviews), @selector(nxEV_layoutSubviews));
}

#pragma mark Properties

- (BOOL)nxEV_hasRowsToDisplay;
{
    NSUInteger numberOfRows = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
        numberOfRows += [self numberOfRowsInSection:sectionIndex];
    }
    return (numberOfRows > 0);
}

@dynamic nxEV_emptyView;
- (UIView *)nxEV_emptyView;
{
    return objc_getAssociatedObject(self, &NXEmptyViewAssociatedKey);
}

- (void)setNxEV_emptyView:(UIView *)value;
{
    if (self.nxEV_emptyView.superview) {
        [self.nxEV_emptyView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &NXEmptyViewAssociatedKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self nxEV_updateEmptyView];
}


#pragma mark Updating

- (void)nxEV_updateEmptyView;
{
    UIView *emptyView = self.nxEV_emptyView;
    
    if (!emptyView) return;
    
    emptyView.frame = self.bounds;
    
    const BOOL emptyViewShouldBeShown = (self.nxEV_hasRowsToDisplay == NO);
    const BOOL emptyViewIsShown       = (emptyView.superview != nil);
    
    if (emptyViewShouldBeShown == emptyViewIsShown) return;
    
    if (emptyViewShouldBeShown) {
        [self addSubview:emptyView];
    } else {
        [emptyView removeFromSuperview];
    }
}


#pragma mark Swizzle methods

- (void)nxEV_reloadData;
{
    // this calls the original reloadData implementation
    [self nxEV_reloadData];
    
    [self nxEV_updateEmptyView];
}

- (void)nxEV_layoutSubviews;
{
    // this calls the original layoutSubviews implementation
    [self nxEV_layoutSubviews];
    
    [self nxEV_updateEmptyView];
}


@end
