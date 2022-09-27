//
//  NetworkManagerTests.swift
//  Job-ReadinessTests
//
//  Created by Luciano Da Silva Berchon on 23/09/22.
//

import XCTest

@testable import Job_Readiness

final class NetworkManagerTests: XCTestCase {
    private let dataTaskStub = DataTaskProtocolStub()
    private lazy var sut = NetworkManager(session: dataTaskStub)
    
    private typealias DataTaskResult = Result<DataTaskMocks.ValidResponse, Error>
    
    func test_request_givenCompletionWithError_shoudReturnNetworkBadRequest() {
        // Arrange
        dataTaskStub.dataTaskCompletionToBeReturned = (nil, nil, APIError.NetworkBadRequest)
        guard let url = URL(string: "www.meli.com.br") else {
            XCTFail("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        var expectedResult: DataTaskResult?
        
        // Act
        sut.request(request: request) { expectedResult = $0 }
        
        // Assert
        XCTAssertEqual(dataTaskStub.dataTaskCalledCount, 1)
        XCTAssertEqual(dataTaskStub.dataTaskUrlPassed, url)
        switch expectedResult {
        case .failure(let error):
            XCTAssertNotNil(error as? APIError)
        default:
            XCTFail("Expected result should be failure")
        }
    }
    
    func test_request_givenAValidData_and_NilError_shouldReturnSerealizedObjectWithSuccess() {
        // Arrange
        dataTaskStub.dataTaskCompletionToBeReturned = (DataTaskMocks.validData, DataTaskMocks.HTTPURLResponse200, nil)
        guard let url = URL(string: "www.meli.com.br") else {
            XCTFail("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        var expectedResult: DataTaskResult?

        // Act
        sut.request(request: request) { expectedResult = $0 }
        
        // Assert
        XCTAssertEqual(dataTaskStub.dataTaskCalledCount, 1)
        XCTAssertEqual(dataTaskStub.dataTaskUrlPassed?.absoluteURL, url)
        print("================")
        print(expectedResult)
        print("================")
        switch expectedResult {
        case .success(let responseData):
            print(responseData)
        default:
            XCTFail("Expected result should be successfully")
        }
    }
}

final class DataTaskProtocolStub: DataTaskProtocol {
    private(set) var dataTaskCalledCount = 0
    private(set) var dataTaskUrlPassed: URL?
    var dataTaskCompletionToBeReturned: (data: Data?, response: URLResponse?, error: Error?)?
    
    func wrappedDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTaskCalledCount += 1
        dataTaskUrlPassed = request.url
        
        completionHandler(dataTaskCompletionToBeReturned?.data,
                          dataTaskCompletionToBeReturned?.response,
                          dataTaskCompletionToBeReturned?.error
        )
    }
}

enum DataTaskMocks {
    static var validData: Data? {
        """
        [
            { "name": "meli" },
            { "name": "go meli go" },
        ]
        """.data(using: .utf8)
    }
    
    static var HTTPURLResponse200: HTTPURLResponse? {
        .init(
            url: URL(string: "www.meli.com.br")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
    }
    
    struct ValidResponse: Codable {
        let name: String
    }
}
