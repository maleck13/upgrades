package upgrade.kafka

import data.upgrade.kafka.versions
import data.upgrade.kafka.fleetMember

nextVersionForFleetMember = vers  {
   some j,i,k
   v := versions[i]
   fleetMember.services[j].name == v.service
   v.version == fleetMember.services[j].version
   v.next[_] == versions[k].version
   vers = versions[k]
}

dependenciesMet{
    v := nextVersionForFleetMember
    s := buildDependencies
    count({x | s[x]; dependencyMet(x,fleetMember)}) == count(s)
}

buildDependencies[deps]{
     v := nextVersionForFleetMember
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



