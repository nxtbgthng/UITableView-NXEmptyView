# Changelog

# v0.1.4
- adding the empty view only once (so layouting only runs once),  
  using `hidden` property now to trigger visibility

# v0.1.3
- preventing the empty view from hiding the table header view

# v0.1.2
- fixing issue #1 (support for pull to refresh)
- adding an option to hide the seperator lines when the empty view is shown (great for transparent empty views!)

# v0.1.1
- fixed a bug where the empty wouldn't be resized when the table view resizes while the empty view is shown - b0c6de5
- added an extension to the `UITableViewDataSource` protocol to bypass the showing of the empty view - 09564aa

# v0.1.0

- Initial release
