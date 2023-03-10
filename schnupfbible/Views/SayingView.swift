//
//  SayingView.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI

struct SayingView: View {
    
    @EnvironmentObject var firestoreManager: SBDataModel
    
    let topCutoff = UIScreen.main.bounds.height*0.10
    let bottomCutoff = UIScreen.main.bounds.height*0.60
    
    var body: some View {
        GeometryReader { scrollgeo in
            ScrollViewReader { spos in
                ScrollView(showsIndicators: false) {
                    Spacer().frame(height: UIScreen.main.bounds.height*0.10).id(0)
                    SingleAxisGeometryReader { g in
                        VStack {
                            Text("\(firestoreManager.saying?.title ?? "Spruchtitel")").font(.system(size: 40.0, weight: .bold))
                                .foregroundColor(g > topCutoff ? .primaryColor : .gray)
                            Divider()
                        }
                    }
                    Spacer().frame(height: UIScreen.main.bounds.height*0.10)
                    
                    ForEach(firestoreManager.saying?.paragraphs ?? [], id: \.self) { p in
                        
                        
                        
                        SingleAxisGeometryReader { geo in
                            Text("\(p)").font(.system(size: 50.0, weight: .bold)).foregroundColor(geo > topCutoff && geo < bottomCutoff ? .primaryColor : .gray).frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        Spacer().frame(height: 30.0)
                    }
                    
                    Spacer().frame(height: UIScreen.main.bounds.height*0.45)
                }.multilineTextAlignment(.trailing).frame(width: UIScreen.main.bounds.width - 30.0)
            }
        }
    }
}

extension Color {

    static var primaryColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 255, green: 255, blue: 255, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1) })
    }

}

struct SayingView_Previews: PreviewProvider {
    
    static var previews: some View {
        SayingView().environmentObject(SBDataModel())
    }
}
