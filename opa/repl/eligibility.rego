package upgrade.someservice

import input.version
import input.fleetMember

# check the fleetmember meets the requirements for the upgrade (Just does a dependency check at the moment)
eligibleForUpgrade{
    dependenciesMet
}

dependenciesMet{
    v := version
    s := buildDependencies
    count({x | s[x]; dependencyMet(x,fleetMember)}) == count(s)
}

buildDependencies[deps]{
     v := version
     deps = v.requirements[_].dependency
}

dependencyMet(dep, fleetMember) = true {
   keyVal := split(dep,":")
   contains(keyVal[1], ">=")
   vers := replace(keyVal[1], ">=", "")
   some i
   fleetMember.services[i].name == keyVal[0]
   semver.compare(fleetMember.services[i].version, vers) >= 0
}

dependencyMet(dep, fleetMember) = true {
   keyVal := split(dep,":")
   contains(keyVal[1], ">")
   vers := replace(keyVal[1], ">", "")
   some i
   fleetMember.services[i].name == keyVal[0]
   semver.compare(fleetMember.services[i].version, vers) == 1
}

dependencyMet(dep, fleetMember) = true {
   keyVal := split(dep,":")
   contains(keyVal[1], "<=")
   vers := replace(keyVal[1], "<=", "")
   some i
   fleetMember.services[i].name == keyVal[0]
   semver.compare(fleetMember.services[i].version, vers) <= 0
}

dependencyMet(dep, fleetMember) = true {
   keyVal := split(dep,":")
   contains(keyVal[1], "<")
   vers := replace(keyVal[1], "<", "")
   some i
   fleetMember.services[i].name == keyVal[0]
   semver.compare(fleetMember.services[i].version, vers) == -1
}

dependencyMet(dep, fleetMember) = true {
   keyVal := split(dep,":")
   some i
   fleetMember.services[i].name == keyVal[0]
   semver.compare(fleetMember.services[i].version, keyVal[1]) == 0
}