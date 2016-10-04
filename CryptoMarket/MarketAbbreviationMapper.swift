//
//  MarketAbbreviationMapper.swift
//  CryptoMarket
//
//  Created by David Moeller on 03/10/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation


enum MarketAbbreviation: String {
	
	case onecr = "1CR"
	case amp = "AMP"
	case bbr = "BBR"
	case bcn = "BCN"
	case bcy = "BCY"
	case bela = "BELA"
	case bitcny = "BITCNY"
	case bits = "BITS"
	case blk = "BLK"
	case block = "BLOCK"
	case btc = "BTC"
	case btcd = "BTCD"
	case btm = "BTM"
	case bts = "BTS"
	case burst = "BURST"
	case c2 = "C2"
	case cga = "CGA"
	case clam = "CLAM"
	case cure = "CURE"
	case dash = "DASH"
	case dcr = "DCR"
	case dgb = "DGB"
	case diem = "DIEM"
	case doge = "DOGE"
	case emc2 = "EMC2"
	case etc = "ETC"
	case eth = "ETH"
	case exp = "EXP"
	case fct = "FCT"
	case fldc = "FLDC"
	case flo = "FLO"
	case game = "GAME"
	case geo = "GEO"
	case grc = "GRC"
	case huc = "HUC"
	case hz = "HZ"
	case ioc = "IOC"
	case lbc = "LBC"
	case lsk = "LSK"
	case ltbc = "LTBC"
	case ltc = "LTC"
	case maid = "MAID"
	case mmnxt = "MMNXT"
	case myr = "MYR"
	case naut = "NAUT"
	case nav = "NAV"
	case nbt = "NBT"
	case neos = "NEOS"
	case nmc = "NMC"
	case nobl = "NOBL"
	case note = "NOTE"
	case nsr = "NSR"
	case nxt = "NXT"
	case omni = "OMNI"
	case pink = "PINK"
	case pot = "POT"
	case ppc = "PPC"
	case qbk = "QBK"
	case qora = "QORA"
	case qtl = "QTL"
	case rads = "RADS"
	case rby = "RBY"
	case rdd = "RDD"
	case ric = "RIC"
	case sbd = "SBD"
	case sc = "SC"
	case sdc = "SDC"
	case sjcx = "SJCX"
	case steem = "STEEM"
	case str = "STR"
	case sync = "SYNC"
	case sys = "SYS"
	case unity = "UNITY"
	case usdt = "USDT"
	case via = "VIA"
	case vox = "VOX"
	case vrc = "VRC"
	case vtc = "VTC"
	case xbc = "XBC"
	case xcn = "XCN"
	case xcp = "XCP"
	case xdn = "XDN"
	case xem = "XEM"
	case xmg = "XMG"
	case xmr = "XMR"
	case xpm = "XPM"
	case xrp = "XRP"
	case xst = "XST"
	case xvc = "XVC"

	static func toFullName(abbreviation: MarketAbbreviation?) -> String {
		
		guard let abbreviation = abbreviation else { return "Unknown" }
		
		switch abbreviation {
		case .btc:
			return "Bitcoin"
		case .xmr:
			return "Monero"
		case .eth:
			return "Ethereum"
		case .etc:
			return "Ethereum Classic"
		case .xrp:
			return "Ripple"
		case .fct:
			return "Factom"
		case .amp:
			return "Synereo AMP"
		case .dash:
			return "Dash"
		case .cga:
			return "Cryptographic Anomaly"
		case .lbc:
			return "LBRY Credits"
		case .maid:
			return "MaidSafeCoin"
		case .bts:
			return "BitShares"
		case .onecr:
			return "1CRedit"
		case .geo:
			return "GeoCoin"
		case .naut:
			return "Nautiluscoin"
		case .nxt:
			return "NXT"
		case .doge:
			return "Dogecoin"
		case .lsk:
			return "Lisk"
		case .steem:
			return "STEEM"
		case .sc:
			return "Siacoin"
		case .ltc:
			return "Litecoin"
		case .str:
			return "Stellar"
		case .sdc:
			return "Shadow"
		case .xem:
			return "NEM"
		case .exp:
			return "Expanse"
		case .burst:
			return "Burst"
		case .bcy:
			return "BitCrystals"
		case .dcr:
			return "Decred"
		case .nav:
			return "NAVCoin"
		case .bbr:
			return "Boolberry"
		case .pot:
			return "PotCoin"
		case .xcp:
			return "Counterparty"
		case .game:
			return "GameCredits"
		case .sbd:
			return "Steem Dollars"
		case .sjcx:
			return "Storjcoin X"
		case .clam:
			return "CLAMS"
		case .ltbc:
			return "LTBCoin"
		case .fldc:
			return "FoldingCoin"
		case .btm:
			return "Bitmark"
		case .sys:
			return "Syscoin"
		case .vox:
			return "Voxels"
		case .rads:
			return "Radium"
		case .ioc:
			return "IO Digital Currency"
		case .xvc:
			return "Vcash"
		case .btcd:
			return "BitcoinDark"
		case .via:
			return "Viacoin"
		case .dgb:
			return "DigiByte"
		case .c2:
			return "Coin 2.0"
		case .cure:
			return "Curecoin"
		case .qora:
			return "Qora"
		case .omni:
			return "Omni"
		case .xbc:
			return "BitcoinPlus"
		case .vtc:
			return "Vertcoin"
		case .myr:
			return "Myriadcoin"
		case .grc:
			return "Gridcoin Research"
		case .neos:
			return "Neoscoin"
		case .xpm:
			return "Primecoin"
		case .nsr:
			return "NuShares"
		case .hz:
			return "Horizon"
		case .xst:
			return "StealthCoin"
		case .pink:
			return "Pinkcoin"
		case .blk:
			return "BlackCoin"
		case .huc:
			return "Huntercoin"
		case .ppc:
			return "Peercoin"
		case .rby:
			return "Rubycoin"
		case .block:
			return "Blocknet"
		case .flo:
			return "Florincoin"
		case .xmg:
			return "Magi"
		case .bcn:
			return "Bytecoin"
		case .emc2:
			return "Einsteinium"
		case .rdd:
			return "Reddcoin"
		case .bela:
			return "BellaCoin"
		case .nmc:
			return "Namecoin"
		case .vrc:
			return "VeriCoin"
		case .sync:
			return "Sync"
		case .note:
			return "DNotes"
		case .bits:
			return "Bitstar"
		case .xcn:
			return "Cryptonite"
		case .nobl:
			return "NobleCoin"
		case .qtl:
			return "Quatloo"
		case .xdn:
			return "DigitalNote"
		case .nbt:
			return "NuBits"
		case .diem:
			return "Diem"
		case .ric:
			return "Riecoin"
		case .bitcny:
			return "BitCNY"
		case .qbk:
			return "Qibuck"
		case .mmnxt:
			return "MMNXT"
		case .unity:
			return "SuperNET"
		case .usdt:
			return "Tether (USD)"
		default:
			return abbreviation.rawValue
		}
		
	}
	
	static func convertMarketName(marketName: String) -> (String, String) {
		
		let stringArray = marketName.components(separatedBy: "_")
		
		let firstAbbr = MarketAbbreviation(rawValue: stringArray[0])
		let secondAbbr = MarketAbbreviation(rawValue: stringArray[1])
		
		return (MarketAbbreviation.toFullName(abbreviation: firstAbbr), MarketAbbreviation.toFullName(abbreviation: secondAbbr))
		
	}
	
}
