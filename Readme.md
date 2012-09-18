# NXEmptyView for UITableView

## What is this?

... a category that dynamically shows an _empty view_ when there are no entries in your table view.

## Behavior

The empty view will be displayed whenever the table view has no cells in any section. Of course only if a view has been set via `nxEV_emptyView`.
Whenever the table view is reloaded or layouted the empty view gets updated.

The frame of the empty view is updated to the bounds of the table view, so make sure it layouts nicely for all the orientations and screen sizes (iPhone 5, yay) that you're targeting.

### Bypassing the Empty View

There might be scenarios in which you don't want the empty view to appear. For example when the content of the list has not yet been loaded and you don't want to scream at the user that there's none just because it has not yet been loaded.

In that case you can let your table view datasource implement the `UITableViewNXEmptyViewDataSource` protocol and return `NO` in `-tableViewShouldBypassNXEmptyView:`. Whenever this value changes do a `-[UITableView reloadData]` to update the empty view.

## Install

### Via Cocoapods

Add this to your Podfile

    pod 'UITableView-NXEmptyView'

In your table view do:

- `#import <UITableView+NXEmptyView/UITableView+NXEmptyView.h>`
- Set the `nxEV_emptyView` property of the table view with the view you want to be displayed when the table is empty.
You can use the Interface Builder to do so as well.

## Contribute

Contributions are highly welcomed!

- Fork the repo
- Add your contribution
- Add a test for it if necessary
- Send us a [pull request](https://github.com/nxtbgthng/UITableView-NXEmptyView/pull/new/master) describing your changes
- Receive virtual high fives! :hand:

Bonus points for feature branches :sunglasses:

### Contributors

- Your name here?


## License

This code is released under the _3-clause BSD License_ (aka _new BSD License_ or _modified BSD License_).
The full text is included in the LICENSE file in the root of the repository.
