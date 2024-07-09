//
//  NYCSchoolWebServiceTest.swift
//  20240626_MassenElarabi_NYCSchoolsTests
//
//  Created by Massen Elarabi on 7/3/24.
//

import XCTest
import Combine
@testable import _0240626_MassenElarabi_NYCSchools

final class NYCSchoolWebServiceTest: XCTestCase {
    
    var sut: NYCSchoolsWebService!
    var cancellables = Set<AnyCancellable>()
    var mockSuccessResponse: HTTPURLResponse!
    var mockFailResponse: HTTPURLResponse!
    let mockURL: String = "https://jsonplaceholder.test.com"
    let mockResponseData = """
        {
            "mockString": "abc",
            "mockInt": 123
        }
    """.data(using: .utf8)!
    let expectedResponseData = MockResponseDataType(mockString: "abc", mockInt: 123)

    override func setUp() {
        super.setUp()
        mockSuccessResponse = HTTPURLResponse.build(url: mockURL, statusCode: 200)
        mockFailResponse = HTTPURLResponse.build(url: mockURL, statusCode: 400)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        sut = NYCSchoolsWebService(urlSession: urlSession)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSuccessResponse() {
        let requestHandler = RequestHandler(url: URL(string: mockURL)!,
                                            response: [mockSuccessResponse],
                                            data: mockResponseData)
        URLProtocolMock.requestHandler = requestHandler.handleRequest
        sut.callAPI(urlString: mockURL)
            .sink { _ in
                //
            } receiveValue: { (response: MockResponseDataType ) in
                XCTAssertNotNil(response)
                XCTAssertEqual(response, self.expectedResponseData)
            }
            .store(in: &cancellables)

    }
    
    func testFailedResponse() {
        let expectedErrorDescription = "Unexpected HTTP status code: 400"
        let requestHandler = RequestHandler(url: URL(string: mockURL)!,
                                            response: [mockFailResponse],
                                            data: Data())
        URLProtocolMock.requestHandler = requestHandler.handleRequest
        sut.callAPI(urlString: mockURL)
            .mapError { (error) -> Error in
                XCTAssertEqual(error.localizedDescription, expectedErrorDescription)
                let apiError = error as? APIError
                XCTAssertNotNil(apiError)
                switch apiError {
                case let .httpStatusCode(statusCode):
                    XCTAssertEqual(statusCode, 400)
                default:
                    XCTFail("Wrong error type received")
                }
                
                return error
            }
            .sink { _ in } receiveValue: { (_ : MockResponseDataType ) in }
            .store(in: &cancellables)

    }

}

// MARK: - MockResponseDataType for testing API requests
struct MockResponseDataType: Decodable, Equatable {
    
    let mockString: String
    let mockInt: Int
}

// MARK: - mock url protocol
class URLProtocolMock: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}

// MARK: - build mock responses
extension HTTPURLResponse {
    static func build(url: String = "https://jsonplaceholder.test.com",
                      statusCode: Int = 200) -> HTTPURLResponse {
        let urlSt = URL(string: url)!
        return HTTPURLResponse(url: urlSt,
                               statusCode: statusCode,
                               httpVersion: nil,
                               headerFields: nil)!
    }
}

// MARK: - request handler
class RequestHandler {
    var allRequests: [URLRequest] = []
    var receivedHeaderFields: [String: String]?
    
    let url: URL
    var response: [HTTPURLResponse]
    let data: Data
    init(url: URL, response: [HTTPURLResponse], data: Data) {
        self.url = url
        self.response = response
        self.data = data
    }
    
    func handleRequest(_ request: URLRequest) throws -> (HTTPURLResponse, Data) {
        self.receivedHeaderFields = request.allHTTPHeaderFields
        self.allRequests.append(request)
        let finalResponse = response.first!
        response.remove(at: 0)
        return (finalResponse, data)
    }
}
