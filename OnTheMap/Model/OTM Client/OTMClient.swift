//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var key = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let udacityBase = "https://onthemap-api.udacity.com/v1"
        
        case getStudentsLocation
        case session
        case publicUserData

        var stringValue: String {
            switch self {
            case .getStudentsLocation:
                return Endpoints.udacityBase + "/StudentLocation"
            case .session:
                return Endpoints.udacityBase + "/session"
            case .publicUserData:
                return Endpoints.udacityBase + "/users/\(Auth.key)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getStudentsLocation(completion: @escaping ([StudentsLocation], Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: Endpoints.getStudentsLocation.url) {(data, response, error) in
        
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(OTMResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
    
    // The following function helps to create a body for the POST/PUT requests
    func makeBody<T: Codable>(bodyStructure: T) -> Data? {
       let jsonEncoder = JSONEncoder()
       let jsonPOSTData: Data?
       do {
          jsonPOSTData = try jsonEncoder.encode(bodyStructure)
       }catch{
          print("Encoding error")
          return nil
       }
       return jsonPOSTData
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        
        /*
        let loginData = UdacityLoginRequest(username: username, password: password)
        let loginBody = LoginRequest(udacity: loginData)
        
        guard let body = makeBody(bodyStructure: loginBody) else {
            statements
        }
        */
                
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if error != nil { // Handle error…
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func loginAnother(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udacityUsernamePassword = UdacityLoginRequest(username: username, password: password)
        let body = LoginRequest(udacity: udacityUsernamePassword)
        
        taskForPOSTRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.key = response.account.key
                Auth.sessionId = response.session.id
                print(Auth.key)
                print(Auth.sessionId)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            Auth.key = ""
            Auth.sessionId = ""
            
            completion()
            
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
    
    class func getPublicUserData(completion: @escaping (String?, String?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.publicUserData.url, response: User.self) { (response, error) in
            if let response = response {
                completion(response.firstName, response.lastName, nil)
            } else {
                completion(nil, nil, error)
            }
        }
    }
    
}
