import Foundation


class GasStation {
    /// 車両詳細
    var myCarModel = CarModel (
        name: "キューブ",
        fuelType: .regular,
        fuelTank: 40.00,
        fuelRemaining: 12.34
    )
    /// 油種
    enum FuelType {
        case diesel
        case regular
        case premium
        // １Lの値段
        var fuelPrice: Decimal {
            switch self {
            case .diesel:
                return 145.00
            case .regular:
                return 165.00
            case .premium:
                return 200.00
            }
        }
    }
    
    /// 給油量
    enum FuelInput {
        case full
        case specifiedQuantity(Decimal)
        // 実際に入れる量
        func refuelQuantity(car: CarModel) -> Decimal {
            switch self {
            case .full:
                return car.fuelTankRemaining
            case .specifiedQuantity(let putQuantity):
                let freeSpace = car.fuelTankRemaining
                // 指定した給油量がタンクの空き容量を超えてないかチェック
                if putQuantity > freeSpace {
                    // 超えてたら空き容量を給油
                    return freeSpace
                }
                return putQuantity
            }
        }
    }
    /// 車の情報
    struct CarModel {
        let name: String
        let fuelType: FuelType
        let fuelTank: Decimal
        let fuelRemaining: Decimal
        // タンクの空き容量
        var fuelTankRemaining: Decimal {
            fuelTank - fuelRemaining
        }
    }
    /// 注文処理
    func buyFuel(type: FuelType, car: CarModel, inputedYen: Decimal, fuelInput: FuelInput) -> Bool{
        guard car.fuelType == type else {
            print("\(car.name)の油種は\(type)ではありません")
            return false
        }
        // 料金計算
        var buyFuelPrice:Decimal = fuelInput.refuelQuantity(car: car) * car.fuelType.fuelPrice
        // 小数点以下切り捨て
        var roundDown = Decimal()
        NSDecimalRound(&roundDown, &buyFuelPrice, 0, .down)
        inputedYen >= roundDown
        // 投入金額が足りているか確認
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

let gasStation = GasStation()
let refuelingThree = gasStation.buyFuel(
    type: .regular,
    car: gasStation.myCarModel,
    inputedYen: 40000,
    fuelInput: .specifiedQuantity(Decimal(22.22))
)
print(refuelingThree)
