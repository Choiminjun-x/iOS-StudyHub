//
//  ImageCacheManager.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 5/29/25.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    /// 메모리 캐시 (NSCache는 자동으로 메모리 관리됨 - LRU 기반)
    private let memoryCache = NSCache<NSString, UIImage>()
    private var cacheKeys: Set<String> = []
    
    /// 디스크 캐시에 사용할 FileManager 인스턴스
    private let fileManager = FileManager.default
    
    /// 디스크 캐시의 루트 경로 (Caches/ImageCache)
    private var diskCachePath: URL {
        self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache", isDirectory: true)
    }
    
    /// 지정된 URL로부터 캐시 키 파일 경로를 생성 (SHA256으로 해시)
    private func diskPath(for url: URL) -> URL {
        let fileName = url.absoluteString.sha256 + ".cache"
        return self.diskCachePath.appendingPathComponent(fileName)
    }
    
    /*
     테스트 이미지 url
     https://picsum.photos/200
     https://picsum.photos/300/200
     https://picsum.photos/id/237/300/200 <- 고정 이미지 Url
     */
    
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        /// 1. 메모리 캐시에서 먼저 검색
        if let cachedImage = self.memoryCache.object(forKey: key) {
            print("[Memory HIT] key: \(key)")
            completion(cachedImage)
            return
        }
        
        /// 2. 디스크 캐시에서 확인
        let diskPath = self.diskPath(for: url)
        if let image = UIImage(contentsOfFile: diskPath.path) {
            self.memoryCache.setObject(image, forKey: key) // 메모리 캐시에 로드
            print("[Disk HIT] key: \(key)")
            DispatchQueue.main.async { completion(image) }
            return
        }
        
        /// 3. 캐시에 없을 경우, 네트워크 요청
        URLSession.shared.dataTask(with: url) { data, _, _ in
            print("[Network Request] key: \(key)")
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            /// 4. 메모리 + 디스크 캐시에 저장
            self.memoryCache.setObject(image, forKey: key)
            self.cacheKeys.insert(key as String)
            print("[Memory Saved] key: \(key), size: \(image.size)")
            
            try? self.saveImageToDisk(data: data, to: diskPath)
        
            print("[Network Loaded] key: \(key), size: \(image.size)")
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
    
    /// 다운로드된 이미지 데이터를 디스크에 저장
    private func saveImageToDisk(data: Data, to path: URL) throws {
        /// 디렉토리가 없다면 생성
        if !self.fileManager.fileExists(atPath: self.diskCachePath.path) {
            try self.fileManager.createDirectory(at: self.diskCachePath, withIntermediateDirectories: true)
        }
        /// 이미지 데이터를 해당 경로에 저장
        try data.write(to: path, options: .atomic)
    }
    
    func dumpAllKeys() {
        print("현재 저장된 메모리 캐시 키 목록:")
        for key in cacheKeys {
            print("- \(key)")
        }
    }
    
    /// 메모리/디스크 캐시 모두 삭제
    func clearAllCache() {
        self.memoryCache.removeAllObjects()
        try? self.fileManager.removeItem(at: self.diskCachePath)
    }
}
