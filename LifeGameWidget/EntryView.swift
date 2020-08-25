//
//  LifeGameWidgetEntryView.swift
//  LifeGameWidgetExtension
//
//  Created by Yusuke Hosonuma on 2020/08/25.
//

import SwiftUI
import WidgetKit

struct EntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    var entry: Provider.Entry

    var body: some View {
        if widgetFamily == .systemSmall {
            HStack {
                boardView(data: entry.relevance.first!)
                Spacer()
            }
            .padding()
            .widgetURL(entry.relevance.first!.url)
        } else {
            HStack {
                ForEach(entry.relevance, id: \.title) { data in
                    Link(destination: data.url) {
                        boardView(data: data)
                    }
                }
            }
            .padding()
        }
    }
    
    func boardView(data: BoardData) -> some View {
        VStack(alignment: .leading) {
            BoardThumbnailImage(board: data.board, cellColor: cellColor, cacheKey: data.cacheKey)
            Text(data.title)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
    
    var cellColor: Color {
        switch colorScheme {
        case .light: return UserDefaultSettingGroup.shared.lightModeColor
        case .dark:  return UserDefaultSettingGroup.shared.darkModeColor
        @unknown default:
            fatalError()
        }
    }
}

struct LifeGameWidget_Previews: PreviewProvider {
    static let preset = BoardPreset.nebura
    static let entry = Entry(date: Date(), relevance: exampleData)
    
    static var previews: some View {
        view(colorScheme: .light)
        view(colorScheme: .dark)
    }
    
    static func view(colorScheme: ColorScheme) -> some View {
        EntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            // Dark is not work in beta4❗
            .colorScheme(colorScheme)
            .preferredColorScheme(colorScheme)
    }
}
