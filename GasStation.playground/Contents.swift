import Foundation


class GasStation {
    //油種
    enum FuelType {
        case diesel
        case regular
        case premium
        //１Lの値段
        var fuelPrice: Decimal {
            switch self{
            case .diesel:
                return todayPriceDiesel
            case .regular:
                return todayPriceRegular
            case .premium:
                return todayPricePremium
            }
        }
    }
    //給油量
    enum FuelInput {
        case full
        case specifiedQuantity(Decimal)
        //実際に入れる量
        func refuelQuantity(car: CarModel) -> Decimal {
            switch self {
            case .full:
                return car.fuelTankRemaining
            case .specifiedQuantity(let putQuantity):
                let freeSpace = car.fuelTankRemaining
                //指定した給油量がタンクの空き容量を超えてないかチェック
                if putQuantity > freeSpace {
                    //超えてたら空き容量を給油
                    return freeSpace
                }
                return putQuantity
            }
        }
    }
    //車の情報
    struct CarModel {
        let name: String
        let fuelType: FuelType
        let fuelTank: Decimal
        let fuelRemaining: Decimal
        //タンクの空き容量
        var fuelTankRemaining: Decimal {
            fuelTank - fuelRemaining
        }
    }
    //注文処理
    func buyFuel(type: FuelType, car: CarModel, inputedYen: Decimal, fuelInput: FuelInput) -> Bool{
        guard car.fuelType == type else {
            print("\(car.name)の油種は\(type)ではありません")
            return false
        }
        //料金計算
        var buyFuelPrice:Decimal = fuelInput.refuelQuantity(car: car) * car.fuelType.fuelPrice
        //小数点以下切り捨て
        var roundDown = Decimal()
        NSDecimalRound(&roundDown, &buyFuelPrice, 0, .down)
        inputedYen >= roundDown
        //投入金額が足りているか確認
        guard roundDown <= inputedYen else {
            print("金額は\(roundDown)円です")
            let shortfall = roundDown - inputedYen
            print("投入金額が\(shortfall)円不足しています")
            return false
        }
        print("金額は\(roundDown)円です")
        print("給油量は\(fuelInput.refuelQuantity(car: car))Lです")
        return true
    }
}

//今日のガソリン価格
let todayPriceDiesel: Decimal = 145.00
let todayPriceRegular: Decimal = 168.00
let todayPricePremium: Decimal = 200.00
//マイカー詳細
let myCarOne = GasStation.CarModel(
    name: "キューブ",
    fuelType: .regular,
    fuelTank: 40,
    fuelRemaining: 12.34
)
let myCarTwo = GasStation.CarModel(
    name: "エルフ2t平トラック",
    fuelType: .diesel,
    fuelTank: 350,
    fuelRemaining: 123.45
)
let myCarThree = GasStation.CarModel(
    name: "クラウン",
    fuelType: .premium,
    fuelTank: 100,
    fuelRemaining: 12.34
)


let ss = GasStation()

let refuelingOne = ss.buyFuel(
    type: .regular,
    car: myCarOne,
    inputedYen: 4646,
    fuelInput: .full
)
print(refuelingOne)

let refuelingTwo = ss.buyFuel(
    type: .diesel,
    car: myCarTwo,
    inputedYen: 7295,
    fuelInput: .specifiedQuantity(Decimal(50.32))
)
print(refuelingTwo)

let refuelingThree = ss.buyFuel(
    type: .regular,
    car: myCarThree,
    inputedYen: 40000,
    fuelInput: .full
)
print(refuelingThree)
