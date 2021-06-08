package upgrade.rhoam

member := {
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
                         }