package main

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/open-policy-agent/opa/rego"
	"github.com/pkg/errors"
	"io/fs"
	"io/ioutil"
	"math"
	"math/rand"
	"strings"
)

func main() {
 	// new version is brought in
	fleetVersionRaw, err := ioutil.ReadFile("./input/fleet_version.json")
	if err != nil{
		panic("failed to read fleet version info")
	}
	fv := &FleetVersion{}
	if err := json.Unmarshal(fleetVersionRaw, fv); err != nil{
		panic("failed to unmarshal fleet version" + err.Error())
	}
	// version rollout is planned
	rolloutPlan, err := buildRolloutGroups(fv)
	if err != nil{
		panic(err)
	}
	data, err := json.MarshalIndent(rolloutPlan, ""," ")
	if err != nil{
		panic("failed to create json rollout plan")
	}
	// rollout plan is stored
	// output plan
	outputPlan := fmt.Sprintf("./output/rollout_%s_%v_plan.json", fv.Version.Service, fv.Version.Version)
	if err := ioutil.WriteFile(outputPlan,data,fs.ModePerm); err != nil{
		panic("failed to write plan " + err.Error())
	}



}
// LOADING POLCIY FROM LOCAL FILE. MAY BE BETTER TO LEVERAGE THE API FROM OPA SERVER
func loadRolloutPolicy(serviceType, serviceName string)(string,error){
	// if no policy load the default policy for the service type (addon for example)
	policyData, err :=  ioutil.ReadFile(fmt.Sprintf("./input/%s_rollout_policy.rego",serviceType))
	if err != nil{
		// failed to find default policy bail
		fmt.Print(err, "failed to find default policy for service type ", serviceType)
		return "", err
	}
	policyData, err = ioutil.ReadFile(fmt.Sprintf("./input/%s_rollout_policy.rego",serviceName))
	if err != nil{
		fmt.Print("err reading file. No policy found for service  " + serviceName + " using default", err)
		return "", err
	}
	return string(policyData), nil
}

// Use the rollout policy for the service to build the rollout plan
func buildRolloutGroups(fleetVersion *FleetVersion)([][]*FleetMember, error)  {
	// load the right policy for the service
	// some of this logic can likely be handled by OPA but my OPA foo is not strong enough yet.
	// Note it may also be simpler to simple call out to an OPA server API rather than loading the rego in code
	ctx := context.TODO()
	var pkg = strings.ToLower(fleetVersion.Fleet.Service)
	var serviceType = strings.ToLower(fleetVersion.Fleet.Servicetype)
	var serviceName = strings.ToLower(fleetVersion.Fleet.Service)
	var groups = [][]*FleetMember{}
	module,err := loadRolloutPolicy(serviceType,serviceName)
	if err != nil{
		return groups, err
	}
	query := fmt.Sprintf("should = data.upgrade.%s.rollout.shouldBeGrouped",pkg)
	q, err := prepareQuery(ctx,module,query)
	if err != nil{
		return groups, errors.Wrap(err,"failed to prepare query for should be grouped")
	}
	res,err := q.Eval(ctx,rego.EvalInput(fleetVersion))
	if err != nil{
		return groups, errors.Wrap(err, "failed to evaluate input")
	}
	if len(res) == 0{
		return groups, nil
	}
	result := res[0].Bindings["should"].([]interface{})
	// may be a better way to do this but for speed just recreated the array
	eligibleToBeGrouped := []map[string]interface{}{}
	for _,m := range result{
		eligibleToBeGrouped = append(eligibleToBeGrouped, m.(map[string]interface{}))
	}
	fleet := convertEligibleGroups(eligibleToBeGrouped)
	// sort by risk Not sure how you would do this in rego
	sortByRisk(fleet)
	fmt.Println("fleet ", fleet)
	// split into groups based on the policy definition for the groups (todo perhaps this can be done in rego itself?)
	// query our group split policy
	query = fmt.Sprintf("s = data.upgrade.%s.rollout.group_split",pkg)
	q, err = prepareQuery(ctx,module,query)
	if err != nil{
		return groups, errors.Wrap(err, "failed to prepare query group_split")
	}
	res, err = q.Eval(ctx)
	if err != nil{
		return groups, errors.Wrap(err, "failed execute query ")
	}
	split := res[0].Bindings["s"].([]interface{})
	fmt.Printf("splitting fleet with size %v into %v groups \n",len(fleet), len(split))
	// groups will be filled based on the percentage policy
	// not sure if this could be done directly in rego
	for i := range split{
		n,_ := split[i].(json.Number).Int64()
		// figure out how many for this group based on the policy
		total := (float64(len(fleet)) / 100) * float64(n)
		if total <= 0{
			total = 1.0
		}else{
			total = math.Ceil(total)
		}
		// convert total to an int as it is now a whole number
		totalIndex := int(total)
		// take of the first n (percentage) in the list and add to the group
		groups = append(groups,fleet[0:totalIndex])
		// remove the grouped members from the fleet
		fleet = append(fleet[:totalIndex-1],fleet[totalIndex:]...)
	}
	fmt.Println(groups)
	for i := range groups{
		fmt.Printf("rolllout group %v has %v cluster \n", i , len(groups[i]))
	}

	return groups,nil
}

func fleetMemberShouldUpgrade()  {
	
}

func convertEligibleGroups(f []map[string]interface{})[]*FleetMember  {
	var fm = []*FleetMember{}

	for _,v := range f{
		services := []*Service{}
		for _,s := range v["services"].([]interface{}){
			serviceMap := s.(map[string]interface{})
			service := &Service{
				Name:          serviceMap["name"].(string),
				Version:       serviceMap["version"].(string),
				Upgradestatus: serviceMap["upgradeStatus"].(string),
			}
			services = append(services, service)
		}
		risk,_ :=v["risk"].(json.Number).Int64()
		fleetM := &FleetMember{
			Clusterid:     v["clusterID"].(string),
			Risk:          risk,
			Services:      services,
			Upgradepolicy: v["upgradePolicy"].(string),
		}
		fm = append(fm,fleetM)
	}
	return fm
}

func prepareQuery(ctx context.Context, module, query string )(rego.PreparedEvalQuery, error){

	// might be less verbose way to do this with the
	r := rego.New(rego.Query(query), rego.Module("upgrade.policy.rego", module), rego.Trace(true) )
	q, err := r.PrepareForEval(ctx)
	if err != nil {
		return rego.PreparedEvalQuery{} , err
	}
	return q, nil
}

func sortByRisk(fleet []*FleetMember) []*FleetMember {
	if len(fleet) < 2 {
		return fleet
	}

	left, right := 0, len(fleet)-1

	pivot := rand.Int() % len(fleet)

	fleet[pivot], fleet[right] = fleet[right], fleet[pivot]

	for i, _ := range fleet {
		if fleet[i].Risk > fleet[right].Risk {
			fleet[left], fleet[i] = fleet[i], fleet[left]
			left++
		}
	}

	fleet[left], fleet[right] = fleet[right], fleet[left]

	sortByRisk(fleet[:left])
	sortByRisk(fleet[left+1:])

	return fleet
}
