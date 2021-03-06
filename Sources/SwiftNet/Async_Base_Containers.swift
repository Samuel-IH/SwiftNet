//
//  File.swift
//  
//
//  Created by SamuelIH on 7/21/20.
//
//

import Foundation
import SwiftUI



/// SNetMicroContent provides a shortcut interface to SNetContent.
///
/// Use SNetMicroContent when your _"loading"_ view uses the same datatype as your _"final"_ view. For example:
///
///       SNetMicroContent(initialValue: UIImage(systemName: "pencil.and.outline")!, request: {
///           sleep(3)
///           return UIImage(systemName: "tortoise")!
///       }) { img in
///           if true {
///               Image(uiImage: img)
///                   .resizable()
///                   .scaledToFit()
///                   .frame(width: 100)
///           }
///       }
///
/// For more info on SNetContent (the base component of SNetMicroContent) check out it's quick help.
public struct SNetMicroContent<dataType:Any, contentT: View>: View {
    
    public init (initialValue: dataType, request: @escaping () -> dataType, @ViewBuilder content: @escaping (dataType) -> contentT) {
        self._initialValue = State(initialValue: initialValue)
        self.request = request
        self.content = content
    }
    
    @State var initialValue: dataType
    var request: ()-> dataType
    var content: (dataType)-> contentT
    public var  body: some View {
        SNetContent(initialView: {self.content(self.initialValue)}, request: request, content: content)
    }
}



/// SNetContent provides an interface where you can provide a SwiftUI View with inline network load code.
/// The main purpose for this component is for network content that is supplimentary to the base view, such as user avatars.
/// For more info on setup and use, view the init help.
///
/// A simple example:
///
///     SNetContent(initialView: {
///         Text("Executing some lengthy task...")
///     }, request: {
///          sleep(3)
///          return UIImage(systemName: "tortoise")!
///     }) { img in
///         Image(uiImage: img)
///             .resizable()
///             .scaledToFit()
///             .frame(width: 100, height: 100)
///     }
public struct SNetContent<dataType:Any, contentT: View, fish: View>: View {
    /// Create a new SNetContent View with a pre-loaded view and a post loaded view to display the content
    /// - Parameters:
    ///   - initialView: The view that is displayed before the network content loads.
    ///   - request: A closure that is executed to provide the network content. This is your network call, and it will automatically be offloaded to the background thread.
    ///   - content: The view that takes the content that you wish to display, this closure provides the output value of __request__
    public init(@ViewBuilder initialView: @escaping () -> fish, request: @escaping () -> dataType, @ViewBuilder content: @escaping (dataType) -> contentT) {
        self.initialView = initialView
        self.request = request
        self.content = content
    }
    
    @State private var initialValue: dataType? = nil
    @State private var didExecute = false
    var initialView: ()-> fish
    var request: ()-> dataType
    var content: (dataType)-> contentT
    public var  body: some View {
        VStack {
            if !didExecute {
                initialView()
                .onAppear {
                    self.netCall()
                }
            } else {
                content(initialValue!)
                    .onAppear {
                        self.netCall()
                    }
            }
        }
    }
    
    private func netCall() {
        DispatchQueue.global(qos: .background).async {
            let iV = self.request()
            DispatchQueue.main.async {
                withAnimation(nil) {
                    self.initialValue = iV
                    self.didExecute = true
                }
            }
        }
    }
}

