//
//  Routable.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

protocol Routable {
    associatedtype Route
    func route(to route: Route)
}
