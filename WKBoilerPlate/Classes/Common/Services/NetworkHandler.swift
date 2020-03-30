//
//  NetworkHandler.swift
//  WKBoilerPlate
//
//  Created by Brian on 21/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Alamofire
import Foundation

typealias OnSuccess = (_ response: Any) -> Void
typealias OnFailure = (_ errorMessage: String) -> Void
typealias OnApiSuccess = (_ jsondata: [String: Any]) -> Void
typealias OnApiFailure = (_ errorMessage: String, _ errorType: ErrorType) -> Void
typealias OnTaskSuccess = (_ status: Bool) -> Void

let kTimeOutInterval = 60.0
let networkFailureMessage = "Please check your internet connection"
let sessionExpiryMessage = "Session Expired. Please retry"

enum RequestContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case html = "text/html"
    case multipartFormData = "multipart/form-data"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

class NetworkHandler {
    /**
     To get the authentication token for the user
     - Used in the headers of backend API calls
     - returns: authorization token as String
     */
    static func getBasicAuthentication() -> String? {
        guard let sessionToken = UserDefaults.standard.object(forKey: Constants.Defaults.authToken) as? String else {
            return ""
        }
        return sessionToken.isEmpty ? "" : "Bearer \(sessionToken)"
    }

    /**
     To construct the HTTP Headers for all requests
     - returns: HTTPHeaders as Dictionary
     */
    static func getHttpHeaders(forRequest isMultipart: Bool) -> HTTPHeaders {
        let type = isMultipart ? RequestContentType.multipartFormData.rawValue : RequestContentType.json.rawValue
        var headers: [HTTPHeader] = [HTTPHeader(name: "Content-Type", value: type)]
        if !NetworkHandler.getBasicAuthentication()!.isEmpty {
            headers.append(HTTPHeader(name: "Authorization", value: NetworkHandler.getBasicAuthentication()!))
        }
        return HTTPHeaders(headers)
    }

    /**
     Common method for all type of API calls, considering the parameters as a Dictionary
     - supported HTTP methods - GET, POST, PUT
     - Parameter endPoint: API endpoint
     - Parameter paramDict: all request parameters as a Dictionary
     - Parameter method: HTTP method type
     - Parameter OnApiSuccess: success handler, return response JSON
     - Parameter OnApiFailure: error handler, return error message and error code
     */
    static func apiRequest(endPoint: String,
                           paramDict: [String: Any],
                           method: HTTPMethod,
                           onSuccess success: @escaping OnApiSuccess,
                           onFailure failure: @escaping OnApiFailure) {
        guard let paramData = try? JSONSerialization.data(withJSONObject: paramDict, options: []) else {
            return
        }
        print(paramDict)
        NetworkHandler.apiRequest(endPoint: endPoint,
                                  paramData: paramData,
                                  method: method,
                                  onSuccess: { responseDict in
                success(responseDict)
            }, onFailure: { errorMsg, errorType in
                failure(errorMsg, errorType)
            })
    }

    /**
     Common method for all type of API calls, considering the parameters in Data format
     - supported HTTP methods - GET, POST, PUT
     - Parameter endPoint: API endpoint
     - Parameter paramData: request parameters in Data format (possibly converted to data from model object)
     - Parameter method: HTTP method type
     - Parameter OnApiSuccess: success handler, return response JSON
     - Parameter onApiFailure: error handler, return error message and error code
     */
    static func apiRequest(endPoint: String,
                           paramData: Data?,
                           method: HTTPMethod,
                           onSuccess success: @escaping OnApiSuccess,
                           onFailure failure: @escaping OnApiFailure) {
        if NetworkReachabilityManager()!.isReachable == false {
            failure(networkFailureMessage, ErrorType.networkError)
        }
        let postUrl: String = AppConfig.getActiveBaseURL() + endPoint
        let request = NSMutableURLRequest(url: NSURL(string: postUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: kTimeOutInterval)
        request.allHTTPHeaderFields = self.getHttpHeaders(forRequest: false).dictionary
        request.httpMethod = method.rawValue
        do {
            let json = try JSONSerialization.jsonObject(with: paramData!, options: []) as? [String: Any]
            if json?.count ?? 0 > 0 {
                request.httpBody = (paramData != nil) ? paramData : nil
            }
            print(json ?? [:])
        } catch {
            print("params json serialization error ")
        }
        print(postUrl)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { data, response, error -> Void in
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse as Any)
            guard let statusCode = (httpResponse?.statusCode) else {
                return
            }
            if error != nil {
                print(error as Any)
                failure(error?.localizedDescription ?? "", .httpError)
            } else {
                NetworkHandler.handleResponseData(jsonData: data!,
                                                  statusCode: statusCode,
                                                  successCallback: { responseDict in
                    success(responseDict)
                }, failureCallback: { errorMsg, errorType in
                    failure(errorMsg, errorType)
                })
            }
         })
        dataTask.resume()
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    /**
     Method for posting Publications API with multipartFormData for image, video files
     - supported HTTP methods - POST
     - Parameter endPoint: API endpoint
     - Parameter paramDict: a dictionary with request parameters
     - Parameter filesDict: a dictionary with the files to upload
     - Parameter method: HTTP method type
     - Parameter OnApiSuccess: success handler, return response JSON
     - Parameter OnApiFailure: error handler, return error message and error code
     */
    static func serviceCallForMultipartFormData(endPoint: String,
                                                paramDict: [String: Any],
                                                files: (Int, [String: Any]),
                                                method: HTTPMethod,
                                                onSuccess success: @escaping OnApiSuccess,
                                                onFailure failure: @escaping OnApiFailure) {
        if NetworkReachabilityManager()!.isReachable == false {
            failure("Please check your internet connection", .networkError)
        } else {
            let postUrl: String = AppConfig.getActiveBaseURL() + endPoint
            print(postUrl)
            print(paramDict)
            print(files)
            
            var response: DataResponse<Data?, AFError>?
            AF.upload(multipartFormData: { multipartFormData in
                //params
                for(key, value) in paramDict {
                    let strVal = value as? String
                    let valueAsData = strVal?.data(using: String.Encoding.utf8)
                    multipartFormData.append(valueAsData ?? Data(), withName: key)
                }
                //files
                switch files.0 {
                case UploadFileType.imageFile.rawValue:
                    for(key, value) in files.1 {
                        let file = value as? UIImage
                        let fileData = file?.pngData()
                        multipartFormData.append(fileData ?? Data(),
                                                 withName: key,
                                                 fileName: "content.png",
                                                 mimeType: "image/png")
                    }
                case UploadFileType.videoFile.rawValue:
                    break
                default:
                    break
                }
            }, to: postUrl).response { resp in
                response = resp
                do {
                    // here "decoded" is of type `Any`, decoded from JSON data
                    let decoded = try JSONSerialization.jsonObject(with: response?.data ?? Data(), options: [])
                    // you can now cast it with the right type
                    if let jsonDict = decoded as? [String: String] {
                        let statusCode = resp.response?.statusCode ?? 0
                        if !jsonDict.isEmpty {
                            // success response for statuscode 200 series
                            if statusCode > 199 && statusCode < 300 {
                                success(jsonDict)
                            } else {
                                // error handling for all other status codes
                                NetworkHandler.handleErrorFromResponseJSON(jsonData: jsonDict,
                                                                           statusCode: statusCode,
                                                                           failureCallBack: { errorMessage in
                                                                            print(errorMessage)
                                    failure(errorMessage, .invalidResponseError)
                                })
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    failure(error.localizedDescription, ErrorType.httpError)
                }
            }
        }
    }

    // MARK: - Response Data Handling

    /**
    Common method to handle the response data from all APIs
    - Parameter jsonData: response Data
    - Parameter statusCode: HTTP status code received
    - Parameter OnApiSuccess: success handler, returns response JSON
    - Parameter OnAPIFailure: error handler, returns error message to be displayed and  the error type as well
    */
    static func handleResponseData(jsonData: Data,
                                   statusCode: Int,
                                   successCallback onAPISuccess: @escaping OnApiSuccess,
                                   failureCallback onAPIFailure: @escaping OnApiFailure) {
        let responseData = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        if let dictFromJSON = responseData as? [String: Any] {
            print(dictFromJSON as Any)
            switch statusCode {
            case 200...299:
                onAPISuccess(dictFromJSON)
            default:
                NetworkHandler.handleErrorFromResponseJSON(jsonData: dictFromJSON,
                                                           statusCode: statusCode,
                                                           failureCallBack: { errorMessage in
                                                            print(errorMessage)
                    onAPIFailure(errorMessage, .httpError)
                })
            }
        } else if statusCode == 204 {
            // Usually on a successful api hit, if an email/sms got triggered and there is no data to be returned, the data will be returned empty.
            if jsonData.isEmpty {
                onAPISuccess([:])
            }
        }
    }

    // MARK: - Response Error Handling

    /**
     Common method to handle all error Responses from all APIs
     - Parameter jsonData: error dictionary
     - Parameter statusCode: HTTP error code or status code received
     - Parameter onFailure: error handler, returns error message to be displayed to user when required.
     */
    static func handleErrorFromResponseJSON(jsonData: [String: Any],
                                            statusCode: Int,
                                            failureCallBack onFailure: @escaping OnFailure) {
        //Handle Auth Token expiry
        if statusCode == 401 && !NetworkHandler.getBasicAuthentication()!.isEmpty {
            UserManager.shared.refreshToken { success in
                if success {
                    onFailure("Session restored. Please retry.")
                } else {
                    onFailure("Session expired. Failed to restore session automatically.")
                }
            }
        } else {
            guard let msg = jsonData[Constants.ResponseKey.messages] as? String else {
                let fallbackErrorMessage = "Something went wrong, please retry."
                let errors = jsonData[Constants.ResponseKey.errors]
                if errors != nil {
                    if errors is [String: Any] {
                        let errorDict = errors as? [String: Any]
                        let messages = errorDict?[Constants.ResponseKey.messages]
                        if messages is String {
                            /* ["errors": {
                                   messages = "xyz must be a valid integer value"
                                 }]  */
                            onFailure(messages as? String ?? fallbackErrorMessage)
                            return
                        } else if messages is [String] {
                            /* ["errors": {
                                   messages =   (
                                         "xyz must be a valid integer value"
                                   );
                                 }]  */
                            let messagesArray = messages as? [String]
                            onFailure(messagesArray?[0] ?? fallbackErrorMessage)
                            return
                        } else if messages is [String: Any] {
                            /* ["errors": {
                                    messages =   (
                                          age: "xyz must be a valid integer value"
                                    );
                                  }]  */
                            let errorMessagesDict = messages as? [String: Any] ?? [:]
                            for key in errorMessagesDict.keys where errorMessagesDict[key] is String {
                                let errMsg = errorMessagesDict[key] as? String ?? fallbackErrorMessage
                                onFailure(errMsg)
                                return
                            }
                        }
                    } else if errors is String {
                        /* ["errors": "xyz must be a valid integer value"]  */
                        let errorMessage = errors as? String
                        onFailure(errorMessage ?? fallbackErrorMessage)
                        return
                    }
                }
                onFailure(fallbackErrorMessage)
                return
            }
            /* ["messages": "xyz"]  */
            onFailure(msg)
        }
    }
}
