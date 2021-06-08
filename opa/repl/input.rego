package upgrade.data

versions := [
               {
                  "service": "RHOAM",
                  "serviceType": "addon",
                  "version": "1.6.0",
                  "serviceImpacting": false,
                  "criticalSecurityUpgrade": false,
                  "requirements": {
                    "platformVersion": ">=4.7.1"
                  },
                  "status": "active"
                },
                {
                  "service": "RHOAM",
                  "serviceType": "addon",
                  "version": "1.7.0",
                  "serviceImpacting": false,
                  "criticalSecurityUpgrade": false,
                  "requirements": {
                    "platformVersion": ">=4.7.10"
                  },
                  "status": "failed"
                },
                {
                  "service": "RHOAM",
                  "serviceType": "addon",
                  "version": "1.7.1",
                  "serviceImpacting": false,
                  "criticalSecurityUpgrade": false,
                  "requirements": {
                    "platformVersion": ">=4.7.10"
                  },
                  "status": "active"
                }
              ]


fleet := {
             "service": "RHOAM",
             "serviceType": "addon",
             "members": [
               {
                 "clusterID": "0",
                 "risk": 7,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "1",
                 "risk": 7,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "2",
                 "risk": 7,
                 "platformVersion": "4.7.12",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "3",
                 "risk": 7,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "4",
                 "risk": 6,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "manual"
               },
               {
                 "clusterID": "5",
                 "risk": 6,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "6",
                 "risk": 6,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "7",
                 "risk": 5,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.7.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "8",
                 "risk": 5,
                 "platformVersion": "4.6.12",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "9",
                 "risk": 5,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "10",
                 "risk": 5,
                 "platformVersion": "4.7.12",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               },
               {
                 "clusterID": "11",
                 "risk": 5,
                 "platformVersion": "4.7.2",
                 "cloud": "aws",
                 "services": [
                   {
                     "name": "RHOAM",
                     "version": "1.6.0"
                   }
                 ],
                 "upgradePolicy": "automatic"
               }
             ]
           }

member :=        {
                           "clusterID": "0",
                           "risk": 7,
                           "platformVersion": "4.7.10",
                           "cloud": "aws",
                           "services": [
                             {
                               "name": "RHOAM",
                               "version": "1.6.0"
                             }
                           ],
                           "upgradePolicy": "automatic"
                         }


version :=                 {
                             "service": "RHOAM",
                             "serviceType": "addon",
                             "version": "1.7.0",
                             "next":["1.7.1"],
                             "serviceImpacting": false,
                             "criticalSecurityUpgrade": false,
                             "requirements": {
                               "platformVersion": ">=4.7.10"
                             },
                             "status": "active"
                           }


cisVersions := [
                  {
                     "apiVersion":"hive.openshift.io/v1",
                     "kind":"ClusterImageSet",
                     "metadata":{
                        "annotations":{
                           "api.openshift.com/available-upgrades":"[\"1.7.1\"]",
                           "api.openshift.com/version":"1.6.0"
                        },
                        "labels":{
                           "api.openshift.com/channel-group":"stable",
                           "api.openshift.com/enabled":"true"
                        },
                        "name":"RHOAM-v1.6.0"
                     },
                     "spec":{
                        "releaseImage":"quay.io/appsre/rhoam@sha256:63545e67cc2af126e289de269ad59940e072af68f4f0cb9c37734f5374afeb60"
                     }
                  },
                  {
                     "apiVersion":"hive.openshift.io/v1",
                     "kind":"ClusterImageSet",
                     "metadata":{
                        "annotations":{
                           "api.openshift.com/available-upgrades":"[\"1.7.1\"]",
                           "api.openshift.com/version":"1.7.0"
                        },
                        "labels":{
                           "api.openshift.com/channel-group":"stable",
                           "api.openshift.com/enabled":"true"
                        },
                        "name":"RHOAM-v1.7.0"
                     },
                     "spec":{
                        "releaseImage":"quay.io/appsre/rhoam@sha256:63545e67cc2af126e289de269ad59940e072af68f4f0cb9c37734f5374afeb62"
                     }
                  },
                  {
                     "apiVersion":"hive.openshift.io/v1",
                     "kind":"ClusterImageSet",
                     "metadata":{
                        "annotations":{
                           "api.openshift.com/available-upgrades":"[]",
                           "api.openshift.com/version":"1.7.1"
                        },
                        "labels":{
                           "api.openshift.com/channel-group":"stable",
                           "api.openshift.com/enabled":"true"
                        },
                        "name":"RHOAM-v1.7.1"
                     },
                     "spec":{
                        "releaseImage":"quay.io/appsre/rhoam@sha256:63545e67cc2af126e289de269ad59940e072af68f4f0cb9c37734f5374afeb62"
                     }
                  }
               ]