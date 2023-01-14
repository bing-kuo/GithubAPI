import Foundation

enum NetworkingError: Error {
    case noDataFound
    case APIError(String)
    case unknown
}

class NetworkingService {
    static let shared = NetworkingService()

    private init() { }

    func fetchUsers(keyword: String, page: Int, perPage: Int = 15, completionHandler: (@escaping (Result<GitHub.UserResponse, Error>) -> Void)) {
        dataTask("search/users",
                 query: [
                    URLQueryItem(name: "q", value: keyword),
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "per_page", value: String(perPage)),
                 ],
                 completionHandler: completionHandler)
    }
    
    private func dataTask<T: Decodable>(_ path: String, query: [URLQueryItem]? = nil, completionHandler: (@escaping (Result<T, Error>) -> Void)) {
        var components = URLComponents(string: "https://api.github.com/" + path)!
        components.queryItems = query

        let request = URLRequest(url: components.url!)

        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            do {
                if let error = error {
                    throw error
                } else if let data = data {
                    completionHandler(.success(try JSONDecoder().decode(T.self, from: data)))
                } else {
                    throw NetworkingError.unknown
                }
            } catch let error {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
