package upgrade

import data.upgrade.data.fleet
import data.upgrade.data.version
import data.upgrade.data.versions
import data.upgrade.data.member

nextVersion[n]  {
   some i, j, k
   v := versions[i]
   member.services[j].name == v.service
   v.version == member.services[j].version
   next := array.slice(versions,i+1, count(v))
   next[k].status == "active"
   n = next[k]
}


# evaluate which fleet memebers should be grouped (if they have the service installed and their current version is < than the new version, their upgrade policy is automatic and the version is not
# marked as (stopped|removed)
shouldBeGrouped[f]{
    #some i
    f := fleet.members[_]
    v := version
    f.upgradePolicy = "automatic"
    f.services[i].name = v.service
    installedVersion := f.services[i].version
    newVersion:= v.version
    semver.compare(installedVersion,newVersion) = -1
    v.status = "active"
}

#the below set of rules would be something easily modified per service

# the percentage of the fleet that should end up in each group. Will be rounded up to the nearest whole number
group_split := [20,70,10]
# the percentage of the fleet that has to have upgrade successfully for each group to be considered successful and allow the rollout to move to the next group
# below it is 15% of the entire fleet this allows for manual upgrades that may happen and should count towards the overall success of the fleet. The percentage threshold should
# never be higher than the group split otherwise you cannot meet the threshold.
group_success_threshold := [15,60,100]

group_by_label := "risk"
