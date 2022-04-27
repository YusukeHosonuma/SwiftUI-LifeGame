//
//  String+.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/16.
//

import CryptoKit

// ref: https://qiita.com/ganchiku/items/014428baa2fb9a13e46d#sha256%E3%81%A8md5%E3%81%AE%E5%AE%9F%E8%A3%85
extension String {
    var md5: String {
        let data = self.data(using: .utf8)!
        let hashed = Insecure.MD5.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
