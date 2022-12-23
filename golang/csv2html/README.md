# Converting CSV to HTML

I was reading a post on a Write the Docs Slack channel about how one could display an Excel spreadsheet as a web page (HTML).
I didn't think it would be that difficult, especially as you can have Excel save the spreadsheet as a CSV (comma-separted value) file, parse the CSV file, and output each row as a table row.
My goto language for simple apps is Go(lang), so here it is.

I also wanted to handle the cases where the spreadsheet could have different numbers of rows
(which in my mind meant they should probably have been in different spreadsheets) and
possibly a title row as the first row for each different set of rows.

You can get the app's options by using the **-h** (help) option.
