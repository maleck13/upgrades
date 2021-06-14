package upgrade.someservice

import input.versions
import input.fleetMember
import input.fleet
import input.version


impacting[v]{
	versions[i].serviceImpacting == true
    v = versions[i]
}

non_impacting[v]{
	versions[i].serviceImpacting == false
    v = versions[i]
}

currentVersion = v{
   some i,j
   vers := versions[i]
   # check the fleet member has the service running
   fleetMember.services[j].name == vers.service
   fleetMember.services[j].version == vers.version
   v :={
      "version": vers,
      "index": i
   }
}

next = v{
   cv = currentVersion
   vers = versions[i]
   vers.version == cv.version.next[count(cv.version.next)-1]
    v :={
      "version": vers,
      "index": i
   }
}


inbetween = v{
  cv = currentVersion
  n = next
  v = array.slice(versions,cv.index+1,n.index+1)
}

nextVersionForMember = v{
  #get all versions inbetween current and next
  possVers = inbetween
  n = next
  # check if there is any service impacting upgrade in betwen current and next
  vers := nextImpactingVersions(possVers)
  # select either next version or a service impacting version inbetween
  v := selectVersion(vers,n)
}

selectVersion(impacting, next) = vers{
	count(impacting) > 0
    vers := impacting[count(impacting)-1]
}

selectVersion(impacting, next) = vers{
	count(impacting) == 0
    vers := next
}


nextImpactingVersions(versions) = vers {
	vers := [x |
    some i
    versions[i].serviceImpacting
    x := versions[i]]

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


