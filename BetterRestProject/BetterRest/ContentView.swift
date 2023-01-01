import CoreML
import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = "Your ideal bedtime is…"
    @State private var alertMessage = "Waiting for calculation..."
    
    @State private var coffeeIntakes = 1...20
    
    
    func calculateBedtime(){
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    HStack{
                        Text("When do you want to wake up?")
                            .font(.headline)
                        Spacer()
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                Section{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Desired amount of sleep")
                            .font(.headline)

                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                }
                Section{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Daily coffee intake").font(.headline)
                        Picker("Daily coffee intake", selection: $coffeeAmount){
                            ForEach(coffeeIntakes, id: \.self){it in
                                Text(String(it))
                            }
                        }
                    }
                }
                
                Section{
                    Button("Calculate", action: calculateBedtime)
                }
                
                Section{
                    Text("\(alertTitle)")
                        .font(.headline)
                    Text(alertMessage)
                }
            }
            .navigationTitle("BetterRest")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
