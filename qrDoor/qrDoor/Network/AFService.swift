//
//  AFService.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 6.06.2023.
//

import Foundation
import Alamofire

struct QrResponse: Codable {
    let qr_string: String
}

class AFQrService {
    private let baseURL = "https://qr-door-backend.herokuapp.com"
    
    func getQrString(string: String, completion: @escaping (Result<QrResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/otp/\(string)"
        AF.request(urlString).validate().responseDecodable(of: QrResponse.self) { response in
            switch response.result {
            case .success(let qrResponse):
                completion(.success(qrResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


//func postReport(date: String, field: String, completion: @escaping (Result<[Gas], AFError>) -> Void) {
//    let url = "\(baseURL)/reports"
//    let parameters: [String: Any] = ["Date": date, "Field": field]
//
//    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodable(of: [Gas].self) { response in
//        switch response.result {
//        case .success(let reports):
//            completion(.success(reports))
//        case .failure(let error):
//            completion(.failure(error))
//        }
//    }
//}
