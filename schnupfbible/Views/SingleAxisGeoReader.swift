//
//  SingleAxisGeoReader.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI

struct SingleAxisGeometryReader<Content: View>: View
{
    private struct SizeKey: PreferenceKey
    {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat)
        {
            value = max(value, nextValue())
        }
    }

    @State private var size: CGFloat = SizeKey.defaultValue

    var axis: Axis = .vertical
    var alignment: Alignment = .center
    let content: (CGFloat)->Content

    var body: some View
    {
        content(size)
            .frame(maxWidth:  axis == .horizontal ? .infinity : nil,
                   maxHeight: axis == .vertical   ? .infinity : nil,
                   alignment: alignment)
            .background(GeometryReader
            {
                proxy in
                Color.clear.preference(key: SizeKey.self, value: axis == .horizontal ? proxy.frame(in: .global).minX : proxy.frame(in: .global).minY)
            })
            .onPreferenceChange(SizeKey.self) { size = $0 }
    }
}

struct SingleAxisGeoReader_Previews: PreviewProvider {
    static var previews: some View {
        SingleAxisGeometryReader() {geo in
            Text("\(geo)")
        }
    }
}
