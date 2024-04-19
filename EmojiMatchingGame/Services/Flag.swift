//
//  Flag.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 11.07.2023.
//

import Foundation


protocol FlagGeneratable {
    
    var count: Int { get }
    var range: ClosedRange<UInt32> { get }
    
    func make(_ tag: String) -> String
    func random() -> String
    func all() -> [String]
}


///
/// Эмоджи-флаг - это составной эмоджи, состоящие последовательности двух или более эмоджи
///
/// Например:
///      Флаг России состоит из последовательности двух эмоджи 🇷️ и 🇺️ = 🇷️🇺️
///      Флаг Республики Беларусь из 🇧️ и 🇾️= 🇧️🇾️
///      Флаг Украины из 🇺️и 🇦️ = 🇺️🇦️
///
fileprivate let literals: [String: String] = [
    "A": "\u{1F1E6}",       //  -   🇦️   -   0x1F1E6
    "B": "\u{1F1E7}",       //  -   🇧️   -   0x1F1E7
    "C": "\u{1F1E8}",       //  -   🇨️   -   0x1F1E8
    "D": "\u{1F1E9}",       //  -   🇩️   -   0x1F1E9
    "E": "\u{1F1EA}",       //  -   🇪️   -   0x1F1EA
    "F": "\u{1F1EB}",       //  -   🇫️   -   0x1F1EB
    "G": "\u{1F1EC}",       //  -   🇬️   -   0x1F1EC
    "H": "\u{1F1ED}",       //  -   🇭️   -   0x1F1ED
    "I": "\u{1F1EE}",       //  -   🇮️   -   0x1F1EE
    "J": "\u{1F1EF}",       //  -   🇯️   -   0x1F1EF
    "K": "\u{1F1F0}",       //  -   🇰️   -   0x1F1F0
    "L": "\u{1F1F1}",       //  -   🇱️   -   0x1F1F1
    "M": "\u{1F1F2}",       //  -   🇲️   -   0x1F1F2
    "N": "\u{1F1F3}",       //  -   🇳️   -   0x1F1F3
    "O": "\u{1F1F4}",       //  -   🇴️   -   0x1F1F4
    "P": "\u{1F1F5}",       //  -   🇵️   -   0x1F1F5
    "Q": "\u{1F1F6}",       //  -   🇶️   -   0x1F1F6
    "R": "\u{1F1F7}",       //  -   🇷️   -   0x1F1F7
    "S": "\u{1F1F8}",       //  -   🇸️   -   0x1F1F8
    "T": "\u{1F1F9}",       //  -   🇹️   -   0x1F1F9
    "U": "\u{1F1FA}",       //  -   🇺️   -   0x1F1FA
    "V": "\u{1F1FB}",       //  -   🇻️   -   0x1F1FB
    "W": "\u{1F1FC}",       //  -   🇼️   -   0x1F1FC
    "X": "\u{1F1FD}",       //  -   🇽️   -   0x1F1FD
    "Y": "\u{1F1FE}",       //  -   🇾️   -   0x1F1FE
    "Z": "\u{1F1FF}",       //  -   🇿️   -   0x1F1FF
    
    "0": "\u{1F3F4}\u{200D}\u{2620}\u{FE0F}",                               //  0x1F3F4 0x0200D 0x02620 0x0FE0F                             🏴‍☠️
    "1": "\u{1F3F4}\u{E0067}\u{E0062}\u{E0065}\u{E006E}\u{E0067}\u{E007F}", //  0x1F3F4 0xE0067 0xE0062 0xE0065 0xE006E 0xE0067 0xE007F     🏴󠁧󠁢󠁥󠁮󠁧󠁿  England
    "2": "\u{1F3F4}\u{E0067}\u{E0062}\u{E0073}\u{E0063}\u{E0074}\u{E007F}", //  0x1F3F4 0xE0067 0xE0062 0xE0073 0xE0063 0xE0074 0xE007F     🏴󠁧󠁢󠁳󠁣󠁴󠁿  Scotland
    "3": "\u{1F3F4}\u{E0067}\u{E0062}\u{E0077}\u{E006C}\u{E0073}\u{E007F}", //  0x1F3F4 0xE0067 0xE0062 0xE0077 0xE006C 0xE0073 0xE007F     🏴󠁧󠁢󠁷󠁬󠁳󠁿  Wales
    
    "4": "\u{1F3F3}\u{FE0F}\u{200D}\u{1F308}",                              //  0x1F3F3 0x0FE0F 0x0200D 0x1F308                             🏳️‍🌈
    "5": "\u{1F3F3}\u{FE0F}\u{200D}\u{26A7}\u{FE0F}"                        //  0x1F3F3 0x0FE0F 0x0200D 0x026A7 0x0FE0F                     🏳️‍⚧️
    
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
    
    ///
    /// Дополнительные значения для флагов
    ///
    /// 0 -
    /// 1 - England
    /// 2 - Scotland
    /// 3 - Wales
    ///
    "0", "1", "2", "3"
]


final class Flag: FlagGeneratable {
    
    var range: ClosedRange<UInt32> {
        0x1F1E6 ... 0x1F1FF
    }
    
    var count: Int {
        countryTags.count
    }
    
    func make(_ tag: String) -> String {
        var flag = ""
        tag.forEach { char in
            if let literal = literals[String(char)] {
                flag += literal
            }
        }
        return flag
    }
    
    func random() -> String {
        return make(countryTags[.random(in: 0 ..< countryTags.count)])
    }
    
    func all() -> [String] {
        countryTags.map { make($0) }
    }
}
