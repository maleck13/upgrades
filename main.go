package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/gorilla/mux"
	"io/ioutil"
	"net/http"
	"strings"

)


var OPA_HOST = "http://localhost:8181"



func main()  {

	fleetFileFlag := flag.String("feet","./opa/repl/json_data/fleet.json", "choose a fleet to load")
	versionsFileFlag := flag.String("versions","./opa/repl/json_data/versions.json", "choose a versions file")
	flag.Parse()
	// load some static data for example purposes
	if err := loadFleet(*fleetFileFlag); err != nil{
		panic(err)
	}
	if err := loadVersions(*versionsFileFlag); err != nil{
		panic(err)
	}

	rollout := &Rollout{}
	for _,v := range versions {
		for _,vers := range v {
			rp , err := rollout.RolloutPlan(vers)
			if err != nil{
				fmt.Println("failed to build rollout plan for version ",vers)
				continue
			}
			planName := fmt.Sprintf("%v-%v",strings.ToLower(vers.Service),vers.Version)
			fmt.Println("added new plan ", planName)
			rolloutPlans[planName] = rp
		}
	}
	r := mux.NewRouter()
	r.HandleFunc("/api/v1/upgrades/rollout", rolloutPlanHandler).Methods("GET")
	r.HandleFunc("/api/v1/upgrades/version", versionHandler).Methods("POST", "PUT")
	http.ListenAndServe(":8080", r)

}

func loadFleet(fleetFile string)error{
	data, err := ioutil.ReadFile(fleetFile)
	if err != nil{
		return err
	}
	kFleet := &Fleet{}
	if err := json.Unmarshal(data,kFleet); err != nil{
		return err
	}
	serviceFleets[kFleet.Service] = kFleet
	for _, m := range kFleet.Members{
		if _, ok := clusterIDtoFleetMembers[m.Clusterid]; !ok{
			clusterIDtoFleetMembers[m.Clusterid] = []*FleetMember{}
		}
		clusterIDtoFleetMembers[m.Clusterid] = append(clusterIDtoFleetMembers[m.Clusterid], m)
	}
	return nil
}

func loadVersions(versionsFile string)error{
	data, err := ioutil.ReadFile(versionsFile)
	if err != nil{
		return err
	}
	serviceVersions := []*Version{}
	if err := json.Unmarshal(data,&serviceVersions); err != nil{
		return err
	}
	if len(serviceVersions) == 0{
		return fmt.Errorf("no versions found")
	}
	service := serviceVersions[0].Service
	versions[service] = serviceVersions
	return nil
}



var versions = map[string][]*Version{}
var serviceFleets = map[string]*Fleet{}
var rolloutPlans = map[string]*RolloutPlan{}
var clusterIDtoFleetMembers = map[string][]*FleetMember{}


func versionHandler(rw http.ResponseWriter, req *http.Request){
	v := &Version{}
	dec := json.NewDecoder(req.Body)
	if err := dec.Decode(v); err != nil{
		rw.WriteHeader(400)
		rw.Write([]byte(err.Error()))
		return
	}
	// obviously we would need to check this was a unique version
	versions[v.Service] = append(versions[v.Service],v)

	r := &Rollout{}
	rp , err := r.RolloutPlan(v);
	if err != nil{
		rw.WriteHeader(500)
		rw.Write([]byte(err.Error()))
		return
	}
	enc := json.NewEncoder(rw)
	if err := enc.Encode(rp); err != nil{
		rw.WriteHeader(500)
		rw.Write([]byte(err.Error()))
		return
	}
}

func rolloutPlanHandler(rw http.ResponseWriter, req *http.Request)  {
	s := req.URL.Query().Get("service")
	v := req.URL.Query().Get("version")
	rp := fmt.Sprintf("%v-%v",s,v)
	fmt.Println("rollout plan = ", rp)
	rollout := rolloutPlans[rp]
	enc := json.NewEncoder(rw)
	if err := enc.Encode(rollout); err != nil{
		rw.WriteHeader(500)
		rw.Write([]byte(err.Error()))
		return
	}
}

func statusHandler(rw http.ResponseWriter, req *http.Request){
	// accepts a cluster id and service and version. Looks up fleet member in rollout plan and updates status

	// provided with the status of the upgrade for a particular version
	// upgrade service marks the fleet member accordingly in the rollout plan
	// upgrade service marks the fleet member accordingly in any previous version rollout plan if the type of service is add-on (gross not sure how to work around that)
}

func availableVersionsHandler(rw http.ResponseWriter, req *http.Request){
	// find out what versions the fleet member can ugprade too
}

func availableUpgrade(rw http.ResponseWriter, req *http.Request)  {
	// cluster id
	// service
	//cid := req.URL.Query().Get("cid")
	//service := req.URL.Query().Get("service")
	//clusterFleet := clusterIDtoFleetMembers[cid]
	//serviceVersions := versions[service]
	//fv := FleetMemberVersionsRequest{
	//	Input: struct {
	//		Version []*Version `json:"version"`
	//		FleetMember   *Fleet
	//	}{Version:serviceVersions , Fleet:clusterFleet },
	//}

	//get the next version for the fleet member
	// if there is no next version they are up to date and there is nothing to do
	//if there is a new version check if there is a rollout plan for that version
	// if there is then look to see is the fleet memeber a member of a rollout group
	// if a member of a rollout group, then check is the group active
	// if no rollout plan or member not in rollout plan look for manual rollout schedule for fleet member

}




type Rollout struct {

}

// build the rollout plan for the service based on the roll out policy in OPA for the service / service type (for example there might be a common policy for add-ons)
// In this case it is creating groups of fleetmembers that have a version of the service less than the new version
func (r *Rollout)RolloutPlan(v *Version)(*RolloutPlan, error)  {
	// gather fleet this would obviously be done calls to an external service
	f := serviceFleets[v.Service]
	if f == nil{
		return nil, fmt.Errorf("no such service fleet")
	}
	// build the fleet version input for OPA
	input := struct {
		Version *Version `json:"version"`
		Fleet *Fleet `json:"fleet"`
	}{
		Version : v,
		Fleet: f,
	}
	fv := &FleetVersionRequest{Input:input}
	// pull back the rollback plan based on the rollout policy
	url := fmt.Sprintf("%s/%s",OPA_HOST, "v1/data/upgrade/"+strings.ToLower(v.Service)+"/rolloutPlan")
	data, err := json.MarshalIndent(fv, "", " ")
	if err != nil{
		return nil, fmt.Errorf("Failed to marshal fleet version information")
	}
	b := bytes.NewBuffer(data)
	req,err := http.NewRequest("POST", url, b)
	if err != nil{
		return  nil, err
	}
	req.Header.Add("'Content-Type","application/json'")
	res, err := http.DefaultClient.Do(req)
	if err != nil{
		return nil,err
	}
	defer res.Body.Close()
	dec := json.NewDecoder(res.Body)
	// decode the response from OPA this will be an eligible array of fleet  members
	rollout := &RolloutGroups{}
	if err := dec.Decode(rollout); err != nil{
		return  nil,err
	}
	fmt.Println(rollout)
	groups := []*Group{}
	// bug reverse as right now the policy gives us the highest risk group in the 0 index
	for i := len(rollout.Result)-1; i >=0; i-- {

		g := &Group{
			Status:       "",
			Members: rollout.Result[i],
		}
		g.Count = len(rollout.Result[i])
		if g.Count > 0{
			for _,o :=range rollout.Result[i][0].Services {
				if o.Name == v.Service {
					g.Risk = o.Risk
					break
				}
			}
		}
		groups = append(groups, g)
	}
	rp := &RolloutPlan{
		Groups:  groups,
		Version: v,
		Status:  "",
	}


	return rp, nil
}


