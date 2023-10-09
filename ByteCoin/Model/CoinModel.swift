struct CoinModel {
    let currency: String
    private let rate: Double
    
    var price: String {
        String(format: "%.2f", rate)
    }
    
    init(currency: String, rate: Double) {
        self.currency = currency
        self.rate = rate
    }
}
