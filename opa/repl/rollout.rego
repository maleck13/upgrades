package upgrade.someservice

import input.versions
import input.fleetMember
import input.fleet
import input.version

# looks at the version the member is on finds that version and looks at the next field return that version
availableVersionForFleetMember = vers  {
   some j,i,k
   # versions is a list of versions for the service
   v := versions[i]
   # check the fleet member has the service running
   fleetMember.services[j].name == v.service
   # find the version they are currently on
   v.version == fleetMember.services[j].version
   # find the next version for them by looking at the latest version in the next array assumes its the last one
   v.next[count(v.next)-1] == versions[k].version
   vers = versions[k]
}


# evaluate which fleet memebers should be grouped for a version. They have the service installed, their current version is < than the new version, their upgrade policy is automatic
shouldBeGrouped[f]{
    some i
    f := fleet.members[_]
    v := version
    f.upgradePolicy == "automatic"
    f.services[i].name == v.service
    installedVersion := f.services[i].version
    newVersion:= v.version
    semver.compare(installedVersion,newVersion) = -1
}


# builds an array of arrays each of which represent a roll out group based on risk labels for the service
rolloutPlan := [ fleetMembers |
        ef := shouldBeGrouped
        some k,j
        r := {x |
          ef[j].services[k].name == version.service
          x := ef[j].services[k].risk}
        sortedRisk := sort(r)
        risk := sortedRisk[_]
        fleetMembers := [fm |
        some i,l
        ef[i].services[l].name == version.service
        ef[i].services[l].risk == risk
        fm := ef[i] ]
    ]


# % of group that needs to be successful before moving to next group
groupSuccessThreshold := 90


