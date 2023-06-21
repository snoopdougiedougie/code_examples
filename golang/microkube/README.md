# Microservice using Kubernetes and Go

This project demonstrates how to create a microservice in Kubernetes using Go.

Run the Go app to create an HTTP listener on port 8080 and makes the endpoint
[http://localhost:8080/pets](http://localhost:8080/pets) accessible.

You can see the list of pets in a number of ways:

- Open [http://localhost:8080/pets](http://localhost:8080/pets) in your web browser
- Run the PowerShell **Invoke-RestMethod** command with the endpoint:

  ```shell
  Invoke-RestMethod http://localhost:8080/pets
  ```
- Run the following **cURL** command:

  ```shell
  curl http://localhost:8080/pets
  ```

You can build a Docker image from the default Golang image by using the **docker build** command. The **-t** argument gives it a tag we use later (don't forget the period at the end):

```shell
docker build -t microservice:1.1 - < Dockerfile
```

Once the command completes, double-check that the image was created:

```shell
docker images microservice:1.1
```

