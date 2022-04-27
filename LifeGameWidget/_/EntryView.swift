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
        switch widgetFamily {
        case .systemSmall:
            small(data: entry.relevance.first!)
            
        case .systemMedium:
            medium(data: entry.relevance)
            
        case .systemLarge:
            large(data: entry.relevance.first!)
            
        @unknown default:
            fatalError()
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
    
    func small(data: BoardData) -> some View {
        HStack {
            boardView(data: data)
            Spacer()
        }
        .font(.system(.caption2, design: .monospaced))
        .lineLimit(1)
        .padding()
        .widgetURL(data.url)
    }
    
    func medium(data: [BoardData]) -> some View {
        HStack {
            ForEach(data, id: \.title) { data in
                Link(destination: data.url) {
                    boardView(data: data)
                }
            }
        }
        .font(.system(.caption2, design: .monospaced))
        .lineLimit(1)
        .padding()
    }
    
    func large(data: BoardData) -> some View {
        VStack {
            // TODO: Widgetの30MBのサイズ制限に引っかかるので、解像度を下げて暫定対応している
            BoardRenderImage(board: data.board.extended(by: .die, count: 1),
                             cellRenderSize: 200 / data.board.size,
                             cellColor: cellColor)
            Text(data.title)
                .foregroundColor(.gray)
        }
        .font(.system(.headline, design: .monospaced))
        .padding()
        .widgetURL(data.url)
    }
    
    func boardView(data: BoardData) -> some View {
        VStack(alignment: .leading) {
            BoardThumbnailImage(board: data.board, cellColor: cellColor, cacheKey: data.cacheKey)
            Text(data.title)
                .foregroundColor(.gray)
        }
    }
}

struct LifeGameWidget_Previews: PreviewProvider {
    static let preset = BoardPreset.nebura
    static let entry = Entry(date: Date(), relevance: exampleData)
    
    static var previews: some View {
        view(family: .systemSmall,  colorScheme: .light)
        view(family: .systemMedium, colorScheme: .light)
        view(family: .systemMedium, colorScheme: .dark)
        view(family: .systemLarge,  colorScheme: .light)
        view(family: .systemLarge,  colorScheme: .dark)
    }
    
    static func view(family: WidgetFamily, colorScheme: ColorScheme) -> some View {
        EntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: family))
            // Dark is not work in beta 6❗
            .colorScheme(colorScheme)
            .preferredColorScheme(colorScheme)
    }
}
