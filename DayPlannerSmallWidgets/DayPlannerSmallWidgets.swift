//
//  DayPlannerSmallWidgets.swift
//  DayPlannerSmallWidgets
//
//  Created by Usama Fouad on 21/03/2021.
//

import WidgetKit
import SwiftUI
import Intents

let cards = [PlanCard(taskTitle: "Wake Up & Eat", taskCat: "Morning Routine", taskDesc: "fevw rewnkmlver w", taskColor: #colorLiteral(red: 0.9294117647, green: 0.5137254902, blue: 0.5450980392, alpha: 1), taskTime: Date().adding(minutes: -400), hours: 1, minutes: 20), PlanCard(taskTitle: "Sleep Again!", taskCat: "Afternoon", taskDesc: "fevw rewnkmlver w", taskColor: #colorLiteral(red: 0.4431372549, green: 0.7882352941, blue: 0.6941176471, alpha: 1), taskTime: Date().adding(minutes: -100) , hours: 3, minutes: 30), PlanCard(taskTitle: "Wake Up & Eat", taskCat: "Morning Routine", taskDesc: "fevw rewnkmlver w", taskColor: #colorLiteral(red: 0.5019607843, green: 0.6392156863, blue: 0.9490196078, alpha: 1), taskTime: Date().adding(minutes: 30), hours: nil, minutes: 30)]

let card = cards[0]

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
    @Environment(\.widgetFamily) var size
    var entry: Provider.Entry

    var body: some View {
        switch size {
        case .systemSmall:
            samllWidgetDesign()
        default:
            largeWidgetDesign()
    }
}
    
    func samllWidgetDesign() -> some View {
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

    func largeWidgetDesign() -> some View {
        VStack {
            ZStack {
                Color(red: 115/255, green: 143/255, blue: 239/255)
                HStack(alignment: .center, spacing: 20.0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("TIME").font(Font.system(size: 18, weight: .bold, design: .default))
                        HStack(alignment: .center, spacing: 1) {
                            Text("HER").font(Font.system(size: 18, weight: .bold, design: .default))
                            Image("background").resizable().frame(width: 20, height: 20, alignment: .center)
                        }
                    }
                    
                    Rectangle().fill(Color.white).frame(width: 0.5).edgesIgnoringSafeArea(.vertical)
                    
                    Text("Today’s Upcoming Tasks:").font(Font.system(size: 14, weight: .bold, design: .default))
                }
            }.frame(height: 60, alignment: .top)
            
            VStack(alignment: .leading) {
                if !cards.isEmpty {
                    ForEach(0 ..< 3) {i in
                        let card = cards[i]
                        VStack(alignment: .leading) {
                            ZStack {
                                Color(card.taskColor)
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(card.taskTitle).font(Font.system(size: 14, weight: .semibold, design: .default))

                                        Text(card.taskCat).font(Font.system(size: 10, weight: .medium, design: .default))

                                        HStack(alignment: .center, spacing: 5) {
                                            Image(systemName: "clock").foregroundColor(.white)
                                            Text(card.getTaskLen()).font(Font.system(size: 14, weight: .semibold, design: .default))
                                        }
                                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                    Spacer()
                                    Text("\(card.getStringDate()) - \(card.getToTime())").font(Font.system(size: 14, weight: .semibold, design: .default)).padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 13))
                                }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                            }
                        }.cornerRadius(15)
                        Spacer()
                    }
                } else {
                    Spacer()
                    VStack{
                        Text("No Tasks For Today!").font(Font.system(size: 30, weight: .bold, design: .default)).foregroundColor(Color(#colorLiteral(red: 0.4509803922, green: 0.5607843137, blue: 0.937254902, alpha: 1)))
                        HStack {
                            Spacer()
                            Image("background").resizable().frame(width: 50, height: 50, alignment: .center).cornerRadius(25)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }.foregroundColor(.white)
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
        .description("This is an example widget.").supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct DayPlannerSmallWidgets_Previews: PreviewProvider {
    static var previews: some View {
        DayPlannerSmallWidgetsEntryView(entry: SimpleEntry(date: Date(), upcomingTask: card, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
