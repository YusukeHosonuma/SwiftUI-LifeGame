//
//  Functons.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/14.
//

func within<T>(value: T, min minValue: T, max maxValue: T) -> T where T: Comparable {
    min(max(value, minValue), maxValue)
}
