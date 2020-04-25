//
//  SecureEnclaveManager.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

/// This class is very inspired (copied almost) from https://github.com/trailofbits/SecureEnclaveCrypto Check it for more reference.

import Foundation
import Security
import LocalAuthentication

final class SecureEnclaveManager {
    
    enum Constants {
        static let publicLabel: String = "com.pips.pay-publicKey"
        static let privateLabel: String = "com.pips.pay-privateKey"
    }
    
    private let helper = SecureEnclaveHelper(publicLabel: Constants.publicLabel,
                                             privateLabel: Constants.privateLabel)
    
    func deleteKeyPair() throws {
        try helper.deletePublicKey()
        try helper.deletePrivateKey()
    }
    
    func encrypt(_ data: Data) throws -> Data {
        let publicKeyRef = try getPublicKey().ref
        let signed = try helper.encrypt(data, publicKey: publicKeyRef)
        return signed
    }
    
    func decrypt(_ data: Data, context: LAContext) throws -> Data {
        let privateKeyRef = try helper.getPrivateKey(context: context)
        let signed = try helper.decrypt(data, privateKey: privateKeyRef)
        return signed
    }
    
    private func getPublicKey() throws -> SecureEnclaveKeyData {
        if let publicKeyRef = try? helper.getPublicKey() {
            return publicKeyRef
        } else {
            let keys = try createKeys()
            return keys.public
        }
    }
    
    private func createKeys() throws -> (`public`: SecureEnclaveKeyData, `private`: SecureEnclaveKeyReference) {
        let accessControl = try helper.accessControl(with: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        let keypairResult = try helper.generateKeyPair(accessControl: accessControl)
        try helper.forceSavePublicKey(keypairResult.public)
        return (public: try helper.getPublicKey(), private: keypairResult.private)
    }
}

final class SecureEnclaveHelper {
    
    let publicLabel: String
    let privateLabel: String
    
    /*!
     *  @param publicLabel  The user visible label in the device's key chain
     *  @param privateLabel The label used to identify the key in the secure enclave
     */
    init(publicLabel: String, privateLabel: String) {
        self.publicLabel = publicLabel
        self.privateLabel = privateLabel
    }
    
    func getPublicKey() throws -> SecureEnclaveKeyData {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: publicLabel,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecReturnData as String: true,
            kSecReturnRef as String: true,
            kSecReturnPersistentRef as String: true
        ]
        
        let raw = try getSecKeyWithQuery(query)
        return SecureEnclaveKeyData(raw as! CFDictionary) // swiftlint:disable:this force_cast
    }
    
    func getPrivateKey(context: LAContext) throws -> SecureEnclaveKeyReference {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrLabel as String: privateLabel,
            kSecReturnRef as String: true,
            kSecUseAuthenticationContext as String: context
        ]
        
        let raw = try getSecKeyWithQuery(query)
        return SecureEnclaveKeyReference(raw as! SecKey) // swiftlint:disable:this force_cast
    }
    
    func generateKeyPair(accessControl: SecAccessControl) throws -> (`public`: SecureEnclaveKeyReference, `private`: SecureEnclaveKeyReference) {
        let privateKeyParams: [String: Any] = [
            kSecAttrLabel as String: privateLabel,
            kSecAttrIsPermanent as String: true,
            kSecAttrAccessControl as String: accessControl
        ]
        let params: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: privateKeyParams
        ]
        var publicKey, privateKey: SecKey?
        
        let status = SecKeyGeneratePair(params as CFDictionary, &publicKey, &privateKey)
        
        guard status == errSecSuccess else {
            throw SecureEnclaveHelperError(message: "Could not generate keypair", osStatus: status)
        }
        
        return (public: SecureEnclaveKeyReference(publicKey!), private: SecureEnclaveKeyReference(privateKey!))
    }
    
    func deletePublicKey() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrApplicationTag as String: publicLabel
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw SecureEnclaveHelperError(message: "Could not delete private key", osStatus: status)
        }
    }
    
    func deletePrivateKey() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrLabel as String: privateLabel,
            kSecReturnRef as String: true
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw SecureEnclaveHelperError(message: "Could not delete private key", osStatus: status)
        }
    }
    
    func encrypt(_ digest: Data, publicKey: SecureEnclaveKeyReference) throws -> Data {
        var error: Unmanaged<CFError>?
        let result = SecKeyCreateEncryptedData(publicKey.underlying, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, digest as CFData, &error)
        if result == nil {
            throw SecureEnclaveHelperError(message: "\(String(describing: error))", osStatus: 0)
        }
        guard let resultData = result as Data? else {
            throw SecureEnclaveHelperError(message: "\(String(describing: error))", osStatus: 0)
        }
        return resultData
    }
    
    func decrypt(_ digest: Data, privateKey: SecureEnclaveKeyReference) throws -> Data {
        var error: Unmanaged<CFError>?
        let result = SecKeyCreateDecryptedData(privateKey.underlying, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, digest as CFData, &error)
        if result == nil {
            throw SecureEnclaveHelperError(message: "\(String(describing: error))", osStatus: 0)
        }
        guard let resultData = result as Data? else {
            throw SecureEnclaveHelperError(message: "\(String(describing: error))", osStatus: 0)
        }
        return resultData
    }
    
    func forceSavePublicKey(_ publicKey: SecureEnclaveKeyReference) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrApplicationTag as String: publicLabel,
            kSecValueRef as String: publicKey.underlying,
            kSecAttrIsPermanent as String: true,
            kSecReturnData as String: true
        ]
        
        var raw: CFTypeRef?
        var status = SecItemAdd(query as CFDictionary, &raw)
        
        if status == errSecDuplicateItem {
            status = SecItemDelete(query as CFDictionary)
            status = SecItemAdd(query as CFDictionary, &raw)
        }
        
        guard status == errSecSuccess else {
            throw SecureEnclaveHelperError(message: "Could not save keypair", osStatus: status)
        }
    }
    
    func accessControl(with protection: CFString = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, flags: SecAccessControlCreateFlags = [.userPresence, .privateKeyUsage]) throws -> SecAccessControl {
        var accessControlError: Unmanaged<CFError>?
        let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, protection, flags, &accessControlError)
        guard accessControl != nil else {
            throw SecureEnclaveHelperError(message: "Could not generate access control. Error \(String(describing: accessControlError?.takeRetainedValue()))", osStatus: nil)
        }
        return accessControl!
    }
    
    private func getSecKeyWithQuery(_ query: [String: Any]) throws -> CFTypeRef {
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            throw SecureEnclaveHelperError(message: "Could not get key for query: \(query)", osStatus: status)
        }
        return result!
    }
}

final class SecureEnclaveKeyReference {
    let underlying: SecKey
    
    fileprivate init(_ underlying: SecKey) {
        self.underlying = underlying
    }
}

final class SecureEnclaveKeyData {
    let underlying: [String: Any]
    let ref: SecureEnclaveKeyReference
    let data: Data
    
    fileprivate init(_ underlying: CFDictionary) {
        let converted = underlying as! [String: Any] // swiftlint:disable:this force_cast
        self.underlying = converted
        self.data = converted[kSecValueData as String] as! Data // swiftlint:disable:this force_cast
        self.ref = SecureEnclaveKeyReference(converted[kSecValueRef as String] as! SecKey) // swiftlint:disable:this force_cast
    }
    
    var hex: String {
        return self.data.map { String(format: "%02hhx", $0) }.joined()
    }
}

struct SecureEnclaveHelperError: Error {
    let message: String
    let osStatus: OSStatus?
    let link: String
    
    init(message: String, osStatus: OSStatus?) {
        self.message = message
        self.osStatus = osStatus
        
        if let code = osStatus {
            link = "https://www.osstatus.com/search/results?platform=all&framework=Security&search=\(code)"
        } else {
            link = ""
        }
    }
}
