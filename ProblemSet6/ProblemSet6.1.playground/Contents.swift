class Weather{
    
    var low: Float
    var high: Float
    var prec: Float
    var wind: Float
    
    init(low: Float, high: Float, prec: Float, wind: Float){
        self.low = low
        self.high = high
        self.prec = prec
        self.wind = wind
        
    }
}

var yesterday = Weather(low: 60, high: 80, prec: 40, wind: 10)
var today = Weather(low: 50, high: 75, prec: 30, wind: 11)

var Low = yesterday.low - today.low
var High = yesterday.high - today.high
var Prec = yesterday.prec - today.prec
var Wind = yesterday.wind - today.wind

print("The Weather difference between the two days is: ")
print(" Low: \(Low)°F")
print(" High: \(High)°F")
print(" Precipation: \(Prec)%")
print(" Wind: \(Wind)mph")






