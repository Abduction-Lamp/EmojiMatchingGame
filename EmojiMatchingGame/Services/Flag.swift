//
//  Flag.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 11.07.2023.
//

import Foundation


protocol FlagGeneratable {
    
    var count: Int { get }
    
    func makeFlag(_ tag: String) -> String
    func getRandomFlag() -> String
}


///
/// Эможи-флаг - это состовной эможи, состоящие последовательности двух или более эмоджи
///
/// Например:
///      Флаг России состоит из последовательности двух эмоджи 🇷️ и 🇺️ = 🇷️🇺️
///      Флаг Республики Беларусь из 🇧️ и 🇾️= 🇧️🇾️
///      Флаг Украины из 🇺️и 🇦️ = 🇺️🇦️
///
fileprivate let literals: [String: String] = [
    "A": "🇦️",       //  -   🇦️   -   0x1F1E6
    "B": "🇧️",       //  -   🇧️   -   0x1F1E7
    "C": "🇨️",       //  -   🇨️   -   0x1F1E8
    "D": "🇩️",       //  -   🇩️   -   0x1F1E9
    "E": "🇪️",       //  -   🇪️   -   0x1F1EA
    "F": "🇫️",       //  -   🇫️   -   0x1F1EB
    "G": "🇬️",       //  -   🇬️   -   0x1F1EC
    "H": "🇭️",       //  -   🇭️   -   0x1F1ED
    "I": "🇮️",       //  -   🇮️   -   0x1F1EE
    "J": "🇯️",       //  -   🇯️   -   0x1F1EF
    "K": "🇰️",       //  -   🇰️   -   0x1F1F0
    "L": "🇱️",       //  -   🇱️   -   0x1F1F1
    "M": "🇲️",       //  -   🇲️   -   0x1F1F2
    "N": "🇳️",       //  -   🇳️   -   0x1F1F3
    "O": "🇴️",       //  -   🇴️   -   0x1F1F4
    "P": "🇵️",       //  -   🇵️   -   0x1F1F5
    "Q": "🇶️",       //  -   🇶️   -   0x1F1F6
    "R": "🇷️",       //  -   🇷️   -   0x1F1F7
    "S": "🇸️",       //  -   🇸️   -   0x1F1F8
    "T": "🇹️",       //  -   🇹️   -   0x1F1F9
    "U": "🇺️",       //  -   🇺️   -   0x1F1FA
    "V": "🇻️",       //  -   🇻️   -   0x1F1FB
    "W": "🇼️",       //  -   🇼️   -   0x1F1FC
    "X": "🇽️",       //  -   🇽️   -   0x1F1FD
    "Y": "🇾️",       //  -   🇾️   -   0x1F1FE
    "Z": "🇿️",       //  -   🇿️   -   0x1F1FF
    
    "1": "\u{1F3F4}\u{E0067}\u{E0062}\u{E0065}\u{E006E}\u{E0067}\u{E007F}", //  0x1F3F4 0xE0067 0xE0062 0xE0065 0xE006E 0xE0067 0xE007F     🏴󠁧󠁢󠁥󠁮󠁧󠁿  England
    "2": "\u{1F3F4}\u{E0067}\u{E0062}\u{E0073}\u{E0063}\u{E0074}\u{E007F}", //  0x1F3F4 0xE0067 0xE0062 0xE0073 0xE0063 0xE0074 0xE007F     🏴󠁧󠁢󠁳󠁣󠁴󠁿  Scotland
    "3": "\u{1F3F4}\u{E0067}\u{E0062}\u{E0077}\u{E006C}\u{E0073}\u{E007F}"  //  0x1F3F4 0xE0067 0xE0062 0xE0077 0xE006C 0xE0073 0xE007F     🏴󠁧󠁢󠁷󠁬󠁳󠁿  Wales
]


///
/// Двузначный буквенный код соответствующий стандарту ISO 3166, alpha2
/// Всего в этом массиве 261 элементов
///
fileprivate let countryTags: [String] = [
    "AC", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ",
    "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ",
    "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CP", "CR", "CU", "CV", "CW", "CX", "CY", "CZ",
    "DE", "DG", "DJ", "DK", "DM", "DO", "DZ",
    "EA", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "EU",
    "FI", "FJ", "FK", "FM", "FO", "FR",
    "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY",
    "HK", "HM", "HN", "HR", "HT", "HU",
    "IC", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT",
    "JE", "JM", "JO", "JP",
    "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ",
    "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY",
    "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ",
    "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ",
    "OM",
    "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY",
    "QA",
    "RE", "RO", "RS", "RU", "RW",
    "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ",
    "TA", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ",
    "UA", "UG", "UN", "UM", "US", "UY", "UZ",
    "VA", "VC", "VE", "VG", "VI", "VN", "VU",
    "WF", "WS",
    "XK",
    "YE", "YT",
    "ZA", "ZM", "ZW",
    
    // Дополнительные значения для флагов England (1), Scotland (2), Wales (3)
    "1", "2", "3"
]


final class Flag: FlagGeneratable {
    
    var count: Int {
        return countryTags.count
    }
    
    func makeFlag(_ tag: String) -> String {
        var flag = ""
        tag.forEach { char in
            if let literal = literals[String(char)] {
                flag += literal
            }
        }
        return flag
    }
    
    func getRandomFlag() -> String {
        return makeFlag(countryTags[.random(in: 0 ..< countryTags.count)])
    }
    
    
    
    //
    // TODO: - Logging info
    //
    init() {
        print("SERVICE\t\t😈\tFlag")
    }
    
    deinit {
        print("SERVICE\t\t♻️\tFlag")
    }
}
