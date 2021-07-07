//
//  UserLoginResponseDTO.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 08.07.2021..
//

//{
//    "statusCode": 200,
//    "data": {
//        "user": {
//            "id": 19,
//            "email": "user6@email.com",
//            "firstname": "user1firstname",
//            "lastname": "user1lastname",
//            "createdAt": 1625142741,
//            "updatedAt": 1625694264,
//            "employer": null,
//            "profileImage": {
//                "id": 16,
//                "name": "07efaecd-4de5-42c0-b198-838cbb0828da-test.png",
//                "url": "https://menuely-bucket.s3.eu-central-1.amazonaws.com/07efaecd-4de5-42c0-b198-838cbb0828da-test.png",
//                "createdAt": 1625142894,
//                "updatedAt": 1625142894
//            },
//            "coverImage": {
//                "id": 15,
//                "name": "aa287585-dfd3-491b-9ee7-bcacb9a9638d-test.png",
//                "url": "https://menuely-bucket.s3.amazonaws.com/aa287585-dfd3-491b-9ee7-bcacb9a9638d-test.png",
//                "createdAt": 1625142887,
//                "updatedAt": 1625142887
//            }
//        },
//        "auth": {
//            "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTksImlhdCI6MTYyNTY5NDI2NCwiZXhwIjoxNjI1Njk0MzI0fQ.i3tM27ijoJJQ8a2Zl82G56gsPyGiXwbA18tWlL80ANk",
//            "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTksImlhdCI6MTYyNTY5NDI2NCwiZXhwIjoxNjU3MjMwMjY0fQ.kgBOkN8u0tY-0a5rJtA2ZDSfJfIyu8NfsEhE-SefgLg"
//        }
//    }
//}

import Foundation

struct UserLoginResponseDTO: Decodable {
    let statusCode: Int
    let data: UserAuth
}
