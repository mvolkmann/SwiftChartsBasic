import Charts
import SwiftUI

extension Date {
    // Creates a Date object for a given hour in the current day.
    static func hour(_ hour: Int) -> Date {
        var components = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: Date()
        )
        components.hour = hour
        return Calendar.current.date(from: components)!
    }
}

struct Weather: Identifiable {
    let dateTime: Date
    let temperature: Double
    var id: Date { dateTime }
}

// This is the data to be plotted.
private let forecast: [Weather] = [
    .init(dateTime: Date.hour(8), temperature: 43.0),
    .init(dateTime: Date.hour(9), temperature: 48.0),
    .init(dateTime: Date.hour(10), temperature: 55.0),
    .init(dateTime: Date.hour(11), temperature: 60.0),
    .init(dateTime: Date.hour(12), temperature: 64.0),
    .init(dateTime: Date.hour(13), temperature: 67.0),
    .init(dateTime: Date.hour(14), temperature: 69.0),
    .init(dateTime: Date.hour(15), temperature: 70.0),
    .init(dateTime: Date.hour(16), temperature: 71.0),
    .init(dateTime: Date.hour(17), temperature: 71.0),
    .init(dateTime: Date.hour(18), temperature: 69.0),
    .init(dateTime: Date.hour(19), temperature: 67.0),
    .init(dateTime: Date.hour(20), temperature: 65.0),
    .init(dateTime: Date.hour(21), temperature: 63.0),
    .init(dateTime: Date.hour(22), temperature: 61.0),
    .init(dateTime: Date.hour(23), temperature: 58.0),
    .init(dateTime: Date.hour(24), temperature: 55.0)
]

struct ContentView: View {
    @State private var chartType: String = "bar"

    let areaColor = LinearGradient(
        gradient: Gradient(colors: [.yellow, .blue]),
        startPoint: .top,
        endPoint: .bottom
    )

    // This is used to select bar and point colors
    // based on the temperature they represent.
    let colors: [UIColor] = [.blue, .yellow, .red]

    var body: some View {
        VStack {
            Picker("Chart Type", selection: $chartType) {
                Text("Bar").tag("bar")
                Text("Line").tag("line")
            }
            .pickerStyle(.segmented)

            Chart(forecast) { data in
                let time = PlottableValue.value("Time", data.dateTime)
                let temp = PlottableValue.value("Temperature", data.temperature)
                let color = color(for: data.temperature)
                if chartType == "bar" {
                    // Each BarMark can be a different color.
                    BarMark(x: time, y: temp)
                        .foregroundStyle(color)
                    /*
                     .annotation {
                         let hour = data.dateTime.formatted(.dateTime.hour())
                         let temp = data.temperature.formatted(
                             .number.precision(.fractionLength(0))
                         )
                         Text("\(temp) at \(hour)")
                             .font(.caption)
                             .rotationEffect(Angle(degrees: -90))
                     }
                     */
                } else {
                    // Each PointMark can be a different color,
                    // but LineMarks and AreaMarks cannot.
                    // They can however be gradient colors.
                    LineMark(x: time, y: temp)
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                    AreaMark(x: time, y: temp)
                        .foregroundStyle(areaColor.opacity(0.7))
                    PointMark(x: time, y: temp)
                        .foregroundStyle(color)
                }
            }
            /*
             .chartXAxis {
                 // TODO: I can't figure out how to make it add an x-axis label
                 // TODO: for EVERY data point!
                 // TODO: It omits ones it thinks will not fit.
                 /*
                  AxisMarks(values: .stride(
                      by: .hour,
                      count: forecast.count,
                  )) { (date: Date) in
                  */
                 AxisMarks { _ in
                     // let foo = print("value =", value)
                     // let hour = date.formatted(.dateTime.hour())
                     AxisGridLine()
                     AxisTick()
                     AxisValueLabel(
                         centered: true,
                         collisionResolution: .disabled,
                         orientation: .verticalReversed
                     ) {
                         // Text(hour)
                         Text("test")
                             .font(.caption)
                             .padding(.top, 10)
                     }
                 }
             }
             */
        }
        .padding()
    }

    // This returns a color to use for a given temperature.
    func color(for temperature: Double) -> Color {
        let low = 30.0
        let high = 100.0
        let percentage = temperature <= low ? 0.0 :
            temperature >= high ? 1.0 :
            (temperature - low) / (high - low)
        return colors.colorAt(percentage: percentage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
