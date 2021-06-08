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
                             "serviceImpacting": false,
                             "criticalSecurityUpgrade": false,
                             "requirements": {
                               "platformVersion": ">=4.7.10"
                             },
                             "status": "active"
                           }