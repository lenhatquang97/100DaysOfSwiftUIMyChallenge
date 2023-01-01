import SwiftUI

struct ContentView: View {
    @State private var inpTempUnit = "Celsius"
    @State private var outTempUnit = "Celsius"
    @State private var number = 0
    let tempArray = ["Celsius", "Fahrenheit", "Kelvin"]
    var outputTemp: Int{
        if inpTempUnit == outTempUnit {
            return number
        }
        if inpTempUnit == tempArray[0] {
            switch outTempUnit {
            case tempArray[1]:
                return number * 9 / 5 + 32
            default:
                return number + 273
            }
        } 
        if inpTempUnit == tempArray[1]{
            switch outTempUnit {
            case tempArray[0]:
                return (number - 32) * 5 / 9
            default:
                return (number - 32) * 5 / 9 + 273
            }
        }
        
        if inpTempUnit == tempArray[2]{
            switch outTempUnit {
            case tempArray[0]:
                return number - 273
            default:
                return (number - 273) * 9 / 5 + 32
            }
        }
        
        return number
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section {
                    Picker("Input temperature unit", selection: $inpTempUnit){
                        ForEach(tempArray, id: \.self){
                            Text($0)
                        }
                    }
                }
                Section{
                    Picker("Output temperature unit", selection: $outTempUnit){
                        ForEach(tempArray, id: \.self){
                            Text($0)
                        }
                    }
                }
                Section{
                    TextField("Number", value: $number, format: .number).keyboardType(.numberPad)
                } header: {
                    Text("Type your number")
                }
                Section{
                    Text("\(outputTemp)")
                } header: {
                    Text("Result")
                }
            }.navigationTitle("Temperature Converter")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
