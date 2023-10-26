//: [Previous](@previous)

import Foundation

/*
    Error handling
 
    - Add an enum that confirms to Error protocl
    - Add do .. try .. catch clause for the function call
    - Add an extension to the error enum you created and confirms to LocalizedError protocol so that you can return customized error message.
 */
enum LoggingError : Error {
    case accessDenied,
         dataNotFound,
         biometricAuthenticationFailed,
         unknown
}

/*
    Even though it is returning String?, NSLocalizedString is used because the string can be different in differen languages.
 */
extension LoggingError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString("Login failed, access denied by API", comment: "accessDenied")
        case .dataNotFound:
            return NSLocalizedString("Couldn't get the response from backend from API", comment: "dataNotFound")
        case .biometricAuthenticationFailed:
            return NSLocalizedString("FaceID didn't match on device", comment: "biometricAuthenticationFailed")
        case .unknown:
            return NSLocalizedString("Recieved an unknown error from API", comment: "unknown")
        }
    }
}

func doLogin(email: String, password: String, statusCode: Int) throws -> Bool {
    print("Doing login") // calling api
    switch statusCode {
    case 200:
        print("login is successful")
        return true
    case 300..<309:
        throw LoggingError.dataNotFound
    case 400...409:
        throw LoggingError.accessDenied
    default:
        throw LoggingError.unknown
    }
}

// 1. do.. try... catch
// doLogin(email: "swift@apple.com", password: "12345", statusCode: 500) - it will crash your application

do {
    try doLogin(email: "swift@apple.com", password: "12345", statusCode: 500)
} catch let error {
    print("error = \(error.localizedDescription)") // localized means internationalized (localized language)
}

// 2. try? - not recommended.
// return nil if there is an error
try? doLogin(email: "swift@apple.com", password: "12345", statusCode: 500)

// 3. try! - never use it
//try! doLogin(email: "swift@apple.com", password: "12345", statusCode: 500) - will crash because force unwrapping.
