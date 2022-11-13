# Queries and Mutations

The JSON files in the *json* directory contain queries and mutations based on the Grafbase [Todo](https://github.com/grafbase/grafbase/tree/main/templates/todo) template.

- [create-item.json](json/create-item.json) creates a new todo list item.
- [create-list.json](json/create-list.json) creates a todo list.
- [delete-item.json](json/delete-item.json) deletes a todo list item.
- [list-items.json](json/list-items.json) lists the items in a todo list.
- [list-lists.json](json/list-lists.json) retrieves the IDs of all of your todo lists.

You must set two environment variables to make this work for any of the language solutions:

- **API_KEY** is your Grafbase API key.
- **ENDPOINT** is the endpoint for your Grafbase project.

To set an environment variable on Linux, Mac, etc:

`export VARIABLE=VALUE`

To set an environment variable on Windows:

`set VARIABLE=NAME`

Use the app's `-h` flag to see the arguments it accepts.

The json files can also contain placeholders for various values:

- **TITLE** is the title for a new todo list or todo list item.
- **LIST-ID** is the ID for a todo list.
- **ITEM-ID** is the ID for a todo list item.

If your query or mutation requires a title, you must supply that with a **-t title** argument, where *title* is the list or item title.

If your query or mutation requires a list ID, you must supply that with a **-l list-id** argument, where *list-id* is the ID of a list.

If your query or mutation requires an item ID, you must supply that with a **-i item-id** argument, where *item-id* is the ID of a list item.
