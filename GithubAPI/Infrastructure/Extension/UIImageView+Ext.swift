import Foundation
import UIKit

extension UIImageView {
    func setImage(url: URL, cache: ImageCache? = nil) {
        if let storedImage = cache?.image(for: url) {
            image = storedImage
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    cache?.insertImage(image, for: url)
                }
            }
        }.resume()
    }
}
