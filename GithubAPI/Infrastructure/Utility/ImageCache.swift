import Foundation
import UIKit

class ImageCache {
    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }

        guard let image = imageCache.object(forKey: url as AnyObject) as? UIImage else { return nil }
        return image
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        lock.lock()
        defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as AnyObject)
    }

    func removeImage(for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
    }
}
