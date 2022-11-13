# Using Go to query and mutate

This go app executes any query or mutation in a JSON file you give it. It uses the following environment variables:

- API_KEY specifies your API key.
- ENDPOINT specifies the Grafbase endpoint for a project based on the [todo](https://github.com/grafbase/grafbase/tree/main/templates/todo) schema, with a `unique` directive specified for both list and item titles.

Use the app's `-h` flag to see the arguments it accepts.

The following command retrieves the list of to-do lists.

`go run main.go -j ../../list-lists.json`
