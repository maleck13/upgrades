# which group should fleet members be included in. Input expected
package upgrade.rhoam.rollout



group[f]{
    shouldBeGrouped[f]
}

# evaluate which fleet memebers should be grouped (if they have the service installed and their current version is < than the new version, their upgrade policy is automatic and the version is not
# marked as (stopped|removed)
shouldBeGrouped[f]{
    some i
    f := input.fleet.members[_]
    v := input.version
    f.upgradePolicy = "automatic"
    f.services[i].name = v.service
    installedVersion := f.services[i].version
    newVersion:= v.version
    semver.compare(installedVersion,newVersion) = -1
    #v.status = "active"
}

#the below set of rules would be something easily modified per service

# the percentage of the fleet that should end up in each group. Will be rounded up to the nearest whole number
group_split := [20,70,10]
# the percentage of the fleet that has to have upgrade successfully for each group to be considered successful and allow the rollout to move to the next group
# below it is 15% of the entire fleet this allows for manual upgrades that may happen and should count towards the overall success of the fleet. The percentage threshold should
# never be higher than the group split otherwise you cannot meet the threshold.
group_success_threshold := [15,60,100]

group_by_label := "risk"


groupMemberShouldBeUpgraded{
    1=1
    #use the groups defined and the fleet member and the version to decide if the fleet member should be upgraded now
    # the fleet member is eligible if they are
    # 1) in a group
    # 2) any previous group has met the success threshold
    # 3) the fleet member meets the requirements specified by the version
    # 4) no previous version between the fleet members current version and this version are marked customer impacting
}

memberShouldBeUpgraded{
1=1
# should be upgraded if
# 1) not in a group
# 2) upgrade set to manual
# 3) they meet the requirements
# 4) their scheduled time is within 2 hrs of the current time
}


nextVersion {
    1=1


}

eligibleForVersion{
  1=1
}

