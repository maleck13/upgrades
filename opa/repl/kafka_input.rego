package upgrade.kafka

versions := [
                   {
                      "service":"Kafka",
                      "serviceType":"saas",
                      "version":"3.4.0",
                      "next":[
                         "3.5.0"
                      ],
                      "serviceImpacting":false,
                      "criticalSecurityUpgrade":false,
                      "requirements":[
                            {"dependency":"strimzi:>=2.5.1"},
                            {"dependency":"observability:>=1.2.0"}
                      ],
                      "status":"active"
                   },
                   {
                      "service":"Kafka",
                      "serviceType":"saas",
                      "version":"3.5.0",
                      "next":[
                         "3.6.1"
                      ],
                      "serviceImpacting":false,
                      "criticalSecurityUpgrade":false,
                      "requirements":[
                            {"dependency":"strimzi:>=2.5.1"},
                            {"dependency":"observability:>=1.2.0"}
                      ],
                      "status":"active"
                   },
                   {
                      "service":"Kafka",
                      "serviceType":"saas",
                      "version":"3.6.0",
                      "next":[
                         "3.6.1"
                      ],
                      "serviceImpacting":false,
                      "criticalSecurityUpgrade":false,
                      "requirements":[
                            {"dependency":"strimzi:>=2.5.1"},
                            {"dependency":"observability:>=1.2.0"}
                      ],
                      "status":"active"
                   },
                   {
                      "service":"Kafka",
                      "serviceType":"saas",
                      "version":"3.6.1",
                      "next":[],
                      "serviceImpacting":false,
                      "criticalSecurityUpgrade":false,
                      "requirements":[
                            {"dependency":"strimzi:2.5.1"},
                            {"dependency":"observability:>=1.2.0"},
                            {"dependency":"platform:>=4.7.0"}
                      ],
                      "status":"active"
                   }
                ]

fleetMember :={
               "clusterID": "0",
               "risk": 7,
               "platformVersion": "4.7.10",
               "cloud": "aws",
               "services": [
                 {
                   "name": "Kafka",
                   "version": "3.5.0"
                 },
                 {
                    "name": "strimzi",
                    "version":"2.5.1"
                 },
                 {
                    "name":"observability",
                    "version":"1.2.1"
                 },
                 {
                    "name":"platform",
                    "version":"4.7.10"
                 }

               ],
               "upgradePolicy": "automatic"
             }