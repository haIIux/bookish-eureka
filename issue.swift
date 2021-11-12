/*
Issue : HomeView list not automatically updating upon adding item to the VehicleViewModel array as expected.
*/

// View Model 
class VehicleViewModel: ObservableObject {
    @Published var vehicleList = [
        VehicleModel(year: 1970, make: "International Harvester", model: "1100D", vin: "JH4KA2550HC005889", mileage: 113445),
        VehicleModel(year: 1967, make: "Chevrolet", model: "Nova", vin: "JH4KA2550HC005555", mileage: 26550)
    ]
}

// Home View
struct HomeView: View {
    @StateObject var vehicle = VehicleViewModel()
    @State private var showingSheet = false
    
    
    var body: some View {
        NavigationView {
            List(vehicles.vehicleList) { vehicle in
                NavigationLink {
                    LogView(vehicle: VehicleModel(year: vehicle.year, make: vehicle.make, model: vehicle.model, vin: vehicle.vin, mileage: vehicle.mileage))
                } label: {
                    VehicleRow(vehicle: VehicleModel(year: vehicle.year, make: vehicle.make, model: vehicle.model, vin: vehicle.vin, mileage: vehicle.mileage))
                }
                .padding(.vertical, 5)
            }
            .listStyle(.plain)
            .navigationTitle("Vehicles")
            .toolbar {
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
                .sheet(isPresented: $showingSheet) {
                    AddVehicleSheet(addVehicle: VehicleViewModel())
                }
            }
        }
    }
}

// Sheet View
struct AddVehicleSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var addVehicle: VehicleViewModel
    
    @State var year: String = ""
    @State var make: String = ""
    @State var model: String = ""
    @State var vin: String = ""
    @State var mileage: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Vehicle Information")) {
                    TextField("Year", text: $year)
                    TextField("Make", text: $make)
                    TextField("Model", text: $model)
                    TextField("VIN", text: $vin)
                    TextField("Mileage", text: $mileage)
                }
                Button {
                    addVehicle.vehicleList.append(VehicleModel(year: Int(year) ?? 0, make: make, model: model, vin: vin, mileage: Int(mileage) ?? 0))
                    print(addVehicle.vehicleList.description)
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Submit")
                        Spacer()
                    }
                }
            }
        }
    }
}
