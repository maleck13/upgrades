# upgrades
investigations into managed upgrades


Very basic look at integrating OPA with Go and also attempts at defining polices 


TODO

- look at adding custom functions 
- look at integrating with OPA as external server
- flesh out some more polices


## Using Whats Here

you can build the binary from main.go 

`
go build .

`

Then run it, it will consume a policy some input and calculate a rollout plan for an upgrade of the provided fleet

There is also a repl directory which you can use with OPA directly
