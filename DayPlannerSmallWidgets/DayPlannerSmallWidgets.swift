//
//  DayPlannerSmallWidgets.swift
//  DayPlannerSmallWidgets
//
//  Created by Usama Fouad on 21/03/2021.
//

import WidgetKit
import SwiftUI
import Intents


var cards = [PlanCard]()

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), undoneCards: [], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), undoneCards: [], configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        if let dayNum = Date().dayNumberOfWeek() {
            if dayNum - 1 >= 0 {
                DataManager.shared.selectedDayInd = dayNum - 1
            } else {
                DataManager.shared.selectedDayInd = 6
            }
        }
        
        if DataManager.shared.loadData() {
            cards = DataManager.shared.daysPlans[DataManager.shared.selectedDayInd]?[0] ?? []
            print("Data Loaded!")
        }
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, undoneCards: cards , configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let undoneCards: [PlanCard]
    let configuration: ConfigurationIntent
}

struct DayPlannerSmallWidgetsEntryView : View {
    @Environment(\.widgetFamily) var size
    var entry: Provider.Entry

    var body: some View {
        switch size {
        case .systemSmall:
            samllWidgetDesign(entry: entry)
        default:
            largeWidgetDesign(entry: entry)
    }
}
    
    func samllWidgetDesign(entry: Provider.Entry) -> some View {
        VStack(spacing: 0) {
            VStack {
                ZStack {
                    Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                    Text("Upcoming Task").font(.custom("Poppins-Semibold", size: 14)).foregroundColor(Color(#colorLiteral(red: 0.3215686275, green: 0.3058823529, blue: 0.3058823529, alpha: 0.85))).frame(alignment: .center).padding(.trailing, 0.5)
                }
            }.frame(height: 35)
                
            ZStack {
                let cards = entry.undoneCards
                if !cards.isEmpty {
                    let card = cards[0]

                    Color(card.taskColorName ?? "")
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(card.taskTitle ?? "").font(Font(UIFont(name: "Poppins-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14))).fontWeight(.semibold)

                            Text(card.taskCategory ?? "").font(Font(UIFont(name: "Poppins-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10))).fontWeight(.medium)
                            HStack(alignment: .center, spacing: 6) {
                                Image(systemName: "clock").foregroundColor(.white)
                                Text(PlanCard.getTaskLen(for: card) ?? "").font(Font(UIFont(name: "Poppins-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14))).fontWeight(.semibold)
                            }

                            Text("\(PlanCard.getFormatedFromTime(for: card)) - \(PlanCard.getFormatedToTime(for: card))").font(Font(UIFont(name: "Poppins-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14))).fontWeight(.semibold)
                        }

                        Spacer()
                    }.foregroundColor(.white).padding(EdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 5))
                } else {
                    Color(#colorLiteral(red: 0.4509803922, green: 0.5607843137, blue: 0.937254902, alpha: 1))

                    VStack(alignment: .center, spacing: 6) {
                        HStack(alignment: .center, spacing: 20) {
                            Spacer()
                            Text("No Tasks Left for Today!").font(.custom("Poppins-Bold", size: 12)).fontWeight(.bold).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center).lineSpacing(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            Image("WhiteLogo").resizable().frame(width: 20, height: 20, alignment: .center).cornerRadius(10)
                        }
                    }
                }
            }
        }
    }

    func largeWidgetDesign(entry: Provider.Entry) -> some View {
        GeometryReader { geo in
            ZStack {
                Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                VStack {
                    ZStack {
                        Color(#colorLiteral(red: 0.4509803922, green: 0.5607843137, blue: 0.937254902, alpha: 1))
                        HStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .leading, spacing: -8) {
                                Text("TIME").font(.custom("Poppins-Bold", size: 18))
                                HStack(alignment: .center, spacing: 1) {
                                    Text("HER").font(.custom("Poppins-Bold", size: 18))
                                    Image("WhiteLogo").resizable().frame(width: 15, height: 15, alignment: .center)
        // Image("LargeWidgetLogo").resizable().frame(width: 50, height: 50, alignment: .center)
                                }
                            }
                            
                            Rectangle().fill(Color.white).frame(width: 0.5).edgesIgnoringSafeArea(.vertical)
                            
                            Text("Today’s Upcoming Tasks:").font(.custom("Poppins-Bold", size: 14))
                        }
                    }.frame(height: geo.size.height / 5, alignment: .top)
                    Spacer().frame(height: 12)
                    VStack(alignment: .center, spacing: 2) {
//                        Spacer()
                        let cards = entry.undoneCards
                        if !cards.isEmpty {
                            let count = cards.count
                            ForEach(0 ..< 3) {i in
                                if i < count, let card = cards[i] {
                                    VStack(alignment: .leading) {
                                        ZStack {
                                            Color(card.taskColorName ?? "")
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading, spacing: geo.size.height * 0.01) {
                                                    Text(card.taskTitle ?? "").font(.custom("Poppins-SemiBold", size: 14))

                                                    Text(card.taskCategory ?? "").font(.custom("Poppins-Medium", size: 10))

                                                    HStack(alignment: .center, spacing: 5) {
                                                        Image(systemName: "clock").foregroundColor(.white)
                                                        Text(PlanCard.getTaskLen(for: card) ?? "").font(.custom("Poppins-SemiBold", size: 14))
                                                    }
                                                }.padding(EdgeInsets(top: geo.size.height * 0.03, leading: geo.size.height * 0.03, bottom: geo.size.height * 0.03, trailing: geo.size.height * 0.03))
                                                Spacer()
                                                Text("\(PlanCard.getFormatedFromTime(for: card)) - \(PlanCard.getFormatedToTime(for: card))").font(.custom("Poppins-SemiBold", size: 14)).padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 13))
                                            }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        }
                                    }.cornerRadius(15).frame(height: geo.size.height/4.3).padding(EdgeInsets(top: 0, leading: 10, bottom: geo.size.height * 0.015, trailing: 10))
                                }
                            }
                            
                            Spacer()
                        } else {
                            Spacer()
                            HStack(spacing: 12){
                                Text("No Tasks For Today!").font(.custom("Poppins-Bold", size: 19)).foregroundColor(Color(#colorLiteral(red: 0.4509803922, green: 0.5607843137, blue: 0.937254902, alpha: 1)))
                                    Image("BlueCheckmark").resizable().frame(width: 30, height: 30, alignment: .center).cornerRadius(15)
                            }
                            Spacer()
                        }
                    }.frame(alignment: .top)
                }.foregroundColor(.white).frame(alignment: .top)
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
        .configurationDisplayName("Day Planner Widget")
        .description("These are tasks for today from Day Planner app!").supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct DayPlannerSmallWidgets_Previews: PreviewProvider {
    static var previews: some View {
        DayPlannerSmallWidgetsEntryView(entry: SimpleEntry(date: Date(), undoneCards: [], configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
