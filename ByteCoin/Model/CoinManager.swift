import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(_ error: Error)
    func didUpdatePrice(_ price: String, _ currency: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "12C29A7D-1817-4238-9575-8D8D9FF6931A" // have to remove it before sending to GitHub
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {
                if let error = $2 {
                    delegate?.didFailWithError(error)
                    return
                }
                
                if let data = $0 {
                    if let parsedData = self.parseJSON(data) {
                        let updatedPrice = parsedData.price
                        let updatedCurrency = parsedData.currency
                        
                        delegate?.didUpdatePrice(updatedPrice, updatedCurrency)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        do {
            let json = try JSONDecoder().decode(CoinData.self, from: data)
            
            let coin = CoinModel(currency: json.asset_id_quote, rate: json.rate)
            
            return coin
        } catch {
            // we have to handle the error if it happens
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
