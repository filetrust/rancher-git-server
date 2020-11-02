# GlassWall gitserver-http

> A git server with Nginx as the HTTP frontend and fast cgi wrapper for running the git http backend


## Usage

To run a git server you'll need to build a docker image using:
* `make image`
then execute a quick test to ensure it works as expected:
* `make test`
then running the container
* `make gitserver`

## Test

run `./test.sh` and all the tests should pass.

This will create a git server http service on `:80`. Now you can clone the sample repository:


```sh
git clone http://localhost:8080/myrepo.git
```


