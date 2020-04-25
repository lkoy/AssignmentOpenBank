//
//  ConfigurationBuilder.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

class ConfigurationBuilder {
    
    static func build() -> Configuration {
        
        let general = Configuration.General(bankEntity: .santander)
        
        let santander = Configuration.Santander(authUrl: "https://apis-sandbox.bancosantander.es/canales-digitales/sb/prestep-authorize", apiAuthUrl: "https://apis-sandbox.bancosantander.es/canales-digitales/sb/v2", apiUrl: "https://apis-sandbox.bancosantander.es/canales-digitales/sb", clientSecret: "D8fT2vS8uO2rI6gC3iN8cJ2aB0dP3sA0cG7bK8nH6lI2hU5pE0", clientId: "22eb7d9a-e4cd-4d70-8efd-6c2f6f5cbb45", redirectUri: "http://test", bic: "BSCHESMM")

        return Configuration(general: general, santander: santander)
    }

}
