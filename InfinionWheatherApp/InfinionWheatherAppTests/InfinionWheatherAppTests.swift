import XCTest
@testable import InfinionWheatherApp

final class MockURLProtocol: URLProtocol {
    static var testData: Data?
    static var response: HTTPURLResponse?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let resp = MockURLProtocol.response {
            client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
        }
        if let d = MockURLProtocol.testData {
            client?.urlProtocol(self, didLoad: d)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

final class InfinionWheatherAppTests: XCTestCase {
    func testOpenWeatherService_parsesResponse() throws {
        let json = """
        {
          "name":"London",
          "weather":[{"description":"light rain"}],
          "main":{"temp":12.34,"feels_like":11.0}
        }
        """
        MockURLProtocol.testData = json.data(using: .utf8)
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let client = URLSessionNetworkClient(session: session)

        let service = OpenWeatherService(apiKey: "DUMMY", client: client)
        let expectation = self.expectation(description: "fetch")
        service.fetchWeather(for: "London") { result in
            switch result {
            case .success(let resp):
                XCTAssertEqual(resp.name, "London")
                XCTAssertEqual(resp.descriptionText, "light rain")
                XCTAssertEqual(resp.temperatureCelsius, 12.34, accuracy: 0.001)
            case .failure(let err):
                XCTFail("unexpected error \(err)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}
