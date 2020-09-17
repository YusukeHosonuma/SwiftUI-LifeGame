//
//  PatternCategory.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/09/18.
//

// Note:
// これらの値は Firestore の`/patternIndex`から取得可能だが、実質固定なので取得コストを下げるために定数として保持する。

enum PatternCategory: String, CaseIterable, Identifiable {
    case agar = "Agar"
    case breeder = "Breeder"
    case conduit = "Conduit"
    case constellation = "Constellation"
    case crawler = "Crawler"
    case eater = "Eater"
    case fuse = "Fuse"
    case gardenOfEden = "Garden of Eden"
    case growingSpaceship = "Growing spaceship"
    case gun = "Gun"
    case inductionCoil = "Induction coil"
    case memoryCell = "Memory cell"
    case methuselah = "Methuselah"
    case miscellaneous = "Miscellaneous"
    case oscillator = "Oscillator"
    case piWave = "Pi wave"
    case problem = "Problem"
    case pseudoStillLife = "Pseudo still life"
    case puffer = "Puffer"
    case pufferEngine = "Puffer engine"
    case pushalong = "Pushalong"
    case rake = "Rake"
    case reflector = "Reflector"
    case rotor = "Rotor"
    case sawtooth = "Sawtooth"
    case spacefiller = "Spacefiller"
    case spaceship = "Spaceship"
    case spark = "Spark"
    case stableReflector = "Stable reflector"
    case strictStillLife = "Strict still life"
    case superstring = "Superstring"
    case tagalong = "Tagalong"
    case wave = "Wave"
    case wick = "Wick"
    case wickstretcher = "Wickstretcher"
    
    var id: String { self.rawValue }
}
