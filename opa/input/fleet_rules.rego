package managed.service.upgrade

# check if a fleet member is eligible for an upgrade

eligible[f]{
   meets_resource_requirements[f]
   meets_cloud_provider_requirements[f]
   meets_dependency_requirements[f]
}

meets_resource_requirements[f]{
   f := input.fleet[_]
   f.resources.estimatedFreeRAMGB > input.requirements.resources.increaseRAMGB
   f.resources.estimatedFreeCores > input.requirements.resources.increaseCores
   f.resources.estimatedFreeStorageGB > input.requirements.resources.increaseStorageGB
}

meets_cloud_provider_requirements[f]{
    f := input.fleet[_]
    f.cloudProvider == "AWS"
}

meets_dependency_requirements[f]{
    f:= input.fleet[_]
}


