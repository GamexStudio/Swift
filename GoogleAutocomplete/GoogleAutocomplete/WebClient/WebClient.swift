//
//  WebClient.swift
//  WebClient-Swift
//

//
//

import UIKit
import Alamofire

var kInternetConnectionMessage = "Please check your internet connection"
var kTryAgainLaterMessage = "Please try again later"
var kErrorDomain = "Error"
var kDefaultErrorCode = 1234

var kSuccessKey = "status"
var kMessageKey = "message"
var kDataKey = "data"

/**
# MultipartFormDataBlock
 
**Snippet**
multipartFormData.appendBodyPart(data: name : )
multipartFormData.appendBodyPart(data: name : mimeType:)

**Example**

    
    multipartFormData: { multipartFormData in
    multipartFormData.appendBodyPart(data: self.name.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"article[name]")
    for var i = 0; i < self.photoArray.count; i++ {
        let imageData = UIImageJPEGRepresentation(self.photoArray[i], 1)

        multipartFormData.appendBodyPart(data: imageData!, name: "article[article_images_attributes][][image]", mimeType: "image/jpeg")
 
    }
*/
typealias MultipartFormDataBlock = (_ multipartFormData : MultipartFormData?) -> Void
typealias CompletionBlock = (_ response: Any?, _ error: Error?) -> Void
typealias DownloadCompletionBlock = (_ filePath: String?, _ fileData: Data?, _ error: Error?) -> Void
typealias ResponseHandler = (_ response:DataResponse<Any>) -> Void

class WebClient: NSObject {
    
    //MARK: - Request
    
    class func requestWithUrlWithoutResponseValidation(url: String, parameters: Dictionary<String, Any>?, completion: CompletionBlock?) -> DataRequest? {
        
        let param = parameters ?? Dictionary()
//        print("Param = \(param)")
        return Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
//                    handleResponse(response: value, completion: completion)
                    completion?(value, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(nil, error)
                }
        }
    }
    
    class func requestWithUrl(url: String, parameters: Dictionary<String, Any>?, completion: CompletionBlock?) -> DataRequest? {
        
        let param = parameters ?? Dictionary()
//        print("Param = \(param)")
        return Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: URLEncoding.default, headers: nil)
            .validate()            
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    handleResponse(response: value, completion: completion)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(nil, error)
                }
        }
    }
    
    //MARK: - Upload requests
    
/**
#   Multipart uploads
     
*[MultipartFormDataBlock](@MultipartFormDataBlock)
     
    - parameters:
     - url: The url in string where the data needs to be uploaded
     - multiPartFormDataBlock: Is a block of type MultipartFormDataBlock
     - completion: Is a block of type CompletionBlock
*/

    
    
    
    class func multiPartRequestWithUrl(url: String, parameters: Dictionary<String,Any>?, multiPartFormDataBlock: MultipartFormDataBlock?, completion: CompletionBlock?) -> Void {
        let param : Dictionary! = parameters ?? Dictionary()
        Alamofire.upload(multipartFormData: { (multiPartFormData) in
            multiPartFormDataBlock?(multiPartFormData)            
            if param != nil {
                for (key, value) in param! {
                    multiPartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: url, encodingCompletion:{encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        handleResponse(response: value, completion: completion)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion?(nil, error)
                    }
                }
            case .failure(let encodingError):
                completion?(nil, encodingError)
            }
            
        })
    }
    
    //MARK: - Upload Media

    class func uploadMedia(url: String = "", mediaType: String, image : UIImage? = nil, fileUrl : URL? = nil, completion: @escaping (Dictionary<String,Any>?, String?, Error?) -> Void) {
        let imageToUpload = image//image?.fixOrientation()
        WebClient.multiPartRequestWithUrl(url: url, parameters: ["type" : mediaType], multiPartFormDataBlock: { (formData) in
            if imageToUpload != nil {
                formData?.append(UIImageJPEGRepresentation(imageToUpload!, 0.7)!, withName: "media_file", fileName: "file.jpg", mimeType: "image/jpeg")
            }
            else {
                formData?.append(fileUrl!, withName: "media_file")
            }
        }) { (responseObject, error) in
            if error == nil {
                let dictData = (responseObject as? Dictionary<String, Any>)?["data"] as? Dictionary<String, Any>
                completion(responseObject as? Dictionary<String, Any>, dictData?["filename"] as? String, error)
            }
            else {
                completion(nil, nil, error)
            }
        }
    }
    
    // main queue by default
    class func upload(file:URL,url:String, progressHandler:@escaping Request.ProgressHandler, responseHandler:@escaping ResponseHandler){
        Alamofire.upload(file, to: url)
            .uploadProgress { progress in
                progressHandler(progress)
            }
            .downloadProgress { progress in
                progressHandler(progress)
            }
            .responseJSON { response in
                responseHandler(response)
        }
    }
    
    //MARK: - Handle Response
    
    class func handleResponse(response: Any?, completion: CompletionBlock?) {
       // print(response ?? "Response nil")
        let error = NSError(domain: kErrorDomain, code: kDefaultErrorCode, userInfo: [NSLocalizedDescriptionKey: kTryAgainLaterMessage])
        if !(response is [AnyHashable: Any]) {
            completion?(nil, error)
        }
        else {
            var codeKey = kSuccessKey
            var messageKey = kMessageKey
            var success = 0
            if (response as! Dictionary<String, Any>).has(kSuccessKey) {
                success = (response as! [AnyHashable: Any])[kSuccessKey] as! Int
            }
            else if (response as! Dictionary<String, Any>).has("Successful") {
                //This is for race api 
                success = ((response as! [AnyHashable: Any])["Successful"] as! Bool) == true ? 1 : 0
                codeKey = "Successful"
                messageKey = "Message"
            }
            
            
            if success == 1 {
                completion?(response, nil)
                
            }else if success == -1 {
                
                //AppDelegate.shared.navigationController.popToRootViewController(animated: true)
                completion?(nil, NSError(domain: "", code: (response as! [AnyHashable: Any])[codeKey] as! Int, userInfo: [NSLocalizedDescriptionKey :(response as! [AnyHashable: Any])[messageKey] as! String ]))
                
            }
            else {
                completion?(nil, NSError(domain: "", code: (response as! [AnyHashable: Any])[codeKey] as! Int, userInfo: [NSLocalizedDescriptionKey :(response as! [AnyHashable: Any])[messageKey] as! String ]))
            }
        }
    }
    
    // MARK: - Download File
    
    class func downloadFile(url: String, downloadCompletionBlock: DownloadCompletionBlock?) -> DownloadRequest? {
        return Alamofire.download(url)
            .downloadProgress(closure: { progress in
                
            })
            .responseData { response in
                switch response.result {
                case .success(let value):
                    downloadCompletionBlock?(nil, value, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    downloadCompletionBlock?(nil, nil, error)
                }
        }
    }
    
    class func downloadFile(url: String, atUrl: URL, downloadCompletionBlock: DownloadCompletionBlock?) -> DownloadRequest? {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (atUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        return Alamofire.download(url, to: destination).response { response in
            if response.error == nil, let imagePath = response.destinationURL?.path {
                downloadCompletionBlock?(imagePath, nil, nil)
            }
            else {
                downloadCompletionBlock?(nil, nil, response.error)
            }
        }
    }
}


