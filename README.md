# OPA supported upgrades


OPA [https://www.openpolicyagent.org/](Open Policy Agent) provides a powerful policy engine that has multiple integration options for building out polcies. It uses the Rego
language to define policies. Policies are made up of rules. Rego acts on a set of data and enforces the rules defined in the policy.

# upgrades
investigations into managed upgrades


Very basic look at integrating OPA with Go and also attempts at defining polices 


Remaining TODO

- look at adding custom functions 
- flesh out some more advanced polices


This is a toy project to investigate leveraging OPA as a policy engine for driving upgrade decisions.


The service here will accept a new version and build a rollout plan for that version based on the risk tolerance of the various fleet members.

To do this we have a basic fleet definition and a basic version definition in json data and then ask OPA via its HTTP API to enforce the rollout policy

This rollout policy filters down the members of the fleet to those that could receive the upgrade and then creates rollout groups for those members
based on their risk setting.
The risk setting is something that would be controlled by an SRE team


Main policies 

### Rollout Policy
takes a version and a fleet and defines how a particular version should be rolled out. The policy defines a rollout plan.
A rollout plan defines a set of groups to receive the upgrade and the threshold at which the group is considered successfully upgraded.
A rollout plan could be as simple as a single group with the entire fleet in it. Or more complex groups based on a risk property

 
### Eligibility Policy
Takes a fleet member and a version and decides if that fleet member is eligible to be upgraded at this point in time. This policy
would be checked with data that is as upto date as possible, ideally in response to a "should I upgrade call". 


## Try It

1) Install OPA 

`
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.29.4/opa_darwin_amd64
`

`
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.29.4/opa_linux_amd64
`


2) Start the OPA server with the predefined policies in this repo

`
opa run --server --log-level=debug ./rollout.rego ./eligibility.rego
`
This will start a local server on port 8181


3) Query the policy with the test data

Data Model:

Fleet Member And Versions [fleet member and versions](opa/repl/json_data/fleet_member_versions.json)

Full Fleet and a Version [fleet and a version](opa/repl/json_data/fleet_version.json)

Fleet Member and Version [fleet member and version](opa/repl/json_data/fleet_member_version.json) 


- Find the next version for a fleet member. Executing from the root of this repo

`
curl localhost:8181/v1/data/upgrade/someservice/availableVersionForFleetMember -d @./opa/repl/json_data/fleet_member_versions.json -H 'Content-Type: application/json' | jq`
`

- Show the rollout plan for a fleet for a particular version

`
curl localhost:8181/v1/data/upgrade/someservice/rolloutPlan -d @./opa/repl/json_data/fleet_version.json -H 'Content-Type: application/json' | jq
`


- Check if a fleet member is eligible for a version

curl localhost:8181/v1/data/upgrade/someservice/eligibleForUpgrade -d @./opa/repl/json_data/fleet_member_version.json -H 'Content-Type: application/json' | jq`
`

