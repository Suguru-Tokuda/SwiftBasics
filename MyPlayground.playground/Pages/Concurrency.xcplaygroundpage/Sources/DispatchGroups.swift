import Foundation

/*
 DispatchGroups
 it allows you to wait for multiple tasks to complete before you proceed to next tasks
 */

func dispatchGroups() {
    let apiURL1 = URL(string: "https://reqres.in/api/users")
    let apiURL2 = URL(string: "https://reqres.in/api/users")
    let apiURL3 = URL(string: "https://reqres.in/api/users")
    
    let apiGroup = DispatchGroup()
    
    // 1
    apiGroup.enter()
    makeGetRequest(url: apiURL1!) { result in
        print("apiURL1 done")
        apiGroup.leave()
    }
    
    // 2
    apiGroup.enter()
    makeGetRequest(url: apiURL2!) { result in
        print("apiURL2 done")
        apiGroup.leave()
    }

    // 3
    apiGroup.enter()
    makeGetRequest(url: apiURL3!) { result in
        print("apiURL3 done")
        apiGroup.leave()
    }
    
    apiGroup.notify(queue: DispatchQueue.main) {
        // UPDATE UI
    }
}

enum NetworkError : Error {
    case badUrlResponse(url: URL),
         invalidURL(url: String),
         unknown
}

extension NetworkError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badUrlResponse(url: let url):
            return "Bad response from URL. \(url)"
        case .invalidURL(url: let urlStr):
            return "Invalid url: \(urlStr)"
        case .unknown:
            return "Unknown error"
        }
    }
}



private func makeGetRequest(url: URL, _ completionHandler: @escaping (Result<Data, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completionHandler(.failure(error))
        }
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            completionHandler(.failure(NetworkError.unknown))
            return
        }
        
        guard let rawData = data else {
            completionHandler(.failure(NetworkError.unknown))
            return
        }
        
        completionHandler(.success(rawData))
    }.resume()
}
