
import Foundation

class NetworkManager {

  private let domainUrlString = "https://api.github.com/"
  

  func fetchDate(completionHandler: @escaping (String) -> Void) {
    let url = URL(string: domainUrlString)!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Error returning film \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
            print("Unexpected response status code: \(String(describing: response))")
        return
      }

        let newStr = String(data: data!, encoding: String.Encoding.utf8)
        completionHandler(newStr!)
    }
    task.resume()
  }
}
