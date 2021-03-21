//
//  DayPlannerSmallWidgets.swift
//  DayPlannerSmallWidgets
//
//  Created by Usama Fouad on 21/03/2021.
//

import WidgetKit
import SwiftUI
import Intents

let card = PlanCard(taskTitle: "Wake Up & Eat", taskCat: "Morning Routine", taskDesc: "fevw rewnkmlver w", taskColor: .red, taskTime: Date(), hours: 1, minutes: 20)
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), upcomingTask: card, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), upcomingTask: card, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, upcomingTask: card, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let upcomingTask: PlanCard?
    let configuration: ConfigurationIntent
}

struct DayPlannerSmallWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 12)
            Text("Upcoming Task").font(Font.system(size: 14, weight: .semibold, design: .default)).foregroundColor(Color(red: 100/255, green: 94/255, blue: 94/255, opacity: 1))
            
            ZStack {
                GeometryReader { geo in
    //                Image("background").resizable().aspectRatio(contentMode: .fill).frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
                
                Color(card.taskColor)
                VStack(alignment: .leading, spacing: 5) {
                    Text(card.taskTitle).font(Font.system(size: 14, weight: .semibold, design: .default))
                    
                    Text(card.taskCat).font(Font.system(size: 10, weight: .medium, design: .default))
                    
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "clock").foregroundColor(.white)
                        Text(card.getTaskLen()).font(Font.system(size: 14, weight: .semibold, design: .default))
                    }
                    
                    Text("\(card.getStringDate()) - \(card.getToTime())").font(Font.system(size: 14, weight: .semibold, design: .default))
                }.foregroundColor(.white).padding(EdgeInsets(top: 10, leading: -20, bottom: 10, trailing: 10))
            }
        }
        
        
    }
}

@main
struct DayPlannerSmallWidgets: Widget {
    let kind: String = "DayPlannerSmallWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DayPlannerSmallWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DayPlannerSmallWidgets_Previews: PreviewProvider {
    static var previews: some View {
        DayPlannerSmallWidgetsEntryView(entry: SimpleEntry(date: Date(), upcomingTask: card, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
