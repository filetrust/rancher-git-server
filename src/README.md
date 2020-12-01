# GlassWall gitserver-http

> A git server with Nginx as the HTTP frontend and fast cgi wrapper for running the git http backend


## Usage

To build and tag a git server you'll need to build a docker image using:
* `DOCKER_BUILDKIT=1 docker build -t glasswallsolutions/git-server:VERSION --secret id=az-secret,src=secrets.json --progress=plain --no-cache .`

Your local secrets.json file should look:

`{
  "clientId": "MY_AZURE_CLIENT_ID",
  "clientSecret": "MY_AZURE_CLIENT_SECRET",
  "tenantId": "MY_AZURE_CLIENT_TENANT ID"
}
` 

then push to glasswall container registry:
* `docker push glasswallsolutions/git-server:VERSION`
To run git server locally (Mac OS)
* `docker run -d -v /Users/USER/initial:/var/lib/initial -p 80:8080 glasswallsolutions/git-server:VERSION`

This will create a git server http service on `:80`. Now you can clone the icap infrastructure repository:

```sh
git clone http://localhost:80/icap-infrastructure.git
```


