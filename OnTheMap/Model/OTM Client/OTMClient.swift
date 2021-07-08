//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    
    enum Endpoints {
        static let udacityBase = "https://onthemap-api.udacity.com/v1/"
        
        case studentsLocation
        case getStudentsLocation
        case session
        case publicUserData

        var stringValue: String {
            switch self {
            case .studentsLocation:
                return Endpoints.udacityBase + "StudentLocation"
            case .getStudentsLocation:
                return Endpoints.udacityBase + "StudentLocation?order=-updatedAt"
            case .session:
                return Endpoints.udacityBase + "session"
            case .publicUserData:
                return Endpoints.udacityBase + "users/\(UserData.key)"
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
                print(error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(OTMResults.self, from: data)
                completion(responseObject.results, nil)
                //print("RESULT !!! \(OTMModel.studentsLocations)")
            } catch {
                completion([], error)
                print("error: \(error)")
            }
        }
        
        task.resume()
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
            //print(String(data: newData, encoding: .utf8)!)
            
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
                //print(String(data: newData, encoding: .utf8)!)
                
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
                //print(String(data: newData, encoding: .utf8)!)
                
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    print(responseObject)
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
                UserData.key = response.account.key
                Auth.sessionId = response.session.id

                print("****** LOGIN OTMCLIENT ********")
                print(UserData.key)
                print(Auth.sessionId)
                print(UserData.objectId)
                print("****** END LOGIN OTMCLIENT ********")
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
                print(error)
                return
            }
            UserData.key = ""
            Auth.sessionId = ""
            
            completion()
            
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            //print(String(data: newData!, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
    
    class func getUserData(completion : @escaping (User?,Error?)->Void) {
        let request = Endpoints.publicUserData.url
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                
                let decoder = JSONDecoder()
                do {
                    
                    let responseObject = try decoder.decode(User.self, from: newData!)
                    //print("****** GETUSERDATA OTMCLIENT ********")
                    //print(String(data: newData!, encoding: .utf8)!)
                    UserData.firstName = responseObject.firstName
                    UserData.lastName = responseObject.lastName
                    UserData.mediaURL = responseObject.mediaURL ?? ""
                    UserData.objectId = responseObject.objectId ?? ""
                    print("*** GETUSERDATA OTMCLIENT ***")
                    print(UserData.firstName + " " + UserData.lastName + " " + UserData.mediaURL)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    print("Error in Udacity Client Login Func")
                    print(error)
                    return
                }
            }
            task.resume()
        }
    
    class func postStudentLocation(mapString: String,
                                   mediaURL: String,
                                   latitude: Float,
                                   longitude: Float,
                                   completion: @escaping (Bool, Error?) -> Void) {
        
        let body = AddStudentLocation(uniqueKey: UserData.key, firstName: UserData.firstName, lastName: UserData.lastName, mapString: UserData.mapString, mediaURL: UserData.mediaURL, latitude: UserData.latitude, longitude: UserData.longitude)
        
        var urlString: String
        
        if (UserData.objectId == "") {
            urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"
        } else {
            urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/\(UserData.objectId)"
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        if (UserData.objectId == "") {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "PUT"
        }
        

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
    
                if (UserData.objectId == "") {
                    let responseObject = try decoder.decode(AddLocationResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(true, nil)
                        UserData.objectId = responseObject.objectId
                        print("****** POSTSTUDENTLOCATION OTMCLIENT ********")
                        print(responseObject)
                    }
                } else {
                    let responseObject = try decoder.decode(AddLocationResponse1.self, from: data)
                    DispatchQueue.main.async {
                        completion(true, nil)
                        print("*** POSTSTUDENTLOCATION OTMCLIENT ***")
                        print(responseObject)
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(false, error)
                }
            }
        }
        /*
        let task = session.dataTask(with: request) {data, response, error in
            if  data != nil {
                print(String(data: data!, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        
            if error != nil { // Handle error..
                print(error)
                DispatchQueue.main.async {
                    completion(false, error)
                }
                
            }
        }
         */
        task.resume()
    }


}
