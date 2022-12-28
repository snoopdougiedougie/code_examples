# Go(lang)

## Create new go project

The following command creates a new project *PROJECT-NAME*,
in the folder *PROJECT-NAME* within the current folder.

```shell
mkdir PROJECT-NAME
cd PROJECT-NAME
go mod init PROJECT-NAME
```

Here's the structure:

```console
./PROJECT-NAME
./PROJECT-NAME/go.mod
```

## Added source code

I prefer my source code to live in a *src/* folder within the project:

```shell
mkdir src
cd src
touch main.go
```

Add the following to src/main.go:

```golang
package main

import "fmt"

func main() {
    fmt.Println("Hello, world.")
}
```

Update the first line of *go.mod* to:

```
module src/main
```

Save both files and run the following command
from the root of *PROJECT-NAME*:

```shell
go run main.go
```

It should display:

```console
Hello, world.
```

