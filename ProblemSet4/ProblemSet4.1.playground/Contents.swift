var num: Int
var width: Int

num = 34
width = 10

var stars = 1

while stars <= num{
    print("*", terminator: "")
    if stars % width == 0 {
        print("")
    }
    stars = stars + 1
}







