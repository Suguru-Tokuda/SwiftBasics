import Foundation

/*
 Asynclet
 */

func asyncLet() {
    let apiURL1 = URL(string: "https://reqres.in/api/users")
    let apiURL2 = URL(string: "https://reqres.in/api/users")
    let apiURL3 = URL(string: "https://reqres.in/api/users")
    
    Task {
        async let res1 = makeGetRequest(url: apiURL1!)
        async let res2 = makeGetRequest(url: apiURL2!)
        async let res3 = makeGetRequest(url: apiURL3!)
        
        let res = await [res1, res2, res3]
        
        print(res)
    }
}

private func makeGetRequest(url: URL) async -> String {
    return url.description
}
