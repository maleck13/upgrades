package main

type Version struct {
	Service                 string   `json:"service"`
	Servicetype             string   `json:"serviceType"`
	Version                 string   `json:"version"`
	Next                    []string `json:"next"`
	Serviceimpacting        bool     `json:"serviceImpacting"`
	Criticalsecurityupgrade bool     `json:"criticalSecurityUpgrade"`
	Requirements            []struct {
		Dependency string `json:"dependency"`
	} `json:"requirements"`
	Status string `json:"status"`
}


type Fleet struct {
	Service     string `json:"service"`
	Servicetype string `json:"serviceType"`
	Members     []*FleetMember `json:"members"`
}

type FleetMember struct {
	Clusterid string `json:"clusterID"`
	Cloud     string `json:"cloud"`
	Services  []struct {
		Name    string `json:"name"`
		Version string `json:"version"`
		Risk      int    `json:"risk"`
		Subscription string `json:"subscription"`
	} `json:"services"`
	Upgradepolicy string `json:"upgradePolicy"`
}



type FleetVersionRequest struct {
	Input struct {
		Version *Version `json:"version"`
		Fleet *Fleet `json:"fleet"`
	} `json:"input"`
}

type FleetMemberVersionsRequest struct {
	Input struct {
		Version []*Version `json:"versions"`
		FleetMember *FleetMember `json:"fleetMember"`
	} `json:"input"`
}


type RolloutGroups struct {
	Result [][]*GroupMember
}

type GroupMember struct {
	*FleetMember
	UpgradeStatus string `json:"upgrade_status"`
}

type RolloutPlan struct {
	Version *Version `json:"version"`
	Groups []*Group `json:"groups"`
	Status string `json:"status"`
}

type Group struct {
	Count int `json:"count"`
	Risk int `json:"risk"`
	Status string `json:"status"`
	Members []*GroupMember `json:"members"`
}