# Airbnb Clone

## 📱 View

### NavigationStack

```swift
NavigationStack {
    ScrollView {
        SearchAndFilterBar()
            .onTapGesture {
                withAnimation(.easeIn) {
                    showDestinationSearchView.toggle()
                }
            }
            
        LazyVStack(spacing: 32) {
            ForEach(viewModel.listings) { listing in
                NavigationLink(value: listing) {
                    ListingItemView(listing: listing)
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
    .navigationDestination(for: Listing.self) { listing in
        ListingDetailView(listing: listing)
            .navigationBarBackButtonHidden()
    }
    
}
```

`NavigationLink` 에 `Hashable` 한 value를 넣어주면 `.navigationDestination` 메소드로 값을 받아와 값에 따라 원하는 뷰를 그려줄 수 있다.

### LazyVStack

```swift
LazyVStack(spacing: 32) {
    ForEach(viewModel.listings) { listing in
        NavigationLink(value: listing) {
            ListingItemView(listing: listing)
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
```

item이 화면에 렌더링 될 때 생성된다.

### TapView

```swift
TabView {
    ExploreView()
        .tabItem { Label("Explore", systemImage: "magnifyingglass") }
    WishlistView()
        .tabItem { Label("Wishlists", systemImage: "heart") }
    ProfileView()
        .tabItem { Label("Profile", systemImage: "person") }

}
```

```swift
TabView {
    ForEach(listing.imageUrls, id: \.self) { image in
        Image(image)
            .resizable()
            .scaledToFill()
    }
}
.tabViewStyle(.page)
```

### MapKit

```swift
import MapKit

@State private var cameraPosition: MapCameraPosition

init(listing: Listing) {
    // ..
        
    let region = MKCoordinateRegion(
        center: listing.city == "San Jose" ? .sanjose : .nugegoda,
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    self._cameraPosition = State(initialValue: .region(region))
}

Map(position: $cameraPosition)
    .frame(height: 200)
    .clipShape(RoundedRectangle(cornerRadius: 12))
```

### .overlay

```swift
ScrollView {
    \\ ...
}
.overlay(alignment: .bottom) {
		ReserveBar(listing: listing)
}
```

### .tapGesture

```swift
VStack {
    \\ ...
}
.onTapGesture {
		withAnimation(.easeIn) { selectedOption = .guests }
}
```

### .modifier

```swift
VStack {
		\\ ...
}
.modifier(CollapsibleDestinationViewModifier())

struct CollapsibleDestinationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 10)
    }
}
```

### Group

```swift
Group {
    VStack {
    }
		
    VStack {
    }
    // ...
}
```

View가 너무 많을 시 에러가 나는데 Group을 이용하면 된다.

## 📖 Knowledge

### Identifiable, Codable, Hashable

```swift
struct Listing: Identifiable, Codable, Hashable {
    let id: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
		// ...
    var features: [ListingFeatures]
    var amenities: [ListingAmenities]
    let type: ListingType
}

enum ListingFeatures: Int, Codable, Identifiable, Hashable {
    case selfCheckIn
    case superHost
    
    var title: String {
        switch self {
        case .selfCheckIn: return "Self check-in"
        case .superHost: return "Superhost"
        }
    }
    
    var subtitle: String {
        switch self {
        case .selfCheckIn: return "Check yourself in with the keypad"
        case .superHost: return "Superhosts are experienced, highly rated hosts who are commited to providing greate stars for guests."
        }
    }
    
    var imageName: String {
        switch self {
        case .selfCheckIn: return "door.left.hand.open"
        case .superHost: return "medal"
        }
    }
    
    var id: Int { return self.rawValue }
}
```

- `Identifiable` : list나 collection에서 각 항목을 구별하는 id를 제공하는 데 사용한다.

- `Codable` : 서버와의 데이터 교환에서 JSON 형식으로 변환할 수 있도록 사용한다.

- `Hashable` : Set이나 Dictionary에 사용한다.

### MVVM

**Service**

```swift
import Foundation

class ExploreService {
    func fetchListings() async throws -> [Listing] {
        return DeveloperPreview.shared.listing
    }
}
```

- 외부 데이터와 상호 작용을 담당
- 데이터 로직을 뷰나 뷰모델에서 직접 수행하지 않고 외부 서비스로 분리함으로서 유지보수나 테스트를 용이하게 한다.

**View**

```swift
import SwiftUI

struct ExploreView: View {
		// ...
    @StateObject var viewModel = ExploreViewModel(service: ExploreService())
    
    var body: some View {
        // ...
        LazyVStack(spacing: 32) {
            ForEach(viewModel.listings) { listing in
                NavigationLink(value: listing) {
                    ListingItemView(listing: listing)
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        // ...
    }
}
```

- 유저에게 보여지는 화면을 정의, 유저 입력을 처리하고 뷰에 표시할 데이터를 뷰모델에서 가져와 렌더링한다.

**ViewModel**

```swift
import Foundation

class ExploreViewModel: ObservableObject {
    @Published var listings: [Listing] = []
		@Published var searchLocation = ""
    private let service: ExploreService
    
    init(service: ExploreService) {
        self.service = service
        
        Task { await fetchListings() }
    }
    
    func fetchListings() async {
        do {
            self.listings = try await service.fetchListings()
        } catch {
            print("DEBUG: Failed to fetch listng with error: \(error.localizedDescription)")
        }
    }

		func updateListingForLocation() {
        let filteredListings = listings.filter( {
            $0.city.lowercased() == searchLocation.lowercased() ||
            $0.state.lowercased() == searchLocation.lowercased()
        })
        
        self.listings = filteredListings.isEmpty ? listingsCopy : filteredListings
    }
}
```

- 뷰에 표시할 데이터를 가공, 뷰와 서비스간의 중간계층 역할을 한다.

### Dependency Injection

어떤 객체가 필요로 하는 다른 객체를 외부에서 전달받아 사용하는 것

```swift
// ViewModel
class ExploreViewModel: ObservableObject {
	@Published var listings: [Listing] = []
	@Published var searchLocation = ""
}
```

```swift
// View
@StateObject var viewModel = ExploreViewModel(service: ExploreService())
```

- SwiftUI에서의 의존성 주입은 `ObervableObject` 를 `@ObservedObject` 또는 `@StateObject` 와 조합하여 구현한다.
- 상태 변경이 있을 때 `@ObservedObject` 는 뷰를 다시 생성해서 그리지만 `@StateObject` 는 뷰를 다시 생성하지 않고 동일한 뷰를 사용하여 효율성이 좋다.
- 기본적으로 `@StateObject` 를 사용하되 해당 프로퍼티를 subview에세도 주입시켜야 한다면 `@ObservedObject` 를 사용한다.

### async / await

**탄생 배경**

기존의 DispatchQueue나 completionHandler를 이용하면

- 클로저 안에 클로저 이런식으로 코드가 안 좋게 보일 수 있다.
- 에러 핸들링이 복잡하고 조건문에서 처리가 힘들다.

**사용 방법**

```swift
// Service
func fetchListings() async throws -> [Listing] {
    return DeveloperPreview.shared.listing
}
```

- `async`  : 비동기적 실행을 할 수 있음 (모든 명령이 그렇진 않음)
- `throws`  : 에러를 던질 수 있음

```swift
// ViewModel
init(service: ExploreService) {
    self.service = service
        
    Task { await fetchListings() }
}

func fetchListings() async {
    do {
        self.listings = try await service.fetchListings()
        self.listingsCopy = listings
    } catch {
        print("DEBUG: Failed to fetch listng with error: \(error.localizedDescription)")
    }
}
```

- `await`  : 비동기적으로 작업하는 곳이라고 명시적으로 알려줌 (이 키워드를 사용해아 비동기적으로 작동함)
