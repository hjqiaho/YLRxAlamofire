//
//  RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. (@bontojr) on 23/08/15.
//  Developed with the kind help of Krunoslav Zaher (@KrunoslavZaher)
//
//  Updated by Ivan Đikić for the latest version of Alamofire(3) and RxSwift(2) on 21/10/15
//  Updated by Krunoslav Zaher to better wrap Alamofire (3) on 1/10/15
//
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

/// Default instance of unknown error
public let RxAlamofireUnknownError = NSError(domain: "RxAlamofireDomain", code: -1, userInfo: nil)

// MARK: Convenience functions

/**
 Creates a NSMutableURLRequest using all necessary parameters.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers
 - returns: An instance of `NSMutableURLRequest`
 */

public func urlRequest(_ method: Alamofire.HTTPMethod,
                       _ url: URLConvertible,
                       parameters: [String: Any]? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: [String: String]? = nil)
  throws -> Foundation.URLRequest {
  var mutableURLRequest = Foundation.URLRequest(url: try url.asURL())
  mutableURLRequest.httpMethod = method.rawValue

  if let headers = headers {
    for (headerField, headerValue) in headers {
      mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
    }
  }

  if let parameters = parameters {
    mutableURLRequest = try encoding.encode(mutableURLRequest, with: parameters)
  }

  return mutableURLRequest
}

// MARK: Request

/**
 Creates an observable of the generated `Request`.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of a the `Request`
 */
public func request(_ method: Alamofire.HTTPMethod,
                    _ url: URLConvertible,
                    parameters: [String: Any]? = nil,
                    encoding: ParameterEncoding = URLEncoding.default,
                    headers: [String: String]? = nil)
  -> Observable<DataRequest> {
  return SessionManager.default.rx.request(method,
                                           url,
                                           parameters: parameters,
                                           encoding: encoding,
                                           headers: headers)
}

/**
 Creates an observable of the generated `Request`.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of a the `Request`
 */
public func request(_ urlRequest: URLRequestConvertible) -> Observable<DataRequest> {
  return SessionManager.default.rx.request(urlRequest: urlRequest)
}

// MARK: data

/**
 Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
 */
public func requestData(_ method: Alamofire.HTTPMethod,
                        _ url: URLConvertible,
                        parameters: [String: Any]? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: [String: String]? = nil)
  -> Observable<(DataResponse<Data>, Data)> {
  return SessionManager.default.rx.responseData(method,
                                                url,
                                                parameters: parameters,
                                                encoding: encoding,
                                                headers: headers)
}

/**
 Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
 */
public func requestData(_ urlRequest: URLRequestConvertible) -> Observable<(DataResponse<Data>, Data)> {
  return request(urlRequest).flatMap { $0.rx.responseData() }
}

/**
 Creates an observable of the returned data.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of `NSData`
 */
public func data(_ method: Alamofire.HTTPMethod,
                 _ url: URLConvertible,
                 parameters: [String: Any]? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: [String: String]? = nil)
  -> Observable<Data> {
  return SessionManager.default.rx.data(method,
                                        url,
                                        parameters: parameters,
                                        encoding: encoding,
                                        headers: headers)
}

// MARK: string

/**
 Creates an observable of the returned decoded string and response.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
 */
public func requestString(_ method: Alamofire.HTTPMethod,
                          _ url: URLConvertible,
                          parameters: [String: Any]? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          headers: [String: String]? = nil)
  -> Observable<(DataResponse<String>, String)> {
  return SessionManager.default.rx.responseString(method,
                                                  url,
                                                  parameters: parameters,
                                                  encoding: encoding,
                                                  headers: headers)
}

/**
 Creates an observable of the returned decoded string and response.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
 */
public func requestString(_ urlRequest: URLRequestConvertible) -> Observable<(DataResponse<String>, String)> {
  return request(urlRequest).flatMap { $0.rx.responseString() }
}

/**
 Creates an observable of the returned decoded string.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of `String`
 */
public func string(_ method: Alamofire.HTTPMethod,
                   _ url: URLConvertible,
                   parameters: [String: Any]? = nil,
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: [String: String]? = nil)
  -> Observable<String> {
  return SessionManager.default.rx.string(method,
                                          url,
                                          parameters: parameters,
                                          encoding: encoding,
                                          headers: headers)
}

// MARK: JSON

/**
 Creates an observable of the returned decoded JSON as `AnyObject` and the response.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
 */
public func requestJSON(_ method: Alamofire.HTTPMethod,
                        _ url: URLConvertible,
                        parameters: [String: Any]? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: [String: String]? = nil)
  -> Observable<(DataResponse<Any>, Any)> {
  return SessionManager.default.rx.responseJSON(method,
                                                url,
                                                parameters: parameters,
                                                encoding: encoding,
                                                headers: headers)
}

/**
 Creates an observable of the returned decoded JSON as `AnyObject` and the response.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
 */
public func requestJSON(_ urlRequest: URLRequestConvertible) -> Observable<(DataResponse<Any>, Any)> {
  return request(urlRequest).flatMap { $0.rx.responseJSON() }
}

/**
 Creates an observable of the returned decoded JSON.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of the decoded JSON as `Any`
 */
public func json(_ method: Alamofire.HTTPMethod,
                 _ url: URLConvertible,
                 parameters: [String: Any]? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: [String: String]? = nil)
  -> Observable<Any> {
  return SessionManager.default.rx.json(method,
                                        url,
                                        parameters: parameters,
                                        encoding: encoding,
                                        headers: headers)
}

// MARK: Upload

/**
 Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
 The request is started immediately.

 - parameter urlRequest: The request object to start the upload.
 - paramenter file: An instance of NSURL holding the information of the local file.
 - returns: The observable of `UploadRequest` for the created request.
 */
public func upload(_ file: URL, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
  return SessionManager.default.rx.upload(file, urlRequest: urlRequest)
}

/**
 Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
 The request is started immediately.

 - parameter urlRequest: The request object to start the upload.
 - paramenter data: An instance of NSData holdint the data to upload.
 - returns: The observable of `UploadRequest` for the created request.
 */
public func upload(_ data: Data, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
  return SessionManager.default.rx.upload(data, urlRequest: urlRequest)
}

/**
 Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
 The request is started immediately.

 - parameter urlRequest: The request object to start the upload.
 - paramenter stream: The stream to upload.
 - returns: The observable of `Request` for the created upload request.
 */
public func upload(_ stream: InputStream, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
  return SessionManager.default.rx.upload(stream, urlRequest: urlRequest)
}

// MARK: Download

/**
 Creates a download request using the shared manager instance for the specified URL request.
 - parameter urlRequest:  The URL request.
 - parameter destination: The closure used to determine the destination of the downloaded file.
 - returns: The observable of `DownloadRequest` for the created download request.
 */
public func download(_ urlRequest: URLRequestConvertible,
                     to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
  return SessionManager.default.rx.download(urlRequest, to: destination)
}

// MARK: Resume Data

/**
 Creates a request using the shared manager instance for downloading from the resume data produced from a
 previous request cancellation.

 - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
 when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
 information.
 - parameter destination: The closure used to determine the destination of the downloaded file.
 - returns: The observable of `Request` for the created download request.
 */
public func download(resumeData: Data,
                     to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
  return SessionManager.default.rx.download(resumeData: resumeData, to: destination)
}

// MARK: Manager - Extension of Manager

extension SessionManager: ReactiveCompatible {}

protocol RxAlamofireRequest {
  func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void)
  func resume()
  func cancel()
}

protocol RxAlamofireResponse {
  var error: Error? { get }
}

extension DefaultDataResponse: RxAlamofireResponse {}

extension DefaultDownloadResponse: RxAlamofireResponse {}

extension DataRequest: RxAlamofireRequest {
  func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
    response { response in
      completionHandler(response)
    }
  }
}

extension DownloadRequest: RxAlamofireRequest {
  func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
    response { response in
      completionHandler(response)
    }
  }
}

extension Reactive where Base: SessionManager {
  // MARK: Generic request convenience

  /**
   Creates an observable of the DataRequest.

   - parameter createRequest: A function used to create a `Request` using a `Manager`

   - returns: A generic observable of created data request
   */
  func request<R: RxAlamofireRequest>(_ createRequest: @escaping (SessionManager) throws -> R) -> Observable<R> {
    return Observable.create { observer -> Disposable in
      let request: R
      do {
        request = try createRequest(self.base)
        observer.on(.next(request))
        request.responseWith(completionHandler: { response in
          if let error = response.error {
            observer.on(.error(error))
          } else {
            observer.on(.completed)
          }
        })

        if !self.base.startRequestsImmediately {
          request.resume()
        }

        return Disposables.create {
          request.cancel()
        }
      } catch {
        observer.on(.error(error))
        return Disposables.create()
      }
    }
  }

  /**
   Creates an observable of the `Request`.

   - parameter method: Alamofire method object
   - parameter url: An object adopting `URLConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of the `Request`
   */
  public func request(_ method: Alamofire.HTTPMethod,
                      _ url: URLConvertible,
                      parameters: [String: Any]? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: [String: String]? = nil)
    -> Observable<DataRequest> {
    return request { manager in
      manager.request(url,
                      method: method,
                      parameters: parameters,
                      encoding: encoding,
                      headers: headers)
    }
  }

  /**
   Creates an observable of the `Request`.

   - parameter URLRequest: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of the `Request`
   */
  public func request(urlRequest: URLRequestConvertible)
    -> Observable<DataRequest> {
    return request { manager in
      manager.request(urlRequest)
    }
  }

  // MARK: data

  /**
   Creates an observable of the data.

   - parameter url: An object adopting `URLConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of the tuple `(NSHTTPURLResponse, NSData)`
   */
  public func responseData(_ method: Alamofire.HTTPMethod,
                           _ url: URLConvertible,
                           parameters: [String: Any]? = nil,
                           encoding: ParameterEncoding = URLEncoding.default,
                           headers: [String: String]? = nil)
    -> Observable<(DataResponse<Data>, Data)> {
    return request(method,
                   url,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).flatMap { $0.rx.responseData() }
  }

  /**
   Creates an observable of the data.

   - parameter URLRequest: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of `NSData`
   */
  public func data(_ method: Alamofire.HTTPMethod,
                   _ url: URLConvertible,
                   parameters: [String: Any]? = nil,
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: [String: String]? = nil)
    -> Observable<Data> {
    return request(method,
                   url,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).flatMap { $0.rx.data() }
  }

  // MARK: string

  /**
   Creates an observable of the tuple `(NSHTTPURLResponse, String)`.

   - parameter url: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
   */
  public func responseString(_ method: Alamofire.HTTPMethod,
                             _ url: URLConvertible,
                             parameters: [String: Any]? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: [String: String]? = nil)
    -> Observable<(DataResponse<String>, String)> {
    return request(method,
                   url,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).flatMap { $0.rx.responseString() }
  }

  /**
   Creates an observable of the data encoded as String.

   - parameter url: An object adopting `URLConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of `String`
   */
  public func string(_ method: Alamofire.HTTPMethod,
                     _ url: URLConvertible,
                     parameters: [String: Any]? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: [String: String]? = nil)
    -> Observable<String> {
    return request(method,
                   url,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
      .flatMap { (request) -> Observable<String> in
        request.rx.string()
      }
  }

  // MARK: JSON

  /**
   Creates an observable of the data decoded from JSON and processed as tuple `(NSHTTPURLResponse, AnyObject)`.

   - parameter url: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
   */
  public func responseJSON(_ method: Alamofire.HTTPMethod,
                           _ url: URLConvertible,
                           parameters: [String: Any]? = nil,
                           encoding: ParameterEncoding = URLEncoding.default,
                           headers: [String: String]? = nil)
    -> Observable<(DataResponse<Any>, Any)> {
    return request(method,
                   url,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).flatMap { $0.rx.responseJSON() }
  }

  /**
   Creates an observable of the data decoded from JSON and processed as `AnyObject`.

   - parameter URLRequest: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter header: A dictionary containing all the additional headers

   - returns: An observable of `AnyObject`
   */
  public func json(_ method: Alamofire.HTTPMethod,
                   _ url: URLConvertible,
                   parameters: [String: Any]? = nil,
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: [String: String]? = nil)
    -> Observable<Any> {
    return request(method,
                   url,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).flatMap { $0.rx.json() }
  }

  // MARK: Upload

  /**
   Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
   The request is started immediately.

   - parameter urlRequest: The request object to start the upload.
   - paramenter file: An instance of NSURL holding the information of the local file.
   - returns: The observable of `AnyObject` for the created request.
   */
  public func upload(_ file: URL, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
    return request { manager in
      manager.upload(file, with: urlRequest)
    }
  }

  /**
   Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
   The request is started immediately.

   - parameter urlRequest: The request object to start the upload.
   - paramenter data: An instance of Data holdint the data to upload.
   - returns: The observable of `UploadRequest` for the created request.
   */
  public func upload(_ data: Data, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
    return request { manager in
      manager.upload(data, with: urlRequest)
    }
  }

  /**
   Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
   The request is started immediately.

   - parameter urlRequest: The request object to start the upload.
   - paramenter stream: The stream to upload.
   - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
   */
  public func upload(_ stream: InputStream,
                     urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
    return request { manager in
      manager.upload(stream, with: urlRequest)
    }
  }

  // MARK: Download

  /**
   Creates a download request using the shared manager instance for the specified URL request.
   - parameter urlRequest:  The URL request.
   - parameter destination: The closure used to determine the destination of the downloaded file.
   - returns: The observable of `(NSData?, RxProgress)` for the created download request.
   */
  public func download(_ urlRequest: URLRequestConvertible,
                       to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
    return request { manager in
      manager.download(urlRequest, to: destination)
    }
  }

  /**
   Creates a request using the shared manager instance for downloading with a resume data produced from a
   previous request cancellation.

   - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
   when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
   information.
   - parameter destination: The closure used to determine the destination of the downloaded file.
   - returns: The observable of `(NSData?, RxProgress)` for the created download request.
   */
  public func download(resumeData: Data,
                       to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
    return request { manager in
      manager.download(resumingWith: resumeData, to: destination)
    }
  }
}

// MARK: Request - Common Response Handlers

extension ObservableType where Element == DataRequest {
  public func responseJSON() -> Observable<DataResponse<Any>> {
    return flatMap { $0.rx.responseJSON() }
  }

  public func json(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
    return flatMap { $0.rx.json(options: options) }
  }

  public func responseString(encoding: String.Encoding? = nil) -> Observable<(DataResponse<String>, String)> {
    return flatMap { $0.rx.responseString(encoding: encoding) }
  }

  public func string(encoding: String.Encoding? = nil) -> Observable<String> {
    return flatMap { $0.rx.string(encoding: encoding) }
  }

  public func responseData() -> Observable<(DataResponse<Data>, Data)> {
    return flatMap { $0.rx.responseData() }
  }

  public func data() -> Observable<Data> {
    return flatMap { $0.rx.data() }
  }

  public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<(DataResponse<Any>, Any)> {
    return flatMap { $0.rx.responsePropertyList(options: options) }
  }

  public func propertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<Any> {
    return flatMap { $0.rx.propertyList(options: options) }
  }

  public func progress() -> Observable<RxProgress> {
    return flatMap { $0.rx.progress() }
  }
}

extension ObservableType where Element: DownloadRequest {
    
  public func response() -> Observable<DefaultDownloadResponse> {
    return flatMap { $0.rx.response() }
  }
    
  public func responseSerialized<Serializer: DownloadResponseSerializerProtocol>(
    queue: DispatchQueue? = nil,
    responseSerializer: Serializer
  )
    -> Observable<DownloadResponse<Serializer.SerializedObject>>
  {
    return flatMap { $0.rx.responseSerialized(queue: queue, responseSerializer: responseSerializer) }
  }
    
  public func responseResult<Serializer: DownloadResponseSerializerProtocol>(
    queue: DispatchQueue? = nil,
    responseSerializer: Serializer
  )
    -> Observable<Serializer.SerializedObject>
  {
    return flatMap { $0.rx.responseResult(queue: queue, responseSerializer: responseSerializer) }
  }

}

// MARK: Request - Validation

extension ObservableType where Element == DataRequest {
  public func validate<S: Sequence>(statusCode: S) -> Observable<Element> where S.Element == Int {
    return map { $0.validate(statusCode: statusCode) }
  }

  public func validate() -> Observable<Element> {
    return map { $0.validate() }
  }

  public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<Element> where S.Iterator.Element == String {
    return map { $0.validate(contentType: acceptableContentTypes) }
  }

  public func validate(_ validation: @escaping DataRequest.Validation) -> Observable<Element> {
    return map { $0.validate(validation) }
  }
}

extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
  // MARK: Defaults

  /// - returns: A validated request based on the status code
  func validateSuccessfulResponse() -> DataRequest {
    return base.validate(statusCode: 200..<300)
  }

  /**
   Transform a request into an observable of the response and serialized object.

   - parameter queue: The dispatch queue to use.
   - parameter responseSerializer: The the serializer.
   - returns: The observable of `(NSHTTPURLResponse, T.SerializedObject)` for the created download request.
   */
  public func responseResult<T: DataResponseSerializerProtocol>(queue: DispatchQueue? = nil,
                                                                responseSerializer: T)
  -> Observable<(DataResponse<T.SerializedObject>, T.SerializedObject)> {
    return Observable.create { observer in
      let dataRequest = self.base
        .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
          switch packedResponse.result {
          case let .success(result):
            if packedResponse.response != nil {
              observer.on(.next((packedResponse, result)))
              observer.on(.completed)
            } else {
              observer.on(.error(RxAlamofireUnknownError))
            }
          case let .failure(error):
            let aferr  =  error as NSError
            if aferr.code == 4  {
                //json解析错误
                if packedResponse.response?.statusCode == 200 {
                    var dataStr = "【null】"
                    if let data = packedResponse.data {
                        dataStr = String(data:data,encoding:.utf8) ?? "【转换成字符串失败】"
                    }
                    let err = NSError.init(domain:aferr.domain,
                                           code: 200,
                                           userInfo: [NSLocalizedDescriptionKey:"返回数据无法解析：\(dataStr)"])
                    observer.on(.error(err))
                }else{
                    let err = NSError.init(domain:aferr.domain,
                                           code: packedResponse.response?.statusCode ?? aferr.code,
                                           userInfo: [NSLocalizedDescriptionKey:statusCodeMsg(statusCode: packedResponse.response?.statusCode, msg: aferr.localizedDescription)])
                    observer.on(.error(err))
                }
            }else{
                observer.on(.error(aferr))
            }
          }
        }
      return Disposables.create {
        dataRequest.cancel()
      }
    }
  }
    //处理请求错误码
    func statusCodeMsg(statusCode:Int?,msg:String) -> String {
        switch statusCode {
        
        case 100:
            return "请求者应当继续提出请求。 服务器返回此代码表示已收到请求的第一部分，正在等待其余部分。 "
        case 101:
            return "请求者已要求服务器切换协议，服务器已确认并准备切换。"
            
        case 300:
            return "针对请求，服务器可执行多种操作。"
        case 301:
            return "请求的网页已永久移动到新位置。服务器返回此响应（对GET或HEAD请求的响应）时，会自动将请求者转到新位置。"
        case 302:
            return "服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来进行以后的请求。"
        case 303:
            return "请求者应当对不同的位置使用单独的 GET 请求来检索响应时，服务器返回此代码。"
        case 304:
            return "自从上次请求后，请求的网页未修改过。 服务器返回此响应时，不会返回网页内容。"
        case 305:
            return "请求者只能使用代理访问请求的网页。 如果服务器返回此响应，还表示请求者应使用代理。"
        case 307:
            return "服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来进行以后的请求。"
            
            
        case 400:
            return "服务器不理解请求的语法。"
        case 401:
            return "请求要求身份验证。对于需要登录的网页，服务器可能返回此响应。"
        case 403:
            return "服务器拒绝请求。"
        case 404:
            return "服务器找不到请求的网页。"
        case 405:
            return "禁用请求中指定的方法。"
        case 406:
            return "无法使用请求的内容特性响应请求的网页。"
        case 407:
            return "此状态代码与 401（未授权）类似，但指定请求者应当授权使用代理。"
        case 408:
            return "服务器等候请求时发生超时。"
        case 409:
            return "服务器在完成请求时发生冲突。服务器必须在响应中包含有关冲突的信息。"
        case 410:
            return "请求的资源已永久删除。"
        case 411:
            return "服务器不接受不含有效内容长度标头字段的请求。"
        case 412:
            return "服务器未满足请求者在请求中设置的其中一个前提条件。"
        case 413:
            return "服务器无法处理请求，因为请求实体过大，超出服务器的处理能力。"
        case 414:
            return "请求的 URI（通常为网址）过长，服务器无法处理。"
        case 415:
            return "请求的格式不受请求页面的支持。"
        case 416:
            return "如果页面无法提供请求的范围，则服务器会返回此状态代码。"
        case 417:
            return "服务器未满足期望请求标头字段的要求。"
            
            
        case 500:
            return "服务器遇到错误，无法完成请求。"
        case 501:
            return "服务器不具备完成请求的功能。 例如，服务器无法识别请求方法。"
        case 502:
            return "服务器作为网关或代理，从上游服务器收到无效响应。"
        case 503:
            return "服务器目前无法使用（由于超载或停机维护）。 通常，这只是暂时状态。"
        case 504:
            return "服务器作为网关或代理，但是没有及时从上游服务器收到请求。"
        case 505:
            return "服务器不支持请求中所用的 HTTP 协议版本。"
            
            
        case 200:
            return "请求成功。"
        default:
            return msg
        }
    }
    
  public func responseJSON() -> Observable<DataResponse<Any>> {
    return Observable.create { observer in
      let request = self.base

      request.responseJSON { response in
        if let error = response.result.error {
          observer.on(.error(error))
        } else {
          observer.on(.next(response))
          observer.on(.completed)
        }
      }

      return Disposables.create {
        request.cancel()
      }
    }
  }

  /**
   Transform a request into an observable of the serialized object.

   - parameter queue: The dispatch queue to use.
   - parameter responseSerializer: The the serializer.
   - returns: The observable of `T.SerializedObject` for the created download request.
   */
  public func result<T: DataResponseSerializerProtocol>(queue: DispatchQueue? = nil,
                                                        responseSerializer: T)
    -> Observable<T.SerializedObject> {
    return Observable.create { observer in
      let dataRequest = self.validateSuccessfulResponse()
        .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
          switch packedResponse.result {
          case let .success(result):
            if let _ = packedResponse.response {
              observer.on(.next(result))
              observer.on(.completed)
            } else {
              observer.on(.error(RxAlamofireUnknownError))
            }
          case let .failure(error):
            observer.on(.error(error as Error))
          }
        }
      return Disposables.create {
        dataRequest.cancel()
      }
    }
  }

  /**
   Returns an `Observable` of NSData for the current request.

   - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`

   - returns: An instance of `Observable<NSData>`
   */
  public func responseData() -> Observable<(DataResponse<Data>, Data)> {
    return responseResult(responseSerializer: DataRequest.dataResponseSerializer())
  }

  public func data() -> Observable<Data> {
    return result(responseSerializer: DataRequest.dataResponseSerializer())
  }

  /**
   Returns an `Observable` of a String for the current request

   - parameter encoding: Type of the string encoding, **default:** `nil`

   - returns: An instance of `Observable<String>`
   */
  public func responseString(encoding: String.Encoding? = nil) -> Observable<(DataResponse<String>, String)> {
    return responseResult(responseSerializer: Base.stringResponseSerializer(encoding: encoding))
  }

  public func string(encoding: String.Encoding? = nil) -> Observable<String> {
    return result(responseSerializer: Base.stringResponseSerializer(encoding: encoding))
  }

  /**
   Returns an `Observable` of a serialized JSON for the current request.

   - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

   - returns: An instance of `Observable<AnyObject>`
   */
  public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<(DataResponse<Any>, Any)> {
    return responseResult(responseSerializer: Base.jsonResponseSerializer(options: options))
  }

  /**
   Returns an `Observable` of a serialized JSON for the current request.

   - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

   - returns: An instance of `Observable<AnyObject>`
   */
  public func json(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
    return result(responseSerializer: Base.jsonResponseSerializer(options: options))
  }

  /**
   Returns and `Observable` of a serialized property list for the current request.

   - parameter options: Property list reading options, **default:** `NSPropertyListReadOptions()`

   - returns: An instance of `Observable<AnyData>`
   */
  public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<(DataResponse<Any>, Any)> {
    return responseResult(responseSerializer: Base.propertyListResponseSerializer(options: options))
  }

  public func propertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<Any> {
    return result(responseSerializer: Base.propertyListResponseSerializer(options: options))
  }
}

// MARK: Reactive + DownloadRequest

extension Reactive where Base: DownloadRequest {
    
  public func response() -> Observable<DefaultDownloadResponse> {
    return Observable.create { observer in
      let request = self.base.response { response in
        if let error = response.error {
          observer.onError(error)
        } else {
          observer.onNext(response)
          observer.onCompleted()
        }
      }
      return Disposables.create(with: request.cancel)
    }
  }
    
  public func responseSerialized<Serializer: DownloadResponseSerializerProtocol>(
    queue: DispatchQueue? = nil,
    responseSerializer: Serializer
  )
    -> Observable<DownloadResponse<Serializer.SerializedObject>>
  {
    return Observable.create { observer in
      let request = self.base.response(
        queue: queue,
        responseSerializer: responseSerializer
      ) { response in
        if let error = response.error {
          observer.onError(error)
        } else {
          observer.onNext(response)
          observer.onCompleted()
        }
      }
      return Disposables.create(with: request.cancel)
    }
  }
    
  public func responseResult<Serializer: DownloadResponseSerializerProtocol>(
    queue: DispatchQueue? = nil,
    responseSerializer: Serializer
  )
    -> Observable<Serializer.SerializedObject>
  {
    return responseSerialized(queue: queue, responseSerializer: responseSerializer)
      .map {
        guard let value = $0.value else {
          throw RxAlamofireUnknownError
        }
        return value
      }
  }
}

extension Reactive where Base: Request {
  // MARK: Request - Upload and download progress

  /**
   Returns an `Observable` for the current progress status.

   Parameters on observed tuple:

   1. bytes written so far.
   1. total bytes to write.

   - returns: An instance of `Observable<RxProgress>`
   */
  public func progress() -> Observable<RxProgress> {
    return Observable.create { observer in
      let handler: Request.ProgressHandler = { progress in
        let rxProgress = RxProgress(bytesWritten: progress.completedUnitCount,
                                    totalBytes: progress.totalUnitCount)
        observer.on(.next(rxProgress))

        if rxProgress.bytesWritten >= rxProgress.totalBytes {
          observer.on(.completed)
        }
      }

      // Try in following order:
      //  - UploadRequest (Inherits from DataRequest, so we test the discrete case first)
      //  - DownloadRequest
      //  - DataRequest
      if let uploadReq = self.base as? UploadRequest {
        uploadReq.uploadProgress(closure: handler)
      } else if let downloadReq = self.base as? DownloadRequest {
        downloadReq.downloadProgress(closure: handler)
      } else if let dataReq = self.base as? DataRequest {
        dataReq.downloadProgress(closure: handler)
      }

      return Disposables.create()
    }
    // warm up a bit :)
    .startWith(RxProgress(bytesWritten: 0, totalBytes: 0))
  }
}

// MARK: RxProgress
public struct RxProgress {
  public let bytesWritten: Int64
  public let totalBytes: Int64

  public init(bytesWritten: Int64, totalBytes: Int64) {
    self.bytesWritten = bytesWritten
    self.totalBytes = totalBytes
  }
}

extension RxProgress {
  public var bytesRemaining: Int64 {
    return totalBytes - bytesWritten
  }

  public var completed: Float {
    if totalBytes > 0 {
      return Float(bytesWritten) / Float(totalBytes)
    } else {
      return 0
    }
  }
}

extension RxProgress: Equatable {}

public func ==(lhs: RxProgress, rhs: RxProgress) -> Bool {
  return lhs.bytesWritten == rhs.bytesWritten &&
    lhs.totalBytes == rhs.totalBytes
}
