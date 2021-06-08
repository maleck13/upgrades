package main

import "fmt"

type FleetVersion struct {
	Fleet *Fleet `json:"fleet"`
	Version *Version `json:"version"`
}


type Fleet struct {
	Service     string `json:"service"`
	Servicetype string `json:"serviceType"`
	Members     []*FleetMember `json:"members"`
}

type Version struct {
	Service                 string `json:"service"`
	Servicetype             string `json:"serviceType"`
	Version                 string `json:"version"`
	Serviceimpacting        bool   `json:"serviceImpacting"`
	Criticalsecurityupgrade bool   `json:"criticalSecurityUpgrade"`
	Requirements            struct {
		Platformversion string `json:"platformVersion"`
	} `json:"requirements"`
	Status string `json:"status"`
}
type Service struct {
	Name          string `json:"name"`
	Version       string `json:"version"`
	Upgradestatus string `json:"upgradeStatus"`
}

type FleetMember struct {

		Clusterid string `json:"clusterID"`
		Risk      int64    `json:"risk"`
		Services  []*Service `json:"services"`
		Upgradepolicy string `json:"upgradePolicy"`

}

func (f *FleetMember)String()string{
	return fmt.Sprintf("risk %v-cid %v",f.Risk, f.Clusterid)
}