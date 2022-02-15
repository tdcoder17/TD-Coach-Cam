//
//  Camera.swift
//  TD Coach Cam
//
//  Created by Theo Davis on 2/8/22.
//

import SwiftUI

struct Camera: View {
    var body: some View {
        CoachCam()
    }
}//End of struct

struct Camera_Previews: PreviewProvider {
    static var previews: some View {
        Camera()
    }
}//End of struct

struct CoachCam: View {
    @StateObject var camera = CoachCamModel()
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                if camera.isTaken {
                    Button(action: {}, label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                        .padding(.trailing, 10)
                }
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        Button(action: {}, label: {
                            Text("Record")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                    } else {
                        Button(action: {camera.isTaken.toggle()}, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
    }
}//End of struct

class CoachCamModel: ObservableObject {
    @Published var isTaken = false
}//End of class
