//
//  SelectorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//
//
//        import SwiftUI
//
//        struct SelectorView<T: Hashable>: View {
//            @Binding var selectedValue: T
//        //    @Binding var changeApproved: Bool
//        //    @Binding var isSheetShown: Bool
//
//            var body: some View {
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("Choose Vehicle Type")
//                        .modifierSheetTitle()
//
//                    Picker(selection: $selectedValue, label: Text("Picker"), content: {
//                        Text("Electric").tag(true)
//                        Text("Non-Electric").tag(false)
//                    })
//                    .pickerStyle(SegmentedPickerStyle())
//
//        //            HStack(alignment: .center, spacing: Constants.UI.itemSpacing, content: {
//        //
//        //                Button(action: {
//        //                    changeApproved = false
//        //                    isSheetShown = false
//        //                }, label: {
//        //                    Text("Cancel")
//        //                })
//        //                .buttonStyle(PlainLikeButtonStyle(.cancel))
//        //
//        //                Button(action: {
//        //                    // change approved by default, no need to set it to true
//        //                    isSheetShown = false
//        //                }, label: {
//        //                    Text("Done")
//        //                })
//        //                .buttonStyle(PlainLikeButtonStyle(.white))
//        //
//        //            })
//
//                }
//                .padding(.bottom, 40)
//                .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
//            }
//        }
//
//        struct SelectorView_Previews: PreviewProvider {
//            @State static var s = "No"
//            static var previews: some View {
//                SelectorView(selectedValue: $s)
//                    .previewLayout(.sizeThatFits)
//            }
//        }
