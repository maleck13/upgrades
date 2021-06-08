

# which group should fleet members be included in. Input expected
package upgrade.addon.rollout


group[f]{
    shouldBeGrouped[f]
}

# evaluate which fleet memebers should be grouped (if they have the service installed and the version is < than the new version and their upgrade policy is automatic
shouldBeGrouped[f]{
    some i
    f := data.fleet.members[_]
    v := data.version
    f.upgradePolicy = "automatic"
    f.services[i].name = v.service
    installedVersion := f.services[i].version
    newVersion:= v.version
    semver.compare(installedVersion,newVersion) = -1
}


# the percentage of the fleet that should end up in each group. Will be rounded up to the nearest whole number
group_split := [20,80]
# the percentage of each group that dictates success
group_success := [80,80]


isEligibleForUpgrade{

}